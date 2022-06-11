-- @Autores: Jorge Manzanares y Jesús Salazar 
-- @Fecha de creación: 08/06/2022
-- @Descripción: Creación de datos redo para módulo multimedia


connect ADMIN_MULTIMEDIA /multimedia

whenever sqlerror exit rollback


set serveroutput on;
/*
drop sequence historico_costo_renta_seq;
drop sequence historico_costo_venta_seq;

create sequence historico_costo_renta_seq 
  start with 6586
  increment by 1
  nominvalue
  nomaxvalue
  cache 20
  noorder;

create sequence historico_costo_venta_seq 
  start with 4091
  increment by 1
  nominvalue
  nomaxvalue
  cache 20
  noorder;
*/
--------------------------------------------------------------------------------
--HISTORICO_COSTO_RENTA---------------------------------------------------------
--------------------------------------------------------------------------------

declare
  v_max_id number;
  v_count number;
  cursor cur_insert is
    select 
      HISTORICO_COSTO_RENTA_SEQ.NEXTVAL as HISTORICO_COSTO_RENTA_ID,
      FECHA_INICIO, 
      FECHA_FIN, 
      COSTO_RENTA,
      CONTENIDO_MULTIMEDIA_ID
    from HISTORICO_COSTO_RENTA sample(60) a where rownum <=7000;
  
  cursor cur_update is
    select * from HISTORICO_COSTO_RENTA sample (60) where rownum <=4000;
begin
   -- insert
   v_count := 0;
  for r in cur_insert loop
    insert into HISTORICO_COSTO_RENTA (
      HISTORICO_COSTO_RENTA_ID,
      FECHA_INICIO, 
      FECHA_FIN, 
      COSTO_RENTA,
      CONTENIDO_MULTIMEDIA_ID
    )
    values (
      r.historico_costo_renta_id, 
      r.fecha_inicio,
      r.fecha_fin,
      r.costo_renta,
      r.contenido_multimedia_id
    );
    v_count := v_count + 1;
  end loop;

  dbms_output.put_line('Registros insertados en HISTORICO_COSTO_RENTA : '||v_count);

  select max(HISTORICO_COSTO_RENTA_ID) into v_max_id from HISTORICO_COSTO_RENTA;
  -- update 
  v_count := 0;
  for r in cur_update loop
      update HISTORICO_COSTO_RENTA set 
        FECHA_INICIO = r.fecha_inicio,
        FECHA_FIN = r.fecha_fin,
        COSTO_RENTA = r.costo_renta,
        CONTENIDO_MULTIMEDIA_ID = r.contenido_multimedia_id
      where HISTORICO_COSTO_RENTA_ID = (select trunc(dbms_random.value(1,v_max_id))from dual);
      v_count := v_count + 1;
  end loop;
  dbms_output.put_line('Registros modificados en HISTORICO_COSTO_RENTA: '||v_count);
end;
/

--------------------------------------------------------------------------------
--HISTORICO_COSTO_VENTA---------------------------------------------------------
--------------------------------------------------------------------------------
declare
  v_max_id number;
  v_count number;
  cursor cur_insert is
    select 
      HISTORICO_COSTO_VENTA_SEQ.NEXTVAL as HISTORICO_COSTO_VENTA_ID,
      FECHA_INICIO, 
      FECHA_FIN, 
      COSTO_VENTA,
      CONTENIDO_MULTIMEDIA_ID
    from HISTORICO_COSTO_VENTA sample(60) a where rownum <=7000;
  
  cursor cur_update is
    select * from HISTORICO_COSTO_VENTA sample (60) where rownum <=4000;
begin
   -- insert
   v_count := 0;
  for r in cur_insert loop
    insert into HISTORICO_COSTO_VENTA (
      HISTORICO_COSTO_VENTA_ID,
      FECHA_INICIO, 
      FECHA_FIN, 
      COSTO_VENTA,
      CONTENIDO_MULTIMEDIA_ID
    )
    values (
      r.historico_costo_VENTA_id, 
      r.fecha_inicio,
      r.fecha_fin,
      r.costo_venta,
      r.contenido_multimedia_id
    );
    v_count := v_count + 1;
  end loop;

  dbms_output.put_line('Registros insertados en HISTORICO_COSTO_VENTA: '||v_count);

  select max(HISTORICO_COSTO_VENTA_ID) into v_max_id from HISTORICO_COSTO_VENTA;
  -- update 
  v_count := 0;
  for r in cur_update loop
      update HISTORICO_COSTO_VENTA set 
        FECHA_INICIO = r.fecha_inicio,
        FECHA_FIN = r.fecha_fin,
        COSTO_VENTA = r.costo_venta,
        CONTENIDO_MULTIMEDIA_ID = r.contenido_multimedia_id
      where HISTORICO_COSTO_VENTA_ID = (select trunc(dbms_random.value(1,v_max_id))from dual);
      v_count := v_count + 1;
  end loop;
  dbms_output.put_line('Registros modificados en HISTORICO_COSTO_VENTA: '||v_count);
end;
/


Prompt Confirmando Cambios
commit;

whenever sqlerror continue none