from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import os
import requests
from dotenv import load_dotenv
from .model_handler import load_bertweet_model
from .preprocessor import preprocess_tweet
from mangum import Mangum

load_dotenv()

app = FastAPI()
handler = Mangum(app)

# Simple CORS setup that allows everything
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class SentimentRequest(BaseModel):
    text: str
class TextRequest(BaseModel):
    text: str
#https://api-inference.huggingface.co/models/finiteautomata/bertweet-base-sentiment-analysis
HF_API_URL = "https://api-inference.huggingface.co/models/j-hartmann/emotion-english-distilroberta-base"
HF_TOKEN = os.getenv("HF_API_TOKEN")

@app.post("/analyze")
async def analyze_text(request: TextRequest):
    try:
        headers = {"Authorization": f"Bearer {HF_TOKEN}"}
        response = requests.post(
            HF_API_URL,
            headers=headers,
            json={"inputs": request.text}
        )
        response.raise_for_status()
        
        # Get all emotion scores
        emotions = response.json()[0]
        # Find emotion with highest score
        max_emotion = max(emotions, key=lambda x: x['score'])
        
        return {
            "emotion": max_emotion['label'].upper(),
            "confidence": max_emotion['score']
        }
    except requests.exceptions.RequestException as e:
        raise HTTPException(
            status_code=503,
            detail=f"Network error: {str(e)}"
        )
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Unexpected error: {str(e)}"
        )