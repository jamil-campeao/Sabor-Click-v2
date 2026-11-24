FROM python:3.13-slim

# Não gera .pyc e mostra os logs na hora
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Instala as dependências antes de copiar o código para aproveitar o cache do Docker
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn==23.0.0

COPY . .

# Roda o sistema com um usuário sem privilégios de administrador
RUN useradd --create-home sabor && chown -R sabor:sabor /app
USER sabor

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "--access-logfile", "-", "app:app"]
