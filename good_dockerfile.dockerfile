FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python3-tk \
        git \
        bash \
        libsm6 \
        libgl1 \
        libxrender1 \
        libxext6 \
        wget \
        curl \
        zip \
        unzip \
        libtcmalloc-minimal4 \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
    
WORKDIR /embedder
VOLUME ["/text_data/to_embed"]
COPY . /embedder/
RUN pip install -r requirements_good.txt --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cu121
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8010"]