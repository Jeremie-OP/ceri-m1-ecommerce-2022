import src.main as api

import random

def test_read_root():
    assert api.read_root() == {"Hello": "World"}

def test_read_artists(mocker):
    nb_items = random.randint(1,10)
    session = mocker.MagicMock()
    session.exec.return_value = [i for i in range(nb_items)]
    assert len(api.get_artists(session)) == nb_items

def test_read_collections(mocker):
    session = mocker.MagicMock()
    album = mocker.MagicMock()
    track = mocker.MagicMock()
    track.number = 0
    track.title = "dummy_track"
    album.tracks = [track]
    album.name = "dummy_album"
    album.artist.name = "dummy_artist"
    album.genre.name = "dummy_genre"
    album.year = 2042
    album.number_of_tracks = 1
    session.exec.return_value = [album]
    assert len(api.get_all_vinyls(session)) == 1
    assert api.get_all_vinyls(session)[0].name == "dummy_album"
    assert api.get_all_vinyls(session)[0].artist == "dummy_artist"
    assert api.get_all_vinyls(session)[0].genre == "dummy_genre"
    assert api.get_all_vinyls(session)[0].year == 2042
    assert api.get_all_vinyls(session)[0].number_of_tracks == 1
    assert len(api.get_all_vinyls(session)[0].tracks) == api.get_all_vinyls(session)[0].number_of_tracks

def test_read_vinyls_by_genre(mocker):
    session = mocker.MagicMock()
    album = mocker.MagicMock()
    track = mocker.MagicMock()
    track.number = 0
    track.title = "dummy_track"
    album.tracks = [track]
    album.name = "dummy_album"
    album.artist.name = "dummy_artist"
    album.genre.name = "dummy_genre"
    album.year = 2042
    album.number_of_tracks = 1
    session.exec.return_value.one.return_value.albums = [album]
    assert len(api.get_vinyls_by_genre("dummy_genre", session)) == 1
    assert api.get_vinyls_by_genre("dummy_genre", session)[0].name == "dummy_album"
    assert api.get_vinyls_by_genre("dummy_genre", session)[0].artist == "dummy_artist"
    assert api.get_vinyls_by_genre("dummy_genre", session)[0].genre == "dummy_genre"
    assert api.get_vinyls_by_genre("dummy_genre", session)[0].year == 2042
    assert api.get_vinyls_by_genre("dummy_genre", session)[0].number_of_tracks == 1
    assert len(api.get_vinyls_by_genre("dummy_genre", session)[0].tracks) == api.get_vinyls_by_genre("dummy_genre", session)[0].number_of_tracks
    session.exec.return_value.one.return_value.albums = []
    assert len(api.get_vinyls_by_genre("dummy_genre", session)) == 0

def test_read_vinyls_by_artist(mocker):
    session = mocker.MagicMock()
    album = mocker.MagicMock()
    track = mocker.MagicMock()
    track.number = 0
    track.title = "dummy_track"
    album.tracks = [track]
    album.name = "dummy_album"
    album.artist.name = "dummy_artist"
    album.genre.name = "dummy_genre"
    album.year = 2042
    album.number_of_tracks = 1
    session.exec.return_value.one.return_value.albums = [album]
    assert len(api.get_vinyls_by_artist("dummy_artist", session)) == 1
    assert api.get_vinyls_by_artist("dummy_artist", session)[0].name == "dummy_album"
    assert api.get_vinyls_by_artist("dummy_artist", session)[0].artist == "dummy_artist"
    assert api.get_vinyls_by_artist("dummy_artist", session)[0].genre == "dummy_genre"
    assert api.get_vinyls_by_artist("dummy_artist", session)[0].year == 2042
    assert api.get_vinyls_by_artist("dummy_artist", session)[0].number_of_tracks == 1
    assert len(api.get_vinyls_by_artist("dummy_artist", session)[0].tracks) == api.get_vinyls_by_artist("dummy_artist", session)[0].number_of_tracks
    session.exec.return_value.one.return_value.albums = []
    assert len(api.get_vinyls_by_artist("dummy_artist", session)) == 0