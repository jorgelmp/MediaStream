-- @Autores: Jorge Manzanares y Jesús Salazar 
-- @Fecha de creación: 08/06/2022
-- @Descripción: Creación de datos redo para módulo usuarios

-------------------------------------------------------------------------------
whenever sqlerror exit rollback

connect ADMIN_USUARIOS /usuarios

set serveroutput on;

/*
create sequence folio_cargo_seq 
  start with 9996448739
  increment by 1
  nocache;

drop sequence cargo_seq;
drop sequence tarjeta_credito_seq; 
drop sequence usuario_contenido_vip_seq; 
drop sequence comentario_seq; 
drop sequence reproduccion_seq;

create sequence cargo_seq 
  start with 4801
  increment by 1
  nocache;

create sequence tarjeta_credito_seq 
  start with 4801
  increment by 1
  nocache;

create sequence usuario_contenido_vip_seq 
  start with 4791
  increment by 1
  nocache;

create sequence comentario_seq 
  start with 4801
  increment by 1
  nocache;

create sequence reproduccion_seq 
  start with 4801
  nocache;
*/
--------------------------------------------------
--------TARJETA_CREDITO------------------
---------------------------------------------------
declare
  v_max_id number;
  v_count number;
  cursor cur_insert is
    select TARJETA_CREDITO_SEQ.NEXTVAL as TARJETA_CREDITO_ID, NUMERO, TIPO, NUMERO_SEGURIDAD, ANIO_VIGENCIA, MES_VIGENCIA
    from TARJETA_CREDITO sample(60) a where rownum <=7000;
  
  cursor cur_update is
    select * from TARJETA_CREDITO sample (60) where rownum <=4000;
begin
   -- insert
   v_count := 0;
  for r in cur_insert loop
    insert into TARJETA_CREDITO (TARJETA_CREDITO_ID, NUMERO, TIPO, NUMERO_SEGURIDAD, ANIO_VIGENCIA, MES_VIGENCIA)
    values (
      r.TARJETA_CREDITO_ID, r.NUMERO, r.TIPO, r.NUMERO_SEGURIDAD, r.ANIO_VIGENCIA, r.MES_VIGENCIA
    );
    v_count := v_count + 1;
  end loop;

  dbms_output.put_line('Registros insertados en TARJETA_CREDITO: '||v_count);

  select max(TARJETA_CREDITO_ID) into v_max_id from TARJETA_CREDITO;
  -- update 
  v_count := 0;
  for r in cur_update loop
      update TARJETA_CREDITO set 
        NUMERO = r.NUMERO, TIPO = r.TIPO, 
        NUMERO_SEGURIDAD = r.NUMERO_SEGURIDAD, 
        ANIO_VIGENCIA = r.ANIO_VIGENCIA, MES_VIGENCIA = r.MES_VIGENCIA
        where TARJETA_CREDITO_ID = (select trunc(dbms_random.value(1,v_max_id))from dual);
        v_count := v_count + 1;
  end loop;
  dbms_output.put_line('Registros modificados en TARJETA_CREDITO: '||v_count);

end;
/

--------------------------------------------------------------------------------
--CARGO-------------------------------------------------------------------------
--------------------------------------------------------------------------------
declare
  v_max_id number;
  v_count number;
  cursor cur_insert is
    select CARGO_SEQ.NEXTVAL as CARGO_ID, FECHA_CARGO, IMPORTE, folio_cargo_seq.NEXTVAL as FOLIO_CARGO, TARJETA_CREDITO_ID
    from CARGO sample(60) a where rownum <=7000;
  
  cursor cur_update is
    select * from CARGO sample (60) where rownum <=4000;
begin
   -- insert
   v_count := 0;
  for r in cur_insert loop
    insert into CARGO (CARGO_ID, FECHA_CARGO, IMPORTE, FOLIO_CARGO, TARJETA_CREDITO_ID)
    values (
      r.CARGO_ID, r.FECHA_CARGO, r.IMPORTE, r.FOLIO_CARGO, r.TARJETA_CREDITO_ID
    );
    v_count := v_count + 1;
  end loop;

  dbms_output.put_line('Registros insertados en CARGO: '||v_count);

  select max(CARGO_ID) into v_max_id from CARGO;
  -- update 
  v_count := 0;
  for r in cur_update loop
      update CARGO set 
        FECHA_CARGO = r.FECHA_CARGO, IMPORTE = r.IMPORTE, 
        TARJETA_CREDITO_ID = r.TARJETA_CREDITO_ID
        where CARGO_ID = (select trunc(dbms_random.value(1,v_max_id))from dual);
        v_count := v_count + 1;
  end loop;
  dbms_output.put_line('Registros modificados en CARGO: '||v_count);

end;
/

--------------------------------------------------------------------------------
--COMENTARIO-------------------------------------------------------------------------
--------------------------------------------------------------------------------
declare
  v_max_id number;
  v_count number;
  cursor cur_insert is
    select COMENTARIO_SEQ.NEXTVAL as COMENTARIO_ID, TEXTO, COMENTARIO_ORIGINAL_ID, 
    CONTENIDO_MULTIMEDIA_ID, USUARIO_ID
    from COMENTARIO sample(60) a where rownum <=7000;
  
  cursor cur_update is
    select * from COMENTARIO sample (60) where rownum <=4000;
begin
   -- insert
   v_count := 0;
  for r in cur_insert loop
    insert into COMENTARIO (COMENTARIO_ID, TEXTO, COMENTARIO_ORIGINAL_ID, 
    CONTENIDO_MULTIMEDIA_ID, USUARIO_ID)
    values (
      r.COMENTARIO_ID, r.TEXTO, r.COMENTARIO_ORIGINAL_ID, 
        r.CONTENIDO_MULTIMEDIA_ID, r.USUARIO_ID
    );
    v_count := v_count + 1;
  end loop;

  dbms_output.put_line('Registros insertados en COMENTARIO: '||v_count);

  select max(COMENTARIO_ID) into v_max_id from COMENTARIO;
  -- update 
  v_count := 0;
  for r in cur_update loop
      update COMENTARIO set 
        TEXTO=r.TEXTO, COMENTARIO_ORIGINAL_ID=r.COMENTARIO_ORIGINAL_ID, 
        CONTENIDO_MULTIMEDIA_ID=r.CONTENIDO_MULTIMEDIA_ID, USUARIO_ID=r.USUARIO_ID
        where COMENTARIO_ID = (select trunc(dbms_random.value(1,v_max_id))from dual);
        v_count := v_count + 1;
  end loop;
  dbms_output.put_line('Registros modificados en COMENTARIO: '||v_count);

end;
/

--------------------------------------------------------------------------------
--REPRODUCCION--------------------------------------------------------------------
--------------------------------------------------------------------------------
declare
  v_max_id number;
  v_count number;
  cursor cur_insert is
    select REPRODUCCION_SEQ.NEXTVAL as REPRODUCCION_ID, SEGUNDO_INICIAL, SEGUNDO_FINAL,
      USUARIO_ID, CONTENIDO_MULTIMEDIA_ID
    from REPRODUCCION sample(60) a where rownum <=7000;
  
  cursor cur_update is
    select * from REPRODUCCION sample (60) where rownum <=4000;
begin
   v_count := 0;
  for r in cur_insert loop
    insert into REPRODUCCION (REPRODUCCION_ID, SEGUNDO_INICIAL, SEGUNDO_FINAL,
      USUARIO_ID, CONTENIDO_MULTIMEDIA_ID)
    values (
      r.REPRODUCCION_ID, r.SEGUNDO_INICIAL, r.SEGUNDO_FINAL, r.USUARIO_ID,
      r.CONTENIDO_MULTIMEDIA_ID
    );
    v_count := v_count + 1;
  end loop;

  dbms_output.put_line('Registros insertados en REPRODUCCION: '||v_count);

  select max(REPRODUCCION_ID) into v_max_id from REPRODUCCION;
  -- update 
  v_count := 0;
  for r in cur_update loop
      update REPRODUCCION set 
        SEGUNDO_INICIAL = r.SEGUNDO_INICIAL,
        SEGUNDO_FINAL = r.SEGUNDO_FINAL, 
        USUARIO_ID = r.USUARIO_ID,
        CONTENIDO_MULTIMEDIA_ID = r.CONTENIDO_MULTIMEDIA_ID
        where REPRODUCCION_ID = (select trunc(dbms_random.value(1,v_max_id))from dual);
        v_count := v_count + 1;
  end loop;
  dbms_output.put_line('Registros modificados en REPRODUCCION: '||v_count);

end;
/

--------------------------------------------------------------------------------
--USUARIO_CONTENIDO_VIP---------------------------------------------------------
--------------------------------------------------------------------------------
declare
  v_max_id number;
  v_count number;
  cursor cur_insert is
    select USUARIO_CONTENIDO_VIP_SEQ.NEXTVAL as USUARIO_CONTENIDO_VIP_ID, 
    FECHA_ADQUISICION, PERIODO_RENTA, FOLIO, USUARIO_ID, CONTENIDO_MULTIMEDIA_ID
    from USUARIO_CONTENIDO_VIP sample(60) a where rownum <=7000;
  
  cursor cur_update is
    select * from USUARIO_CONTENIDO_VIP sample (60) where rownum <=4000;
begin
   -- insert
   v_count := 0;
  for r in cur_insert loop
    insert into USUARIO_CONTENIDO_VIP (USUARIO_CONTENIDO_VIP_ID, FECHA_ADQUISICION, 
    PERIODO_RENTA, FOLIO, USUARIO_ID, CONTENIDO_MULTIMEDIA_ID)
    values (
      r.USUARIO_CONTENIDO_VIP_ID, r.FECHA_ADQUISICION, r.PERIODO_RENTA, 
      r.FOLIO, r.USUARIO_ID, r.CONTENIDO_MULTIMEDIA_ID
    );
    v_count := v_count + 1;
  end loop;

  dbms_output.put_line('Registros insertados en USUARIO_CONTENIDO_VIP: '||v_count);

  select max(USUARIO_CONTENIDO_VIP_ID) into v_max_id from USUARIO_CONTENIDO_VIP;
  -- update 
  v_count := 0;
  for r in cur_update loop
      update USUARIO_CONTENIDO_VIP set 
        FECHA_ADQUISICION=r.FECHA_ADQUISICION, 
        PERIODO_RENTA=r.PERIODO_RENTA, FOLIO=r.FOLIO, USUARIO_ID=r.USUARIO_ID, 
        CONTENIDO_MULTIMEDIA_ID=r.CONTENIDO_MULTIMEDIA_ID
        where USUARIO_CONTENIDO_VIP_ID = (select trunc(dbms_random.value(1,v_max_id))from dual);
        v_count := v_count + 1;
  end loop;
  dbms_output.put_line('Registros modificados en USUARIO_CONTENIDO_VIP: '||v_count);

end;
/
Prompt Confirmando Cambios
commit;

whenever sqlerror continue none