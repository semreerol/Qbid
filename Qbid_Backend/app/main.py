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

@app.get("/users/", response_model=list[schemas.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = crud.get_users(db, skip=skip, limit=limit)
    return users