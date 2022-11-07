FROM python:bullseye
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /backend
COPY requirements.txt .
RUN python -m pip install --no-cache-dir --upgrade -r requirements.txt
COPY ./src /backend/src
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80"]