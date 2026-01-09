from fastapi import FastAPI

app = FastAPI(title="Qbid API", version="0.1.0")

@app.get("/")
def read_root():
    return {"message": "Qbid API çalışıyor!", "status": "active"}

@app.get("/health")
def health_check():
    return {"status": "ok"}