from flask import Flask, jsonify, request
from flask_cors import CORS
import numpy as np
import joblib
import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision import transforms, models
from PIL import Image
import io
import os
from dotenv import load_dotenv

load_dotenv()

# from tests.plant_disease_prediction_test_script import to_device

app = Flask(__name__)
CORS(app)


device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# gemini help for disease prediction:
import google.generativeai as genai
genai.configure(api_key=os.getenv('GEMINI_API_KEY'))
gemini_model = genai.GenerativeModel("gemini-1.5-flash")

def get_gemini_prediction(img_bytes):
    try:
        response = gemini_model.generate_content([
            """You are an expert plant disease classifier.
Your task:
- If the uploaded image clearly shows a plant with a recognizable disease, return ONLY the disease name (no extra text).
- If the image is unrelated to plants, does not show a disease, or is unclear, respond with exactly: "Please upload a plant disease image".""",
            {"mime_type": "image/jpeg", "data": img_bytes}
        ])
        return response.text.strip()
    except Exception as e:
        return None


crop_model = joblib.load('src/models/croprecommendation.joblib')
fert_model = joblib.load("src/models/RandomForestClassifier.joblib")
soil_dict = joblib.load("src/models/soil_dict.joblib")
crop_dict = joblib.load("src/models/crop_dict.joblib")
loaded_pt = joblib.load('src/models/PowerTransformer.joblib')
loaded_rf = joblib.load('src/models/cropyieldrf.joblib')


class ImageClassificationBase(nn.Module):
    pass

class PretrainedEfficientNetB4(ImageClassificationBase):
    def __init__(self, num_classes, pretrained=False):
        super().__init__()
        self.network = models.efficientnet_b4(pretrained=pretrained)
        in_features = self.network.classifier[1].in_features
        self.network.classifier = nn.Sequential(
            nn.Dropout(0.5),
            nn.Linear(in_features, num_classes)
        )

    def forward(self, xb):
        return self.network(xb)

train_classes = joblib.load('src/models/class_labels.joblib')

num_classes = len(train_classes)
pest_model = PretrainedEfficientNetB4(num_classes, pretrained=True)
checkpoint = torch.load('src/models/pest-detection-model-v2-latest-checkpoint.pth', map_location=device)
pest_model.load_state_dict(checkpoint['model_state_dict'])

pest_model = pest_model.to(device)
pest_model.eval()

pest_transform = transforms.Compose([
    transforms.Resize((192, 192)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225])
])

def predict_pest(img_bytes, pest_model):
    img = Image.open(io.BytesIO(img_bytes)).convert('RGB')
    img = pest_transform(img)
    xb = to_device(img.unsqueeze(0), device)
    with torch.no_grad():
        outputs = pest_model(xb)
        _, preds = torch.max(outputs, dim=1)
        predicted_class = train_classes[preds[0].item()]
    return str(predicted_class)


#tensors to device
def to_device(data, device):
    if isinstance(data, (list, tuple)):
        return [to_device(x, device) for x in data]
    return data.to(device, non_blocking=True)
class ImageClassificationBase(nn.Module):
    pass

def ConvBlock(in_channels, out_channels, pool=False):
    layers = [
        nn.Conv2d(in_channels, out_channels, kernel_size=3, padding=1),
        nn.BatchNorm2d(out_channels),
        nn.ReLU(inplace=True)
    ]
    if pool:
        layers.append(nn.MaxPool2d(4))
    return nn.Sequential(*layers)

# ResNet9 definition
class ResNet9(ImageClassificationBase):
    def __init__(self, in_channels, num_diseases):
        super().__init__()
        self.conv1 = ConvBlock(in_channels, 64)
        self.conv2 = ConvBlock(64, 128, pool=True)
        self.res1 = nn.Sequential(ConvBlock(128, 128), ConvBlock(128, 128))
        self.conv3 = ConvBlock(128, 256, pool=True)
        self.conv4 = ConvBlock(256, 512, pool=True)
        self.res2 = nn.Sequential(ConvBlock(512, 512), ConvBlock(512, 512))
        self.classifier = nn.Sequential(
            nn.MaxPool2d(4),
            nn.Flatten(),
            nn.Linear(512, num_diseases)
        )

    def forward(self, xb):
        out = self.conv1(xb)
        out = self.conv2(out)
        out = self.res1(out) + out
        out = self.conv3(out)
        out = self.conv4(out)
        out = self.res2(out) + out
        out = self.classifier(out)
        return out


disease_classes = joblib.load('src/models/diseases.joblib')
disease_model = ResNet9(in_channels=3, num_diseases=len(disease_classes))
disease_model.load_state_dict(torch.load('src/models/plant-disease-model.pth', map_location=device))
disease_model = to_device(disease_model, device)
disease_model.eval()

# # Image transformation
disease_transform = transforms.Compose([
    transforms.Resize((256, 256)),
    transforms.ToTensor()
])

def predict_disease(img_bytes):
    img = Image.open(io.BytesIO(img_bytes)).convert('RGB')
    img = disease_transform(img)
    xb = to_device(img.unsqueeze(0), device)
    with torch.no_grad():
        yb = disease_model(xb)
        _, preds = torch.max(yb, dim=1)
        return disease_classes[preds[0].item()]


#predict_yield power transformer:
def predict_yield(area, production, rainfall, fertilizer, crop_name, season, state):
    n_features = len(loaded_pt.feature_names_in_)
    data = np.zeros((1, n_features))

    data[0, 0] = area
    data[0, 1] = production
    data[0, 2] = rainfall
    data[0, 3] = fertilizer

    crop_cols = [i for i, col in enumerate(loaded_pt.feature_names_in_) if crop_name.lower() in col.lower()]
    if crop_cols:
        data[0, crop_cols[0]] = 1

    season_cols = [i for i, col in enumerate(loaded_pt.feature_names_in_) if season.lower() in col.lower()]
    if season_cols:
        data[0, season_cols[0]] = 1

    state_cols = [i for i, col in enumerate(loaded_pt.feature_names_in_) if state.lower() in col.lower()]
    if state_cols:
        data[0, state_cols[0]] = 1

    data_transformed = loaded_pt.transform(data)
    data_final = np.delete(data_transformed, [0, 1], axis=1)

    prediction = loaded_rf.predict(data_final)
    return prediction[0]



# crop prediction endpoint
@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json(force=True)

        features = [
            float(data.get('N', 0)),
            float(data.get('P', 0)),
            float(data.get('K', 0)),
            float(data.get('temperature', 0)),
            float(data.get('humidity', 0)),
            float(data.get('ph', 0)),
            float(data.get('rainfall', 0))
        ]

        prediction = crop_model.predict([features])

        return jsonify({
            'status': 'success',
            'recommended_crop': prediction[0]
        })

    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 400

# disease prediction endpoint
@app.route('/predict-disease', methods=['POST'])
def predict_disease_endpoint():
    try:
        if 'image' not in request.files:
            return jsonify({'status': 'error', 'message': 'No image uploaded'}), 400

        file = request.files['image']
        img_bytes = file.read()

        # Run both model + Gemini
        model_prediction = predict_disease(img_bytes)
        gemini_prediction = get_gemini_prediction(img_bytes)

        final_prediction = model_prediction
        similarity = False

        if gemini_prediction:
            # Simple similarity check (case-insensitive substring match)
            if model_prediction.lower() in gemini_prediction.lower() or gemini_prediction.lower() in model_prediction.lower():
                similarity = True
                final_prediction = model_prediction
            else:
                final_prediction = gemini_prediction

        return jsonify({
            'status': 'success',
            'model_prediction': model_prediction,
            'gemini_prediction': gemini_prediction,
            'similarity': similarity,
            'final_prediction': final_prediction
        })

    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 400

# fertilizer prediction endpoint
@app.route("/predict-fertilizer", methods=["POST"])
def predict_fertilizer():
    try:
        data = request.get_json(force=True)
        Soil_Type = data.get("Soil_Type")
        Crop_Type = data.get("Crop_Type")

        if Soil_Type not in soil_dict or Crop_Type not in crop_dict:
            return jsonify({"status": "error", "message": "Invalid Soil or Crop type"}), 400

        features = np.array([[
            float(data.get("Temparature", 0)),
            float(data.get("Humidity", 0)),
            float(data.get("Moisture", 0)),
            float(data.get("Nitrogen", 0)),
            float(data.get("Potassium", 0)),
            float(data.get("Phosphorous", 0)),
            soil_dict[Soil_Type],
            crop_dict[Crop_Type]
        ]])

        prediction = fert_model.predict(features)
        return jsonify({"status": "success", "recommended_fertilizer": prediction[0]})

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400

# yield prediction endpoint
@app.route("/predict-yield", methods=["POST"])
def predict_yield_endpoint():
    try:
        data = request.get_json(force=True)

        area = float(data.get("area", 0))
        production = float(data.get("production", 0))
        rainfall = float(data.get("rainfall", 0))
        fertilizer = float(data.get("fertilizer", 0))
        crop_name = data.get("crop_name", "")
        season = data.get("season", "")
        state = data.get("state", "")

        prediction = predict_yield(area, production, rainfall, fertilizer, crop_name, season, state)
        pred_value = float(prediction)

        # Interpretation
        if pred_value < 2:
            interpretation = "⚠️ Low yield predicted."
        elif 2 <= pred_value <= 6:
            interpretation = "✅ Reasonable yield prediction."
        else:
            interpretation = "📈 High yield prediction."

        return jsonify({
            "status": "success",
            "predicted_yield": round(pred_value, 2),
            "Prediction": interpretation
        })

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400



# pest prediction endpoint:
@app.route('/predict-pest', methods=['POST'])
def predict_pest_endpoint():
    try:
        if 'image' not in request.files:
            return jsonify({'status': 'error', 'message': 'No image uploaded'}), 400

        file = request.files['image']
        img_bytes = file.read()

        model_prediction = predict_pest(img_bytes, pest_model)

        return jsonify({
            'status': 'success',
            'prediction': model_prediction
        })

    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 400

# /
@app.route('/')
def home():
    return jsonify({
        "message": "Welcome to the Crop Recommendation API!",
        "status": "success"
    })

if __name__ == '__main__':
    app.run(debug=True, port=8080)
