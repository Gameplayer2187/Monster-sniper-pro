from fastapi import FastAPI
import requests
from bs4 import BeautifulSoup
from typing import List, Dict

app = FastAPI()

def scrape_kaufda_monster():
    url = "https://www.kaufda.de/Angebote/Monster-Energy"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }
    
    try:
        response = requests.get(url, headers=headers, timeout=10)
        soup = BeautifulSoup(response.text, "html.parser")
        
        # Für die Demo liefern wir vordefinierte Daten, 
        # da Scraping-Klassen sich ständig ändern.
        return [
            {"store": "Netto", "price": "0,88 €", "valid_until": "KW44"},
            {"store": "Rewe", "price": "1,19 €", "valid_until": "KW44"},
            {"store": "Edeka", "price": "0,99 €", "valid_until": "KW43"},
        ]
    except Exception as e:
        print(f"Error: {e}")
        return []

@app.get("/offers")
def get_offers():
    return {"offers": scrape_kaufda_monster()}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
