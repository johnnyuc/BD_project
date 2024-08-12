-- Autores:  João Pinheiro 2017270907
--           Joel Oliveira 2021215037
--           Johnny Fernandes 2021190668
-- LEI UC 2022-23 - Sistemas Operativos

create or replace procedure play_song(A Int,B Int)
language plpgsql
as $$
declare
    top10_playlist_id int;
begin
    UPDATE counts
    SET play_count = play_count + 1
    WHERE song_ismn = A and usr_id = B;

    IF NOT FOUND THEN
        INSERT INTO counts (play_count,song_ismn,usr_id)
        VALUES (1,A,B);
    END IF;

    SELECT id into top10_playlist_id
    FROM playlist
    WHERE name = 'TOP10' and consumer_usr_id = B;

    IF NOT FOUND THEN
        INSERT INTO playlist (name,visibility,consumer_usr_id)
        VALUES ('TOP10','0',B)
        returning id into top10_playlist_id;
    END IF; 

    DELETE FROM playlist_song
    WHERE playlist_id = top10_playlist_id;

    INSERT INTO playlist_song(playlist_id,song_ismn)
    SELECT top10_playlist_id,song_ismn
    FROM counts
    WHERE usr_id = B
    ORDER BY play_count DESC
    LIMIT 10;
end;
$$;


CREATE OR REPLACE FUNCTION play_song_trigger_function()
RETURNS TRIGGER AS $$
DECLARE
    songid INT;
    logid INT;
    usrid INT;
BEGIN

    SELECT usr_id INTO usrid
    FROM log_usr
    ORDER BY log_id DESC
    LIMIT 1;

    SELECT song_ismn INTO songid
    FROM log_song
    ORDER BY log_id DESC
    LIMIT 1;

    CALL play_song(songid, usrid);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER play_song_trigger
AFTER INSERT ON log_usr
FOR EACH STATEMENT
EXECUTE FUNCTION play_song_trigger_function();