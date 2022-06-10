-- @Autores: Jorge Manzanares y Jesús Salazar
-- @Fecha de creación: 02/07/2022
-- @Descripción: Creación de los objetos del módulo MULTIMEDIA de Media Stream

WHENEVER SQLERROR EXIT ROLLBACK;

CONNECT ADMIN_MULTIMEDIA /multimedia;

declare
  cursor cur_tables is 
    select TABLE_NAME from user_tables;
begin
  for t in cur_tables loop
    DBMS_OUTPUT.PUT_LINE('Eliminando la tabla => ' || t.table_name);
    execute immediate 'drop table ' || t.table_name || ' cascade constraints';
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR, excepción inesperada => ' || TO_CHAR(sqlcode));
    dbms_output.put_line('ERROR => ' || SQLERRM);
end;
/
--------------------------------------------------------------------------------

-- TABLE:  ALBUM
--   __________________________________________________________
--  |        SEGMENT      |    TYPE     |    TABLESPACE        |
--  |_____________________|_____________|______________________|
--  | ALBUM               | TABLE       | MEDIA_DATOS_TBS      |
--  | ALBUM_PK            | INDEX       | MEDIA_INDICES_TBS    |
--  | ALBUM_PORTADA_LOB   | LOBSEGMENT  | MEDIA_CONTENIDOS_TBS |
--  | ALBUM PORTADA_LOBIX | LOBINDEX    | MEDIA_CONTENIDOS_TBS |
--  |_____________________|_____________|______________________|

CREATE TABLE ALBUM(
  ALBUM_ID             NUMBER(10, 0)    NOT NULL,
  NOMBRE               VARCHAR2(50)     NOT NULL,
  FECHA_LANZAMIENTO    DATE             NOT NULL,
  ARTISTA              VARCHAR2(50)     NOT NULL,
  PORTADA              BLOB             NOT NULL,
  CONSTRAINT album_pk PRIMARY KEY (ALBUM_ID)
  USING INDEX (
    CREATE UNIQUE INDEX ALBUM_PK ON ALBUM(ALBUM_ID)
    TABLESPACE MEDIA_INDICES_TBS
  )
) 
LOB (PORTADA) STORE AS ALBUM_PORTADA_LOB (
  TABLESPACE MEDIA_CONTENIDOS_TBS 
  INDEX ALBUM_PORTADA_LOBIX (TABLESPACE MEDIA_INDICES_TBS)
)
TABLESPACE MEDIA_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  GENERO
--   __________________________________________________________
--  |        SEGMENT      |    TYPE     |    TABLESPACE        |
--  |_____________________|_____________|______________________|
--  | GENERO              | TABLE       | MEDIA_DATOS_TBS      |
--  | GENERO_PK           | INDEX       | MEDIA_INDICES_TBS    |
--  | GENERO_NOMBRE_IX    | INDEX       | MEDIA_INDICES_TBS    |
--  |_____________________|_____________|______________________|

CREATE TABLE GENERO(
  GENERO_ID      NUMBER(10, 0)    NOT NULL,
  NOMBRE         VARCHAR2(50)     NOT NULL,
  DESCRIPCION    VARCHAR2(100)    NOT NULL,
  CONSTRAINT genero_pk PRIMARY KEY (GENERO_ID)
  USING INDEX (
    CREATE UNIQUE INDEX GENERO_PK ON GENERO(GENERO_ID)
    TABLESPACE MEDIA_INDICES_TBS
  )
) TABLESPACE MEDIA_DATOS_TBS
;

CREATE INDEX GENERO_NOMBRE_IX ON GENERO(LOWER(NOMBRE))
TABLESPACE MEDIA_INDICES_TBS;

--------------------------------------------------------------------------------

-- TABLE:  STATUS_CONTENIDO
--   __________________________________________________________
--  |        SEGMENT      |    TYPE     |    TABLESPACE        |
--  |_____________________|_____________|______________________|
--  | STATUS_CONTENIDO    | TABLE       | MEDIA_DATOS_TBS      |
--  | STATUS_CONTENIDO_PK | INDEX       | MEDIA_INDICES_TBS    |
--  |_____________________|_____________|______________________|

CREATE TABLE STATUS_CONTENIDO(
  STATUS_CONTENIDO_ID    NUMBER(10, 0)    NOT NULL,
  CLAVE                  VARCHAR2(10)     NOT NULL,
  DESCRIPCION            VARCHAR2(20)     NOT NULL,
  CONSTRAINT STATUS_CONTENIDO_PK PRIMARY KEY (STATUS_CONTENIDO_ID)
  USING INDEX (
    CREATE UNIQUE INDEX STATUS_CONTENIDO_PK 
    ON STATUS_CONTENIDO(STATUS_CONTENIDO_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ),
  CONSTRAINT STATUS_CONTENIDO_CLAVE_CHK 
  CHECK (CLAVE IN ('PE', 'EL', 'S', 'R'))
) TABLESPACE MEDIA_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  CONTENIDO_MULTIMEDIA
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | CONTENIDO_MULTIMEDIA           | TABLE       | MEDIA_DATOS_TBS      |
--  | CONTENIDO_MULTIMEDIA_PK        | INDEX       | MEDIA_INDICES_TBS    |
--  | CONTENIDO_MULTIMEDIA_CLAVE_UK  | INDEX       | MEDIA_INDICES_TBS    |
--  | CONTENIDO_MULTIMEDIA_NOMBRE_IX | INDEX       | MEDIA_INDICES_TBS    |
--  | CONTENIDO_MULTIMEDIA_GENERO_IX | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE CONTENIDO_MULTIMEDIA(
  CONTENIDO_MULTIMEDIA_ID    NUMBER(10, 0)    NOT NULL,
  FECHA_STATUS               DATE             NOT NULL,
  CLAVE                      VARCHAR2(16)     NOT NULL,
  NOMBRE                     VARCHAR2(50)     NOT NULL,
  TOTAL_REPRODUCCIONES       NUMBER(16, 0)    NOT NULL,
  DURACION                   NUMBER(6, 0)     NOT NULL,
  TIPO                       CHAR(1)          NOT NULL,
  GENERO_ID                  NUMBER(10, 0)    NOT NULL,
  STATUS_CONTENIDO_ID        NUMBER(10, 0)    NOT NULL,
  CONSTRAINT CONTENIDO_MULTIMEDIA_PK PRIMARY KEY (CONTENIDO_MULTIMEDIA_ID)
  USING INDEX (
    CREATE UNIQUE INDEX CONTENIDO_MULTIMEDIA_PK 
    ON CONTENIDO_MULTIMEDIA(CONTENIDO_MULTIMEDIA_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ), 
  CONSTRAINT CONTENIDO_MULTIMEDIA_GENERO_FK FOREIGN KEY (GENERO_ID)
  REFERENCES GENERO(GENERO_ID),
  CONSTRAINT CONTENIDO_MULTIMEDIA_STATUS_FK FOREIGN KEY (STATUS_CONTENIDO_ID)
  REFERENCES STATUS_CONTENIDO(STATUS_CONTENIDO_ID),
  CONSTRAINT CONTENIDO_MULTIMEDIA_CLAVE_CHK CHECK ((LENGTH(CLAVE)) = 16),
  CONSTRAINT CONTENIDO_MULTIMEDIA_TIPO_CHK CHECK (TIPO IN ('A', 'V'))
) TABLESPACE MEDIA_DATOS_TBS
;

CREATE UNIQUE INDEX CONTENIDO_MULTIMEDIA_CLAVE_UK 
ON CONTENIDO_MULTIMEDIA(CLAVE)
TABLESPACE MEDIA_INDICES_TBS;

CREATE INDEX CONTENIDO_MULTIMEDIA_NOMBRE_IX 
ON CONTENIDO_MULTIMEDIA(LOWER(NOMBRE))
TABLESPACE MEDIA_INDICES_TBS;

CREATE INDEX CONTENIDO_MULTIMEDIA_GENERO_IX 
ON CONTENIDO_MULTIMEDIA(GENERO_ID)
TABLESPACE MEDIA_INDICES_TBS;

--------------------------------------------------------------------------------

-- TABLE:  AUDIO
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | AUDIO                          | TABLE       | MEDIA_DATOS_TBS      |
--  | AUDIO_PK                       | INDEX       | MEDIA_INDICES_TBS    |
--  | AUDIO_SONIDO_LOB               | LOBSEGMENT  | MEDIA_CONTENIDOS_TBS |
--  | AUDIO_SONIDO_LOBIX             | LOBINDEX    | MEDIA_CONTENIDOS_TBS |
--  | AUDIO_ALBUM_IX                 | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE AUDIO(
  CONTENIDO_MULTIMEDIA_ID    NUMBER(10, 0)     NOT NULL,
  SONIDO                     BLOB              NOT NULL,
  LETRA                      VARCHAR2(2500)    NOT NULL,
  FORMATO                    VARCHAR2(10)      NOT NULL,
  KBPS                       NUMBER(4, 0)      NOT NULL,
  ALBUM_ID                   NUMBER(10, 0)     NOT NULL,
  CONSTRAINT AUDIO_PK PRIMARY KEY (CONTENIDO_MULTIMEDIA_ID)
  USING INDEX (
    CREATE UNIQUE INDEX AUDIO_PK 
    ON AUDIO(CONTENIDO_MULTIMEDIA_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ), 
  CONSTRAINT AUDIO_CONTENIDO_MULT_FK FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES CONTENIDO_MULTIMEDIA(CONTENIDO_MULTIMEDIA_ID),
  CONSTRAINT AUDIO_ALBUM_FK FOREIGN KEY (ALBUM_ID)
  REFERENCES ALBUM(ALBUM_ID)
) 
LOB (SONIDO) STORE AS AUDIO_SONIDO_LOB (
  TABLESPACE MEDIA_DATOS_TBS
  INDEX AUDIO_SONIDO_LOBIX(TABLESPACE MEDIA_INDICES_TBS)
)
TABLESPACE MEDIA_DATOS_TBS
;

CREATE INDEX AUDIO_ALBUM_IX ON AUDIO(ALBUM_ID)
TABLESPACE MEDIA_INDICES_TBS;

--------------------------------------------------------------------------------

-- TABLE:  AUTOR
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | AUTOR                          | TABLE       | MEDIA_DATOS_TBS      |
--  | AUTOR_PK                       | INDEX       | MEDIA_INDICES_TBS    |
--  | AUTOR_NOMBRE_ARTISTICO_IX      | INDEX       | MEDIA_INDICES_TBS    |
--  | AUTOR_EMAIL_UK                 | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE AUTOR(
  AUTOR_ID            NUMBER(10, 0)    NOT NULL,
  NOMBRE              VARCHAR2(50)     NOT NULL,
  AP_PATERNO          VARCHAR2(50)     NOT NULL,
  AP_MATERNO          VARCHAR2(50),
  EMAIL               VARCHAR2(40)     NOT NULL,
  NOMBRE_ARTISTICO    VARCHAR2(50)     NOT NULL,
  CONSTRAINT AUTOR_PK PRIMARY KEY (AUTOR_ID)
  USING INDEX (
    CREATE UNIQUE INDEX AUTOR_PK ON AUTOR(AUTOR_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ) 
) TABLESPACE MEDIA_DATOS_TBS
;

CREATE INDEX AUTOR_NOMBRE_ARTISTICO_IX 
ON AUTOR(LOWER(NOMBRE_ARTISTICO))
TABLESPACE MEDIA_INDICES_TBS;

CREATE UNIQUE INDEX AUTOR_EMAIL_UK ON AUTOR(EMAIL)
TABLESPACE MEDIA_INDICES_TBS;

--------------------------------------------------------------------------------

-- TABLE:  AUTOR_CONTENIDO_MULTIMEDIA
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | AUTOR_CONTENIDO_MULTIMEDIA     | TABLE       | MEDIA_DATOS_TBS      |
--  | AUTOR_CONTENIDO_MULTIMEDIA_PK  | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE AUTOR_CONTENIDO_MULTIMEDIA(
  AUTOR_ID                    NUMBER(10, 0)    NOT NULL,
  CONTENIDO_MULTIMEDIA_ID     NUMBER(10, 0)    NOT NULL,
  PORCENTAJE_PARTICIPACION    NUMBER(3, 0)     NOT NULL,
  CONSTRAINT AUTOR_CONTENIDO_MULT_PK 
  PRIMARY KEY (AUTOR_ID, CONTENIDO_MULTIMEDIA_ID)
  USING INDEX (
    CREATE UNIQUE INDEX AUTOR_CONTENIDO_MULT_PK 
    ON AUTOR_CONTENIDO_MULTIMEDIA(
      AUTOR_ID, CONTENIDO_MULTIMEDIA_ID
    )
    TABLESPACE MEDIA_INDICES_TBS
  ), 
  CONSTRAINT AUTOR_CONTENIDO_AUTOR_FK 
  FOREIGN KEY (AUTOR_ID)
  REFERENCES AUTOR(AUTOR_ID),
  CONSTRAINT AUTOR_CONTENIDO_CONTENIDO_FK 
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES CONTENIDO_MULTIMEDIA(CONTENIDO_MULTIMEDIA_ID)
) TABLESPACE MEDIA_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  SERIE
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | SERIE                          | TABLE       | MEDIA_DATOS_TBS      |
--  | SERIE_PK                       | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE SERIE(
  SERIE_ID             NUMBER(10, 0)    NOT NULL,
  FECHA_LANZAMIENTO    DATE             NOT NULL,
  NOMBRE_SERIE         VARCHAR2(50)     NOT NULL,
  CONSTRAINT SERIE_PK PRIMARY KEY (SERIE_ID)
  USING INDEX (
    CREATE UNIQUE INDEX SERIE_PK ON SERIE(SERIE_ID)
    TABLESPACE MEDIA_INDICES_TBS
  )
) TABLESPACE MEDIA_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  TEMPORADA
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | TEMPORADA                      | TABLE       | MEDIA_DATOS_TBS      |
--  | TEMPORADA_PK                   | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE TEMPORADA(
  TEMPORADA_ID     NUMBER(10, 0)    NOT NULL,
  NUM_TEMPORADA    NUMBER(3, 0)     NOT NULL,
  SERIE_ID         NUMBER(10, 0)    NOT NULL,
  CONSTRAINT TEMPORADA_PK PRIMARY KEY (TEMPORADA_ID)
  USING INDEX (
    CREATE UNIQUE INDEX TEMPORADA_PK 
    ON TEMPORADA(TEMPORADA_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ), 
  CONSTRAINT TEMPORADA_SERIE_FK FOREIGN KEY (SERIE_ID)
  REFERENCES SERIE(SERIE_ID)
) TABLESPACE MEDIA_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  VIDEO
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | VIDEO                          | TABLE       | MEDIA_DATOS_TBS      |
--  | VIDEO_PK                       | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE VIDEO(
  CONTENIDO_MULTIMEDIA_ID    NUMBER(10, 0)    NOT NULL,
  TIPO                       VARCHAR2(30)     NOT NULL,
  CLASIFICACION              VARCHAR2(1)      NOT NULL,
  CODIFICACION               VARCHAR2(10)     NOT NULL,
  TRANSPORTE                 VARCHAR2(10)     NOT NULL,
  PROTOCOLO_TRANSMISION      VARCHAR2(10)     NOT NULL,
  TEMPORADA_ID               NUMBER(10, 0),
  CONSTRAINT VIDEO_PK PRIMARY KEY (CONTENIDO_MULTIMEDIA_ID)
  USING INDEX (
    CREATE UNIQUE INDEX VIDEO_PK ON VIDEO(CONTENIDO_MULTIMEDIA_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ),
  CONSTRAINT VIDEO_CONTENIDO_MULTIMEDIA_FK 
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES CONTENIDO_MULTIMEDIA(CONTENIDO_MULTIMEDIA_ID),
  CONSTRAINT VIDEO_TEMPORADA_FK FOREIGN KEY (TEMPORADA_ID)
  REFERENCES TEMPORADA(TEMPORADA_ID),
  CONSTRAINT VIDEO_CLASIFICACION_CHK
  CHECK (CLASIFICACION IN ('AA','A','B','C','D'))
) TABLESPACE MEDIA_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  CONTENIDO_VIP
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | CONTENIDO_VIP                  | TABLE       | MEDIA_DATOS_TBS      |
--  | CONTENIDO_VIP_PK               | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE CONTENIDO_VIP(
  CONTENIDO_MULTIMEDIA_ID    NUMBER(10, 0)    NOT NULL,
  COSTO_RENTA                NUMBER(7, 2)     NOT NULL,
  COSTO_VENTA                NUMBER(7, 2)     NOT NULL,
  FECHA_INICIO               DATE             NOT NULL,
  FECHA_FIN                  DATE,
  CONSTRAINT CONTENIDO_VIP_PK PRIMARY KEY (CONTENIDO_MULTIMEDIA_ID)
  USING INDEX (
    CREATE UNIQUE INDEX CONTENIDO_VIP_PK 
    ON CONTENIDO_VIP(CONTENIDO_MULTIMEDIA_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ),
  CONSTRAINT CONTENIDO_VIP_CONTENIDO_MULTIMEDIA_FK
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES VIDEO(CONTENIDO_MULTIMEDIA_ID)
) TABLESPACE MEDIA_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  HISTORICO_COSTO_RENTA
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | HISTORICO_COSTO_RENTA          | TABLE       | MEDIA_HISTORICOS_TBS |
--  | HISTORICO_COSTO_RENTA_PK       | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE HISTORICO_COSTO_RENTA(
  HISTORICO_COSTO_RENTA_ID    NUMBER(10,0)    NOT NULL,
  FECHA_INICIO                DATE             NOT NULL,
  FECHA_FIN                   DATE             NOT NULL,
  COSTO_RENTA                 NUMBER(7,2)     NOT NULL,
  CONTENIDO_MULTIMEDIA_ID     NUMBER(10,0)    NOT NULL,
  CONSTRAINT HISTORICO_COSTO_PLAN_SUSCRIPCION_PK
  PRIMARY KEY (HISTORICO_COSTO_RENTA_ID) 
  USING INDEX (
    CREATE UNIQUE INDEX HISTORICO_COSTO_RENTA_PK
    ON HISTORICO_COSTO_RENTA(HISTORICO_COSTO_RENTA_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ),
  CONSTRAINT HISTORICO_COSTO_RENTA_CONTENIDO_MULTIMEDIA_FK
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES CONTENIDO_VIP(CONTENIDO_MULTIMEDIA_ID)
) TABLESPACE MEDIA_HISTORICOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  HISTORICO_COSTO_VENTA
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | HISTORICO_COSTO_VENTA          | TABLE       | MEDIA_HISTORICOS_TBS |
--  | HISTORICO_COSTO_VENTA_PK       | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE HISTORICO_COSTO_VENTA(
  HISTORICO_COSTO_VENTA_ID    NUMBER(10, 0)    NOT NULL,
  FECHA_INICIO                DATE             NOT NULL,
  FECHA_FIN                   DATE             NOT NULL,
  COSTO_VENTA                 NUMBER(7, 2)     NOT NULL,
  CONTENIDO_MULTIMEDIA_ID     NUMBER(10, 0)    NOT NULL,
  CONSTRAINT HISTORICO_COSTO_VENTA_PK PRIMARY KEY (HISTORICO_COSTO_VENTA_ID)
  USING INDEX (
    CREATE UNIQUE INDEX HISTORICO_COSTO_VENTA_PK
    ON HISTORICO_COSTO_VENTA(HISTORICO_COSTO_VENTA_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ),
  CONSTRAINT HISTORICO_COSTO_VENTA_CONTENIDO_MULTIMEDIA_FK 
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES CONTENIDO_VIP(CONTENIDO_MULTIMEDIA_ID)
) TABLESPACE MEDIA_HISTORICOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  HISTORICO_STATUS_CONTENIDO
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | HISTORICO_STATUS_CONTENIDO     | TABLE       | MEDIA_HISTORICOS_TBS |
--  | HISTORICO_STATUS_CONTENIDO_PK  | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE HISTORICO_STATUS_CONTENIDO(
  HISTORICO_STATUS_CONTENIDO_ID   NUMBER(10, 0)    NOT NULL,
  FECHA_STATUS                  DATE             NOT NULL,
  CONTENIDO_MULTIMEDIA_ID       NUMBER(10, 0)    NOT NULL,
  STATUS_CONTENIDO_ID           NUMBER(10, 0)    NOT NULL,
  CONSTRAINT HISTORICO_STATUS_CONTENIDO_PK
  PRIMARY KEY (HISTORICO_STATUS_CONTENIDO_ID)
  USING INDEX (
    CREATE UNIQUE INDEX HISTORICO_STATUS_CONTENIDO_PK
    ON HISTORICO_STATUS_CONTENIDO(HISTORICO_STATUS_CONTENIDO_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ), 
  CONSTRAINT HISTORICO_STATUS_CONTENIDO_CONTENIDO_MULTIMEDIA_FK
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES CONTENIDO_MULTIMEDIA(CONTENIDO_MULTIMEDIA_ID),
  CONSTRAINT HISTORICO_STATUS_CONTENIDO_STATUS_CONTENIDO_FK 
  FOREIGN KEY (STATUS_CONTENIDO_ID)
  REFERENCES STATUS_CONTENIDO(STATUS_CONTENIDO_ID)
) TABLESPACE MEDIA_HISTORICOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  SECCION_VIDEO
--   __________________________________________________________________________
--  |              SEGMENT                |    TYPE     |    TABLESPACE        |
--  |_____________________________________|_____________|______________________|
--  | SECCION_VIDEO                       | TABLE       | MEDIA_DATOS_TBS      |
--  | SECCION_VIDEO_PK                    | INDEX       | MEDIA_INDICES_TBS    |
--  | SECCION_VIDEO_FRAGMENTO_VIDEO_LOB   | LOBSEGMENT  | MEDIA_CONTENIDOS_TBS |
--  | SECCION_VIDEO_FRAGMENTO_VIDEO_LOBIX | LOBINDEX    | MEDIA_CONTENIDOS_TBS |
--  |_____________________________________|_____________|______________________|

CREATE TABLE SECCION_VIDEO(
  NUM_SECCION                NUMBER(10, 0)    NOT NULL,
  CONTENIDO_MULTIMEDIA_ID    NUMBER(10, 0)    NOT NULL,
  FRAGMENTO_VIDEO            BLOB           NOT NULL,
  CONSTRAINT SECCION_VIDEO_PK 
  PRIMARY KEY (NUM_SECCION, CONTENIDO_MULTIMEDIA_ID) 
  USING INDEX (
    CREATE UNIQUE INDEX SECCION_VIDEO_PK
    ON SECCION_VIDEO(NUM_SECCION, CONTENIDO_MULTIMEDIA_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ),
  CONSTRAINT SECCION_VIDEO_CONTENIDO_MULTIMEDIA_FK
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES VIDEO(CONTENIDO_MULTIMEDIA_ID)
) 
LOB (FRAGMENTO_VIDEO) STORE AS SECCION_VIDEO_FRAGMENTO_VIDEO_LOB(
  TABLESPACE  MEDIA_CONTENIDOS_TBS
  INDEX SECCION_VIDEO_FRAGMENTO_VIDEO_LOBIX (TABLESPACE MEDIA_CONTENIDOS_TBS)
)
TABLESPACE MEDIA_DATOS_TBS
;

GRANT REFERENCES ON CONTENIDO_MULTIMEDIA TO ADMIN_USUARIOS;
GRANT REFERENCES ON CONTENIDO_VIP TO ADMIN_USUARIOS;

set serveroutput on;
declare
  cursor cur_tables is 
    select TABLE_NAME from user_tables;
begin
  for t in cur_tables loop
    DBMS_OUTPUT.PUT_LINE('Dando SELECT a ADMIN_USUARIOS en la tabla => ' || t.table_name);
    execute immediate 'grant select on ' || t.table_name || ' to ADMIN_USUARIOS';
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR, excepción inesperada => ' || TO_CHAR(sqlcode));
    dbms_output.put_line('ERROR => ' || SQLERRM);
end;
/

set serveroutput off;

disconnect;