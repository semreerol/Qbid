from sqlalchemy import Column, Integer, String, Boolean
from .database import Base
from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String) # Burayı ekledik
    is_active = Column(Boolean, default=True)
    auctions = relationship("Auction", back_populates="owner")


# ... (Mevcut User sınıfın burada duruyor, ona dokunma)

class Auction(Base):
    __tablename__ = "auctions"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(String)
    min_price = Column(Integer)  # Gizli taban fiyat (Satıcı belirler)
    is_active = Column(Boolean, default=True)
    
    # Bu ilanı kim açtı?
    owner_id = Column(Integer, ForeignKey("users.id"))
    
    # İlişkiler (Python tarafında kolay erişim için)
    owner = relationship("User", back_populates="auctions")
    bids = relationship("Bid", back_populates="auction")

class Bid(Base):
    __tablename__ = "bids"

    id = Column(Integer, primary_key=True, index=True)
    amount = Column(Integer)  # Teklif edilen tutar
    
    # Kim teklif verdi? Hangi ilana?
    bidder_id = Column(Integer, ForeignKey("users.id"))
    auction_id = Column(Integer, ForeignKey("auctions.id"))

    bidder = relationship("User")
    auction = relationship("Auction", back_populates="bids")

    