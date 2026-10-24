
# Base stage
FROM python:3.11-slim@sha256:b7a9e5f6a93d6d4a31f129bbd4bdee69efccb6ded0fb230d78aafaf37af98377 AS base

# Install curl for health checks
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/app

# Update packaging tools to address bundled vulnerabilities
RUN python -m pip install --no-cache-dir --upgrade "setuptools>=80.9.0" "wheel>=0.46.2"

# Install Python dependencies
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Development stage
FROM base AS dev
RUN pip install watchdog
ENV FLASK_ENV=development
CMD ["python", "app.py"]

# Production stage
FROM base AS final

# Create a non-root user
RUN groupadd --system appuser && \
    useradd --system --gid appuser --home-dir /home/appuser appuser

COPY --chown=appuser:appuser . .

USER appuser

EXPOSE 80

CMD ["gunicorn", "app:app", "-b", "0.0.0.0:80", "--log-file", "-", "--access-logfile", "-", "--workers", "4", "--keep-alive", "0"]
