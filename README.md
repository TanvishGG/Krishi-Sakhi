# Krishi Sakhi

Krishi Sakhi is a cross-platform solution for smart agriculture, featuring a Flutter mobile app and a Flask backend powered by machine learning models. The system provides crop recommendations, yield predictions, plant disease detection, and pest identification to assist farmers in making informed decisions.


## Project Structure

```
Krishi Sakhi/
├── Flask Backend - ML Models/
│   ├── requirements.txt
│   ├── src/
│   │   ├── app.py
│   │   └── models/
│   │       └── ... (ML models and assets)
│   └── tests/
│       └── plant_disease_prediction_test_script.py
├── Flutter App/
│   ├── pubspec.yaml
│   ├── .env
│   ├── lib/
│   │   ├── main.dart
│   │   ├── l10n/                # Localization
│   │   ├── models/              # Data models
│   │   ├── providers/           # State management (provider)
│   │   ├── screens/             # UI screens (home, onboarding, crop recommendation, etc.)
│   │   ├── services/            # API and logic services
│   │   ├── utils/               # Utilities (env_keys, constants, theme)
│   │   └── widgets/             # Reusable widgets
│   └── ... (platform folders: android, ios, web, etc.)
└── README.md
```


## Features
- **Crop Recommendation:** Suggests optimal crops based on soil nutrients, weather, and rainfall using ML models and fallback logic.
- **Yield Prediction:** Estimates expected crop yield from user and weather data.
- **Plant Disease Detection:** Identifies plant diseases from leaf images using deep learning.
- **Pest Detection:** Detects and classifies pests from images.
- **Fertilizer Recommendation:** Recommends fertilizers based on soil and crop data.
- **Weather Integration:** Fetches real-time weather data for location-aware recommendations.
- **Schemes & Loans:** Provides information on government schemes and agricultural loans.
- **Voice Assistant:** Voice-based interaction for hands-free usage.
- **Chatbot:** In-app chatbot for agricultural queries and support.
- **Multi-language Support:** Localized UI for multiple Indian languages.

## Getting Started


### 1. Backend (Flask + ML Models)

#### Features
- **Crop Recommendation:** Predicts optimal crops using a trained ML model.
- **Yield Prediction:** Estimates crop yield based on area, production, rainfall, fertilizer, crop, season, and state.
- **Plant Disease Detection:** Classifies plant diseases from images using a PyTorch model and Gemini AI for enhanced accuracy.
- **Pest Detection:** Identifies pests from images using a deep learning model.
- **Fertilizer Recommendation:** Suggests fertilizers based on soil and crop type.
- **API Endpoints:** RESTful endpoints for all predictions, with JSON and image support.
- **Environment Variables:** Loads sensitive keys (e.g., Gemini API key) from `.env`.

#### Structure
```
Flask Backend - ML Models/
├── requirements.txt         # Python dependencies
├── .env                    # Environment variables (not committed)
├── src/
│   ├── app.py              # Main Flask app and API endpoints
│   └── models/             # ML models and assets (joblib, pth files)
└── tests/
    └── plant_disease_prediction_test_script.py
```

#### Setup
1. Navigate to the backend folder:
   ```sh
   cd "Flask Backend - ML Models"
   ```
2. Create a Python virtual environment:
   ```sh
   python -m venv venv
   ```
3. Activate the environment:
   - **Windows:**
     ```sh
     .\venv\Scripts\activate
     ```
   - **macOS/Linux:**
     ```sh
     source venv/bin/activate
     ```
4. Install dependencies:
   ```sh
   pip install -r requirements.txt
   ```
5. Create a `.env` file in the backend root. Example:
   ```
   GEMINI_API_KEY=your_api_key_here
   FLASK_ENV=development
   SECRET_KEY=your_secret_key
   # Add other keys as needed
   ```
6. Run the Flask server:
   ```sh
   python src/app.py
   ```


### 2. Frontend (Flutter App)

#### Setup
1. Navigate to the Flutter app folder:
   ```sh
   cd "Flutter App"
   ```
2. Get dependencies:
   ```sh
   flutter pub get
   ```
3. Create an environment file for API endpoints and keys:
   - Create a `.env` file in the `Flutter App` directory. Example:
     ```
     # Flutter App/.env
     API_BASE_URL=http://127.0.0.1:5000
     OPENWEATHER_API_KEY=your_openweather_key
     GEMINI_API_KEY=your_gemini_key
     # Add other keys as needed
     ```
   - The app uses [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv) to load environment variables at startup. Keys are accessed in code via the `EnvKeys` class in `lib/utils/env_keys.dart`:
     ```dart
     import 'package:flutter_dotenv/flutter_dotenv.dart';
     class EnvKeys {
       static String get openWeatherApiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';
       static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
       // ...
     }
     ```
   - Update the `.env` file as needed for your deployment.
4. Run the app:
   ```sh
   flutter run
   ```

#### App Structure Details
- **State Management:** Uses `provider` for app-wide state (authentication, language, crop recommendation, weather, etc.).
- **API Services:** All backend and ML model communication is handled in `lib/services/` (e.g., `crop_api_service.dart`).
- **Screens:** Each feature (crop recommendation, disease detection, etc.) has its own screen in `lib/screens/`.
- **Localization:** Multi-language support via `flutter_localizations` and custom `AppLocalizations`.
- **Environment Variables:** All sensitive keys and endpoints are loaded from `.env` and never hardcoded.
- **UI:** Custom themes and reusable widgets for a consistent look.

## Notes
- Ensure both backend and frontend `.env` files are **not committed to version control**.
- Update API URLs in the Flutter `.env` file as per your backend deployment.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)
