FROM python:3.9-alpine

WORKDIR /app

COPY requirements.txt .

# --- DEĞİŞİKLİK BURADA ---
# Hem pip'i hem de setuptools'u güncelliyoruz ki 'jaraco' açığı kapansın.
RUN pip install --upgrade pip setuptools && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
