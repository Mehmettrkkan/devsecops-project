# 🛡️ DevSecOps Python Projesi

![Build Status](https://github.com/Mehmettrkkan/devsecops-project/actions/workflows/guvenlik.yaml/badge.svg)
![Python](https://img.shields.io/badge/Python-3.9-blue?logo=python)
![Docker](https://img.shields.io/badge/Docker-Ready-blue?logo=docker)
![Security](https://img.shields.io/badge/Security-Trivy%20%26%20Bandit-green)

Bu proje, basit bir Python (Flask) uygulamasının güvenli bir CI/CD (Sürekli Entegrasyon/Sürekli Dağıtım) hattı üzerinden nasıl geliştirilip dağıtılacağını gösteren bir **DevSecOps** uygulamasıdır.

Proje, kod her güncellendiğinde otomatik olarak güvenlik taramalarından geçer ve sadece güvenli olduğu onaylanırsa Docker imajı oluşturulur.

## 🚀 Kullanılan Teknolojiler ve Araçlar

* **Uygulama:** Python, Flask
* **Konteynerizasyon:** Docker (Alpine Linux tabanlı optimize imajlar)
* **CI/CD:** GitHub Actions
* **SCA (Yazılım Bileşen Analizi):** `Safety` (Kütüphane açıkları için)
* **SAST (Statik Kod Analizi):** `Bandit` (Kod içi güvenlik hataları için)
* **Konteyner Güvenliği:** `Trivy` (Docker imaj taraması için)

## 📂 Proje Yapısı

```bash
.
├── .github/workflows/  # CI/CD Pipeline ayarları (GitHub Actions)
├── app.py              # Flask uygulama kodu
├── Dockerfile          # Docker imaj konfigürasyonu
├── requirements.txt    # Python kütüphaneleri
└── README.md           # Proje dokümantasyonu