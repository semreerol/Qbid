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

# ... (önceki kodlar)

def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.User).offset(skip).limit(limit).all()

# --- MÜZAYEDE İŞLEMLERİ ---

def create_auction(db: Session, auction: schemas.AuctionCreate, user_id: int):
    db_auction = models.Auction(**auction.dict(), owner_id=user_id)
    db.add(db_auction)
    db.commit()
    db.refresh(db_auction)
    return db_auction

def get_auctions(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Auction).offset(skip).limit(limit).all()

# --- TEKLİF İŞLEMLERİ ---

def create_bid(db: Session, bid: schemas.BidCreate, user_id: int, auction_id: int):
    db_bid = models.Bid(**bid.dict(), bidder_id=user_id, auction_id=auction_id)
    db.add(db_bid)
    db.commit()
    db.refresh(db_bid)
    return db_bid

def close_auction(db: Session, auction_id: int):
    # 1. İlanı bul
    auction = db.query(models.Auction).filter(models.Auction.id == auction_id).first()
    
    if not auction:
        return {"status": "error", "message": "İlan bulunamadı"}
    
    if not auction.is_active:
        return {"status": "info", "message": "Bu ilan zaten kapanmış"}

    # 2. En yüksek teklifi bul (Veritabanından fiyata göre tersten sıralayıp ilkini al)
    highest_bid = db.query(models.Bid).filter(models.Bid.auction_id == auction_id)\
                    .order_by(models.Bid.amount.desc()).first()

    # 3. İlanı pasife çek (Artık teklif verilemez)
    auction.is_active = False
    db.commit()

    # 4. Sonuç Hesaplama
    if not highest_bid:
        return {"status": "fail", "message": "Hiç teklif gelmedi."}
    
    if highest_bid.amount >= auction.min_price:
        return {
            "status": "success",
            "winner_id": highest_bid.bidder_id,
            "winning_price": highest_bid.amount,
            "message": "Ürün satıldı!"
        }
    else:
        return {
            "status": "fail",
            "highest_bid": highest_bid.amount,
            "min_price": auction.min_price, # Artık sonucu gösterirken taban fiyatı açıklayabiliriz
            "message": "Taban fiyat geçilemedi, ürün satılmadı."
        }