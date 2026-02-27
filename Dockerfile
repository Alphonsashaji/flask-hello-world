# Use slim image
FROM python:3.11-slim

# Prevent pyc files & enable logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create non-root user
RUN useradd -m appuser

WORKDIR /app

# Install system deps (if needed)
RUN apt-get update && apt-get install -y build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies first (Docker layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . .

# Change ownership
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 5000

# Production server
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "run:app"]
