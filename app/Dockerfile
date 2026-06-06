FROM python:3.12-slim

ARG APP_VERSION=v1
ARG APP_COLOR=blue

ENV APP_VERSION=${APP_VERSION}
ENV APP_COLOR=${APP_COLOR}
ENV APP_STRATEGY="Local Docker"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
