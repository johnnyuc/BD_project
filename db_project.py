###############################################
# Autores:  João Pinheiro 2017270907          #
#           Joel Oliveira 2021215037          #
#           Johnny Fernandes 2021190668       #
# LEI UC 2022-23 - Sistemas Operativos        #
###############################################

# Bibliotecas gerais
import logging # Logging
import time # Timestamps
import datetime # Timestamps
import random # Random
import traceback # Debugging

# Servidor web
import flask # Web server
from flask import request, jsonify # HTTP Requests
from flask_bcrypt import Bcrypt # Encriptação de passwords

# Base de dados
import psycopg2 # PostgreSQL
import json # API
import jwt # Tokens

# Aplicação Flask
app = flask.Flask(__name__)
# Encriptação de passwords
bcrypt = Bcrypt(app)

# Salt para encriptação de passwords
alphanum = "abcdefghijklmnopqrstuvwxyz1234567890"
secret_key = random.choice(alphanum)

StatusCodes = {
    'success': 200,
    'api_error': 400,
    'internal_error': 500
}

###############################################
# Acesso à base de dados                      #
###############################################

# Dados de acesso à base de dados
def db_connection():
    db = psycopg2.connect(
        user='apiuser',
        password='apiuser',
        host='127.0.0.1',
        port='5432',
        database='projeto'
    )
    return db


# Criação de token de acesso
# Expira em 1 dia
def generate_token(user_id):
  try:
    data = {
      'expires': str(datetime.datetime.now() + datetime.timedelta(days=1)),
      'time': str(datetime.datetime.now()),
      'user': user_id
    }
    print("data",data) # DEBUG
    return jwt.encode(data,secret_key,'HS256')
  except Exception as err:
    return {'Error': str(err)}
    
# Verificação de token de acesso
def decode_token(token):
  re = {'data': {}, 'error': {}}
  try:
    data = jwt.decode(token, secret_key, 'HS256')  
    re['data'] = {'userid': data['user']}
    return re
  except jwt.ExpiredSignatureError as err1: # Token expirou
    re['error'] = {'message': str(err1)}
    return re
  except jwt.InvalidTokenError as err2: # Token inválido
    re['error'] = {'message': str(err2)}
    return re


###############################################
# Endpoints                                   #
###############################################

# Index page @ http://localhost:8080/dbproj/
@app.route('/dbproj/', methods=['GET']) 
def landing_page():
    return "Bem-vindo à Plataforma iDEI Music Streaming!"

# Registo de novos utilizadores - Método POST
@app.route('/dbproj/user', methods=['POST'])
def register_user():
    # Acesso padrão comum a todas as rotas
    logger.info('REGISTER [POST] - /dbproj/user')
    payload = flask.request.get_json()

    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------

    is_admin = 0 # Flag para verificar se o utilizador é administrador
   
    # Verificação da existência de um utilizador com o mesmo nome ou email
    statement = 'SELECT username, email FROM usr WHERE username = %s or email = %s FOR UPDATE'
    values = (payload["username"], payload["email"])
    cur.execute(statement, values)
   
    if cur.rowcount:
        response = {'status': StatusCodes['internal_error'],'Error': 'O username ou email já está em uso'}
        return flask.jsonify(response)

    # Se o utilizador não estiver autenticado, cria-se um novo utilizador
    if 'usertoken' not in flask.request.headers:
        try:
            # Inserção de um novo utilizador na tabela de utilizadores
            statement = 'INSERT INTO usr (username, password, email, name, address) VALUES (%s, %s, %s, %s, %s)'
            hashed_password = bcrypt.generate_password_hash(payload['password']).decode('utf-8') # BCrypt para encriptar a password
            values = (payload['username'], hashed_password, payload['email'], payload['name'], payload['address'])
            cur.execute(statement, values)
            conn.commit()

            # Verifica se a inserção foi corretamente feita e insere-o na tabela de consumidores
            cur.execute("SELECT id FROM usr WHERE username = %s and email = %s FOR UPDATE", (payload["username"], payload["email"]))
            userid_notoken = cur.fetchall()
            statement = 'INSERT INTO consumer (usr_id) VALUES (%s)'
            values = (userid_notoken[0][0],)
            cur.execute(statement, values)
            conn.commit()

            # Envia resposta ao cliente
            response = {'status': StatusCodes['success'], 'results': f'user_id {userid_notoken[0][0]}'}

        # Casos de erro
        except (Exception, psycopg2.DatabaseError) as error:
            logger.error(f'POST /dbproj/user - error: {error}')
            response = {'status': StatusCodes['internal_error'], 'errors': str(error)}
            # Rollback da transação em caso de erro
            conn.rollback()

        return flask.jsonify(response)
    
    # Se o utilizador estiver autenticado, é necessário verificar se é admin ou não
    else:
        # Decode do token para validar o utilizador autenticado
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)
    
        # Inserção de um novo artista
        try:
            logger.debug(f'Utilizador logado {user_data}')
            cur.execute("SELECT usr_id FROM admin")
            admin = cur.fetchall()
            
            for i in range(len(admin)):
                if user_data['data']['userid'] == admin[i][0]:
                    is_admin = 1   
            
            # Insere o utilizador como artista
            if is_admin == 1:
                logger.debug(f'Inserção de um novo artista')

                # Insere o utilizador
                statement = 'INSERT INTO usr (username, password, email, name, address) VALUES (%s, %s, %s, %s, %s)'
                password = request.json['password']
                hashed_password = bcrypt.generate_password_hash(password).decode('utf-8') # BCrypt para encriptar a password
                values = (payload['username'], hashed_password, payload['email'], payload['name'], payload['address'])
                cur.execute(statement, values)
                conn.commit()
                
                # Retorna o ID do utilizador inserido
                cur.execute("SELECT id FROM usr WHERE username = %s and email = %s", (payload['username'], payload['email']))
                userid = cur.fetchall()

                # Retorna o ID da label do payload
                cur.execute("SELECT id FROM label WHERE name = %s", (payload['label'],))
                labelid = cur.fetchone()

                # Verifica se a label existe
                if labelid is None:
                    logger.debug(f'Utilizador não inserido na tabela de artistas (label inválida))')
                    conn.rollback()
                    response = {'status': StatusCodes['api_error'],'Error': 'Não associou uma label válida. Inserido como utilizador'}
                    return flask.jsonify(response)

                # Insere o artista
                else: 
                    logger.debug(f'Utilizador inserido na tabela de artistas')
                    statement = 'INSERT INTO artist (artistic_name, label_id, usr_id) VALUES (%s, %s, %s)'
                    values = ((payload["artistic_name"], labelid[0], userid[0][0]))
                    cur.execute(statement, values)
                    conn.commit()

                    logger.debug(f'UserID {userid} introduzido na tabela de artistas com o ID da label {labelid}')

            # O utilizador logado não tem permissões
            elif is_admin == 0:
                response={'status': StatusCodes['internal_error'],'Error': 'O utilizador não tem permissão para criar novos artistas'}
                return flask.jsonify(response)

            else:
                response={'status': StatusCodes['internal_error'],'Error': 'Indique um tipo válido para admin (0 ou 1)'}
                return flask.jsonify(response)
            
            response = {'status': StatusCodes['success'], 'results': f'{userid[0][0]}'}
            
        # Casos de erro
        except (Exception, psycopg2.DatabaseError) as error:
            print("Payload: ", payload)
            print(traceback.format_exc())
            logger.error(f'POST /dbproj/user - error: {error}')
            response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

            # Rollback da transação em caso de erro
            conn.rollback()

        # Fecha a conexão à base de dados
        finally:
            if conn is not None:
                conn.close()

        return flask.jsonify(response)


# Autenticação de utilizadores - Método PUT
@app.route('/dbproj/user', methods=['PUT'])
def login():
    # Acesso padrão comum a todas as rotas
    logger.info('LOGIN [PUT] - /dbproj/user')
    payload = flask.request.get_json()

    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------

    # Verifica se o utilizador existe
    cur.execute("SELECT id, username FROM usr WHERE username = %s ", (payload["username"],))
    if cur.rowcount == 0:
        response={'status': StatusCodes['internal_error'],'Error': 'Utilizador não existe'}
        return flask.jsonify(response)

    username = request.json['username']
    password = request.json['password']
    cur.execute("SELECT * FROM usr WHERE USERNAME = %s", (username,))
    user = cur.fetchone()

    # Verifica se a password está correta
    if user is not None and bcrypt.check_password_hash(user[2], password):
        try:
            # Gera o token
            user_token=generate_token(user[0])
            data = decode_token(user_token)
            response = {'status': StatusCodes['success'], 'results': f'Token: {user_token} ',  'message': 'Usuário autenticado com sucesso!'}
            conn.commit()

        # Casos de erro
        except (Exception, psycopg2.DatabaseError) as error:
            print(traceback.format_exc())
            logger.error(error)
            response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

            # Rollback da transação em caso de erro
            conn.rollback()

        # Fecha a conexão à base de dados
        finally:
            if conn is not None:
                conn.close()

        return flask.jsonify(response)

    # Caso a password esteja incorreta ou o utilizador não exista
    else:
        return flask.jsonify({'message': 'O utilizador não foi encontrado ou password inválida'})
    

# Inserção de nova música - Método POST
@app.route('/dbproj/song', methods=['POST'])
def insert_song():
    # Acesso padrão comum a todas as rotas
    logger.info('SONG [POST] - /dbproj/song')
    payload = flask.request.get_json()

    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------

    is_artist = 0 # Flag para verificar se o utilizador é artista

    # Verifica se o token é válido
    if 'usertoken' not in flask.request.headers:
        return {"Error":"Por favor faça login para inserir uma nova música"}
    else:
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)
    
    # Verifica se o utilizador é artista
    cur.execute("SELECT usr_id FROM artist")
    artist = cur.fetchall()
    for i in range (len(artist)):
        if user_data['data']['userid'] == artist[i][0]:
            is_artist = 1
    
    # Caso o utilizador não seja artista
    if is_artist == 0:
        response={'status': StatusCodes['internal_error'],'Error': 'O utilizador não tem permissão para inserir novas músicas'}
        return flask.jsonify(response)
    
    # Caso o utilizador seja artista
    try:
        # Retorna o ID da label do payload
        cur.execute("SELECT id FROM label WHERE name = %s ",(payload["label"],))
        labelid = cur.fetchone()

        if labelid is None:
            logger.debug(f'Música não inserida (label inválida)')
            conn.rollback()
            response={'status': StatusCodes['api_error'],'Error': 'Não associou uma label válida à música'}
            return flask.jsonify(response)

        # Retorna o ID do album do payload (se for None, passa NULL para a query)
        cur.execute("SELECT id FROM album WHERE name = %s ",(payload["album"],))
        albumid = cur.fetchone()

        # Insere a música na tabela de músicas
        statement = 'INSERT INTO song (name, release_date, genre, duration, first_artist, album_pos, label_id) VALUES (%s, %s, %s, %s, %s, %s , %s)'
        values = (payload['name'], payload['release_date'],  payload['genre'], payload['duration'], user_data['data']['userid'], albumid, labelid)
        cur.execute(statement, values)
        conn.commit()

        # Retorna o ID da música inserida
        cur.execute("SELECT ismn FROM song WHERE name = %s ",(payload["name"],)) # ISMN é o ID da música (PK)
        songid = cur.fetchone()

        # Insere os artistas auxiliares na tabela artist_song
        for artist_name in payload["other_artists"]:
            cur.execute("SELECT id FROM usr u, artist a WHERE u.name = %s AND u.id = a.usr_id", (artist_name,))
            artist = cur.fetchone()
            
            # O artista não existe
            if artist is None:
                logger.debug(f'Artista {artist_name} não encontrado na base de dados e não inserido em feat')
            else:
            # O artista existe
                logger.debug(f'Artista {artist_name} encontrado na base de dados e inserido em feat')

                # Insere o artista na tabela artist_song
                statement = 'INSERT INTO artist_song (artist_usr_id, song_ismn) VALUES (%s, %s)'
                values = (artist[0], songid)
                cur.execute(statement, values)
                conn.commit()

        response = {'status': StatusCodes['success'], 'results': f'{songid[0]}'}

    # Casos de erro
    except (Exception, psycopg2.DatabaseError) as error:
        print(traceback.format_exc())
        logger.error(f'POST create - error: {error}')
        response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

        # Rollback da transação em caso de erro
        conn.rollback()

    # Fecha a conexão à base de dados
    finally:
        if conn is not None:
            conn.close()

    return flask.jsonify(response)


# Criação de um novo álbum - Método POST
@app.route('/dbproj/album', methods=['POST'])
def create_album():
    # Acesso padrão comum a todas as rotas
    logger.info('ALBUM [POST] - /dbproj/album')
    payload = flask.request.get_json()

    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------

    is_artist = 0 # Flag para verificar se o utilizador é artista

    # Verifica se o token é válido
    if 'usertoken' not in flask.request.headers:
        return {"Error":"Por favor faça login para criar um novo álbum"}
    else:
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)

    # Verifica se o utilizador é artista
    cur.execute("SELECT usr_id FROM artist")
    artist = cur.fetchall()
    for i in range (len(artist)):
        if user_data['data']['userid'] == artist[i][0]:
            is_artist = 1
    
    # Caso o utilizador não seja artista
    if is_artist == 0:
        response={'status': StatusCodes['internal_error'],'Error': 'O utilizador não tem permissão para criar novos álbuns'}
        return flask.jsonify(response)
    
    # Caso o utilizador seja artista
    try:
        # Retorna o ID da label do payload
        cur.execute("SELECT id FROM label WHERE name = %s ",(payload["label"],))
        labelid = cur.fetchone()

        if labelid is None:
            logger.debug(f'Álbum não criado (label inválida)')
            conn.rollback()
            response={'status': StatusCodes['api_error'],'Error': 'Não associou uma label válida à música'}
            return flask.jsonify(response)

        # Insere o álbum na tabela de álbuns
        statement = 'INSERT INTO album (name, release_date, label_id, artist_usr_id) VALUES (%s, %s, %s, %s)'
        values = (payload['name'], payload['release_date'], labelid, user_data['data']['userid'])
        cur.execute(statement, values)
        conn.commit()

        # Retorna o ID do álbum inserido
        cur.execute("SELECT id FROM album WHERE name = %s ",(payload["name"],))
        albumid= cur.fetchone()

        # Insere as músicas do álbum na tabela album_song
        iter = 1   
        for song_ismn in payload["songs"]:
            # Verifica se a música existe
            cur.execute("SELECT ismn, album_pos FROM song WHERE ismn = %s", (song_ismn,))
            song_data = cur.fetchone()

            # Se a música não existir
            if song_data is None:
                logger.debug(f'A música com ISMN {song_ismn} não foi encontrada e não foi inserida no álbum')
            # Se a música existir
            else:
                # Verifica se a música pertence ao utilizador
                cur.execute("SELECT * FROM song LEFT JOIN artist_song ON song.ismn = artist_song.song_ismn WHERE (artist_song.artist_usr_id = %s OR song.first_artist = %s) AND song.ismn = %s", 
                            (user_data['data']['userid'], user_data['data']['userid'], song_ismn))
                artist_song = cur.fetchone()
                
                if artist_song is None:
                    logger.debug(f'A música com ISMN {song_ismn} não pertence ao utilizador {user_data["data"]["userid"]}')
                else:
                    logger.debug(f'A música com ISMN {song_ismn} foi encontrada e inserida no álbum')

                    # Verifica se a música já está associada a um álbum
                    if song_data[1] is None or song_data[1] == "":
                        # Insere a música na tabela album_song
                        statement = 'INSERT INTO album_song (song_ismn, album_id) VALUES (%s, %s)'
                        values = (song_data[0], albumid[0])
                        cur.execute(statement, values)
                        conn.commit()

                        # Atualiza o album_pos da música
                        cur.execute("UPDATE song SET album_pos = %s WHERE ismn = %s", (iter, song_data[0]))
                        conn.commit()
                        iter += 1
                    else:
                        logger.debug(f'A música com ISMN {song_ismn} não pode ser adicionada ao álbum porque o album_pos não está vazio')
                    
            if iter == 1:
                logger.debug(f'Álbum não criado (nenhuma música válida)')
                conn.rollback()
                response = {'status': StatusCodes['api_error'],'Error': 'Não associou nenhuma música válida ao álbum'}
                return flask.jsonify(response)
        
        response = {'status': StatusCodes['success'], 'results': f'{albumid[0]}'}
        
    # Casos de erro
    except (Exception, psycopg2.DatabaseError) as error:
        print(traceback.format_exc())
        logger.error(f'POST create - error: {error}')
        response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

        # Rollback da transação em caso de erro
        conn.rollback()

    # Fecha a conexão à base de dados
    finally:
        if conn is not None:
            conn.close()

    return flask.jsonify(response)


# Pesquisa de músicas a partir de uma keyword - Método GET
@app.route('/dbproj/song/<keyword>', methods=['GET'])
def get_song(keyword):
    # Acesso padrão comum a todas as rotas
    logger.info(f'SONG [GET] - /dbproj/song/{keyword}')

    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------

    # Verifica se o token é válido
    if 'usertoken' not in flask.request.headers:
        return {"Error":"Por favor faça login ou registe-se para poder utilizar a plataforma"}
    else:
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)
    
    # Retorna todas as músicas que contenham a keyword
    try:
        cur.execute(f"""
            SELECT s.name AS TituloMusica, u.name AS NomeArtista, a.name AS NomeAlbum
            FROM usr u
            INNER JOIN artist ar ON u.id = ar.usr_id
            INNER JOIN artist_song am ON ar.usr_id = am.artist_usr_id
            INNER JOIN song s ON am.song_ismn = s.ismn
            INNER JOIN album_song am2 ON am.song_ismn = am2.song_ismn
            INNER JOIN album a ON am2.album_id = a.id
            WHERE s.name LIKE '%{keyword}%';
        """)

        songs_result = cur.fetchall()
    
        songs = []
        for row in songs_result:
            song_dict = {
                "title": row[0],
                "artists": row[1].split(","),
                "albums": row[2].split(",")
            }
            songs.append(song_dict)
        
        # Converter a lista em JSON
        response = json.dumps(songs)

    # Casos de erro
    except (Exception, psycopg2.DatabaseError) as error:
        print(traceback.format_exc())
        logger.error(f'GET /departments/<ndep> - error: {error}')
        response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

    # Fecha a conexão à base de dados
    finally:
        if conn is not None:
            conn.close()
    
    return flask.jsonify(response)


# Pesquisa artistas a partir de um ID - Método GET
@app.route('/dbproj/artist_info/<artist_id>', methods=['GET'])
def detail_artist(artist_id):
    # Acesso padrão comum a todas as rotas
    logger.info(f'ARTIST [GET] - /dbproj/artist_info/{artist_id}')

    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------

    # Verifica se o token é válido
    if 'usertoken' not in flask.request.headers:
        return {"Error":"Por favor faça login ou registe-se para poder utilizar a plataforma"}
    else:
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)
    
    # Relações entre tabelas:
    #1 - Artistas com as músicas 
    #2 - Músicas com os artistas 
    #3 - Álbuns com músicas
    #4 - Álbuns com os IDs
    #5 - Relaciona músicas com as playlists

    is_consumer = 0
    cur.execute("SELECT usr_id FROM consumer")
    consumer = cur.fetchone()
    for i in range (len(consumer)):
        if user_data['data']['userid'] == consumer[0]:
            is_consumer = 1
    
    # Caso o utilizador não seja consumidor
    if is_consumer == 0:
        response={'status': StatusCodes['internal_error'],'Error': 'Não é um utilizador normal do sistema'}
        return flask.jsonify(response)
    
    # Verifica se o utilizador tem uma subscrição ativa
    cur.execute("SELECT consumer_usr_id FROM subscription WHERE subscription_end > %s FOR UPDATE", (datetime.datetime.now(),))
    user_subscrito = cur.fetchone()
    for i in range (len(user_subscrito)):
        if user_data['data']['userid'] == user_subscrito[0]:
            is_premium = 1
            
    # Caso o utilizador não tenha uma subscrição ativa
    if is_premium == 0:
        response={'status': StatusCodes['internal_error'],'Error': 'O utilizador não tem uma subscricao ativa'}
        return flask.jsonify(response)
    # Retorna todas as informações de um determinado artista
    try:

        query = ''' SELECT u.name, array_agg(DISTINCT s.ismn), array_agg(DISTINCT a.id), array_agg(DISTINCT ps.playlist_id )
            FROM usr AS u
            INNER JOIN artist_song AS ast ON ast.artist_usr_id = u.id
            INNER JOIN song AS s ON s.ismn = ast.song_ismn
            INNER JOIN album_song AS als ON als.song_ismn = s.ismn
            INNER JOIN album AS a ON a.id = als.album_id
            LEFT JOIN playlist_song AS ps ON ps.song_ismn = s.ismn
            WHERE u.id = %s
            '''
        if is_premium == 1:
            query += "GROUP BY u.name"
        else:
            query += ", playlist.visibility "

        cur.execute(query, (artist_id,))

        artist_data = cur.fetchone()
        if artist_data:
            artist_name, song_ids, album_ids, playlist_ids = artist_data
            # Formata a resposta para envio
            response = {
                "name": artist_name,
                "songs": song_ids,
                "albums": album_ids,
                "playlists": playlist_ids
            }
            
            return flask.jsonify(response)

    # Casos de erro
    except (Exception, psycopg2.DatabaseError) as error:
        print(traceback.format_exc())
        logger.error(f'GET /artist_info/<artist_id> - error: {error}')
        response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

    # Fecha a conexão à base de dados
    finally:
        if conn is not None:
            conn.close()

    return flask.jsonify(response)


# Criação de uma nova playlist - Método POST
@app.route('/dbproj/playlist', methods=['POST'])
def create_playlist():
    # Acesso padrão comum a todas as rotas
    logger.info('PLAYLIST [POST] - /dbproj/playlist')
    payload = flask.request.get_json()
    is_consumer = 0
    is_premium = 0
    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------

    # Verifica se o token é válido
    if 'usertoken' not in flask.request.headers:
        return {"Error":"Por favor faça login para criar uma nova playlist"}
    else:
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)
            
    # Verfifica se o utilizador é consumidor
    is_consumer = 0
    cur.execute("SELECT usr_id FROM consumer")
    consumer = cur.fetchone()
    for i in range (len(consumer)):
        if user_data['data']['userid'] == consumer[0]:
            is_consumer = 1
    
    # Caso o utilizador não seja consumidor
    if is_consumer == 0:
        response={'status': StatusCodes['internal_error'],'Error': 'Não é um utilizador normal do sistema'}
        return flask.jsonify(response)
    
    # Verifica se o utilizador tem uma subscrição ativa
    cur.execute("SELECT consumer_usr_id FROM subscription WHERE subscription_end > %s FOR UPDATE", (datetime.datetime.now(),))
    user_subscrito = cur.fetchone()
    for i in range (len(user_subscrito)):
        if user_data['data']['userid'] == user_subscrito[0]:
            is_premium = 1
            
    # Caso o utilizador não tenha uma subscrição ativa
    if is_premium == 0:
        response={'status': StatusCodes['internal_error'],'Error': 'O utilizador não tem uma subscricao ativa'}
        return flask.jsonify(response)

    # Else, é porque tem subscrição ativa e é consumidor
    try:
        insere = True if payload['visibility'] == 'public' else False # Define a visibilidade da playlist
        statement = 'INSERT INTO playlist(name, visibility, consumer_usr_id) VALUES (%s, %s, %s)'
        values = (payload['name'], insere, user_data['data']['userid'])
        cur.execute(statement, values)
        conn.commit()

        # Obtem o ID da playlist criada
        cur.execute("SELECT id FROM playlist WHERE name = %s FOR UPDATE ",(payload["name"],))
        playlist = cur.fetchone()

        # Insere as músicas na playlist
        for song_name in payload["songs"]:#caso para inserir musicas pertencenter ao album.isto e guardado na tabela album_Song;
            cur.execute("SELECT ismn FROM song WHERE name = %s FOR UPDATE", (song_name,))
            song = cur.fetchone()
            # A música não existe
            if song is None:
                logger.debug(f"Erro: a música {song_name} não foi encontrada na base de dados")
            # A música existe e foi encontrada
            else:
                statement = 'INSERT INTO playlist_song (playlist_id,song_ismn) VALUES (%s,%s)'
                values =(playlist[0],song[0])
                cur.execute(statement, values)
                conn.commit()

        response = {'status': StatusCodes['success'], 'results': f'{playlist[0]}'}
        
    # Casos de erro
    except (Exception, psycopg2.DatabaseError) as error:
        print(traceback.format_exc())
        logger.error(f'POST create - error: {error}')
        response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

        # Rollback da transação em caso de erro
        conn.rollback()

    # Fecha a conexão à base de dados
    finally:
        if conn is not None:
            conn.close()

    return flask.jsonify(response)


# Criação de um novo cartão pré-pago - Método POST
@app.route('/dbproj/card', methods=['POST'])
def create_pre_paid_card():
    # Acesso padrão comum a todas as rotas
    logger.info('CARD [POST] - /dbproj/card')
    payload = flask.request.get_json()

    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------
   
    # Verifica se o token é válido
    if 'usertoken' not in flask.request.headers:
        return {"Error":"Por favor faça login para criar uma nova playlist"}
    else:
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)
            
    expire_date = datetime.datetime.now() + datetime.timedelta(days=365)
    cur.execute("SELECT usr_id FROM admin")
    admin = cur.fetchall()
    for i in range (len(admin)):
        if user_data['data']['userid'] == admin[i][0]:
            is_admin = 1 

    # Caso o utilizador não seja administrador
    if is_admin == 0:
        response={'status': StatusCodes['internal_error'],'Error': 'O utilizador não tem permissões para criar cartões'}
        return flask.jsonify(response)

    # Else, é porque é administrador
    try:
        n_cartoes = payload['number_cards']
        ids = []

        # Insere os cartões na base de dados
        for i in range(n_cartoes):
            statement = 'INSERT INTO card(price, expire_date, current_balance, admin_usr_id) VALUES (%s, %s, %s,%s)'
            values = (payload['card_price'], expire_date, payload['card_price'], user_data['data']['userid'])
            cur.execute(statement, values)
            conn.commit()

            # Retorna os IDs dos cartões criados
            cur.execute("SELECT lastval()")
            cards = cur.fetchone()[0]
            ids.append(cards)

        response = {'status': StatusCodes['success'], 'results': f'{json.dumps(ids)}'}
    
    # Casos de erro
    except (Exception, psycopg2.DatabaseError) as error:
        print(traceback.format_exc())
        logger.error(f'POST create - error: {error}')
        response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

        # Rollback da transação em caso de erro
        conn.rollback()

    # Fecha a conexão à base de dados
    finally:
        if conn is not None:
            conn.close()

    return flask.jsonify(response)


# Função auxiliar para atualizar o saldo de um cartão (usada abaixo)
def update_card_balance(cur, card_id, new_balance):
    conn = db_connection()
    statement = 'UPDATE card SET current_balance = %s WHERE id = %s'
    values = (new_balance, card_id)
    cur.execute(statement, values)
    conn.commit()


# Criação de uma nova subscrição - Método POST
@app.route('/dbproj/subscription', methods=['POST'])
def create_subscription():
    # Acesso padrão comum a todas as rotas
    logger.info('SUBSCRIPTION [POST] - /dbproj/subscription')
    payload = flask.request.get_json()

    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------

    # Verifica se o token é válido
    if 'usertoken' not in flask.request.headers:
        return {"Error":"Por favor faça login para fazer uma subscrição"}
    else:
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)
        
    # Verifica se o utilizador é um consumidor
    is_consumer = 0
    cur.execute("SELECT usr_id FROM consumer")
    consumer = cur.fetchone()
    for i in range (len(consumer)):
        if user_data['data']['userid'] == consumer[0]:
            is_consumer = 1

    if is_consumer == 0:
        response = {'status': StatusCodes['internal_error'],'Error': 'Não é um utilizador normal do sistema e não pode fazer subscrições'}
        return flask.jsonify(response)
    
    cur.execute("SELECT consumer_usr_id, subscription_end FROM subscription WHERE consumer_usr_id = %s FOR UPDATE", (user_data['data']['userid'],))
    user_subscription = cur.fetchall()
    
    # Parametros da subscrição
    prices = {'month': 7, 'quarter': 21, 'semester': 42} # Preços das subscrições
    duration = {'month': 30, 'quarter': 90, 'semester': 180} # Duração das subscrições
    period = payload['period'] # Periodo da subscrição
    cards = payload['cards'] # Quantidade de cartões associados à subscrição

    # Verifica se foram inseridos cartões
    if cards == 0: 
        response = {'status': StatusCodes['internal_error'],'Error': 'O utilizador não tem cartões associados'}
        return flask.jsonify(response)

    # Define o valor da dívida
    debt = prices[period]

    # Calcula o valor da subscrição e verifica se o utilizador tem saldo suficiente
    for card in cards:
        cur.execute("SELECT current_balance FROM card WHERE id = %s FOR UPDATE", (card,))
        balance = cur.fetchone()
        if balance[0]:
            if balance[0] >= debt:
                update_card_balance(cur, card, balance[0]-debt)
                debt = 0
                break
            else:
                debt -= balance[0]
                update_card_balance(cur, card, 0)
        
    # Caso o utilizador tenha dívida (não tem saldo suficiente)
    if debt:
        conn.rollback()
        response = {'status': StatusCodes['internal_error'],'Error': 'O utilizador não possui saldo suficiente para fazer uma subscrição'}    
        return flask.jsonify(response)
    
    # Caso o utilizador não tenha subscrição
    if not user_subscription:
        end_date = datetime.datetime.now() + datetime.timedelta(days=duration[period])
        cur.execute("INSERT INTO subscription(subscription_end, consumer_usr_id) VALUES (%s, %s)", (end_date, user_data['data']['userid']))
    # Caso o utilizador já tenha uma subscrição

    else:
        # Caso a subscrição já tenha terminado
        if user_subscription[0][1] < datetime.datetime.now():
            end_date = datetime.datetime.now() + datetime.timedelta(days=duration[period])
        # Caso a subscrição ainda esteja ativa
        else:
            end_date = user_subscription[0][1] + datetime.timedelta(days=duration[period])
        cur.execute("UPDATE subscription SET subscription_end = %s WHERE consumer_usr_id = %s", (end_date, user_data['data']['userid']))

    conn.commit()

    cur.execute("SELECT lastval()")
    subscription_id = cur.fetchone()[0]

    response = {'status': StatusCodes['success'], 'results': f'{subscription_id}'}
    return flask.jsonify(response)
    

# Novos comentários a uma determinada música - Método POST
@app.route('/dbproj/comments/<song_id>/<parent_comment>', methods=['POST'])
@app.route('/dbproj/comments/<song_id>', defaults={'parent_comment': None}, methods=['POST'])
def create_comment(song_id, parent_comment):
    # Acesso padrão comum a todas as rotas
    logger.info(f'COMMENT [POST] - /dbproj/comments/{song_id}/{parent_comment}')
    payload = flask.request.get_json()

    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------

    # Verifica se o token é válido
    if 'usertoken' not in flask.request.headers:
        return {"Error":"Por favor faça login para comentar"}
    else:
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)

    # Verifica se é um comentário de top-level ou uma resposta a um comentário
    if parent_comment is None:
        logger.debug('A criar um comentário de top-level')
    else:
        logger.debug(f'A responder ao comentário {parent_comment}')

    # Verifica se a música existe
    cur.execute("SELECT ismn FROM song WHERE ismn = %s FOR UPDATE", (song_id,))
    song = cur.fetchone()
    if song is None:
        response = {'status': StatusCodes['internal_error'], 'errors': 'A música não existe'}
        return flask.jsonify(response)

    try:
        # Verifica se é comentário top-level ou resposta
        if parent_comment is None:
            # Comentário top-level
            statement = 'INSERT INTO comment (content, comment_id, song_ismn) VALUES (%s, %s, %s) RETURNING id FOR UPDATE '
            values = (payload['content'], None, song_id)
            cur.execute(statement, values)
            conn.commit()

            # Verifica se o comentário foi criado com sucesso
            cur.execute("SELECT lastval()")
            comentario = cur.fetchone()
            response = {'status': StatusCodes['success'], 'results': f'Comentário de top-level {comentario[0]} criado com sucesso'}

        else:
            # Verifica se o comentário existe
            cur.execute("SELECT id FROM comment WHERE id = %s FOR UPDATE", (parent_comment,))
            comment = cur.fetchone()
            if comment is None:
                response = {'status': StatusCodes['internal_error'], 'errors': 'O comentário parente não existe'}
                return flask.jsonify(response)

            # Resposta a um comentário
            statement = 'INSERT INTO comment (content, comment_id, song_ismn) VALUES (%s, %s, %s) RETURNING id FOR UPDATE'
            values = (payload['content'], parent_comment, song_id)
            cur.execute(statement, values)
            conn.commit()

            # Verifica se a resposta foi criada com sucesso
            cur.execute("SELECT lastval()")
            comentario = cur.fetchone()
            response = {'status': StatusCodes['success'], 'results': f'{comentario[0]}'}

    # Casos de erro
    except (Exception, psycopg2.DatabaseError) as error:
        print(traceback.format_exc())
        logger.error(f'POST create - error: {error}')
        response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

        # Rollback da transação em caso de erro
        conn.rollback()

    # Fecha a conexão à base de dados
    finally:
        if conn is not None:
            conn.close()
    
    return flask.jsonify(response)


# Reprodução de uma música - Método PUT
@app.route('/dbproj/<song_id>', methods=['PUT'])
def play_song(song_id):
    # Acesso padrão comum a todas as rotas
    logger.info(f'PLAY SONG [GET] - /dbproj/{song_id}')
    
    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------

    # Verifica se o token é válido
    if 'usertoken' not in flask.request.headers:
        return {"Error":"Por favor faça login para reproduzir a música"}
    else:
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)
       
    # Verifica se a música existe
    cur.execute("SELECT ismn FROM song WHERE ismn = %s", (song_id,))
    song = cur.fetchone()
    if song is None:
        response = {'status': StatusCodes['internal_error'], 'errors': 'A música não existe'}
        return flask.jsonify(response)
    
    # Play da música
    try:
    # Insere na tabela de logs
        statement = 'INSERT INTO log (played_date) VALUES (%s)' 
        values = (datetime.datetime.now(),)
        cur.execute(statement, values)
        conn.commit()

        # Seleciona o id do log
        cur.execute("SELECT lastval()")
        log = cur.fetchone()

        # Insere na tabela de log_song
        statement = 'INSERT INTO log_song (log_id, song_ismn) VALUES (%s, %s)'
        values = (log[0], song_id)
        cur.execute(statement, values)
        conn.commit()

        # Insere na tabela de log_usr
        statement = 'INSERT INTO log_usr (log_id, usr_id) VALUES (%s, %s)'
        values = (log[0], user_data['data']['userid'])
        cur.execute(statement, values)
        conn.commit()
        response = {'status': StatusCodes['success'], 'results':''}

    # Casos de erro
    except (Exception, psycopg2.DatabaseError) as error:
        print(traceback.format_exc())
        logger.error(f'GET play - error: {error}')
        response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

        # Rollback da transação em caso de erro
        conn.rollback()

    # Fecha a conexão à base de dados
    finally:
        if conn is not None:
            conn.close()
    
    return flask.jsonify(response)

@app.route('/dbproj/report/<year>/<month>', methods=['GET'])
def get_report(year, month):
    # Acesso padrão comum a todas as rotas
    logger.info(f'GET REPORT [GET] - /dbproj/report')
    
    conn = db_connection()
    cur = conn.cursor()
    # -----------------------------------
    # Verifica se o token é válido
    if 'usertoken' not in flask.request.headers:
        return {"Error":"Por favor faça login ou registe-se para poder utilizar a plataforma"}
    else:
        user_data = decode_token(flask.request.headers.get('usertoken'))
        if user_data['error']:
            return flask.jsonify(user_data)
    
    try:
        cur.execute("""
        SELECT EXTRACT(MONTH FROM l.played_date) AS month, s.genre, COUNT(*) AS playbacks
        FROM log_song ls
        JOIN log l ON ls.log_id = l.id
        JOIN song s ON ls.song_ismn = s.ismn
        WHERE EXTRACT(YEAR FROM l.played_date) = %s
        AND EXTRACT(MONTH FROM l.played_date) = %s
        GROUP BY month, s.genre
        ORDER BY s.genre
        """, (year, month))

        # Pegar os resultados da query
        rows = cur.fetchall()

        # Converte as linhas para uma lista de dicionários
        result = []
        for row in rows:
            result.append({
                'month': row[0],
                'genre': row[1],
                'playbacks': row[2]
            })

        # Devolve a resposta
        return jsonify(result)
    
    # Casos de erro
    except (Exception, psycopg2.DatabaseError) as error:
        print(traceback.format_exc())
        logger.error(f'GET play - error: {error}')
        response = {'status': StatusCodes['internal_error'], 'errors': str(error)}

        # Rollback da transação em caso de erro
        conn.rollback()

    # Fecha a conexão à base de dados
    finally:
        if conn is not None:
            conn.close()
    
    return flask.jsonify(response)
    



###############################################
# Main - Execução da aplicação                #
###############################################

if __name__ == '__main__':
    
    # Configura o logging
    logging.basicConfig(filename='log_file.log')
    logger = logging.getLogger('logger')
    logger.setLevel(logging.DEBUG)
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)

    # Formatação das mensagens de logging
    formatter = logging.Formatter('%(asctime)s [%(levelname)s]:  %(message)s', '%H:%M:%S')
    ch.setFormatter(formatter)
    logger.addHandler(ch)

    # Inicialização do servidor
    host = '127.0.0.1'
    port = 8080
    app.run(host=host, debug=True, threaded=True, port=port)
    logger.info(f'iDEI API: http://{host}:{port}')
