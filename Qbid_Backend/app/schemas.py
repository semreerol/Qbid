from pydantic import BaseModel

# Kullanıcı oluştururken istenecek veriler
class UserCreate(BaseModel):
    email: str
    password: str 

# Kullanıcı bilgisini geri döndürürken gösterilecek veriler
# (Şifreyi geri döndürmemek için ayrı sınıf yapıyoruz)
class User(BaseModel):
    id: int
    email: str
    is_active: bool

    class Config:
        from_attributes = True

# --- AUCTION (MÜZAYEDE) ŞEMALARI ---

class AuctionBase(BaseModel):
    title: str
    description: str

# İlan oluştururken "minimum fiyat" istenir
class AuctionCreate(AuctionBase):
    min_price: int 

# İlanı gösterirken "minimum fiyat" GİZLENİR (Blind Bid Kuralı)
class Auction(AuctionBase):
    id: int
    owner_id: int
    is_active: bool
    # Dikkat: min_price buraya eklenmedi!

    class Config:
        from_attributes = True

# --- BID (TEKLİF) ŞEMALARI ---

class BidCreate(BaseModel):
    amount: int

class Bid(BaseModel):
    id: int
    amount: int
    bidder_id: int
    auction_id: int

    class Config:
        from_attributes = True        

class UserLogin(BaseModel):
    email: str
    password: str        