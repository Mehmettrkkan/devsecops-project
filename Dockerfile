FROM python:3.9-alpine

WORKDIR /app

COPY src/requirements.txt .FROM python:3.9-alpine

WORKDIR /app

# Önce bağımlılık dosyasını çekiyoruz 
COPY src/requirements.txt .

# Pip ve setuptools güncellenip bağımlılıklar kuruluyor
RUN pip install --upgrade pip setuptools && \
    pip install --no-cache-dir -r requirements.txt

COPY src/ .

EXPOSE 5000

CMD ["python", "app.py"]

RUN pip install --upgrade pip setuptools && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
