🌾 AgriVision — AI-Powered Smart Agriculture System

A complete Flutter + FastAPI + Machine Learning solution for farmers, agronomists, and researchers.

AgriVision helps users detect crop diseases, get fertilizer recommendations, and predict crop yields using advanced AI models — all delivered through a modern mobile app.

✨ Key Features
🟢 1. AI-Based Crop Disease Detection

Upload or capture leaf images

Backend ML model predicts disease + confidence

Shows treatment suggestions

🟡 2. Fertilizer Recommendation System

Uses soil NPK values, crop type, and environmental factors

Suggests fertilizer combinations for best crop growth

🔵 3. Crop Yield Prediction

Estimates yield using soil properties, nitrogen levels, environment inputs, etc.

🟣 4. Flutter Mobile App

Cross-platform (Android/iOS)

Clean UI/UX

Real-time interaction with backend

🟤 5. FastAPI Backend

ML model inference

Preprocessing pipelines

REST API endpoints

Fully documented at /docs

🧰 Tech Stack
Frontend (Mobile App)

Flutter (Dart)

Provider / Riverpod (if used)

Material Design UI

REST API communication

Backend

FastAPI

Uvicorn

Pydantic

Python ML ecosystem

Machine Learning

TensorFlow / PyTorch models

OpenCV / Pillow for image preprocessing

NumPy / Pandas for data handling

📂 Project Structure
Agrivision/
│
├── agrivision/                   # Flutter Frontend
│   ├── lib/
│   ├── assets/
│   └── pubspec.yaml
│
├── agrivision-backend/           # FastAPI Backend
│   ├── models/                   # Stored ML model files (.h5/.pt)
│   ├── routers/                  # API endpoints
│   ├── utils/                    # preprocessing helpers
│   ├── main.py                   # FastAPI entry
│   └── requirements.txt
│
└── README.md

🚀 Getting Started
🔹 1. Clone the Repository
git clone https://github.com/vikrant16sharma/Agrivision.git
cd Agrivision

📱 Frontend Setup (Flutter)
Install Dependencies
cd agrivision
flutter pub get

Run the App
flutter run


Ensure that your API base URL in Flutter code points to your backend (local or deployed).

🖥️ Backend Setup (FastAPI)
Install Dependencies
cd agrivision-backend
pip install -r requirements.txt

Start Server
uvicorn main:app --reload


Backend will run on:

http://127.0.0.1:8000


Swagger documentation:

http://127.0.0.1:8000/docs

📡 API Endpoints (FastAPI)
Endpoint	Method	Purpose
/predict-disease	POST	Predict crop disease from image
/predict-yield	POST	Estimate crop yield from inputs
/recommend-fertilizer	POST	Suggest fertilizer based on soil data
🔧 Architecture Overview
          ┌───────────────────┐
          │   Flutter App     │
          │  (Frontend UI)    │
          └───────▲───────────┘
                  │
        REST API Calls (JSON/Image)
                  │
          ┌───────▼───────────┐
          │   FastAPI Server   │
          │ (Backend Logic)    │
          └───────▲───────────┘
                  │
       ML Inference & Processing
                  │
          ┌───────▼───────────┐
          │  ML Models (CNN)   │
          │  Yield Predictor   │
          │  Recommendation     │
          └────────────────────┘

🛣️ Future Enhancements

Offline TFLite support in mobile app

Deploy backend on Render/EC2

Add multilingual support

Add chat-based agronomy assistant

Weather-integrated predictions

🤝 Contributing

Fork the repo

Create your feature branch

Commit changes

Open a pull request
