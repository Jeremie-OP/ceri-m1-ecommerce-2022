from typing import List
from fastapi import FastAPI, Depends
from sqlmodel import Session, select

from .model import Artist, Album, Genre, Track
from .db import init_db, get_session

class Song():
    def __init__(self, number, title):
        self.number = number
        self.title = title

app = FastAPI()

@app.on_event("startup")
def on_startup():
    init_db()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/collection")
def get_all_vinyls(session: Session = Depends(get_session)):
    statement = select(Album)
    result = session.exec(statement)
    albums = {"albums": []}
    for album in result:
        albums.get("albums").append(album.json())
    return albums

@app.get("/genre/{genre}")
def get_vinyls_by_genre(genre, session: Session = Depends(get_session)):
    statement = select(Genre).where(Genre.name == genre)
    result = session.exec(statement).one().albums
    albums = {"albums": []}
    for album in result:
        albums.get("albums").append(album.json())
    return albums

@app.get("/artist/{artist}")
def get_vinyls_by_artist(artist, session: Session = Depends(get_session)):
    statement = select(Artist).where(Artist.name == artist)
    result = session.exec(statement).one().albums
    albums = {"albums": []}
    for album in result:
        albums.get("albums").append(album.json())
    return albums
