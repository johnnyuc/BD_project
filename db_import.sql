-- Autores:  João Pinheiro 2017270907
--           Joel Oliveira 2021215037
--           Johnny Fernandes 2021190668
-- LEI UC 2022-23 - Sistemas Operativos

-- $2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW corresponde a 'password'

-- Criar labels
INSERT INTO label (name) VALUES
    ('Label 1'),
    ('Label 2'),
    ('Label 3'),
    ('Label 4'),
    ('Label 5'),
    ('Label 6'),
    ('Label 7'),
    ('Label 8'),
    ('Label 9'),
    ('Label 10');

-- Criar artistas
INSERT INTO usr (username, password, email, name, address) VALUES
    ('artist1', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist1@example.com', 'Artist 1', 'Address 1'),
    ('artist2', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist2@example.com', 'Artist 2', 'Address 2'),
    ('artist3', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist3@example.com', 'Artist 3', 'Address 3'),
    ('artist4', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist4@example.com', 'Artist 4', 'Address 4'),
    ('artist5', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist5@example.com', 'Artist 5', 'Address 5'),
    ('artist6', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist6@example.com', 'Artist 6', 'Address 6'),
    ('artist7', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist7@example.com', 'Artist 7', 'Address 7'),
    ('artist8', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist8@example.com', 'Artist 8', 'Address 8'),
    ('artist9', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist9@example.com', 'Artist 9', 'Address 9'),
    ('artist10', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist10@example.com', 'Artist 10', 'Address 10'),
    ('artist11', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist11@example.com', 'Artist 11', 'Address 11'),
    ('artist12', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist12@example.com', 'Artist 12', 'Address 12'),
    ('artist13', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist13@example.com', 'Artist 13', 'Address 13'),
    ('artist14', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist14@example.com', 'Artist 14', 'Address 14'),
    ('artist15', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'artist15@example.com', 'Artist 15', 'Address 15');

INSERT INTO artist (artistic_name, label_id, usr_id) VALUES
    ('Artist 1', (SELECT id FROM label WHERE name = 'Label 1'), (SELECT id FROM usr WHERE username = 'artist1')),
    ('Artist 2', (SELECT id FROM label WHERE name = 'Label 2'), (SELECT id FROM usr WHERE username = 'artist2')),
    ('Artist 3', (SELECT id FROM label WHERE name = 'Label 3'), (SELECT id FROM usr WHERE username = 'artist3')),
    ('Artist 4', (SELECT id FROM label WHERE name = 'Label 4'), (SELECT id FROM usr WHERE username = 'artist4')),
    ('Artist 5', (SELECT id FROM label WHERE name = 'Label 5'), (SELECT id FROM usr WHERE username = 'artist5')),
    ('Artist 6', (SELECT id FROM label WHERE name = 'Label 6'), (SELECT id FROM usr WHERE username = 'artist6')),
    ('Artist 7', (SELECT id FROM label WHERE name = 'Label 7'), (SELECT id FROM usr WHERE username = 'artist7')),
    ('Artist 8', (SELECT id FROM label WHERE name = 'Label 8'), (SELECT id FROM usr WHERE username = 'artist8')),
    ('Artist 9', (SELECT id FROM label WHERE name = 'Label 9'), (SELECT id FROM usr WHERE username = 'artist9')),
    ('Artist 10', (SELECT id FROM label WHERE name = 'Label 10'), (SELECT id FROM usr WHERE username = 'artist10')),
    ('Artist 11', (SELECT id FROM label WHERE name = 'Label 1'), (SELECT id FROM usr WHERE username = 'artist11')),
    ('Artist 12', (SELECT id FROM label WHERE name = 'Label 2'), (SELECT id FROM usr WHERE username = 'artist12')),
    ('Artist 13', (SELECT id FROM label WHERE name = 'Label 3'), (SELECT id FROM usr WHERE username = 'artist13')),
    ('Artist 14', (SELECT id FROM label WHERE name = 'Label 4'), (SELECT id FROM usr WHERE username = 'artist14')),
    ('Artist 15', (SELECT id FROM label WHERE name = 'Label 5'), (SELECT id FROM usr WHERE username = 'artist15'));

-- Inserir músicas
INSERT INTO song (name, release_date, genre, duration, first_artist, label_id) VALUES
    ('Song 1', '19-05-2023', 'Pop', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 1'), (SELECT id FROM label WHERE name = 'Label 1')),
    ('Song 2', '19-05-2023', 'Rock', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 2'), (SELECT id FROM label WHERE name = 'Label 2')),
    ('Song 3', '19-05-2023', 'R&B', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 3'), (SELECT id FROM label WHERE name = 'Label 3')),
    ('Song 4', '19-05-2023', 'Electronic', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 4'), (SELECT id FROM label WHERE name = 'Label 4')),
    ('Song 5', '19-05-2023', 'Pop', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 5'), (SELECT id FROM label WHERE name = 'Label 5')),
    ('Song 6', '19-05-2023', 'Hip Hop', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 6'), (SELECT id FROM label WHERE name = 'Label 6')),
    ('Song 7', '19-05-2023', 'Indie', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 7'), (SELECT id FROM label WHERE name = 'Label 7')),
    ('Song 8', '19-05-2023', 'Pop', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 8'), (SELECT id FROM label WHERE name = 'Label 8')),
    ('Song 9', '19-05-2023', 'Rock', 2, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 9'), (SELECT id FROM label WHERE name = 'Label 9')),
    ('Song 10', '19-05-2023', 'R&B', 2, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 10'), (SELECT id FROM label WHERE name = 'Label 10')),
    ('Song 11', '19-05-2023', 'Pop', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 11'), (SELECT id FROM label WHERE name = 'Label 1')),
    ('Song 12', '19-05-2023', 'Electronic', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 12'), (SELECT id FROM label WHERE name = 'Label 2')),
    ('Song 13', '19-05-2023', 'Hip Hop', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 13'), (SELECT id FROM label WHERE name = 'Label 3')),
    ('Song 14', '19-05-2023', 'Indie', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 14'), (SELECT id FROM label WHERE name = 'Label 4')),
    ('Song 15', '19-05-2023', 'Pop', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 15'), (SELECT id FROM label WHERE name = 'Label 5')),
    ('Song 16', '19-05-2023', 'Pop', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 1'), (SELECT id FROM label WHERE name = 'Label 6')),
    ('Song 17', '19-05-2023', 'Rock', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 2'), (SELECT id FROM label WHERE name = 'Label 7')),
    ('Song 18', '19-05-2023', 'R&B', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 3'), (SELECT id FROM label WHERE name = 'Label 8')),
    ('Song 19', '19-05-2023', 'Electronic', 5, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 4'), (SELECT id FROM label WHERE name = 'Label 9')),
    ('Song 20', '19-05-2023', 'Pop', 5, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 5'), (SELECT id FROM label WHERE name = 'Label 10')),
    ('Song 21', '19-05-2023', 'Hip Hop', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 6'), (SELECT id FROM label WHERE name = 'Label 1')),
    ('Song 22', '19-05-2023', 'Indie', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 7'), (SELECT id FROM label WHERE name = 'Label 2')),
    ('Song 23', '19-05-2023', 'Pop', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 8'), (SELECT id FROM label WHERE name = 'Label 3')),
    ('Song 24', '19-05-2023', 'Rock', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 9'), (SELECT id FROM label WHERE name = 'Label 4')),
    ('Song 25', '19-05-2023', 'R&B', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 10'), (SELECT id FROM label WHERE name = 'Label 5')),
    ('Song 26', '19-05-2023', 'Pop', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 11'), (SELECT id FROM label WHERE name = 'Label 6')),
    ('Song 27', '19-05-2023', 'Electronic', 3, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 12'), (SELECT id FROM label WHERE name = 'Label 7')),
    ('Song 28', '19-05-2023', 'Hip Hop', 4, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 13'), (SELECT id FROM label WHERE name = 'Label 8')),
    ('Song 29', '19-05-2023', 'Indie', 2, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 14'), (SELECT id FROM label WHERE name = 'Label 9')),
    ('Song 30', '19-05-2023', 'Pop', 5, (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 15'), (SELECT id FROM label WHERE name = 'Label 10'));
  
-- Insere featuring
INSERT INTO artist_song (artist_usr_id, song_ismn) VALUES
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 2'), (SELECT ismn FROM song WHERE name = 'Song 1')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 3'), (SELECT ismn FROM song WHERE name = 'Song 1')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 6'), (SELECT ismn FROM song WHERE name = 'Song 5')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 7'), (SELECT ismn FROM song WHERE name = 'Song 5')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 11'), (SELECT ismn FROM song WHERE name = 'Song 10')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 12'), (SELECT ismn FROM song WHERE name = 'Song 10')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 1'), (SELECT ismn FROM song WHERE name = 'Song 15')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 2'), (SELECT ismn FROM song WHERE name = 'Song 15')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 3'), (SELECT ismn FROM song WHERE name = 'Song 20')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 4'), (SELECT ismn FROM song WHERE name = 'Song 20')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 5'), (SELECT ismn FROM song WHERE name = 'Song 25')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 6'), (SELECT ismn FROM song WHERE name = 'Song 25')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 7'), (SELECT ismn FROM song WHERE name = 'Song 30')),
    ((SELECT usr_id FROM artist WHERE artistic_name = 'Artist 8'), (SELECT ismn FROM song WHERE name = 'Song 30'));

-- Criar álbuns
INSERT INTO album (name, release_date, label_id, artist_usr_id) VALUES
    ('Album 1', '19-05-2023', (SELECT id FROM label WHERE name = 'Label 1'), (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 1')),
    ('Album 2', '19-05-2023', (SELECT id FROM label WHERE name = 'Label 2'), (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 2')),
    ('Album 3', '19-05-2023', (SELECT id FROM label WHERE name = 'Label 3'), (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 3')),
    ('Album 4', '19-05-2023', (SELECT id FROM label WHERE name = 'Label 4'), (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 4')),
    ('Album 5', '19-05-2023', (SELECT id FROM label WHERE name = 'Label 5'), (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 5')),
    ('Album 6', '19-05-2023', (SELECT id FROM label WHERE name = 'Label 1'), (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 6')),
    ('Album 7', '19-05-2023', (SELECT id FROM label WHERE name = 'Label 2'), (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 6')),
    ('Album 8', '19-05-2023', (SELECT id FROM label WHERE name = 'Label 3'), (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 7')),
    ('Album 9', '19-05-2023', (SELECT id FROM label WHERE name = 'Label 4'), (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 7')),
    ('Album 10', '19-05-2023', (SELECT id FROM label WHERE name = 'Label 5'), (SELECT usr_id FROM artist WHERE artistic_name = 'Artist 8'));

-- Insere músicas nos álbuns
INSERT INTO album_song (album_id, song_ismn) VALUES
    ((SELECT id FROM album WHERE name = 'Album 1'), (SELECT ismn FROM song WHERE name = 'Song 1')),
    ((SELECT id FROM album WHERE name = 'Album 2'), (SELECT ismn FROM song WHERE name = 'Song 2')),
    ((SELECT id FROM album WHERE name = 'Album 3'), (SELECT ismn FROM song WHERE name = 'Song 3')),
    ((SELECT id FROM album WHERE name = 'Album 4'), (SELECT ismn FROM song WHERE name = 'Song 4')),
    ((SELECT id FROM album WHERE name = 'Album 5'), (SELECT ismn FROM song WHERE name = 'Song 5')),
    ((SELECT id FROM album WHERE name = 'Album 6'), (SELECT ismn FROM song WHERE name = 'Song 6')),
    ((SELECT id FROM album WHERE name = 'Album 7'), (SELECT ismn FROM song WHERE name = 'Song 7')),
    ((SELECT id FROM album WHERE name = 'Album 8'), (SELECT ismn FROM song WHERE name = 'Song 8')),
    ((SELECT id FROM album WHERE name = 'Album 9'), (SELECT ismn FROM song WHERE name = 'Song 9')),
    ((SELECT id FROM album WHERE name = 'Album 10'), (SELECT ismn FROM song WHERE name = 'Song 10')),
    ((SELECT id FROM album WHERE name = 'Album 1'), (SELECT ismn FROM song WHERE name = 'Song 11')),
    ((SELECT id FROM album WHERE name = 'Album 2'), (SELECT ismn FROM song WHERE name = 'Song 12')),
    ((SELECT id FROM album WHERE name = 'Album 3'), (SELECT ismn FROM song WHERE name = 'Song 13')),
    ((SELECT id FROM album WHERE name = 'Album 4'), (SELECT ismn FROM song WHERE name = 'Song 14')),
    ((SELECT id FROM album WHERE name = 'Album 5'), (SELECT ismn FROM song WHERE name = 'Song 15')),
    ((SELECT id FROM album WHERE name = 'Album 6'), (SELECT ismn FROM song WHERE name = 'Song 16')),
    ((SELECT id FROM album WHERE name = 'Album 7'), (SELECT ismn FROM song WHERE name = 'Song 17')),
    ((SELECT id FROM album WHERE name = 'Album 8'), (SELECT ismn FROM song WHERE name = 'Song 18')),
    ((SELECT id FROM album WHERE name = 'Album 9'), (SELECT ismn FROM song WHERE name = 'Song 19')),
    ((SELECT id FROM album WHERE name = 'Album 10'), (SELECT ismn FROM song WHERE name = 'Song 20')),
    ((SELECT id FROM album WHERE name = 'Album 1'), (SELECT ismn FROM song WHERE name = 'Song 21')),
    ((SELECT id FROM album WHERE name = 'Album 2'), (SELECT ismn FROM song WHERE name = 'Song 22')),
    ((SELECT id FROM album WHERE name = 'Album 3'), (SELECT ismn FROM song WHERE name = 'Song 23')),
    ((SELECT id FROM album WHERE name = 'Album 4'), (SELECT ismn FROM song WHERE name = 'Song 24')),
    ((SELECT id FROM album WHERE name = 'Album 5'), (SELECT ismn FROM song WHERE name = 'Song 25'));

-- Criar consumidores
INSERT INTO usr (username, password, email, name, address) VALUES
    ('consumer1', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'consumer1@example.com', 'Consumer 1', 'Address 1'),
    ('consumer2', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'consumer2@example.com', 'Consumer 2', 'Address 2'),
    ('consumer3', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'consumer3@example.com', 'Consumer 3', 'Address 3'),
    ('consumer4', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'consumer4@example.com', 'Consumer 4', 'Address 4'),
    ('consumer5', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'consumer5@example.com', 'Consumer 5', 'Address 5'),
    ('consumer6', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'consumer6@example.com', 'Consumer 6', 'Address 6'),
    ('consumer7', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'consumer7@example.com', 'Consumer 7', 'Address 7'),
    ('consumer8', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'consumer8@example.com', 'Consumer 8', 'Address 8'),
    ('consumer9', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'consumer9@example.com', 'Consumer 9', 'Address 9'),
    ('consumer10', '$2a$10$Zw0Ffe0l4q.bMG6txhHRGOxR5q94NJHbuKTPFExHqPugqG/j5iFVW', 'consumer10@example.com', 'Consumer 10', 'Address 10');

INSERT INTO consumer (usr_id) VALUES
    ((SELECT id FROM usr WHERE username = 'consumer1')),
    ((SELECT id FROM usr WHERE username = 'consumer2')),
    ((SELECT id FROM usr WHERE username = 'consumer3')),
    ((SELECT id FROM usr WHERE username = 'consumer4')),
    ((SELECT id FROM usr WHERE username = 'consumer5')),
    ((SELECT id FROM usr WHERE username = 'consumer6')),
    ((SELECT id FROM usr WHERE username = 'consumer7')),
    ((SELECT id FROM usr WHERE username = 'consumer8')),
    ((SELECT id FROM usr WHERE username = 'consumer9')),
    ((SELECT id FROM usr WHERE username = 'consumer10'));

-- Criar playlists
INSERT INTO playlist (name, visibility, consumer_usr_id) VALUES
    ('Playlist 1', true, (SELECT id FROM usr WHERE username = 'consumer1')),
    ('Playlist 2', false, (SELECT id FROM usr WHERE username = 'consumer2')),
    ('Playlist 3', true, (SELECT id FROM usr WHERE username = 'consumer3')),
    ('Playlist 4', false, (SELECT id FROM usr WHERE username = 'consumer4')),
    ('Playlist 5', true, (SELECT id FROM usr WHERE username = 'consumer5')),
    ('Playlist 6', false, (SELECT id FROM usr WHERE username = 'consumer6')),
    ('Playlist 7', true, (SELECT id FROM usr WHERE username = 'consumer7')),
    ('Playlist 8', false, (SELECT id FROM usr WHERE username = 'consumer8')),
    ('Playlist 9', true, (SELECT id FROM usr WHERE username = 'consumer9')),
    ('Playlist 10', false, (SELECT id FROM usr WHERE username = 'consumer10'));

-- Adicionar músicas às playlists
INSERT INTO playlist_song (playlist_id, song_ismn) VALUES
    ((SELECT id FROM playlist WHERE name = 'Playlist 1'), (SELECT ismn FROM song WHERE name = 'Song 1')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 1'), (SELECT ismn FROM song WHERE name = 'Song 2')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 1'), (SELECT ismn FROM song WHERE name = 'Song 3')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 2'), (SELECT ismn FROM song WHERE name = 'Song 2')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 2'), (SELECT ismn FROM song WHERE name = 'Song 3')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 2'), (SELECT ismn FROM song WHERE name = 'Song 4')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 3'), (SELECT ismn FROM song WHERE name = 'Song 3')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 3'), (SELECT ismn FROM song WHERE name = 'Song 4')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 3'), (SELECT ismn FROM song WHERE name = 'Song 5')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 4'), (SELECT ismn FROM song WHERE name = 'Song 4')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 4'), (SELECT ismn FROM song WHERE name = 'Song 5')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 4'), (SELECT ismn FROM song WHERE name = 'Song 6')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 5'), (SELECT ismn FROM song WHERE name = 'Song 5')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 5'), (SELECT ismn FROM song WHERE name = 'Song 6')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 5'), (SELECT ismn FROM song WHERE name = 'Song 7')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 6'), (SELECT ismn FROM song WHERE name = 'Song 6')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 7'), (SELECT ismn FROM song WHERE name = 'Song 7')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 8'), (SELECT ismn FROM song WHERE name = 'Song 8')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 9'), (SELECT ismn FROM song WHERE name = 'Song 9')),
    ((SELECT id FROM playlist WHERE name = 'Playlist 10'), (SELECT ismn FROM song WHERE name = 'Song 10'));

-- Inserir comentários
INSERT INTO comment (content, comment_id, song_ismn) VALUES
    ('Comment 1', null, (SELECT ismn FROM song WHERE name = 'Song 1')),
    ('Comment 2', null, (SELECT ismn FROM song WHERE name = 'Song 2')),
    ('Comment 3', null, (SELECT ismn FROM song WHERE name = 'Song 3')),
    ('Comment 4', null, (SELECT ismn FROM song WHERE name = 'Song 4')),
    ('Comment 5', null, (SELECT ismn FROM song WHERE name = 'Song 5'));

-- Inserir subcomentários
INSERT INTO comment (content, comment_id, song_ismn) VALUES
    ('Comment 6', (SELECT id FROM comment WHERE content = 'Comment 5'), (SELECT ismn FROM song WHERE name = 'Song 6'));
INSERT INTO comment (content, comment_id, song_ismn) VALUES
    ('Comment 7', (SELECT id FROM comment WHERE content = 'Comment 6'), (SELECT ismn FROM song WHERE name = 'Song 7'));
INSERT INTO comment (content, comment_id, song_ismn) VALUES
    ('Comment 8', (SELECT id FROM comment WHERE content = 'Comment 7'), (SELECT ismn FROM song WHERE name = 'Song 8'));
INSERT INTO comment (content, comment_id, song_ismn) VALUES
    ('Comment 9', (SELECT id FROM comment WHERE content = 'Comment 4'), (SELECT ismn FROM song WHERE name = 'Song 9'));
INSERT INTO comment (content, comment_id, song_ismn) VALUES
    ('Comment 10', (SELECT id FROM comment WHERE content = 'Comment 3'), (SELECT ismn FROM song WHERE name = 'Song 10'));
INSERT INTO comment (content, comment_id, song_ismn) VALUES
    ('Comment 11', (SELECT id FROM comment WHERE content = 'Comment 10'), (SELECT ismn FROM song WHERE name = 'Song 12'));
INSERT INTO comment (content, comment_id, song_ismn) VALUES
    ('Comment 13', (SELECT id FROM comment WHERE content = 'Comment 11'), (SELECT ismn FROM song WHERE name = 'Song 13'));
INSERT INTO comment (content, comment_id, song_ismn) VALUES
    ('Comment 14', (SELECT id FROM comment WHERE content = 'Comment 2'), (SELECT ismn FROM song WHERE name = 'Song 14'));
INSERT INTO comment (content, comment_id, song_ismn) VALUES
    ('Comment 15', (SELECT id FROM comment WHERE content = 'Comment 1'), (SELECT ismn FROM song WHERE name = 'Song 15'));