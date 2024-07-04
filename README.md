
# Smart Farming Mobile Application

## Overview

This project is a Mobile Application designed to control and monitor a Greenhouse Environment using the ESP8266 microcontroller. The application allows users to manage devices like fans, lights, and sliding windows, and to monitor temperature and other environmental factors. Data is sent to a Firebase Realtime Database and displayed in the Flutter app. The project also includes several advanced modules for crop prediction, cost estimation, pest classification, weed classification, IoT control, and agricultural news updates.

## Features

### IoT Control
- **Devices**: Control fans, lights, and sliding windows.
- **Sensors**: Monitor temperature, soil moisture, and smoke.
- **Automation**: Automatic control based on sensor values.
- **Database**: ESP8266 sends data to Firebase Realtime Database.

### Crop Prediction
- **Manual Input**: Enter soil and climatic parameters manually.
- **Automatic Input**: Fetch climatic data using Weather API.
- **Model**: Random Forest Classifier hosted on Flask.

### Cost Estimation
- **Model**: Predict the cost of cultivation using parameters sent from the app.
- **Technology**: Flask hosted model.

### Pest Classification
- **Image Processing**: Capture and send images to Flask server.
- **Model**: MobileNet and Sequential model from Keras.
- **Response**: Flask server processes the image and returns the pest classification.

### Weed Classification
- **Similar to Pest Classification**: Capture, send images, process, and classify.

### Newsletter Section
- **Agricultural News**: Fetch latest news using News API.
- **Notifications**: Get alerts related to agriculture and climate.

### Authentication and Notifications
- **Firebase Authentication**: Secure login using email and password.
- **Firebase Cloud Messaging**: Notifications for IoT alerts (e.g., smoke detected, soil moisture levels).

## Technologies Used
- **Flutter**: For mobile application development.
- **Firebase**: Realtime Database, Authentication, Cloud Messaging.
- **ESP8266**: Microcontroller for IoT.
- **Flask**: Backend server for hosting machine learning models.
- **Replit**: For running Flask code.
- **Provider**: State management in Flutter.
- **APIs**: Weather API, News API.

## Installation and Setup

### Firebase Setup
1. Create a Firebase project.
2. Add your `google-services.json` file for Android.
3. Add your `GoogleService-Info.plist` file for iOS.

### Flask Server Setup
1. Ensure Flask and required libraries are installed.
2. Deploy your Flask server on Replit or any other hosting platform.

### Dependencies
1. Install Flutter dependencies.
   ```bash
   flutter pub get

## Usage

### Run the Flask Server
  ```bash
  flask run
```
### Run the Flutter Application
  ```bash
  flutter run
```

## Screenshots
Here are some screenshots of the application

<img src="https://github.com/s4rath/smart_farming/assets/83325357/f6c35afe-db50-4411-acff-a8bbaaee63d2" alt="Onboard Screen" width="260"/>

<img src="https://github.com/s4rath/smart_farming/assets/83325357/bc3349d6-8850-40c4-9bcb-d1fdc50c21d1" alt="Home Page" width="260"/>

<img src="https://github.com/s4rath/smart_farming/assets/83325357/6a2c44b8-c0ba-4d73-9586-4128e50dbb69" alt="IoT Control" width="260"/>

<img src="https://github.com/s4rath/smart_farming/assets/83325357/75a7505f-994a-47c5-afb3-c5be09e1c161" alt="Pest Classification Page" width="260"/>

<img src="https://github.com/s4rath/smart_farming/assets/83325357/b1c3594a-db9b-4fb5-999d-809ad3bf650b" alt="Pest Detail Page" width="260"/>

<img src="https://github.com/s4rath/smart_farming/assets/83325357/00492e12-8269-4e45-afda-d75753182911" alt="News Page" width="260"/>

<img src="https://github.com/s4rath/smart_farming/assets/83325357/b8b92cd9-4ec7-4bcf-9275-761ecb6aa8b4" alt="News Detail Page" width="260"/>


### This is the structure of Firebase realtime database
<img src="https://github.com/s4rath/smart_farming/assets/83325357/b2968c31-7f73-4cc6-b251-b33bdcf6dfcd" alt="Firebase Realtime Database" width="500"/>

### This is our Green House Miniature Structure

<img src="https://github.com/s4rath/smart_farming/assets/83325357/e6104e79-a141-4c35-bb89-d26a150098bb" alt="Green House Miniature Structure" width="500"/>



## Contributors
- **Sarath Sreedhar J** - B.Tech Information Technology, 2024
- **Shegin Ismail A P** - B.Tech Information Technology, 2024
- **Vishnu C N** - B.Tech Information Technology, 2024
- **Maheswari S M** - B.Tech Information Technology, 2024

## Guides 
- **Dr. Deepthi Saseedharan**
- **Prof. Rejin R**

## License
This project is licensed under the Creative Commons Legal Code.

