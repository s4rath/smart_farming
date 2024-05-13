from flask import Flask
from threading import Thread
import time
import google
from google.oauth2 import service_account
from google.auth.transport.requests import AuthorizedSession
import requests
import json
import datetime, pytz

app = Flask(__name__)


scopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging"
]

temperature_notification_sent = False
soil_moisture_notification_sent = False
climate_notification_sent = False
light_notification_sent = False

dtobj1 = datetime.datetime.utcnow()
dtobj3 = dtobj1.replace(tzinfo=pytz.UTC)
dtobj_india = dtobj3.astimezone(pytz.timezone("Asia/Calcutta"))

database_credentials = service_account.Credentials.from_service_account_file(
    "smart-farming-6852a-firebase-adminsdk-mxidz-0208a8ba06.json",
    scopes=scopes)


database_authed_session = AuthorizedSession(database_credentials)


def send_notification(device_token, title, body):
  
    fcm_url = 'https://fcm.googleapis.com/v1/projects/smart-farming-6852a/messages:send'

 
    payload = {
        "message": {
            "token": device_token,
            "notification": {
                "title": title,
                "body": body,
            },
            "data": {
                "key1": "value1",
                "key2": "value2"
            }
        }
    }

 
    json_payload = json.dumps(payload)

    
    fcm_request = google.auth.transport.requests.Request()
    database_credentials.refresh(fcm_request)
    fcm_access_token = database_credentials.token

  
    fcm_headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer {}'.format(fcm_access_token)
    }

    # Send POST request to FCM endpoint
    fcm_response = requests.post(fcm_url,
                                 data=json_payload,
                                 headers=fcm_headers)

    # Check if request was successful
    if fcm_response.status_code == 200:
        print('Notification sent successfully!')
    else:
        print(f'Failed to send notification: {fcm_response.text}')





def check_condition_and_send_notification(data):

    global light_notification_sent
    global soil_moisture_notification_sent
    global climate_notification_sent
    global dtobj_india

    if 'fcmToken' in data:

        if (data.get('Light', {}).get('Ldr_Value') is not None
                and float(data['Light']['Ldr_Value']) < 300.0
                and (10 < dtobj_india.hour < 15)
                and not light_notification_sent):
            print("light can send")
            light_notification_sent = True
            for user_uuid in data.get('fcmToken', {}).keys():

                device_token = data['fcmToken'].get(user_uuid)
                send_notification(
                    device_token,
                    title="Grow Light is on",
                    body="Sunlight Intensity  is less than 300 nm")
        elif (int(data['Light']['Ldr_Value']) > 300):
            print("in")
            light_notification_sent = False

        if (data.get('Soil', {}).get('Soil_Moisture') is not None
                and int(data['Soil']['Soil_Moisture']) > 600
                and not soil_moisture_notification_sent):
            print("soil moisture can send")
            soil_moisture_notification_sent = True
            for user_uuid in data.get('fcmToken', {}).keys():
                device_token = data['fcmToken'].get(user_uuid)
                send_notification(device_token,
                                  title="Water pump is on",
                                  body="soil moisture is greater than 600")
        elif (int(data['Soil']['Soil_Moisture']) < 600):
            print("soil calling")
            soil_moisture_notification_sent = False

        if (((data.get('Temperature', {}).get('Celsius_Value') is not None
              and float(data['Temperature']['Celsius_Value']) > 35.0) or
             (data.get('Humidity', {}).get('Percentage_Value') is not None
              and float(data['Humidity']['Percentage_Value']) > 60.0) or
             (data.get('Smoke', {}).get('PPM_Value') is not None
              and int(data['Smoke']['PPM_Value']) > 150))
                and not climate_notification_sent):
            print("climate can send")
            climate_notification_sent = True
            for user_uuid in data.get('fcmToken', {}).keys():
                device_token = data['fcmToken'].get(user_uuid)
                send_notification(
                    device_token,
                    title="Fan is on and Window is open ",
                    body=
                    "Either smoke greater than 150 or  temperature falls above  35 or  humidity greater than 60"
                )
        elif ((float(data['Temperature']['Celsius_Value']) < 35.0)
              and (float(data['Humidity']['Percentage_Value']) < 60.0)
              and (int(data['Smoke']['PPM_Value']) < 150)):
            print("climate calling")
            climate_notification_sent = False


@app.route('/')
def index():
    return "Alive"


def run():
    app.run(host='0.0.0.0', port=8080)


def keep_alive():
    t = Thread(target=run)
    t.start()
    while True:
        time.sleep(10)
      
        database_name = "smart-farming-6852a-default-rtdb.asia-southeast1"
        url = f"https://{database_name}.firebasedatabase.app/.json"

      
        database_response = database_authed_session.get(url)

      
        if database_response.status_code == 200:
           
            data = database_response.json()
            print(data)
          

            check_condition_and_send_notification(data)
        else:
            print(
                f"Failed to fetch data from Firebase Realtime Database: {database_response.text}"
            )
