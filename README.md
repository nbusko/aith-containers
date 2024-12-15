# News AI-based Chat Delivery Project

This project is designed to deliver news in a chat format based on data and themes.

## Installation

### Step 1: Create a .env File

Add a `.env` file to the root directory of the project with the following content:

```bash
# Embedder settings
EMBEDDER_PORT=8050
SPECIFIC_MODEL="" # will be chosen default model
CUDA_VISIBLE_DEVICES_EMB=all
TRANSFORMERS_CACHE=/cache/

# MySQL
DB_NAME=rag_db
DB_USER=root
EMBEDDER_URL=http://embedder:8050
DB_HOST=mysql
DB_PORT=3306
DB_ROOT_PASSWORD=123

RAG_ENGINE_PORT=8070

# Neural GPT worker settings
WORKER_PORT=8090
GPT_TOKEN="sk-XXXXXXXXXXXXXXXXXXXXXXXXX"
BASE_GPT_URL="https://api.proxyapi.ru/openai/v1" 
```

Fill in the variables with the appropriate values.

### Step 2: Build and Start Containers

1. **Build Containers**

   Run the following command to build the Docker containers:

   ```bash
   docker-compose build
   ```

2. **Start Containers**

   Start the containers in detached mode:

   ```bash
   docker-compose up -d
   ```

## `docker-compose.yml` description:

- **mysql:**
  - MySQL database.
  - Uses the `mysql:5.6` image.
  - Container name is `mysql`.
  - Adds the `mysqldata` volume to the `/var/lib/mysql` directory for database storage and `eee/my.cnf` to the `/etc/mysql/my.cnf` directory.
  - Checks health with `healthcheck`.
  - Network `my_network`.

- **rag_engine:**
  - Service for searching information in the database based on user requests.
  - Uses the `rag_engine:latest` image, built from `./rag_engine`.
  - Container name is `rag_engine`.
  - `restart: always`.
  - Runs the command `bash -c "uvicorn src.main:app --host 0.0.0.0 --port ${RAG_ENGINE_PORT}"`.
  - Depends on services:
    - mysql
    - embedder
    - neural_worker
  - Network `my_network`.

- **neural_worker:**
  - Service for processing user requests using LLM.
  - Uses the `neural_worker:latest` image, built from `./neural_worker`.
  - Container name is `neural_worker`.
  - `restart: always`.
  - Runs the command `bash -c "uvicorn main:app --host 0.0.0.0 --port ${WORKER_PORT}"`.
  - Network `my_network`.

- **embedder:**
  - Service for obtaining text embeddings.
  - Uses the `embedder:latest` image, built from `./embedder`.
  - Container name is `embedder`.
  - `restart: always`.
  - Runs the command `bash -c "uvicorn main:app --host 0.0.0.0 --port ${EMBEDDER_PORT}"`.
  - Network `my_network`.

- **init:**
  - Service for initialization.
  - Uses the `python:3.10-slim` image.
  - Container name is `init`.
  - `restart: no`.
  - Runs the command `sh -c "echo 'Starting services'; sleep 30; echo 'initialization is completed'"`.
  - Network `my_network`.


## Questions answering

> Ограничение ресурсов в docker-compose.yml

Да, можно ограничить ресурсы, например память и CPU, для сервисов в docker-compose.yml. Это можно сделать установив параметры mem_limit и cpus. 
```yaml
services:
   my_service:
      image: my_image:latest
   deploy:
      resources:
         limits:
            memory: 512M
            cpus: '0.3'
```

> Запуск только определенного сервиса

Чтобы запустить только определенный сервис из docker-compose.yml, можно использовать команду:
```bash
docker-compose up <service_name>
```
Запускает определенный серис и его зависимости



