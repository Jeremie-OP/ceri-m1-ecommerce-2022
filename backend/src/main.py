from typing import List
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware

from sqlmodel import Session, select

from src.model import Artist, Album, Genre, Song, Vinyl
from src.db import init_db, get_session
import os


def list_vinyls(result):
    vinyls = []
    for album in result:
        tracklist = []
        for track in album.tracks:
            song = Song(
                number=track.number,
                title=track.title
            )
            tracklist.append(song)
        vinyl = Vinyl(
            name=album.name,
            artist=album.artist.name,
            genre=album.genre.name,
            year=album.year,
            number_of_tracks=album.number_of_tracks,
            tracks=tracklist
        )
        vinyls.append(vinyl)
    return vinyls


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
#authorize Access-Control


@app.on_event("startup")
def on_startup():
    init_db()

@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/artists", response_model=list[Artist])
def get_artists(session: Session = Depends(get_session)):
    statement = select(Artist)
    result = session.exec(statement)
    return [artist for artist in result]


@app.get("/collection", response_model=list[Vinyl])
def get_all_vinyls(session: Session = Depends(get_session)):
    statement = select(Album)
    result = session.exec(statement)
    return list_vinyls(result)


@app.get("/genre/{genre}", response_model=list[Vinyl])
def get_vinyls_by_genre(genre, session: Session = Depends(get_session)):
    statement = select(Genre).where(Genre.name == genre)
    try:
        result = session.exec(statement).one().albums
        return list_vinyls(result)
    except:
        return []


@app.get("/artist/{artist}", response_model=list[Vinyl])
def get_vinyls_by_artist(artist, session: Session = Depends(get_session)):
    statement = select(Artist).where(Artist.name == artist)
    try:
        result = session.exec(statement).one().albums
        return list_vinyls(result)
    except:
        return []
