# uhh model test code to refer:



# -*- coding: utf-8 -*-

import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision import transforms
from PIL import Image
import matplotlib.pyplot as plt
import joblib

# Move tensors to device
def to_device(data, device):
    if isinstance(data, (list, tuple)):
        return [to_device(x, device) for x in data]
    return data.to(device, non_blocking=True)

# Base class definition (can be simplified if not needed)
class ImageClassificationBase(nn.Module):
    pass

# Convolutional block
def ConvBlock(in_channels, out_channels, pool=False):
    layers = [
        nn.Conv2d(in_channels, out_channels, kernel_size=3, padding=1),
        nn.BatchNorm2d(out_channels),
        nn.ReLU(inplace=True)
    ]
    if pool:
        layers.append(nn.MaxPool2d(4))
    return nn.Sequential(*layers)

# Model architecture
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

# Set device
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

# Load class labels
train_classes = joblib.load('/content/drive/MyDrive/SIH/diseases.joblib')  # or the path you shared

# Create the model
model = ResNet9(3, len(train_classes))
model.load_state_dict(torch.load('/content/drive/MyDrive/SIH/plant-disease-model.pth', map_location=device))
model = to_device(model, device)
model.eval()

# Image loading and transformation
transform = transforms.Compose([
    transforms.Resize((256, 256)),  # Resize image to 256x256
    transforms.ToTensor()
])
img_path = "/content/drive/MyDrive/SIH/potatolateblight.jpg"
img = Image.open(img_path).convert('RGB')
img = transform(img)

# Prediction function
def predict_image(img, model):
    xb = to_device(img.unsqueeze(0), device)
    with torch.no_grad():
        yb = model(xb)
        _, preds = torch.max(yb, dim=1)
        return train_classes[preds[0].item()]

# Get prediction
predicted_class = predict_image(img, model)

# Display the image and prediction
plt.imshow(img.permute(1, 2, 0))
plt.axis('off')
plt.title(f'Predicted: {predicted_class}')
plt.show()
