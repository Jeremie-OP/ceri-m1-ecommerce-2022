CREATE DATABASE IF NOT EXISTS vinyl;
CREATE TABLE IF NOT EXISTS vinyl.artist (
	artist_id INT NOT NULL AUTO_INCREMENT,
    artist_name CHAR(50) NOT NULL,
    PRIMARY KEY (artist_id)
);
CREATE TABLE IF NOT EXISTS vinyl.album (
	album_id INT NOT NULL AUTO_INCREMENT,
    album_name CHAR(50) NOT NULL,
    release_year INT NOT NULL,
    number_of_tracks INT NOT NULL,
    artist_id INT NOT NULL,
    PRIMARY KEY (album_id),
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);
CREATE TABLE IF NOT EXISTS vinyl.track (
	track_id INT NOT NULL AUTO_INCREMENT,
    track_num INT NOT NULL,
    track_title CHAR(50) NOT NULL,
    album_id INT NOT NULL,
    PRIMARY KEY (track_id),
    FOREIGN KEY (album_id) REFERENCES album(album_id)
);
CREATE TABLE IF NOT EXISTS vinyl.genre (
	genre_id INT NOT NULL AUTO_INCREMENT,
    genre_name CHAR(50) NOT NULL,
    album_id INT,
	PRIMARY KEY (genre_id),
    FOREIGN KEY (album_id) REFERENCES album(album_id)
);
