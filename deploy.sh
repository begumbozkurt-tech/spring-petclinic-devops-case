#!/bin/bash

set -e

echo "[1/5] Minikube kümesi kontrol ediliyor ve başlatılıyor."
if ! minikube status | grep -q "Running"; then
    minikube start --driver=docker
else
    echo "Minikube zaten çalışıyor."
fi

echo "[2/5] Spring Petclinic Docker imajı Minikube ortamına yükleniyor."
minikube image load petclinic:v1

echo "[3/5] Eski Helm release'leri ve Kubernetes kaynakları temizleniyor."
helm uninstall petclinic-release 2>/dev/null || true

echo "[4/5] Helm Chart ile uygulama ve veritabanı deploy ediliyor."
helm install petclinic-release ./petclinic-chart

echo "[5/5] Pod'ların ayağa kalkması bekleniyor."
kubectl rollout status deployment/mysql-deployment
kubectl rollout status deployment/petclinic-deployment

echo "Uygulama tarayıcınızda çalıştırılıyor."
minikube service petclinic-service
