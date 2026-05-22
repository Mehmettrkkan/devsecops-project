FROM python:3.9-alpine

WORKDIR /app

# İmajın içindeki işletim sistemi kütüphanelerini (OpenSSL, musl vb.) en güncel güvenli sürümlerine çekiyoruz.
RUN apk update && apk upgrade --no-cache

# Önce bağımlılık dosyasını çekiyoruz
COPY src/requirements.txt .

# wheel zafiyetini (CVE-2026-24049) kapatmak için pip ve setuptools'un yanına wheel'i de ekliyoruz.
RUN pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Kaynak kodları kopyalıyoruz
COPY src/ .

EXPOSE 5000

CMD ["python", "app.py"]
