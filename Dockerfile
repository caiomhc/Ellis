# 1. Use uma imagem oficial do Python como imagem base
# O README especifica Python 3.10+, então usaremos uma imagem 'slim' para manter o tamanho reduzido.
FROM python:3.10-slim-bullseye

# 2. Define o diretório de trabalho no contêiner
WORKDIR /app

# 3. Copia o arquivo de dependências para o diretório de trabalho
# Isso é feito primeiro para aproveitar o cache de camadas do Docker.
# Se o requirements.txt não mudar, esta camada não será reconstruída.
COPY requirements.txt .

# 4. Instala os pacotes necessários especificados no requirements.txt
# Atualizamos o pip e usamos --no-cache-dir para manter a imagem menor.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 5. Copia o restante do código da aplicação
COPY . .

# 6. Expõe a porta em que o aplicativo é executado
EXPOSE 8000

# 7. Define o comando para executar a aplicação
# Usamos 0.0.0.0 para torná-lo acessível de fora do contêiner.
# O --reload é ótimo para desenvolvimento, mas não deve ser usado em produção.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]