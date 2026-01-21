from flask import Flask, request
import os

app = Flask(__name__)

# GÜVENLİK AÇIĞI 1: Hardcoded Secret (Kod içine gömülü şifre)
# Bu ASLA yapılmamalıdır. Bunu tarayıcıların yakalamasını istiyoruz.
AWS_SECRET_KEY = "AKIA1234567890FAKEKEY"

@app.route('/')
def home():
    return "Merhaba, DevSecOps Dünyası!"

@app.route('/ara')
def ara():
    query = request.args.get('q')
    # GÜVENLİK AÇIĞI 2: Basit bir XSS potansiyeli
    return f"Aranan kelime: {query}"

if __name__ == '__main__':
    # Debug=True production ortamında tehlikelidir çünkü hata detaylarını gösterir.
    app.run(host='0.0.0.0', port=5000, debug=True)
