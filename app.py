from flask import Flask, request
import os

app = Flask(__name__)

# DÜZELTME 1: Şifreyi koddan sildik! 
# Artık şifreyi sunucunun ortam değişkenlerinden okuyacak.
# Eğer bulamazsa 'varsayilan_deger' atayacak.
AWS_SECRET_KEY = os.environ.get("AWS_SECRET_KEY", "VarsayilanGuvenliDegil")

@app.route('/')
def home():
    return "Merhaba, Guvenli DevSecOps Dunyasi!"

@app.route('/ara')
def ara():
    query = request.args.get('q')
    # Basit XSS'i engellemek için escape yapmak gerekir ama şimdilik kalsın.
    return f"Aranan kelime: {query}"

if __name__ == '__main__':
    # DÜZELTME 2: Debug modunu kapattık! Production'da asla açık olmamalı.
    app.run(host='0.0.0.0', port=5000, debug=False)
