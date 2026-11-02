#!/bin/bash

set -e

echo "[1/6] Minikube kümesi kontrol ediliyor ve başlatılıyor."
if ! minikube status | grep -q "Running"; then
    minikube start --driver=docker
else
    echo "Minikube zaten çalışıyor."
fi

echo "[2/6] Spring Petclinic Docker imajı Minikube ortamına yükleniyor."
minikube image load petclinic:v1

echo "[3/6] Eski Helm release'leri ve Kubernetes kaynakları temizleniyor."
helm uninstall petclinic-release 2>/dev/null || true

kubectl delete deployment petclinic-deployment mysql-deployment --ignore-not-found=true
kubectl delete service mysql-service petclinic-service --ignore-not-found=true

echo "[4/6] Varsa mevcut mysql-pvc Helm'e tanımlanıyor, yoksa bırakılıyor."
if kubectl get pvc mysql-pvc &>/dev/null; then
    echo "Mevcut mysql-pvc bulundu, Helm sahiplik etiketleri ekleniyor..."
    kubectl label pvc mysql-pvc app.kubernetes.io/managed-by=Helm --overwrite
    kubectl annotate pvc mysql-pvc meta.helm.sh/release-name=petclinic-release --overwrite
    kubectl annotate pvc mysql-pvc meta.helm.sh/release-namespace=default --overwrite
else
    echo "Mevcut mysql-pvc bulunamadı, Helm kendi oluşturacak."
fi


echo "[5/6] Helm Chart ile uygulama ve veritabanı deploy ediliyor."
helm install petclinic-release ./petclinic-chart

echo "[6/6] Pod'ların ayağa kalkması bekleniyor."
kubectl rollout status deployment/mysql-deployment
kubectl rollout status deployment/petclinic-deployment

echo "Uygulama tarayıcınızda çalıştırılıyor."
minikube service petclinic-service
