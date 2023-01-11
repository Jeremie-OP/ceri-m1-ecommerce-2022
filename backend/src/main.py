import bcrypt
import string

from typing import List
from fastapi import FastAPI, Request, Depends
from sqlmodel import Session, select

from src.model import Artist, Album, Genre, Track, Song, Vinyl, User, Password, Purchase, Item, Order, Stock
from src.db import init_db, get_session

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
            id=album.id,
            name=album.name,
            artist=album.artist.name,
            genre=album.genre.name,
            year=album.year,
            number_of_tracks=album.number_of_tracks,
            tracks=tracklist
        )
        vinyls.append(vinyl)
    return vinyls

def list_orders(result):
    orders = []
    for order in result:
        items = []
        for item in order.items:
            for i in range(item.quantity):
                album = list_vinyls([item.album])[0]
                album.tracks = []
                items.append(album)
        order = Order(
            id=order.id,
            date=order.purchase_date,
            user=order.user.id,
            items=items
        )
        orders.append(order)
    return(orders)

app = FastAPI()

@app.on_event("startup")
def on_startup():
    init_db()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/collection", response_model=list[Vinyl])
def get_all_vinyls(session: Session = Depends(get_session)):
    statement = select(Album)
    result = session.exec(statement)
    return list_vinyls(result)

@app.get("/genres", response_model=list[Genre])
def get_genres(session: Session = Depends(get_session)):
    statement = select(Genre)
    result = session.exec(statement)
    return [genre for genre in result]

@app.get("/artists", response_model=list[Artist])
def get_artists(session: Session = Depends(get_session)):
    statement = select(Artist)
    result = session.exec(statement)
    return [artist for artist in result]

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

@app.get("/vinyl/{ref}", response_model=Vinyl)
def get_vinyl_by_id(ref, session: Session = Depends(get_session)):
    statement = select(Album).where(Album.id == ref)
    try:
        result = session.exec(statement).one()
        return list_vinyls([result])[0]
    except:
        return []

@app.get("/stock/{ref}", response_model=int)
def get_stock_by_vinyl(ref, session: Session = Depends(get_session)):
    statement = select(Stock).where(Stock.album_id == ref)
    try:
        result = session.exec(statement).one()
        return result.available
    except:
        return -1

@app.get("/restock/{ref}/{num}")
def update_stock(ref, num, session: Session = Depends(get_session)):
    statement = select(Stock).where(Stock.album_id == ref)
    try:
        result = session.exec(statement).one()
        result.available = num
        session.add(result)
        session.commit()
        return({"success": 1})
    except:
        return {"error": 6}

@app.get("/orders")
def get_orders(session: Session = Depends(get_session)):
    statement = select(Purchase)
    result = session.exec(statement)
    return list_orders(result)

@app.get("/history/{user}", response_model=list[Order])
def get_puchases_by_user(user, session: Session = Depends(get_session)):
    statement = select(Purchase).where(Purchase.user_id == user)
    try:
        result = session.exec(statement).all()
        if len(result) == 0: return []
        return list_orders(result)
    except:
        return []

@app.get("/search/{text}")
def research(text, session: Session = Depends(get_session)):
    matchs = []
    occurence = dict()
    tokens = text.split(" ")
    stop_words = ["and", "but", "for", "out", "for", "from", "the", "les", "une", "des"]
    for token in tokens[:]:
        token = token.lower()
        if token in stop_words or len(token) < 3: tokens.remove(token)
    if len(tokens) == 0:
        return []
    statement = select(Album)
    result = session.exec(statement).all()
    for token in tokens:
        for album in result:
            if token.lower() in album.name.lower():
                if album.id in occurence:
                    occurence[album.id] = True
                else:
                    matchs.append(album)
            if token.lower() in album.artist.name.lower():
                if album.id in occurence:
                    occurence[album.id] = True
                else:
                    matchs.append(album)
    return matchs

@app.post("/createAccount")
async def create_account(request: Request, session: Session = Depends(get_session)):
    data = await request.json()
    statement = select(User).where(User.login == data["login"])
    try:
        result = session.exec(statement).one()
        return {"error": 1}
    except:
        for info in data.values():
            if info == None:
                return {"error": 2}
        new_user = User(
            login=data["login"],
            first=data["first"],
            last=data["last"],
            address=data["address"],
            zip=data["zip"],
            city=data["city"]
        )
        session.add(new_user)
        session.commit()
        statement = select(User).where(User.login == data["login"])
        new_user = session.exec(statement).one()
        plain_password = data["password"].encode('utf-8')
        hashed_password = bcrypt.hashpw(plain_password, bcrypt.gensalt())
        new_password = Password(password=hashed_password.decode('utf-8'), user_id=new_user.id)
        session.add(new_password)
        session.commit()
        return {"success": 1}

@app.post("/connect")
async def authentification(request: Request, session: Session = Depends(get_session)):
    data = await request.json()
    statement = select(User).where(User.login == data["login"])
    user = session.exec(statement).one()
    statement = select(Password).where(Password.user_id == user.id)
    password = session.exec(statement).one()
    plain_password = data["password"].encode('utf-8')
    if (bcrypt.checkpw(plain_password, password.password.encode('utf-8 '))):
        return user
    else:
        return {"error": -1}

@app.post("/updateAccount")
async def update_user_data(request: Request, session: Session = Depends(get_session)):
    data = await request.json()
    statement = select(User).where(User.id == data["id"])
    user = session.exec(statement).one()
    user.login = data["login"]
    user.first = data["first"]
    user.last = data["last"]
    user.address = data["address"]
    user.zip = data["zip"]
    user.city = data["city"]
    try:
        session.add(user)
        session.commit()
        return {"success": 1}
    except:
        return {"error": 5}

@app.post("/checkout")
async def confirm_order(request: Request, session: Session = Depends(get_session)):
    data = await request.json()
    # data = {0: {"user_id": 1}, 1: {"id": 1, "amount": 2}, 2: {"id": 4, "amount": 1}}
    user_id = data[0]["user_id"]
    try:
        purchase = Purchase(user_id=user_id)
        session.add(purchase)
        session.commit()
        session.refresh(purchase)
        for i in range(1, len(data)):
            item = Item(
                purchase_id=purchase.id,
                album_id=data[i]["id"],
                quantity=data[i]["amount"]
            )
            session.add(item)
        session.commit()
        return {"success": "confirmed"}
    except:
        return {"error": "bdd"}

@app.post("/newAlbum")
async def add_new_album(request: Request, session: Session = Depends(get_session)):
    data = await request.json()
    # data = {"name": "repression", "artist": "trust", "genre": "hard rock", "year": 1980, "number_of_tracks": 1, "tracks": ["antisocial"]}
    album_name = string.capwords(data["name"])
    artist_name = string.capwords(data["artist"])
    genre_name = string.capwords(data["genre"])
    try:
        statement = select(Album).where(Album.name == album_name and Album.artist.name == artist_name)
        result = session.exec(statement).one()
        return {"error": "duplicate"}
    except: 
        pass
    try:
        statement = select(Artist).where(Artist.name == artist_name)
        result = session.exec(statement).all()
        if len(result) == 0:
            artist = Artist(name=artist_name)
            session.add(artist)
            session.commit()
            session.refresh(artist)
        else:
            artist= result.pop()
        statement = select(Genre).where(Genre.name == genre_name)
        result = session.exec(statement).all()
        if len(result) == 0:
            genre = Genre(name=genre_name)
            session.add(genre)
            session.commit()
            session.refresh(genre)
        else:
            genre = result.pop()
        album = Album(
            name = album_name,
            year = data["year"],
            number_of_tracks = data["number_of_tracks"],
            artist_id = artist.id,
            genre_id = genre.id,
        )
        session.add(album)
        session.commit()
        session.refresh(album)
        for i, track in enumerate(data["tracks"]):
            track = Track(
                number=i+1,
                title=string.capwords(track),
                album_id=album.id
            )
            session.add(track)
        session.commit()
        return {"succes": 1}
    except:
        return {"error": "bdd"}