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