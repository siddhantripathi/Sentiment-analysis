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
HF_API_URL = "https://api-inference.huggingface.co/models/finiteautomata/bertweet-base-sentiment-analysis"
HF_TOKEN = os.getenv("HF_API_TOKEN")

@app.post("/analyze")
async def analyze_text(request: TextRequest):
    try:
        headers = {"Authorization": f"Bearer {HF_TOKEN}"}
        response = requests.post(
            HF_API_URL,
            headers=headers,
            json={"inputs": request.text},
            timeout=10
        )
        
        # Handle model loading errors more gracefully
        if response.status_code == 503:
            return {
                "sentiment": "LOADING",
                "confidence": 0,
                "original_text": request.text,
                "message": "Model is loading, please try again in a few seconds"
            }
            
        if response.status_code != 200:
            raise HTTPException(
                status_code=response.status_code,
                detail=f"Hugging Face API error: {response.text}"
            )
            
        result = response.json()[0]
        best_result = max(result, key=lambda x: x['score'])
        
        label_map = {
            'POS': 'POSITIVE',
            'NEG': 'NEGATIVE', 
            'NEU': 'NEUTRAL'
        }
        
        return {
            "sentiment": label_map.get(best_result['label'], 'NEUTRAL'),
            "confidence": best_result['score'],
            "original_text": request.text
        }

    except requests.exceptions.RequestException as e:
        raise HTTPException(
            status_code=500,
            detail=f"Network error: {str(e)}"
        )
        
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Unexpected error: {str(e)}"
        )