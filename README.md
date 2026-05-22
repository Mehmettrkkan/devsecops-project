<div align="center">


<br/>

[![CI/CD Pipeline](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![Security: Trivy](https://img.shields.io/badge/Security-Trivy-1904DA?style=for-the-badge&logo=aqua&logoColor=white)](https://trivy.dev)
[![SAST: Semgrep](https://img.shields.io/badge/SAST-Semgrep-2B8CBE?style=for-the-badge&logo=semgrep&logoColor=white)](https://semgrep.dev)
[![IaC: Checkov](https://img.shields.io/badge/IaC-Checkov-5C4EE5?style=for-the-badge&logo=bridgecrew&logoColor=white)](https://checkov.io)
[![Container: Docker](https://img.shields.io/badge/Container-Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docker.com)
[![Infra: Terraform](https://img.shields.io/badge/Infra-Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://terraform.io)
[![SBOM: Syft](https://img.shields.io/badge/SBOM-Syft-00ADD8?style=for-the-badge&logo=anchore&logoColor=white)](https://github.com/anchore/syft)

# 🛡️ DevSecOps Pipeline Project

<br/>

> **"Security is not a feature — it's a foundation."**  
> Sıfırdan inşa edilmiş, tam otomatik, katmanlı güvenlik mimarisi ile güçlendirilmiş production-ready DevSecOps pipeline'ı.

<br/>

</div>

---

## 🎯 Proje Hakkında

Bu proje, modern yazılım geliştirme süreçlerinde **güvenliği en başından itibaren** (Shift-Left Security) üretime entegre etmeyi hedefleyen, **enterprise düzeyinde** bir DevSecOps pipeline'ının referans implementasyonudur.

Monolitik ve dağınık bir proje yapısından yola çıkılarak:

- ✅ **Modüler dizin mimarisi** oluşturuldu
- ✅ **4 bağımsız güvenlik katmanı** pipeline'a entegre edildi
- ✅ **Dockerfile güvenlik açıkları** tespit edilip yamalandı
- ✅ **XSS zafiyeti** SAST taramasıyla yakalanıp giderildi
- ✅ **SBOM** (Software Bill of Materials) otomatik üretimi sağlandı
- ✅ **Kubernetes & Terraform** IaC dosyaları güvenlik denetimine alındı

Her `git push` ve `pull request` işleminde pipeline otomatik olarak tetiklenerek kod üretime çıkmadan önce **güvenlik kapısından geçmek zorunda kalır.**

---

## 🏗️ Mimari Genel Bakış

```
┌─────────────────────────────────────────────────────────────────────┐
│                        DEVELOPER WORKSTATION                        │
│                                                                     │
│   git commit ──────────────────────────────► git push / PR          │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       GITHUB ACTIONS CI/CD                          │
│                                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐  ┌────────┐  │
│  │  KATMAN 1    │  │  KATMAN 2    │  │   KATMAN 3    │  │KATMAN 4│  │
│  │              │  │              │  │               │  │        │  │
│  │ Secret Scan  │─►│    SAST      │─►│  Container    │─►│  IaC   │  │
│  │  (Gitleaks)  │  │(Semgrep +    │  │  Security     │  │Security│  │
│  │              │  │   Bandit)    │  │(Trivy + Syft) │  │Checkov)│  │
│  └──────────────┘  └──────────────┘  └───────────────┘  └────────┘  │
│         │                 │                  │               │      │
│         ▼                 ▼                  ▼               ▼      │
│    ✅ PASS / ❌ FAIL  ✅ PASS / ❌ FAIL  ✅ PASS / ❌ FAIL ✅/❌   │
└─────────────────────────────┬───────────────────────────────────────┘
                              │ (Tüm katmanlar ✅)
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     PRODUCTION DEPLOYMENT                           │
│                                                                     │
│         Docker Registry ──► Kubernetes Cluster                      │
│              (ECR/GHCR)         (EKS/GKE)                           │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📁 Proje Yapısı

```
.
├── 📂 src/                          # Uygulama kaynak kodları
│   ├── app.py                       # Flask uygulaması (ana giriş noktası)
│   ├── routes/                      # API rotaları
│   └── utils/                       # Yardımcı fonksiyonlar
│
├── 📂 infra/
│   ├── k8s/                         # Kubernetes manifestoları
│   │   ├── deployment.yaml          # Deployment tanımı (güvenli konfigürasyon)
│   │   ├── service.yaml             # Service tanımı
│   │   └── hpa.yaml                 # Horizontal Pod Autoscaler
│   └── terraform/                   # Terraform IaC dosyaları
│       ├── main.tf                  # Ana altyapı tanımı
│       ├── variables.tf             # Değişken tanımları
│       └── outputs.tf               # Çıktı tanımları
│
├── 📂 scripts/                      # Otomasyon scriptleri
│   ├── build.sh                     # Docker build scripti
│   ├── scan.sh                      # Manuel güvenlik tarama scripti
│   └── setup-local.sh               # Yerel ortam kurulum scripti
│
├── 📂 .github/
│   └── workflows/
│       ├── ci-security.yml          # Ana güvenlik pipeline'ı (4 katman)
│       └── cd-deploy.yml            # Deployment pipeline'ı
│
├── Dockerfile                       # Optimize edilmiş, güvenli imaj tanımı
├── .gitleaksrc                      # Gitleaks konfigürasyonu
├── .semgrepignore                   # Semgrep false-positive yönetimi
└── README.md                        # Bu dosya
```

---

## 🔄 Pipeline Mimarisi — 4 Katmanlı Güvenlik

### Katman 1 — Secret Scan (Gitleaks)

> **Amaç:** Commit geçmişine yanlışlıkla eklenmiş API anahtarı, şifre, token ve credential'ları tespit etmek.

```yaml
# .github/workflows/ci-security.yml (ilgili bölüm)
- name: 🔐 Secret Scan with Gitleaks
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Neler taranır:**
| Zafiyet Türü | Örnek | Sonuç |
|---|---|---|
| AWS API Keys | `AKIA...` formatı | ❌ Pipeline durdurulur |
| GitHub PAT | `ghp_...` formatı | ❌ Pipeline durdurulur |
| Generic Secrets | `password = "abc123"` | ❌ Pipeline durdurulur |
| Şifreli/Base64 | Şüpheli string desenleri | ⚠️ Uyarı üretilir |

> **Pro Tip:** Gitleaks, yalnızca güncel kodu değil, **tüm git geçmişini** tarar. Yanlışlıkla commit'lenen bir secret, sonraki commit'te silinse bile tespit edilir.

---

### Katman 2 — SAST (Semgrep & Bandit)

> **Amaç:** Python (Flask) kaynak kodundaki güvenlik açıklarını kaynak kod analizinden tespit etmek.

```yaml
- name: 🔍 SAST — Semgrep
  uses: returntocorp/semgrep-action@v1
  with:
    config: "p/python p/flask p/owasp-top-ten"

- name: 🔍 SAST — Bandit
  run: |
    pip install bandit
    bandit -r src/ -f json -o bandit-report.json
```

**Tespit Edilen & Yamalanan Zafiyetler:**

```python
# ❌ ÖNCE — XSS Zafiyeti (Semgrep tarafından tespit edildi)
@app.route('/search')
def search():
    query = request.args.get('q')
    return f"<h1>Arama sonucu: {query}</h1>"  # Tehlikeli! Unsanitized input

# ✅ SONRA — Yamandı
from markupsafe import escape

@app.route('/search')
def search():
    query = request.args.get('q')
    return f"<h1>Arama sonucu: {escape(query)}</h1>"  # Güvenli
```

**False-Positive Yönetimi (Risk Kabulü):**

```python
# Geliştirme ortamında 0.0.0.0 binding zorunludur.
# Bu bir false-positive'dir; production'da reverse proxy (Nginx/ALB) bu portu açık bırakmaz.
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)  # nosec B104 # nosemgrep
```

> **Profesyonel Not:** `# nosec` ve `# nosemgrep` annotation'ları, kaçışların gerekçesiyle birlikte kod review sürecinde belgelenir. Kör bir `noqa` politikası uygulanmaz.

---

### Katman 3 — Container Security & SBOM (Trivy & Syft)

> **Amaç:** Docker imajını CI ortamında build edip zafiyet taramasından geçirmek ve yazılım bileşen envanteri (SBOM) üretmek.

```yaml
- name: 🏗️ Build Docker Image
  run: docker build -t $IMAGE_NAME:${{ github.sha }} .

- name: 🛡️ Container Vulnerability Scan — Trivy
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: ${{ env.IMAGE_NAME }}:${{ github.sha }}
    severity: 'CRITICAL,HIGH'
    exit-code: '1'       # CRITICAL/HIGH bulunursa pipeline'ı kır
    format: 'sarif'
    output: 'trivy-results.sarif'

- name: 📦 Generate SBOM — Syft
  uses: anchore/sbom-action@v0
  with:
    image: ${{ env.IMAGE_NAME }}:${{ github.sha }}
    format: spdx-json
    output-file: sbom.spdx.json
    artifact-name: sbom-report
```

**Dockerfile Optimizasyonu & Güvenlik Sertleştirmesi:**

```dockerfile
# ❌ ÖNCE — Güvensiz, şişirilmiş imaj
FROM python:3.11
COPY . .                    # Tüm repo kopyalanıyor — tehlikeli ve gereksiz
RUN pip install -r requirements.txt
CMD ["python", "app.py"]

# ✅ SONRA — Güvenli, minimal, optimize edilmiş
FROM python:3.11-alpine     # Alpine: minimalist, düşük attack surface

WORKDIR /app

# Önce bağımlılıkları kopyala (Docker layer cache optimizasyonu)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Yalnızca kaynak kodunu kopyala (secrets, .git, test dosyaları dahil değil)
COPY src/ ./src/

# Non-root kullanıcı oluştur (güvenlik best practice)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 5000
CMD ["python", "src/app.py"]
```

**Trivy Taramasında Yamalanan Zafiyetler:**

| CVE | Paket | Önem | Çözüm |
|---|---|---|---|
| CVE-2023-XXXX | `python:3.11` base image | CRITICAL | `python:3.11-alpine` güncel sürüme geçildi |
| CVE-2023-YYYY | `wheel` kütüphanesi | HIGH | `pip install wheel==0.42.0` sürüm pinlendi |

---

### Katman 4 — IaC Security (Checkov)

> **Amaç:** Kubernetes manifestolarını ve Terraform dosyalarını altyapı konfigürasyon hatalarına karşı taramak.

```yaml
- name: 🏛️ IaC Security Scan — Checkov
  uses: bridgecrewio/checkov-action@master
  with:
    directory: infra/
    framework: kubernetes,terraform
    soft-fail: false
    output_format: sarif
    output_file_path: checkov-results.sarif
```

**Tespit Edilen & Düzeltilen IaC Sorunları:**

```yaml
# ❌ ÖNCE — Güvensiz Kubernetes Deployment
apiVersion: apps/v1
kind: Deployment
spec:
  containers:
  - name: app
    image: myapp:latest
    # CKV_K8S_11: CPU limiti tanımlanmamış!
    # CKV_K8S_12: Memory limiti tanımlanmamış!
    securityContext:
      runAsNonRoot: false   # CKV_K8S_6: Root olarak çalışıyor!
      allowPrivilegeEscalation: true  # CKV_K8S_20: Yetki yükseltmeye izin var!

# ✅ SONRA — Güvenli & Checkov-compliant Kubernetes Deployment
spec:
  containers:
  - name: app
    image: myapp:1.2.3       # Belirli versiyon pinlendi (latest yasak)
    resources:
      limits:
        cpu: "500m"
        memory: "256Mi"
      requests:
        cpu: "100m"
        memory: "128Mi"
    securityContext:
      runAsNonRoot: true
      runAsUser: 1000
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
          - ALL
```

---

## 🛠️ Teknoloji Yığını

<div align="center">

| Kategori | Araç | Versiyon | Amaç |
|---|---|---|---|
| **CI/CD** | GitHub Actions | Latest | Pipeline orkestrasyon |
| **Containerization** | Docker | 24.x | Uygulama paketleme |
| **Secret Scanning** | Gitleaks | v8.x | Credential sızıntısı tespiti |
| **SAST** | Semgrep | Latest | Kaynak kod güvenlik analizi |
| **SAST** | Bandit | 1.7.x | Python-spesifik güvenlik taraması |
| **Container Security** | Trivy | Latest | CVE & zafiyet taraması |
| **SBOM** | Syft | Latest | Yazılım malzeme listesi üretimi |
| **IaC Security** | Checkov | Latest | Altyapı konfigürasyon denetimi |
| **Infrastructure** | Terraform | 1.6.x | Cloud altyapı yönetimi |
| **Orchestration** | Kubernetes | 1.28.x | Container orkestrasyon |
| **Application** | Python / Flask | 3.11 / 3.x | Backend API |

</div>

---

## 🔥 Örnek Zafiyet Yönetimi Senaryosu

> Bu senaryo, pipeline'ın gerçek hayatta nasıl bir XSS zafiyetini yakalayıp yamaladığını adım adım göstermektedir.

### 📍 Senaryo: XSS Zafiyeti Tespit & Yamalanması

**Durum:** Geliştirici, Flask arama endpoint'ine yeni bir özellik ekler ve `git push` yapar.

---

**Adım 1 — Hatalı Kod Commit'lendi**

```python
# src/routes/search.py — commit: a3f9c21
@app.route('/search')
def search():
    query = request.args.get('q', '')
    return f"<p>Sonuçlar: {query}</p>"   # ← Kullanıcı girdisi doğrudan HTML'e basılıyor
```

---

**Adım 2 — Pipeline Tetiklendi, Semgrep Alarmı Verdi**

```
🔍 Running Semgrep SAST scan...

┌─────────────────────────────────────────────────────────────────────┐
│  FINDING: python.flask.security.xss.reflected-xss-taint             │
│  Severity: HIGH                                                     │
│  File: src/routes/search.py                                         │
│  Line: 4                                                            │
│                                                                     │
│  Kullanıcıdan gelen `query` değişkeni, HTML encode edilmeden        │
│  doğrudan response'a dahil ediliyor.                                │
│  Saldırgan: /search?q=<script>document.cookie</script>              │
│                                                                     │
│  ❌ Pipeline BAŞARISIZ — 1 HIGH severity finding                    │
└─────────────────────────────────────────────────────────────────────┘
```

---

**Adım 3 — Geliştirici Uyarıyı Aldı ve Kodu Yamadı**

```python
# src/routes/search.py — commit: b7d2e44 (FIX: sanitize search input)
from markupsafe import escape

@app.route('/search')
def search():
    query = request.args.get('q', '')
    safe_query = escape(query)          # ← Input sanitize edildi ✅
    return f"<p>Sonuçlar: {safe_query}</p>"
```

---

**Adım 4 — Pipeline Yeniden Çalıştı, Tüm Katmanlar Geçti**

```
✅ Katman 1 — Gitleaks:  No secrets detected
✅ Katman 2 — Semgrep:   0 findings (HIGH/CRITICAL)
✅ Katman 2 — Bandit:    No issues identified
✅ Katman 3 — Trivy:     0 CRITICAL, 0 HIGH vulnerabilities
✅ Katman 3 — Syft:      SBOM generated → sbom.spdx.json
✅ Katman 4 — Checkov:   Passed 47 checks, 0 failed

🚀 Deployment onaylandı. Production'a gönderiliyor...
```

---

**Sonuç:** Zafiyet, production ortamına çıkmadan **kaynak kodda** tespit edildi. Yamadan production'a kadar geçen süre: **< 10 dakika.** Geleneksel yaklaşımda bu zafiyet ancak manuel code review veya pentest sırasında bulunabilirdi.

---

## 📊 Pipeline Akış Diyagramı

```
git push
    │
    ▼
┌─────────────────────────────────┐
│   Trigger: push / pull_request  │
└────────────────┬────────────────┘
                 │
                 ▼
        ┌────────────────┐
        │  Secret Scan   │
        │   (Gitleaks)   │
        └───────┬────────┘
                │
         ┌──────┴──────┐
         │             │
       PASS           FAIL
         │             │
         ▼             ▼
  ┌────────────┐  ❌ Pipeline
  │    SAST    │     STOP
  │(Semgrep +  │
  │  Bandit)   │
  └─────┬──────┘
        │
   ┌────┴────┐
   │         │
 PASS       FAIL
   │         │
   ▼         ▼
┌──────────────────┐  ❌ Pipeline
│  Container Scan  │     STOP
│  (Trivy + Syft)  │
└────────┬─────────┘
         │
    ┌────┴────┐
    │         │
  PASS       FAIL
    │         │
    ▼         ▼
┌──────────┐  ❌ Pipeline
│  Checkov │     STOP
│(K8s + TF)│
└────┬─────┘
     │
   PASS
     │
     ▼
🚀 DEPLOY
```

---

## 📦 Üretilen Artifactler

Her başarılı pipeline çalışmasında aşağıdaki raporlar GitHub Actions artifact'ları olarak saklanır:

| Artifact | Format | Açıklama | Retention |
|---|---|---|---|
| `trivy-results.sarif` | SARIF | Container zafiyet raporu | 30 gün |
| `sbom.spdx.json` | SPDX JSON | Software Bill of Materials | 90 gün |
| `bandit-report.json` | JSON | Python SAST raporu | 30 gün |
| `checkov-results.sarif` | SARIF | IaC güvenlik raporu | 30 gün |

> SARIF formatındaki raporlar otomatik olarak **GitHub Security → Code Scanning** sekmesine entegre edilir.

---

<div align="center">

---


*Bu proje, güvenliğin bir afterthought değil, yazılım geliştirme sürecinin ayrılmaz bir parçası olduğunu kanıtlamak için inşa edilmiştir.*

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0d1117,50:1a1f2e,100:0d1117&height=100&section=footer" width="100%"/>

</div>
