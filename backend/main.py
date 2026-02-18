from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import xgboost as xgb
import numpy as np
import os

# 1. Initialisation de l'application

app = FastAPI(
    title="DiaAI API",
    description="API qui appelle le modèle IA (XGBoost + FastAPI)",
    version="1.0"
)

# 2. Chargement du Modèle IA

current_dir = os.path.dirname(os.path.abspath(__file__))
model_path = os.path.join(current_dir, "..", "IA", "diaai_model.json")

model = xgb.XGBRegressor()

if os.path.exists(model_path):
    model.load_model(model_path)
    print(f"Modèle chargé depuis {model_path} !")
else:
    print(f"Impossible de trouver le fichier ici : {model_path}")

# 3. Définition du format des données

class PredictionInput(BaseModel):
    glycemie_avant: float
    glucides: float
    insuline: float

# 4. La Route Principale : /predict

@app.post("/predict")
def predict_glycemie(data: PredictionInput):
    # Vérification de sécurité
    if model is None:
        raise HTTPException(status_code=503, detail="Le modèle IA n'est pas chargé.")

    try:
        # Préparation des données pour XGBoost
        features = np.array([[
            data.glycemie_avant, 
            data.glucides, 
            data.insuline
        ]])
        
        # Calcul de la prédiction
        prediction = model.predict(features)[0]
        
        # Renvoi de la réponse
        return {
            "glycemie_estimee": float(round(prediction, 2)),
            "unite": "g/L",
            "statut": "OK"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erreur de calcul : {str(e)}")

# 5. Route de test (Ping)
@app.get("/")
def read_root():
    return {"message": "Serveur DiaAI en ligne."}