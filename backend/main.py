import secrets
from pathlib import Path
from contextlib import asynccontextmanager

import psycopg
from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse, RedirectResponse
from pydantic import BaseModel, HttpUrl


@asynccontextmanager
async def lifespan(app: FastAPI):
    with psycopg.connect(connect_timeout=5) as conn:
        conn.execute(
            "CREATE TABLE IF NOT EXISTS links "
            "(code TEXT PRIMARY KEY, url TEXT NOT NULL)"
        )
    yield


app = FastAPI(lifespan=lifespan)


class LinkCreate(BaseModel):
    url: HttpUrl


@app.get("/")
def home():
    return FileResponse(Path(__file__).with_name("index.html"))


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/api/links")
def create_link(link: LinkCreate):
    code = secrets.token_urlsafe(8)

    with psycopg.connect(connect_timeout=5) as conn:
        conn.execute(
            "INSERT INTO links (code, url) VALUES (%s, %s)",
            (code, str(link.url)),
        )

    return {
        "code": code,
        "short_url": f"/r/{code}",
    }


@app.get("/r/{code}")
def redirect(code: str):
    with psycopg.connect(connect_timeout=5) as conn:
        row = conn.execute(
            "SELECT url FROM links WHERE code = %s",
            (code,),
        ).fetchone()

    if row is None:
        raise HTTPException(status_code=404, detail="Link nie istnieje")

    return RedirectResponse(row[0], status_code=302)
