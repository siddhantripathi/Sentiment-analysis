# backend/app/model_handler.py
from transformers import pipeline, AutoTokenizer, AutoModelForSequenceClassification
import torch

def load_bertweet_model():
    tokenizer = AutoTokenizer.from_pretrained("finiteautomata/bertweet-base-sentiment-analysis")
    model = AutoModelForSequenceClassification.from_pretrained(
        "finiteautomata/bertweet-base-sentiment-analysis",
        torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32
    )
    return pipeline(
        "text-classification",
        model=model,
        tokenizer=tokenizer,
        device=0 if torch.cuda.is_available() else -1
    )