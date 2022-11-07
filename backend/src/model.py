from typing import List, Optional

from sqlmodel import SQLModel, Field, Relationship
from pydantic import BaseModel

class Artist(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(index=True)
    albums: List["Album"] = Relationship(back_populates="artist")

class Genre(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(index=True)
    albums: List["Album"] = Relationship(back_populates="genre")

class Album(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(index=True)
    year: int
    number_of_tracks: int
    artist_id: int = Field(default=None, foreign_key="artist.id")
    artist: Artist = Relationship(back_populates="albums")
    genre_id: int = Field(default=None, foreign_key="genre.id")
    genre: Genre = Relationship(back_populates="albums")
    tracks: List["Track"] = Relationship(back_populates="album")

class Track(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    number: int
    title: str
    album_id: int = Field(default=None, foreign_key="album.id")
    album: Album = Relationship(back_populates="tracks")

class Song(BaseModel):
    number: int
    title: str

class Vinyl(BaseModel):
    name: str
    artist: str
    genre: str
    year: int
    number_of_tracks: int
    tracks: list[Song]