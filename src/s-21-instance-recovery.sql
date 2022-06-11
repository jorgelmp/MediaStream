-- @Autores: Jorge Manzanares y Jesús Salazar 
-- @Fecha de creación: 10/06/2022
-- @Descripción: Proceso de instance recovery


set serveroutput on;

@s-14-1-redo-multimedia.sql
@s-14-2-redo-usuarios.sql

connect sys/systemp as sysdba

Prompt Tiempo estimado de recuperacion para la carga de datos
select estimated_mttr from V$INSTANCE_RECOVERY;


Prompt shutdown abort
shutdown abort

set serveroutput on;
set timing on;
prompt
Prompt levantando la instancia 
startup
set timing off;

--alter system set fast_start_mttr_target=20;

