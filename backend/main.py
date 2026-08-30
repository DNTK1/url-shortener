import secrets

from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse
from pydantic import BaseModel, HttpUrl

app = FastAPI()

links = {}


class LinkCreate(BaseModel):
    url: HttpUrl


@app.get("/")
def home():
    return {"message": "URL shortener działa"}


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/api/links")
def create_link(link: LinkCreate):
    code = secrets.token_urlsafe(5)
    links[code] = str(link.url)

    return {
        "code": code,
        "short_url": f"/r/{code}",
    }


@app.get("/r/{code}")
def redirect(code: str):
    if code not in links:
        raise HTTPException(status_code=404, detail="Link nie istnieje")

    return RedirectResponse(links[code], status_code=302)
