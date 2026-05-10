import os
import requests
from PIL import Image
from io import BytesIO

# Bildquellen von Unsplash (lizenzfrei)
FOOD_IMAGES = {
    'avocado_toast': 'https://images.unsplash.com/photo-1588137378633-dea1336ce1e2',
    'chicken_salad': 'https://images.unsplash.com/photo-1546793665-c74683f339c1',
    'smoothie_bowl': 'https://images.unsplash.com/photo-1511690743698-d9d85f2fbf38',
    'quinoa_salad': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
    'buddha_bowl': 'https://images.unsplash.com/photo-1546007597-ef65133ee642',
    'greek_yogurt': 'https://images.unsplash.com/photo-1583165758869-0741a4397197',
    'protein_pancakes': 'https://images.unsplash.com/photo-1528207776546-365bb710ee93',
    'salmon_avocado': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    'vegan_bowl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
    'chicken_rice': 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d',
}

def download_and_save_image(url, filename, target_size=(800, 600)):
    try:
        # Erstelle den Zielordner, falls er nicht existiert
        os.makedirs('assets/images/food', exist_ok=True)
        
        # Lade das Bild herunter
        response = requests.get(url)
        img = Image.open(BytesIO(response.content))
        
        # Konvertiere zu RGB falls nötig
        if img.mode in ('RGBA', 'P'):
            img = img.convert('RGB')
        
        # Resize mit Beibehaltung des Seitenverhältnisses
        img.thumbnail(target_size)
        
        # Speichere das Bild
        output_path = f'assets/images/food/{filename}.jpg'
        img.save(output_path, 'JPEG', quality=85)
        print(f'Erfolgreich gespeichert: {output_path}')
        
    except Exception as e:
        print(f'Fehler beim Herunterladen von {filename}: {str(e)}')

def main():
    for name, url in FOOD_IMAGES.items():
        download_and_save_image(url, name)

if __name__ == '__main__':
    main() 