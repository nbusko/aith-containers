Манифесты хранятся в `k8s-manifests`



## Шаги по настройке


1. Запуск minikube командой minikube start и настройка Docker на использование minikube daemon:

   ```bash
   minikube start
   eval $(minikube docker-env)
   ```
   ![alt text](image.png)

2. Запуск deploy.sh для сбора образов в среде миникуба и применения манифестов kubernetes: 

   ```bash
   chmod +x deploy.sh
   ./deploy.sh 
   ```

3. Применение манифестов и проверка логов подов из `deploy.sh`:

   ![alt text](image-1.png)

   ![alt text](image-2.png)


5. Проброс портов наружу:

   ```bash
   kubectl port-forward svc/embedder 8002:8002
   ```
6. Сервис работает:
   ![alt text](image-3.png)
   ![alt text](image-5.png)