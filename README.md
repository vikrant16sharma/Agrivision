# 🌾 AgriVision — AI-Powered Smart Agriculture System

A complete **Flutter + FastAPI + Machine Learning** solution for farmers, agronomists, and researchers.

AgriVision helps users detect crop diseases, get fertilizer recommendations, and predict crop yields using advanced AI models — all delivered through a modern mobile app.

---

## ✨ Key Features

### 🟢 1. AI-Based Crop Disease Detection
- Upload or capture leaf images  
- Backend ML model predicts disease + confidence  
- Displays treatment suggestions  

### 🟡 2. Fertilizer Recommendation System
- Uses soil NPK values, crop type, and environmental factors  
- Suggests fertilizer combinations for best crop growth  

### 🔵 3. Crop Yield Prediction
- Estimates yield using soil properties, nitrogen levels, and environmental inputs  

### 🟣 4. Flutter Mobile App
- Cross-platform (Android/iOS)  
- Clean UI/UX  
- Real-time backend interaction  

### 🟤 5. FastAPI Backend
- Handles ML model inference  
- Image preprocessing pipelines  
- REST API endpoints  
- Auto-generated Swagger documentation at `/docs`

---

## 🧰 Tech Stack

### **Frontend (Mobile App)**
- Flutter (Dart)  
- Provider / Riverpod (if used)  
- Material Design  
- REST API communication  

### **Backend**
- FastAPI  
- Uvicorn  
- Pydantic  
- Python ML ecosystem  

### **Machine Learning**
- TensorFlow / PyTorch  
- OpenCV / Pillow  
- NumPy / Pandas  

---

## 📂 Project Structure

Agrivision/
│
├── agrivision/ # Flutter Frontend
│ ├── lib/
│ ├── assets/
│ └── pubspec.yaml
│
├── agrivision-backend/ # FastAPI Backend
│ ├── models/ # Stored ML model files (.h5/.pt)
│ ├── routers/ # API endpoints
│ ├── utils/ # preprocessing helpers
│ ├── main.py # FastAPI entry
│ └── requirements.txt
│
└── README.md


---

# 🚀 Getting Started

## 🔹 1. Clone the Repository

```sh
git clone https://github.com/vikrant16sharma/Agrivision.git
cd Agrivision
##📱 Frontend Setup (Flutter)
Install Dependencies
cd agrivision
flutter pub get

Run the App
flutter run


Ensure that your API base URL in Flutter code points to your backend (local or deployed).

##🖥️ Backend Setup (FastAPI)
Install Dependencies
cd agrivision-backend
pip install -r requirements.txt

Start Server
uvicorn main:app --reload


Backend will run at:

http://127.0.0.1:8000


Swagger documentation:

https://cropdetectionbackend.onrender.com/docs
