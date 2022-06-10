-- @Autores: Jorge Manzanares y Jesús Salazar
-- @Fecha de creación: 02/07/2022
-- @Descripción: Creación de los objetos del módulo USUARIOS de Media Stream

WHENEVER SQLERROR EXIT ROLLBACK;

CONNECT ADMIN_USUARIOS /usuarios;

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

-- TABLE:  TARJETA_CREDITO
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | TARJETA_CREDITO                | TABLE       | USUARIOS_DATOS_TBS   |
--  | TARJETA_CREDITO_PK             | INDEX       | USUARIOS_INDICES_TBS |
--  |________________________________|_____________|______________________|

CREATE TABLE TARJETA_CREDITO (
  TARJETA_CREDITO_ID    NUMBER(10, 0)    NOT NULL,
  NUMERO                NUMBER(16, 0)    NOT NULL,
  TIPO                  VARCHAR2(10)     NOT NULL,
  NUMERO_SEGURIDAD      NUMBER(4, 0)     NOT NULL,
  ANIO_VIGENCIA         NUMBER(2, 0)     NOT NULL,
  MES_VIGENCIA          NUMBER(2, 0)     NOT NULL,
  CONSTRAINT TARJETA_CREDITO_PK PRIMARY KEY (TARJETA_CREDITO_ID)
  USING INDEX (
    CREATE UNIQUE INDEX TARJETA_CREDITO_PK 
    ON TARJETA_CREDITO(TARJETA_CREDITO_ID)
    TABLESPACE USUARIOS_INDICES_TBS
  )
) TABLESPACE USUARIOS_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  PLAN_SUSCRIPCION
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | PLAN_SUSCRIPCION               | TABLE       | USUARIOS_DATOS_TBS   |
--  | PLAN_SUSCRIPCION_PK            | INDEX       | USUARIOS_INDICES_TBS |
--  |________________________________|_____________|______________________|

CREATE TABLE PLAN_SUSCRIPCION(
  PLAN_SUSCRIPCION_ID    NUMBER(10, 0)    NOT NULL,
  COSTO                  NUMBER(10, 2)    NOT NULL,
  FECHA_COSTO_INICIO     DATE             NOT NULL,
  FECHA_COSTO_FIN        DATE,
  CLAVE                  VARCHAR2(20)     NOT NULL,
  NOMBRE                 VARCHAR2(50)     NOT NULL,
  DESCRIPCION            VARCHAR2(100)    NOT NULL,
  CONSTRAINT PLAN_SUSCRIPCION_PK PRIMARY KEY (PLAN_SUSCRIPCION_ID)
  USING INDEX (
    CREATE UNIQUE INDEX PLAN_SUSCRIPCION_PK 
    ON PLAN_SUSCRIPCION(PLAN_SUSCRIPCION_ID)
    TABLESPACE USUARIOS_INDICES_TBS
  )
) TABLESPACE USUARIOS_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  USUARIO
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | USUARIO                        | TABLE       | USUARIOS_DATOS_TBS   |
--  | USUARIO_PK                     | INDEX       | USUARIOS_INDICES_TBS |
--  | USUARIO_EMAIL_UK               | INDEX       | USUARIOS_INDICES_TBS |
--  | USUARIO_RFC_UK                 | INDEX       | USUARIOS_INDICES_TBS |
--  | USUARIO_PLAN_SUS_IX            | INDEX       | USUARIOS_INDICES_TBS |
--  | USUARIO_USERNAME_UK            | INDEX       | USUARIOS_INDICES_TBS |
--  |________________________________|_____________|______________________|

CREATE TABLE USUARIO(
  USUARIO_ID             NUMBER(10, 0)    NOT NULL,
  USERNAME               VARCHAR2(40)     NOT NULL,
  CONTRASENIA             VARCHAR2(40)     NOT NULL,
  EMAIL                  VARCHAR2(40)     NOT NULL,
  NOMBRE                 VARCHAR2(50)     NOT NULL,
  AP_PATERNO             VARCHAR2(50)     NOT NULL,
  AP_MATERNO             VARCHAR2(50),
  RFC                    VARCHAR2(13),
  USUARIO_FAMILIAR_ID    NUMBER(10, 0),
  TARJETA_CREDITO_ID     NUMBER(10, 0),
  PLAN_SUSCRIPCION_ID    NUMBER(10, 0)    NOT NULL,
  CONSTRAINT USUARIO_PK PRIMARY KEY (USUARIO_ID)
  USING INDEX (
    CREATE UNIQUE INDEX USUARIO_PK 
    ON USUARIO(USUARIO_ID)
    TABLESPACE USUARIOS_INDICES_TBS
  ), 
  CONSTRAINT USUARIO_TARJETA_FK FOREIGN KEY (TARJETA_CREDITO_ID)
  REFERENCES TARJETA_CREDITO(TARJETA_CREDITO_ID),
  CONSTRAINT USUARIO_PLAN_FK FOREIGN KEY (PLAN_SUSCRIPCION_ID)
  REFERENCES PLAN_SUSCRIPCION(PLAN_SUSCRIPCION_ID),
  CONSTRAINT USUARIO_FAMILIAR_FK FOREIGN KEY (USUARIO_FAMILIAR_ID)
  REFERENCES USUARIO(USUARIO_ID)
) TABLESPACE USUARIOS_DATOS_TBS
;

CREATE UNIQUE INDEX USUARIO_EMAIL_UK ON USUARIO(EMAIL)
TABLESPACE USUARIOS_INDICES_TBS;

CREATE UNIQUE INDEX USUARIO_RFC_UK ON USUARIO(RFC)
TABLESPACE USUARIOS_INDICES_TBS;

CREATE UNIQUE INDEX USUARIO_PLAN_SUS_IX 
ON USUARIO(PLAN_SUSCRIPCION_ID)
TABLESPACE USUARIOS_INDICES_TBS;

CREATE UNIQUE INDEX USUARIO_USERNAME_UK 
ON USUARIO(USERNAME)
TABLESPACE USUARIOS_INDICES_TBS;

--------------------------------------------------------------------------------

-- TABLE:  CALIFICACION_CONTENIDO
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | CALIFICACION_CONTENIDO        | TABLE       | MEDIA_DATOS_TBS      |
--  | CALIFICACION_CONTENIDO_PK     | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE CALIFICACION_CONTENIDO(
  USUARIO_ID                 NUMBER(10, 0)    NOT NULL,
  CONTENIDO_MULTIMEDIA_ID    NUMBER(10, 0)    NOT NULL,
  FECHA_CALIFICACION         DATE             NOT NULL,
  CALIFICACION               NUMBER(1, 0)     NOT NULL,
  CONSTRAINT CALIFICACION_CONTENIDO_PK 
  PRIMARY KEY (USUARIO_ID, CONTENIDO_MULTIMEDIA_ID)
  USING INDEX (
    CREATE UNIQUE INDEX CALIFICACION_CONTENIDO_PK 
    ON CALIFICACION_CONTENIDO(
      USUARIO_ID, CONTENIDO_MULTIMEDIA_ID
    )
    TABLESPACE MEDIA_INDICES_TBS
  ), 
  CONSTRAINT CALIFICACION_CONTENIDO_USUARIO_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID),
  CONSTRAINT CALIFICACION_CONTENIDO_MULTIMEDIA_FK 
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES ADMIN_MULTIMEDIA.CONTENIDO_MULTIMEDIA(CONTENIDO_MULTIMEDIA_ID),
  CONSTRAINT CALIFICACION_CONTENIDO_CALIF_CHK 
  CHECK (CALIFICACION >= 1 AND CALIFICACION <= 5)
) TABLESPACE MEDIA_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  CARGO
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | CARGO                          | TABLE       | USUARIOS_DATOS_TBS   |
--  | CARGO_PK                       | INDEX       | USUARIOS_INDICES_TBS |
--  | CARGO_FOLIO_UK                 | INDEX       | USUARIOS_INDICES_TBS |
--  |________________________________|_____________|______________________|

CREATE TABLE CARGO(
  CARGO_ID              NUMBER(10, 0)    NOT NULL,
  FECHA_CARGO           DATE             NOT NULL,
  IMPORTE               NUMBER(10, 0)    NOT NULL,
  FOLIO_CARGO           NUMBER(10, 0)    NOT NULL,
  TARJETA_CREDITO_ID    NUMBER(10, 0)    NOT NULL,
  CONSTRAINT CARGO_PK PRIMARY KEY (CARGO_ID)
  USING INDEX (
    CREATE UNIQUE INDEX CARGO_PK ON CARGO(CARGO_ID)
    TABLESPACE USUARIOS_INDICES_TBS
  ), 
  CONSTRAINT CARGO_TARJETA_ID FOREIGN KEY (TARJETA_CREDITO_ID)
  REFERENCES TARJETA_CREDITO(TARJETA_CREDITO_ID)
) TABLESPACE USUARIOS_DATOS_TBS
;

CREATE UNIQUE INDEX CARGO_FOLIO_UK ON CARGO(FOLIO_CARGO)
TABLESPACE USUARIOS_INDICES_TBS;

--------------------------------------------------------------------------------

-- TABLE:  COMENTARIO
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | COMENTARIO                     | TABLE       | MEDIA_DATOS_TBS      |
--  | COMENTARIO_PK                  | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE COMENTARIO(
  COMENTARIO_ID              NUMBER(10,0)    NOT NULL,
  TEXTO                      VARCHAR2(100)    NOT NULL,
  COMENTARIO_ORIGINAL_ID     NUMBER(10,0),
  CONTENIDO_MULTIMEDIA_ID    NUMBER(10,0)    NOT NULL,
  USUARIO_ID                 NUMBER(10,0)    NOT NULL,
  CONSTRAINT COMENTARIO_PK PRIMARY KEY (COMENTARIO_ID)
  USING INDEX (
    CREATE UNIQUE INDEX COMENTARIO_PK 
    ON COMENTARIO(COMENTARIO_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ), 
  CONSTRAINT COMENTARIO_CONTENIDO_FK FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES ADMIN_MULTIMEDIA.CONTENIDO_MULTIMEDIA(CONTENIDO_MULTIMEDIA_ID),
  CONSTRAINT COMENTARIO_USUARIO_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID),
  CONSTRAINT COMENTARIO_COMENTARIO_ORIGINAL_FK FOREIGN KEY (COMENTARIO_ORIGINAL_ID)
  REFERENCES COMENTARIO(COMENTARIO_ID)
) TABLESPACE MEDIA_DATOS_TBS
;


--------------------------------------------------------------------------------

-- TABLE:  DISPOSITIVO
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | DISPOSITIVO                    | TABLE       | USUARIOS_DATOS_TBS   |
--  | DISPOSITIVO_PK                 | INDEX       | USUARIOS_INDICES_TBS |
--  |________________________________|_____________|______________________|

CREATE TABLE DISPOSITIVO(
  DISPOSITIVO_ID       NUMBER(10, 0)    NOT NULL,
  TIPO                 VARCHAR2(10)     NOT NULL,
  IP                   VARCHAR2(15)     NOT NULL,
  SISTEMA_OPERATIVO    VARCHAR2(30)     NOT NULL,
  NOMBRE               VARCHAR2(30)     NOT NULL,
  MARCA                VARCHAR2(20)     NOT NULL,
  USUARIO_ID           NUMBER(10, 0)    NOT NULL,
  CONSTRAINT DISPOSITIVO_PK PRIMARY KEY (DISPOSITIVO_ID)
  USING INDEX (
    CREATE UNIQUE INDEX DISPOSITIVO_PK
    ON DISPOSITIVO(DISPOSITIVO_ID)
    TABLESPACE USUARIOS_INDICES_TBS
  ), 
  CONSTRAINT DISPOSITIVO_USUARIO_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID)
) TABLESPACE USUARIOS_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  HISTORICO_COSTO_PLAN_SUSCRIPCION
--   _____________________________________________________________________________
--  |             SEGMENT                 |    TYPE     |    TABLESPACE           |
--  |_____________________________________|_____________|_________________________|
--  | HISTORICO_COSTO_PLAN_SUSCRIPCION    | TABLE       | USUARIOS_HISTORICOS_TBS |
--  | HISTORICO_COSTO_PLAN_SUSCRIPCION_PK | INDEX       | USUARIOS_INDICES_TBS    |
--  |_____________________________________|_____________|_________________________|

CREATE TABLE HISTORICO_COSTO_PLAN_SUSCRIPCION(
  HISTORICO_COSTO_PLAN_SUSCRIPCION_ID    NUMBER(10, 0)    NOT NULL,
  COSTO                                  NUMBER(7, 2)     NOT NULL,
  FECHA_COSTO_INICIO                     DATE             NOT NULL,
  FECHA_COSTO_FIN                        DATE             NOT NULL,
  PLAN_SUSCRIPCION_ID                    NUMBER(10, 0)    NOT NULL,
  CONSTRAINT HISTORICO_COSTO_PLAN_SUSCRIPCION_PK
  PRIMARY KEY (HISTORICO_COSTO_PLAN_SUSCRIPCION_ID)
  USING INDEX (
    CREATE UNIQUE INDEX HISTORICO_COSTO_PLAN_SUSCRIPCION_PK
    ON HISTORICO_COSTO_PLAN_SUSCRIPCION(
      HISTORICO_COSTO_PLAN_SUSCRIPCION_ID
    )
    TABLESPACE USUARIOS_INDICES_TBS
  ), 
  CONSTRAINT HISTORICO_COSTO_PLAN_SUSCRIPCION_PLAN_SUSCRIPCION_FK
  FOREIGN KEY (PLAN_SUSCRIPCION_ID)
  REFERENCES PLAN_SUSCRIPCION(PLAN_SUSCRIPCION_ID)
) TABLESPACE USUARIOS_HISTORICOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  PLAYLIST
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | PLAYLIST                       | TABLE       | USUARIOS_DATOS_TBS   |
--  | PLAYLIST_PK                    | INDEX       | USUARIOS_INDICES_TBS |
--  |________________________________|_____________|______________________|

CREATE TABLE PLAYLIST(
  PLAYLIST_ID    NUMBER(10, 0)    NOT NULL,
  NOMBRE         VARCHAR2(50)     NOT NULL,
  USUARIO_ID     NUMBER(10, 0)    NOT NULL,
  CONSTRAINT PLAYLIST_PK  PRIMARY KEY (PLAYLIST_ID)
  USING INDEX (
    CREATE UNIQUE INDEX PLAYLIST_PK
    ON PLAYLIST(PLAYLIST_ID)
    TABLESPACE USUARIOS_INDICES_TBS
  ), 
  CONSTRAINT PLAYLIST_USUARIO_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID)
) TABLESPACE USUARIOS_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  PLAYLIST_COMPARTIDA
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | PLAYLIST_COMPARTIDA            | TABLE       | USUARIOS_DATOS_TBS   |
--  | PLAYLIST_COMPARTIDA_PK         | INDEX       | USUARIOS_INDICES_TBS |
--  |________________________________|_____________|______________________|

CREATE TABLE PLAYLIST_COMPARTIDA(
  USUARIO_INVITADO_ID    NUMBER(10, 0)    NOT NULL,
  PLAYLIST_ID            NUMBER(10, 0)    NOT NULL,
  CONSTRAINT PLAYLIST_COMPARTIDA_PK
  PRIMARY KEY (USUARIO_INVITADO_ID, PLAYLIST_ID)
  USING INDEX (
    CREATE UNIQUE INDEX PLAYLIST_COMPARTIDA_PK
    ON PLAYLIST_COMPARTIDA(USUARIO_INVITADO_ID, PLAYLIST_ID)
    TABLESPACE USUARIOS_INDICES_TBS
  ),  
  CONSTRAINT PLAYLIST_COMPARTIDA_USUARIO_INVITADO_FK
  FOREIGN KEY (USUARIO_INVITADO_ID)
  REFERENCES USUARIO(USUARIO_ID),
  CONSTRAINT PLAYLIST_COMPARTIDA_PLAYLIST_FK
  FOREIGN KEY (PLAYLIST_ID)
  REFERENCES PLAYLIST(PLAYLIST_ID)
) TABLESPACE USUARIOS_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  PLAYLIST_CONTENIDO
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | PLAYLIST_CONTENIDO             | TABLE       | USUARIOS_DATOS_TBS   |
--  | PLAYLIST_CONTENIDO_PK          | INDEX       | USUARIOS_INDICES_TBS |
--  |________________________________|_____________|______________________|

CREATE TABLE PLAYLIST_CONTENIDO(
  PLAYLIST_ID                NUMBER(10, 0)    NOT NULL,
  CONTENIDO_MULTIMEDIA_ID    NUMBER(10, 0)    NOT NULL,
  CONSTRAINT PLAYLIST_CONTENIDO_PK
  PRIMARY KEY (PLAYLIST_ID, CONTENIDO_MULTIMEDIA_ID)
  USING INDEX (
    CREATE UNIQUE INDEX PLAYLIST_CONTENIDO_PK
    ON PLAYLIST_CONTENIDO(PLAYLIST_ID, CONTENIDO_MULTIMEDIA_ID)
    TABLESPACE USUARIOS_INDICES_TBS
  ), 
  CONSTRAINT PLAYLIST_CONTENIDO_PLAYLIST_FK FOREIGN KEY (PLAYLIST_ID)
  REFERENCES PLAYLIST(PLAYLIST_ID),
  CONSTRAINT PLAYLIST_CONTENIDO_CONTENIDO_MULTIMEDIA_FK
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES ADMIN_MULTIMEDIA.CONTENIDO_MULTIMEDIA(CONTENIDO_MULTIMEDIA_ID)
) TABLESPACE USUARIOS_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  REPRODUCCION
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | REPRODUCCION                   | TABLE       | MEDIA_DATOS_TBS      |
--  | REPRODUCCION_PK                | INDEX       | MEDIA_INDICES_TBS    |
--  |________________________________|_____________|______________________|

CREATE TABLE REPRODUCCION(
  REPRODUCCION_ID            NUMBER(10, 0)    NOT NULL,
  SEGUNDO_INICAL             NUMBER(5, 0)     NOT NULL,
  SEGUNDO_FINAL              NUMBER(5, 0)     NOT NULL,
  USUARIO_ID                 NUMBER(10, 0)    NOT NULL,
  CONTENIDO_MULTIMEDIA_ID    NUMBER(10, 0)    NOT NULL,
  CONSTRAINT REPRODUCCION_PK PRIMARY KEY (REPRODUCCION_ID)
  USING INDEX (
    CREATE UNIQUE INDEX REPRODUCCION_PK
    ON REPRODUCCION(REPRODUCCION_ID)
    TABLESPACE MEDIA_INDICES_TBS
  ), 
  CONSTRAINT REPRODUCCION_USUARIO_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID),
  CONSTRAINT REPRODUCCION_CONTENIDO_MULTIMEDIA_FK 
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES ADMIN_MULTIMEDIA.CONTENIDO_MULTIMEDIA(CONTENIDO_MULTIMEDIA_ID)
) TABLESPACE MEDIA_DATOS_TBS
;

--------------------------------------------------------------------------------

-- TABLE:  USUARIO_CONTENIDO_VIP
--   _____________________________________________________________________
--  |             SEGMENT            |    TYPE     |    TABLESPACE        |
--  |________________________________|_____________|______________________|
--  | USUARIO_CONTENIDO_VIP          | TABLE       | USUARIOS_DATOS_TBS   |
--  | USUARIO_CONTENIDO_VIP_PK       | INDEX       | USUARIOS_INDICES_TBS |
--  |________________________________|_____________|______________________|

CREATE TABLE USUARIO_CONTENIDO_VIP(
  USUARIO_CONTENIDO_VIP_ID    NUMBER(10, 0)    NOT NULL,
  FECHA_ADQUISICION           DATE             NOT NULL,
  PERIODO_RENTA               NUMBER(3, 0),
  FOLIO                       VARCHAR2(8)      NOT NULL,
  USUARIO_ID                  NUMBER(10, 0)    NOT NULL,
  CONTENIDO_MULTIMEDIA_ID     NUMBER(10, 0)    NOT NULL,
  CONSTRAINT USUARIO_CONTENIDO_VIP_PK PRIMARY KEY (USUARIO_CONTENIDO_VIP_ID)
  USING INDEX (
    CREATE UNIQUE INDEX USUARIO_CONTENIDO_VIP_PK
    ON USUARIO_CONTENIDO_VIP(USUARIO_CONTENIDO_VIP_ID)
    TABLESPACE USUARIOS_INDICES_TBS
  ),
  CONSTRAINT USUARIO_CONTENIDO_VIP_CONTENIDO_MULTIMEDIA_FK
  FOREIGN KEY (CONTENIDO_MULTIMEDIA_ID)
  REFERENCES ADMIN_MULTIMEDIA.CONTENIDO_VIP(CONTENIDO_MULTIMEDIA_ID),
  CONSTRAINT USUARIO_CONTENIDO_VIP_USUARIO_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID)
) TABLESPACE USUARIOS_DATOS_TBS
;

set serveroutput on;
declare
  cursor cur_tables is 
    select TABLE_NAME from user_tables;
begin
  for t in cur_tables loop
    DBMS_OUTPUT.PUT_LINE('Dando SELECT a ADMIN_MULTIMEDIA en la tabla => ' || t.table_name);
    execute immediate 'grant select on ' || t.table_name || ' to ADMIN_MULTIMEDIA';
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR, excepción inesperada => ' || TO_CHAR(sqlcode));
    dbms_output.put_line('ERROR => ' || SQLERRM);
end;
/

set serveroutput off;