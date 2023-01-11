from datetime import datetime

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
    id = int
    name: str
    artist: str
    genre: str
    year: int
    number_of_tracks: int
    tracks: list[Song]

class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    login: str
    first: str
    last: str
    address: str
    zip: str
    city: str
    admin: bool = Field(default=False)
    purchases: List["Purchase"] = Relationship(back_populates="user")

class Password(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    password: str
    user_id: int = Field(default=None, foreign_key="user.id")

class Purchase(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    purchase_date: datetime = Field(default=datetime.now(), nullable=False)
    user_id: int = Field(default=None, foreign_key="user.id")
    user: User = Relationship(back_populates="purchases")
    items: List["Item"] = Relationship(back_populates="purchase")

class Item(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    purchase_id: int = Field(default=None, foreign_key="purchase.id")
    purchase: Purchase = Relationship(back_populates="items")
    album_id: int = Field(default=None, foreign_key="album.id")
    album: Album = Relationship()
    quantity: int

class Stock(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    album_id: int = Field(default=None, foreign_key="album.id")
    available: int

class Order(BaseModel):
    id = int
    date: datetime
    user: int
    items: list[Vinyl]