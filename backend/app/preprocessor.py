# backend/app/preprocessor.py
import re

def preprocess_tweet(text):
    text = re.sub(r'\s+', ' ', text)  # Remove extra whitespace
    text = re.sub(r'(@[A-Za-z0-9_]+)', lambda m: m.group().lower(), text)  # Lowercase mentions
    text = re.sub(r'#(\w+)', lambda m: m.group().lower(), text)  # Lowercase hashtags
    text = re.sub(r'(.)\1{2,}', r'\1\1', text)  # Remove character elongation
    return text.strip()