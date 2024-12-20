#!/bin/bash

# Функция для сборки Docker образов
build_images() {
    echo "Сборка Docker образов..."
    
    # Сборка embedder
    cd embedder
    docker build -t embedder:latest .
    cd ..

    # Сборка neural_worker
    cd neural_worker
    docker build -t neural_worker:latest .
    cd ..

    # Сборка rag_engine
    cd rag_engine
    docker build -t rag_engine:latest .
    cd ..
}

# Функция для применения манифестов Kubernetes
apply_manifests() {
    echo "Применение манифестов Kubernetes..."
    cd k8s-manifests

    kubectl apply -f configmap.yaml
    kubectl apply -f secrets.yml
    kubectl apply -f mysql-pvc.yml
    kubectl apply -f mysql-config.yml
    kubectl apply -f mysql-deployment.yaml
    kubectl apply -f mysql-service.yaml
    kubectl apply -f embedder-deployment.yaml
    kubectl apply -f embedder-service.yaml
    kubectl apply -f neural-worker-deployment.yaml
    kubectl apply -f neural-worker-service.yaml
    kubectl apply -f rag-engine-deployment.yaml
    kubectl apply -f rag-engine-service.yaml

    cd ..
}

# Функция для проверки состояния подов и сервисов
check_status() {
    echo "Проверка состояния подов и сервисов..."
    kubectl get pods
    kubectl get services
}

# Функция для доступа к сервисам
access_service() {
    echo "Доступ к rag-engine сервису..."
    minikube service rag-engine
}

# Выполнение функций
build_images
apply_manifests
check_status
access_service

echo "Процесс завершен."
