
from flask import Flask, request, jsonify
# from keras.preprocessing import image
import keras.utils as image
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1'
from keras.models import load_model

app= Flask(__name__)

import pickle
import numpy as np
import pandas as pd
from sklearn.preprocessing import LabelEncoder


def levenshtein(s1, s2):
    """Calculate the Levenshtein distance between two strings."""
    if len(s1) < len(s2):
        return levenshtein(s2, s1)
    if len(s2) == 0:
        return len(s1)

    previous_row = range(len(s2) + 1)
    for i, c1 in enumerate(s1):
        current_row = [i + 1]
        for j, c2 in enumerate(s2):
            insertions = previous_row[j + 1] + 1
            deletions = current_row[j] + 1
            substitutions = previous_row[j] + (c1 != c2)
            current_row.append(min(insertions, deletions, substitutions))
        previous_row = current_row

    return previous_row[-1]

def find_closest_match(query, choices):
    """Find the closest match for the query in a list of choices."""
    best_match = None
    min_distance = float('inf')
    for choice in choices:
        distance = levenshtein(query, choice)
        if distance < min_distance:
            best_match = choice
            min_distance = distance
    return best_match

df = pd.read_csv("/home/johnhona1/Rainfall_sheet.csv")

def loadweed_model():
    # loaded_model = load_model('/home/johnhona1/my_model.h5')
    # loaded_model = load_model('mobilenet_v3.h5')
    loaded_model = load_model('weed_arvin_model.h5')
    return loaded_model

def loadd_model():
    loaded_model = load_model('latest_pest_model.h5')
    return loaded_model

#changed
def loadlabelencodercost_model():
    with open("label_encoders_newCost.pkl", 'rb') as f:
        label_encoders = pickle.load(f)
    return label_encoders

def loadxgboostcost_model():
    with open('xgboost_model_newCost.pkl', 'rb') as f:
        stored_model = pickle.load(f)
    return stored_model


def load_xgboostmodel_and_label_encoder(model_filename='cost_xgboost_model.pkl', encoder_filename='cost_label_encoders.pkl'):
    try:
        with open(model_filename, 'rb') as model_file:
            model = pickle.load(model_file)

        with open(encoder_filename, 'rb') as encoder_file:
            label_encoder = pickle.load(encoder_file)

        return model, label_encoder
    except FileNotFoundError as e:
        app.logger.error(f"File not found: {e}")
        return None, None
    except Exception as e:
        app.logger.error(f"Error loading model and label encoder: {e}")
        return None, None
##changed

def preprocess_image(image_path, target_size):
    img = image.load_img(image_path, target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = img_array / 255.0  # Normalize pixel values
    return img_array

def predict_class(image_path, model, target_size):
    img_array = preprocess_image(image_path, target_size)
    predictions = model.predict(img_array)
    predicted_class = np.argmax(predictions)
    confidence_score = np.max(predictions)
    predicted_class=np.int64(predicted_class)
    confidence_score=np.float64(confidence_score)
    return predicted_class , confidence_score


def load_model_and_label_encoder(model_filename='crop_prediction_model.pkl', encoder_filename='label_encoder.pkl'):
    try:
        with open(model_filename, 'rb') as model_file:
            model = pickle.load(model_file)

        with open(encoder_filename, 'rb') as encoder_file:
            label_encoder = pickle.load(encoder_file)

        return model, label_encoder
    except FileNotFoundError as e:
        app.logger.error(f"File not found: {e}")
        return None, None
    except Exception as e:
        app.logger.error(f"Error loading model and label encoder: {e}")
        return None, None

def full_load_model_and_label_encoder(model_filename='crop_prediction_new_model.pkl', encoder_filename='croppredictlabel_encoder.pkl'):
    try:
        with open(model_filename, 'rb') as model_file:
            model = pickle.load(model_file)

        with open(encoder_filename, 'rb') as encoder_file:
            label_encoder = pickle.load(encoder_file)

        return model, label_encoder
    except FileNotFoundError as e:
        print(f"File not found: {e}")
        return None, None
    except Exception as e:
        print(f"Error loading model and label encoder: {e}")
        return None, None

def calculate_nutrient_requirements(gdd, labels):
    def calculate_gdd(row):
        if row['minimum_temperature'] <= row['base_minimum_temperature']:
            return (row['base_minimum_temperature'] + row['maximum_temperature']) / 2 - row['base_minimum_temperature']
        elif row['minimum_temperature'] > row['base_minimum_temperature'] and row['maximum_temperature'] <= row['base_maximum_temperature']:
            return (row['minimum_temperature'] + row['maximum_temperature']) / 2 - row['base_minimum_temperature']
        elif row['maximum_temperature'] > row['base_maximum_temperature']:
            return (row['minimum_temperature'] + row['base_maximum_temperature']) / 2 - row['base_minimum_temperature']

    result = {}
    for label in labels:
        # Filter DataFrame based on user label
        filtered_rows = gdd[gdd['label'] == label].copy()

        # Apply calculate_gdd function to filtered rows
        filtered_rows['GDD'] = filtered_rows.apply(calculate_gdd, axis=1)

        # Calculate nutrient requirements
        filtered_rows['Nitrogen_requirement'] = 200 * (filtered_rows['nitrogen'] / 100)
        filtered_rows['Phosphorus_requirement'] = 200 * (filtered_rows['phosphorus'] / 100)
        filtered_rows['Potassium_requirement'] = 200 * (filtered_rows['pottassium'] / 100)

        # Drop the 'label' column
        filtered_rows.drop(columns=['label'], inplace=True)

        # Store the result for this label
        result[label] = filtered_rows[['GDD', 'Nitrogen_requirement', 'Phosphorus_requirement', 'Potassium_requirement']].to_dict(orient='records')

    return result

# Function to make predictions and calculate nutrient requirements
def make_predictions_and_nutrient_requirements(N, P, k, temperature, humidity, ph, rainfall, model, label_encoder):
    user_input = np.array([N, P, k, temperature, humidity, ph, rainfall]).reshape(1, -1)

    # Make crop predictions
    y_pred_user = model.predict(user_input)
    predicted_label_user = label_encoder.inverse_transform(y_pred_user)[0]
    gdd =pd.read_csv("gddfinal.csv")
    # Calculate nutrient requirements

    # Predict top 5 crops
    predicted_probabilities = model.predict_proba(user_input)
    top_5_crops_indices = np.argsort(predicted_probabilities[0])[::-1][:5]
    top_5_crops_labels = label_encoder.inverse_transform(top_5_crops_indices)

    nutrient_requirements = calculate_nutrient_requirements(gdd, top_5_crops_labels.tolist())

    return predicted_label_user, nutrient_requirements, top_5_crops_labels.tolist()
def predict_crop_and_nutrients(temperature, humidity, rainfall, model, label_encoder):
    # Prepare user input for prediction
    user_input = np.array([temperature, humidity, rainfall]).reshape(1, -1)

    # Make predictions using the trained model
    y_pred_user = model.predict(user_input)

    # Get the class labels based on the predicted indices
    predicted_label_user = label_encoder.inverse_transform(y_pred_user)[0]

    # Get the predicted probabilities for each class
    predicted_probabilities = model.predict_proba(user_input)

    # Get the top 5 predicted crops
    top_5_crops_indices = np.argsort(predicted_probabilities[0])[::-1][:5]
    top_5_crops_labels = label_encoder.inverse_transform(top_5_crops_indices)
    gdd =pd.read_csv("gddfinal.csv")
    nutrient_requirements = calculate_nutrient_requirements(gdd, top_5_crops_labels.tolist())

    return predicted_label_user, nutrient_requirements, top_5_crops_labels.tolist()

def cost_estimate(crop, state, years,model, label_encoder):
    # Transform crop and state using label encoders
    crop_encoded = label_encoder['Crop'].transform([crop])[0]
    state_encoded = label_encoder['State'].transform([state])[0]

    # Create DataFrame for inference
    # years = range(2024, 2030)
    years=[years]
    inference_data = pd.DataFrame({
        "Year": years,
        "Crop": crop_encoded,
        "State": state_encoded
    })

    # Predict costs for each year
    predictions = []
    for year in years:
        prediction = model.predict(inference_data[inference_data['Year'] == year])[0]
        prediction_result = {
            "Year": year,
            "State": state,
            "Crop": crop,
            "OperationalCost": round(float(prediction[0]), 2),
            "HumanLabour": round(float(prediction[1]), 2),
            "AnimalLabour": round(float(prediction[2]), 2),
            "MachineLabour": round(float(prediction[3]), 2),
            "Seed": round(float(prediction[4]), 2),
            "FertilizerManure": round(float(prediction[5]), 2),
            "Insecticides": round(float(prediction[6]), 2),
            "FixedCost": round(float(prediction[7]), 2),
            "TotalCost": round(float(prediction[8]), 2)
        }
        predictions.append(prediction_result)

    return predictions


@app.route('/predict', methods=['POST'])
def predict():
    data = request.json

    N = data['N']
    P = data['P']
    k = data['k']
    temperature = data['temperature']
    humidity = data['humidity']
    ph = data['ph']
    rainfall = data['rainfall']

    model, label_encoder = load_model_and_label_encoder()
    predicted_crop, nutrient_requirements, top_5_crops = make_predictions_and_nutrient_requirements(N, P, k, temperature, humidity, ph, rainfall, model, label_encoder)

    response = {
        'predicted_crop': predicted_crop,
        'nutrient_requirements': nutrient_requirements,
        'top_5_crops': top_5_crops
    }

    return jsonify(response)

@app.route('/automatepredict', methods=['POST'])
def automatepredict():
    data = request.json

    temperature = data['temperature']
    humidity = data['humidity']
    rainfall = data['rainfall']

    model, label_encoder = full_load_model_and_label_encoder()
    predicted_crop, nutrient_requirements, top_5_crops = predict_crop_and_nutrients(temperature, humidity, rainfall, model, label_encoder)

    response = {
        'predicted_crop': predicted_crop,
        'nutrient_requirements': nutrient_requirements,
        'top_5_crops': top_5_crops
    }

    return jsonify(response)

@app.route('/cost', methods=['POST'])
def CalculateCost():
    data = request.json

    crop = data['Cropname']
    state = data['Statename']
    years= data['year']


    model ,label_encoder =load_xgboostmodel_and_label_encoder()

    cost_json = cost_estimate(crop, state,years=int(years) ,model=model, label_encoder=label_encoder)


    return jsonify(cost_json)

@app.route('/pest',methods=['POST'])
def predictPest():
    # Check if an image file is uploaded
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'})

    file = request.files['file']

    # Save the uploaded image temporarily
    temp_image_path = 'temp_image.jpg'
    file.save(temp_image_path)

    # Load the model
    loaded_model = loadd_model()

    # Make prediction using the loaded model
    predicted_class, confidence = predict_class(temp_image_path, loaded_model, target_size=(224, 224))

    # Map predicted class index to class name
    pest = ['aphids', 'armyworm', 'beetle', 'bollworm', 'grasshopper', 'mites', 'mosquito', 'sawfly', 'stem_borer']
    predicted_class_name = pest[predicted_class]

    # Remove the temporary image file
    os.remove(temp_image_path)

    return jsonify({'predicted_class': int(predicted_class), 'confidence': confidence})

@app.route('/weed',methods=['POST'])
def predictWeed():
    # Check if an image file is uploaded
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'})

    file = request.files['file']

    # Save the uploaded image temporarily
    temp_image_path = 'temp_image.jpg'
    file.save(temp_image_path)

    # Load the model
    loaded_model = loadweed_model()

    # Make prediction using the loaded model
    predicted_class,confidence = predict_class(temp_image_path, loaded_model, target_size=(224, 224))

    # Map predicted class index to class name
    weed = ['Black-grass', 'charlock', 'cleavers', 'common chickweed', 'common wheat', 'Fat Hen', 'Loose Silky-bent', 'Maize', 'Scentless Mayweed','Sheperds Purse','Small-flowered Cranesbill','Sugar beet']
    predicted_class_name = weed[predicted_class]


    os.remove(temp_image_path)

    return jsonify({'predicted_class': int(predicted_class),'confidence':float(confidence)})


@app.route('/rainfall_sheet', methods=['POST'])
def get_rainfall():

    data = request.json
    district = data['district'].upper()

    try:

        rainfall = df.loc[df['DISTRICT'] == district, 'RAINFALL'].values[0]
        return jsonify({'rainfall': rainfall})
    except IndexError:
        # If the district is not found, find the closest match using Levenshtein distance
        closest_match = find_closest_match(district, df['DISTRICT'])
        rainfall = df.loc[df['DISTRICT'] == closest_match, 'RAINFALL'].values[0]
        return jsonify({'rainfall': rainfall, 'matched_district': closest_match})


if __name__=="__main__":
    app.run(debug=True)