# ---- base ----
FROM python:3.11-slim-bullseye  # 3.12 bazı wheel’larda hâlâ derleme gerektiriyor → yavaş

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=0  # pip kullandığınız için ama geleceğe yatırım; opsiyonel

WORKDIR /app


RUN apt-get update && apt-get install -y --no-install-recommends \
        libglib2.0-0 \
        libgl1-mesa-glx \
        libsm6 libxext6 libxrender-dev \
    && rm -rf /var/lib/apt/lists/*


COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt


COPY . .


EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080", "--log-level", "debug"]

