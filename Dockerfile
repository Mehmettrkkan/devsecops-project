# 1. Base Image: Python'un hafif bir sürümünü alıyoruz 
FROM python:3.9-alpine

# 2. Çalışma dizini oluşturuyoruz
WORKDIR /app

# 3. Önce gereksinim dosyasını kopyalıyoruz 
COPY requirements.txt .

# 4. Kütüphaneleri yüklüyoruz
RUN pip install --no-cache-dir -r requirements.txt

# 5. Tüm proje dosyalarını içeri kopyalıyoruz
COPY . .

# 6. Uygulamanın çalışacağı portu belirtiyoruz
EXPOSE 5000

# 7. Uygulamayı başlatıyoruz
CMD ["python", "app.py"]
