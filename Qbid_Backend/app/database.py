from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

# Veritabanı adresini "Environment Variable" (Ortam Değişkeni) olarak alacağız.
# Eğer sistemde kayıtlı bir adres yoksa (localde çalışırken hata vermesin diye) boş bir string atıyoruz.
# Gerçek ortamda buraya Render/Railway'in verdiği adresi gireceğiz.
SQLALCHEMY_DATABASE_URL = os.getenv("DATABASE_URL")

# Eğer URL yoksa (henüz ayarlamadıysak) işlem yapma
if SQLALCHEMY_DATABASE_URL:
    # Postgres bağlantı motorunu oluştur
    engine = create_engine(SQLALCHEMY_DATABASE_URL)
    
    # Veritabanı oturumu oluşturucu
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
else:
    engine = None
    SessionLocal = None

# Modellerimizin (Tabloların) miras alacağı temel sınıf
Base = declarative_base()

# Veritabanı bağlantısını sağlayan yardımcı fonksiyon (Dependency Injection için)
def get_db():
    if SessionLocal is None:
        return
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()