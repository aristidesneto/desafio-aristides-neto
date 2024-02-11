FROM python:3.11.8-alpine3.19

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip && \ 
    pip install --no-cache-dir --upgrade -r requirements.txt

COPY ./comments_api ./comments_api

ENV USER=appuser \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN adduser --disabled-password --gecos '' ${USER}

RUN chown -R ${USER}:${USER} /app

USER ${USER}

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "comments_api.api:app"]
