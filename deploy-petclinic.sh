#!/bin/bash

set -e

echo "[1/4] Minikube kümesi kontrol ediliyor ve başlatılıyor."
if ! minikube status | grep -q "Running"; then
    minikube start --driver=docker
else
    echo "Minikube zaten çalışıyor."
fi

echo "[2/4] Spring Petclinic Docker imajı Minikube ortamına yükleniyor."
minikube image load petclinic:v1
minikube image load mysql:9.7

echo "[3/4] Kubernetes deployment ve service manifestoları uygulanıyor"
kubectl apply -f petclinic.yaml

echo "[4/4] Uygulamanın ayağa kalkması bekleniyor."
kubectl rollout status deployment/petclinic-deployment
kubectl rollout status deployment/mysql-deployment

echo "Tarayıcı açılıyor."
minikube service petclinic-service
