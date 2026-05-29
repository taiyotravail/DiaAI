# DiaAI

DiaAI est une application complète (Mobile + API + IA) conçue pour aider à l'estimation et à la prédiction de la glycémie. Elle s'appuie sur des données telles que la glycémie précédente, les glucides ingérés et les unités d'insuline injectées, afin d'alimenter un modèle d'Intelligence Artificielle (XGBoost) entraîné sur ces paramètres.

## Fonctionnalités

- **Frontend Mobile** : Application développée en Flutter offrant une interface fluide (iOS & Android).
- **Prédictions IA** : Backend rapide propulsé par **FastAPI** interrogeant un modèle **XGBoost regressor**.
- **Historique** : Sauvegarde des prédictions passées (Intégration Firebase / Cloud Firestore).
- **Interface Utilisateur** : Écrans de résumé, d'historique, de prédictions, et un guide interactif.

## Architecture du Projet

Le dépôt est divisé en trois parties principales :

1. **`frontend/`** : Application mobile Flutter.
2. **`backend/`** : Serveur FastAPI servant d'interface pour le modèle de Machine Learning.
3. **`IA/`** : Scripts et notebooks (`entrainement.ipynb`) pour l'entraînement du modèle XGBoost, ainsi que le modèle exporté (`diaai_model.json`).

## Installation & Lancement

Prérequis :
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version ^3.11.0)
- [Python 3.8+](https://www.python.org/downloads/)
- Compte Firebase (pour la synchronisation Firestore)

### 1. Cloner le dépôt

```bash
git clone https://github.com/votre-nom/DiaAI.git
cd DiaAI
```

### 2. Lancer le Backend (FastAPI)

Le backend gère les requêtes de prédiction et requiert un jeton d'authentification.

```bash
cd backend
pip install -r requirements.txt

# Définir le token de sécurité (sur macOS/Linux)
export API_BEARER_TOKEN="votre_token_secret"

# Lancer le serveur (le back tournera sur http://127.0.0.1:8000 par défaut)
uvicorn main:app --reload
```

### 3. Lancer le Frontend (Flutter)

```bash
cd frontend
flutter pub get

# Assurez-vous d'avoir un émulateur ou un appareil connecté
flutter run
```
*(Note : Pensez à vérifier/remplacer le fichier `google-services.json` et `GoogleService-Info.plist` si vous connectez votre propre projet Firebase).*

## Modèle IA

Le modèle d'apprentissage automatique est développé en Python à l'aide de **XGBoost**. Le carnet d'expérimentation et d'entraînement est disponible dans le dossier `IA/entrainement.ipynb`.
Le modèle final est exporté sous le format JSON (`diaai_model.json`) pour être facilement chargé par l'API Backend.

## Stack Technique

- **Frontend** : Flutter, Dart, Firebase, Cloud Firestore.
- **Backend** : FastAPI, Python, Pydantic, Uvicorn.
- **Machine Learning** : XGBoost, NumPy, scikit-learn.

## Sécurité
L'API est protégée par un *Middleware* exigeant un Bearer token d'authentification (`HTTPBearer`) garantissant que seules les communications autorisées de l'application mobile puissent solliciter l'IA.
