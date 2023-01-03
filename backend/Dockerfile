FROM python:bullseye
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /backend

COPY cloud-sql-proxy .
RUN chmod +x ./cloud-sql-proxy

# Install production dependencies.
COPY requirements.txt .
RUN python -m pip install --no-cache-dir --upgrade -r requirements.txt

ENV PORT=8080

COPY ./src /backend/src
CMD uvicorn src.main:app --host 0.0.0.0 --port $PORT

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
# CMD exec gunicorn --bind :"8080" --workers 1 --timeout 0 src.main:app