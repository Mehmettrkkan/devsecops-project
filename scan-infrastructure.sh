#!/bin/bash

echo "Starting Infrastructure Security Scan with Checkov..."

# Kubernetes manifest dosyalarını tarar
# Eğer root yetkisi ile çalışan pod varsa veya CPU limiti yoksa hata verir.
checkov --directory k8s-specifications --check CKV_K8S_21,CKV_K8S_10

if [ $? -eq 0 ]; then
  echo "Infrastructure Security Check Passed! ✅"
else
  echo "Security Issues Found in Kubernetes Manifests! ❌"
  exit 1
fi
