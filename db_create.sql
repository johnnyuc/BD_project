-- Autores:  João Pinheiro 2017270907
--           Joel Oliveira 2021215037
--           Johnny Fernandes 2021190668
-- LEI UC 2022-23 - Sistemas Operativos

-- Criação de tabelas
CREATE TABLE usr (
	id	 SERIAL,
	username VARCHAR(512) NOT NULL,
	password VARCHAR(512) NOT NULL,
	email	 VARCHAR(512) NOT NULL,
	name	 VARCHAR(512) NOT NULL,
	address	 VARCHAR(512) NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE artist (
	artistic_name VARCHAR(512) NOT NULL,
	label_id	 INTEGER NOT NULL,
	usr_id	 INTEGER,
	PRIMARY KEY(usr_id)
);

CREATE TABLE consumer (
	usr_id INTEGER,
	PRIMARY KEY(usr_id)
);

CREATE TABLE admin (
	usr_id INTEGER,
	PRIMARY KEY(usr_id)
);

CREATE TABLE song (
	ismn	 SMALLSERIAL,
	name	 VARCHAR(512) NOT NULL,
	release_date DATE NOT NULL,
	genre	 VARCHAR(512) NOT NULL,
	duration	 INTEGER NOT NULL,
	first_artist INTEGER NOT NULL,
	album_pos	 SMALLINT,
	label_id	 INTEGER NOT NULL,
	PRIMARY KEY(ismn)
);

CREATE TABLE album (
	id		 SERIAL,
	name		 VARCHAR(512) NOT NULL,
	release_date	 VARCHAR(512) NOT NULL,
	label_id	 INTEGER NOT NULL,
	artist_usr_id INTEGER NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE comment (
	id	 SERIAL,
	content	 VARCHAR(512) NOT NULL,
	comment_id INTEGER ,
	song_ismn	 SMALLINT NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE purchase (
	transaction_time	 TIMESTAMP NOT NULL,
	transaction_value FLOAT(8) NOT NULL,
	card_id		 SMALLINT,
	subscription_id	 INTEGER,
	PRIMARY KEY(card_id,subscription_id)
);

CREATE TABLE subscription (
	id		 SERIAL NOT NULL,
	subscription_end TIMESTAMP NOT NULL,
	consumer_usr_id	 INTEGER NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE card (
	id		 SMALLSERIAL,
	price		 FLOAT(8) NOT NULL,
	expire_date	 DATE NOT NULL,
	current_balance FLOAT(8),
	admin_usr_id	 INTEGER NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE playlist (
	id		 SERIAL,
	name		 VARCHAR(512) NOT NULL,
	visibility	 BOOL NOT NULL,
	consumer_usr_id INTEGER NOT NULL,
	PRIMARY KEY(id)
);
CREATE TABLE counts (
	play_count INTEGER,
	usr_id	 INTEGER NOT NULL,
	song_ismn	 SMALLINT NOT NULL
);


CREATE TABLE label (
	id	 SERIAL,
	name VARCHAR(512) NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE log (
	played_date DATE NOT NULL,
	id		 SERIAL,
	PRIMARY KEY(id)
);

CREATE TABLE log_usr (
	log_id INTEGER,
	usr_id INTEGER,
	PRIMARY KEY(log_id,usr_id)
);

CREATE TABLE log_song (
	log_id	 INTEGER,
	song_ismn SMALLINT,
	PRIMARY KEY(log_id,song_ismn)
);

CREATE TABLE playlist_song (
	playlist_id INTEGER,
	song_ismn	 SMALLINT,
	PRIMARY KEY(playlist_id,song_ismn)
);

CREATE TABLE album_song (
	album_id	 INTEGER NOT NULL,
	song_ismn SMALLINT,
	PRIMARY KEY(song_ismn)
);

CREATE TABLE artist_song (
	artist_usr_id INTEGER,
	song_ismn	 SMALLINT,
	PRIMARY KEY(artist_usr_id,song_ismn)
);


-- Adiciona relações
ALTER TABLE usr ADD UNIQUE (username, email);
ALTER TABLE artist ADD UNIQUE (artistic_name);
ALTER TABLE artist ADD CONSTRAINT artist_fk1 FOREIGN KEY (label_id) REFERENCES label(id);
ALTER TABLE artist ADD CONSTRAINT artist_fk2 FOREIGN KEY (usr_id) REFERENCES usr(id);
ALTER TABLE consumer ADD CONSTRAINT consumer_fk1 FOREIGN KEY (usr_id) REFERENCES usr(id);
ALTER TABLE admin ADD CONSTRAINT admin_fk1 FOREIGN KEY (usr_id) REFERENCES usr(id);
ALTER TABLE song ADD UNIQUE (name);
ALTER TABLE song ADD CONSTRAINT song_fk1 FOREIGN KEY (label_id) REFERENCES label(id);
ALTER TABLE album ADD UNIQUE (name, release_date);
ALTER TABLE album ADD CONSTRAINT album_fk1 FOREIGN KEY (label_id) REFERENCES label(id);
ALTER TABLE album ADD CONSTRAINT album_fk2 FOREIGN KEY (artist_usr_id) REFERENCES artist(usr_id);
ALTER TABLE comment ADD CONSTRAINT comment_fk1 FOREIGN KEY (comment_id) REFERENCES comment(id);
ALTER TABLE comment ADD CONSTRAINT comment_fk2 FOREIGN KEY (song_ismn) REFERENCES song(ismn);
ALTER TABLE purchase ADD CONSTRAINT purchase_fk1 FOREIGN KEY (card_id) REFERENCES card(id);
ALTER TABLE purchase ADD CONSTRAINT purchase_fk2 FOREIGN KEY (subscription_id) REFERENCES subscription(id);
ALTER TABLE subscription ADD CONSTRAINT subscription_fk1 FOREIGN KEY (consumer_usr_id) REFERENCES consumer(usr_id);
ALTER TABLE card ADD CONSTRAINT card_fk1 FOREIGN KEY (admin_usr_id) REFERENCES admin(usr_id);
ALTER TABLE playlist ADD CONSTRAINT playlist_fk1 FOREIGN KEY (consumer_usr_id) REFERENCES consumer(usr_id);
ALTER TABLE label ADD UNIQUE (name);
ALTER TABLE log_usr ADD CONSTRAINT log_usr_fk1 FOREIGN KEY (log_id) REFERENCES log(id);
ALTER TABLE log_usr ADD CONSTRAINT log_usr_fk2 FOREIGN KEY (usr_id) REFERENCES usr(id);
ALTER TABLE log_song ADD CONSTRAINT log_song_fk1 FOREIGN KEY (log_id) REFERENCES log(id);
ALTER TABLE log_song ADD CONSTRAINT log_song_fk2 FOREIGN KEY (song_ismn) REFERENCES song(ismn);
ALTER TABLE playlist_song ADD CONSTRAINT playlist_song_fk1 FOREIGN KEY (playlist_id) REFERENCES playlist(id);
ALTER TABLE playlist_song ADD CONSTRAINT playlist_song_fk2 FOREIGN KEY (song_ismn) REFERENCES song(ismn);
ALTER TABLE album_song ADD CONSTRAINT album_song_fk1 FOREIGN KEY (album_id) REFERENCES album(id);
ALTER TABLE album_song ADD CONSTRAINT album_song_fk2 FOREIGN KEY (song_ismn) REFERENCES song(ismn);
ALTER TABLE artist_song ADD CONSTRAINT artist_song_fk1 FOREIGN KEY (artist_usr_id) REFERENCES artist(usr_id);
ALTER TABLE artist_song ADD CONSTRAINT artist_song_fk2 FOREIGN KEY (song_ismn) REFERENCES song(ismn);
ALTER TABLE counts ADD CONSTRAINT counts_fk1 FOREIGN KEY (usr_id) REFERENCES usr(id);
ALTER TABLE counts ADD CONSTRAINT counts_fk2 FOREIGN KEY (song_ismn) REFERENCES song(ismn);

-- Cria utilizador admin
INSERT INTO usr (id, username, password, email, name, address) VALUES (1,'admin', '$2b$12$RNkxEQuqUBU0xV/Hky6j4uloDN6.iep.L4TddnlhxnqTimQevpMR2', 'admin', 'admin', 'DEI');
INSERT into admin values(1);

-- Cria utilizador para a API
CREATE ROLE apiuser WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  PASSWORD 'apiuser';

-- Garante permissões
GRANT SELECT, UPDATE, INSERT ON TABLE admin TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE album TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE album_song TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE artist TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE artist_song TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE card TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE comment TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE consumer TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE label TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE log TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE playlist TO apiuser;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE playlist_song TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE purchase TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE subscription TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE usr TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE song TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE log_song TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE log_usr TO apiuser;
GRANT SELECT, UPDATE, INSERT ON TABLE counts TO apiuser;


-- Permissões específicas para a API
GRANT USAGE, SELECT, UPDATE ON TABLE album_id_seq TO apiuser;
GRANT USAGE, SELECT, UPDATE ON TABLE card_id_seq TO apiuser;
GRANT USAGE, SELECT, UPDATE ON TABLE comment_id_seq TO apiuser;
GRANT USAGE, SELECT, UPDATE ON TABLE label_id_seq TO apiuser;
GRANT USAGE, SELECT, UPDATE ON TABLE log_id_seq TO apiuser;
GRANT USAGE, SELECT, UPDATE ON TABLE playlist_id_seq TO apiuser;
GRANT USAGE, SELECT, UPDATE ON TABLE song_ismn_seq TO apiuser;
GRANT USAGE, SELECT, UPDATE ON TABLE subscription_id_seq TO apiuser;
GRANT USAGE, SELECT, UPDATE ON TABLE usr_id_seq TO apiuser;
