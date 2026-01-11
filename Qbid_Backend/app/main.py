from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas, crud
from .database import SessionLocal, engine

# 1. Veritabanı tablolarını oluştur (Eğer yoksa)
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Qbid API")

# Dependency: Her istekte veritabanını aç, iş bitince kapat.
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def read_root():
    return {"message": "Qbid API Hazır!"}

# --- KULLANICI İŞLEMLERİ ---

@app.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    # Önce bu email var mı kontrol et
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Bu email zaten kayıtlı")
    # Yoksa oluştur
    return crud.create_user(db=db, user=user)

@app.post("/login/")
def login(user_credentials: schemas.UserLogin, db: Session = Depends(get_db)):
    # 1. Kullanıcıyı email ile bul
    user = crud.get_user_by_email(db, email=user_credentials.email)
    
    # 2. Kullanıcı yoksa hata ver
    if not user:
        raise HTTPException(status_code=404, detail="Kullanıcı bulunamadı")
    
    # 3. Şifre kontrolü (Basit demo mantığımızla)
    # create_user fonksiyonunda şifreye "notreallyhashed" eklemiştik, burada da ekleyip kontrol ediyoruz.
    check_password = user_credentials.password + "notreallyhashed"
    
    if user.hashed_password != check_password:
        raise HTTPException(status_code=400, detail="Şifre hatalı")
    
    # 4. Başarılıysa User ID'sini dön
    return {"status": "success", "user_id": user.id, "email": user.email} 

@app.get("/users/", response_model=list[schemas.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = crud.get_users(db, skip=skip, limit=limit)
    return users

# ... (User endpointlerinin altına ekle)

# 1. Yeni Müzayede Başlat
@app.post("/auctions/", response_model=schemas.Auction)
def create_auction(auction: schemas.AuctionCreate, user_id: int, db: Session = Depends(get_db)):
    # Not: Normalde user_id'yi giriş yapmış kullanıcıdan otomatik alırız (JWT ile).
    # Şimdilik test için elle giriyoruz.
    return crud.create_auction(db=db, auction=auction, user_id=user_id)

# 2. Müzayedeleri Listele
@app.get("/auctions/", response_model=list[schemas.Auction])
def read_auctions(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    auctions = crud.get_auctions(db, skip=skip, limit=limit)
    return auctions

# 3. Teklif Ver
@app.post("/auctions/{auction_id}/bids/", response_model=schemas.Bid)
def create_bid(auction_id: int, bid: schemas.BidCreate, user_id: int, db: Session = Depends(get_db)):
    return crud.create_bid(db=db, bid=bid, user_id=user_id, auction_id=auction_id)


@app.post("/auctions/{auction_id}/close")
def close_auction_endpoint(auction_id: int, db: Session = Depends(get_db)):
    result = crud.close_auction(db=db, auction_id=auction_id)
    return result