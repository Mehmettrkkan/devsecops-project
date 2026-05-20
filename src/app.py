from flask import Flask, request
from markupsafe import escape # XSS koruması için eklendi

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'DevSecOps Pipeline Test!'

@app.route('/search')
def search():
    query = request.args.get('q', '')
    # Girdiyi escape ederek XSS zafiyetini kapatıyoruz
    return f"Aranan kelime: {escape(query)}"

if __name__ == '__main__':
    # Docker içinde çalıştığımız için 0.0.0.0 kullanmamız gerekiyor.
    # SAST araçlarına bu satırı es geçmelerini söylüyoruz.
    app.run(host='0.0.0.0', port=5000, debug=False) # nosec B104 # nosemgrep