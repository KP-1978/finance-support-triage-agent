FROM python:3.11-slim

# System deps for psycopg2 + curl (healthcheck)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc libpq-dev curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies (cached layer — only re-runs if requirements.txt changes)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Make start script executable
RUN chmod +x start.sh

# Railway sets $PORT at runtime (default 8501 for local testing)
ENV PORT=8501

EXPOSE $PORT

CMD ["./start.sh"]
