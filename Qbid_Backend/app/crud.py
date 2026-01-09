from sqlalchemy.orm import Session
from . import models, schemas

def create_user(db: Session, user: schemas.UserCreate):
    # NOT: Gerçek projede şifreyi hashleyerek (kriptolayarak) kaydetmeliyiz.
    # Şimdilik mantığı anlamak için düz kaydediyoruz.
    fake_hashed_password = user.password + "notreallyhashed"
    
    db_user = models.User(email=user.email, hashed_password=fake_hashed_password)
    db.add(db_user)
    db.commit()      # İşlemi onayla
    db.refresh(db_user) # Yeni ID atanmış halini geri al
    return db_user

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()