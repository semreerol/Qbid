# 1. Base Image: Python 3.10 yüklü hafif Linux
FROM python:3.10-slim

# 2. Python çıktılarını anlık görelim (loglar tamponlanmasın)
ENV PYTHONUNBUFFERED=1

# 3. Çalışma dizini oluştur
WORKDIR /code

# 4. Kütüphaneleri kopyala ve yükle
COPY requirements.txt /code/
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# 5. Kodları kopyala (app klasörünü /code/app içine at)
COPY ./app /code/app

# 6. Uygulamayı başlat
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]