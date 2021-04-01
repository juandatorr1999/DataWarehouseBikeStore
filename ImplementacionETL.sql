--------------------------------------------------------
--  File created - Monday-November-02-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ACTUALIZA_DCLIENTE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "DWHA01702686"."ACTUALIZA_DCLIENTE" AS 
BEGIN
  insert into DWHA01702686.dcliente
  select DWHA01702686.secuenciadcliente.nextval, cliente.customer_id, cliente.first_name, cliente.last_name,  cliente.phone, cliente.email, cliente.street, cliente.city, cliente.state, cliente.zip_code
  from BIKESTORE.customers cliente
  where cliente.customer_id not in (select codigo from DWHA01702686.dcliente);
  commit;
END ACTUALIZA_DCliente;

/
--------------------------------------------------------
--  DDL for Procedure ACTUALIZA_DPRODUCTO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "DWHA01702686"."ACTUALIZA_DPRODUCTO" AS 
BEGIN
  insert into DWHA01702686.dproducto
  select DWHA01702686.secuenciadproducto.nextval, product_id, product_name, model_year, list_price,brand_name, category_name
  from DWHA01702686.producto 
  where product_id not in (select codigo from DWHA01702686.dproducto);
  commit;
END ACTUALIZA_DPRODUCTO;

/
--------------------------------------------------------
--  DDL for Procedure ACTUALIZA_DSTAFF
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "DWHA01702686"."ACTUALIZA_DSTAFF" AS 
BEGIN
  insert into DWHA01702686.dstaff
  select DWHA01702686.secuenciadstaff.nextval, sta.staff_id, sta.first_name, sta.last_name, sta.email, sta.phone, sta.active, sto.store_name
  from BIKESTORE.staffs sta, bikestore.stores sto
  where sta.store_id = sto.store_id
  and sta.staff_id not in (select codigo from DWHA01702686.dstaff);
  commit;
END ACTUALIZA_DSTAFF;

/
--------------------------------------------------------
--  DDL for Procedure ACTUALIZA_DTIENDA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "DWHA01702686"."ACTUALIZA_DTIENDA" AS 
BEGIN
  insert into DWHA01702686.dtienda
  select DWHA01702686.secuenciadtienda.nextval, store_id, store_name, phone, email, street, city, state, zip_code
  from BIKESTORE.stores 
  where store_id not in (select codigo from DWHA01702686.dtienda);
  commit;
END ACTUALIZA_DTIENDA;

/
--------------------------------------------------------
--  DDL for Procedure ACTUALIZA_HCLIENTE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "DWHA01702686"."ACTUALIZA_HCLIENTE" 
(
  FECHAINICIAL IN DATE  
, FECHAFINAL IN DATE  
) AS 
  vFechaInicial date;
  vFechaFinal   date;
  vdCliePk       number;
  vdTiempoPk    number;
  v_cantidad    number;
  v_ingresos    number;
  v_ingresosdescuento    number;

  cursor c_tiempo is
  select dtiempopk
  from dwhA01702686.dtiempo
  WHERE fecha between vFechaInicial and vFechaFinal;




cursor c_cliente is
select tiempo.DTIEMPOPK, cliente.dclientepk,sum(ORDERS.QUANTITY),sum(ORDERS.QUANTITY*ORDERS.LIST_PRICE), SUM((ORDERS.QUANTITY*ORDERS.LIST_PRICE)*(1-ORDERS.DISCOUNT))
from DWHA01702686.ORDERS_UNION ORDERS, DWHA01702686.Dcliente cliente, DWHA01702686.DTIEMPO TIEMPO
WHERE ORDERS.customer_id = cliente.CODIGO
AND to_date(ORDERS.ORDER_DATE,'YYYY-MM-DD') = TIEMPO.FECHA
group by TIEMPO.FECHA,cliente.dclientepk, TIEMPO.DTIEMPOPK ;

BEGIN
  vFechaInicial := fechainicial;
  vFechaFinal := fechafinal;

  open c_tiempo;
    loop
        fetch c_tiempo into vdTiempoPk;
        exit when c_tiempo%NOTFOUND;
        delete from DWHA01702686.hcliente where DTIEMPOPK = vdTiempoPk;
        commit;
    end loop;
    close c_tiempo;

    open c_cliente;
    loop
        fetch c_cliente into vdTiempoPk, vdCliePk, v_cantidad, v_ingresos, v_ingresosdescuento;
        exit when c_cliente%NOTFOUND;
        insert into DWHA01702686.hcliente (hclientepk,dtiempopk,dclientepk, cantidadvendida, ingresototal,ingresodescuento)
        values (dwha01702686.secuenciahcliente.nextval, vdTiempoPk, vdCliePk, v_cantidad, v_ingresos, v_ingresosdescuento);
        commit ;
    end loop;
    close c_cliente;
END ACTUALIZA_HCliente;

/
--------------------------------------------------------
--  DDL for Procedure ACTUALIZA_HPRODUCTO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "DWHA01702686"."ACTUALIZA_HPRODUCTO" 
(
  FECHAINICIAL IN DATE  
, FECHAFINAL IN DATE  
) AS 
  vFechaInicial date;
  vFechaFinal   date;
  vdProPk       number;
  vdTiempoPk    number;
  v_cantidad    number;
  v_ingresos    number;
  v_ingresosdescuento    number;

  cursor c_tiempo is
  select dtiempopk
  from dwhA01702686.dtiempo
  WHERE fecha between vFechaInicial and vFechaFinal;




cursor c_producto is
select DWHA01702686.DTiempo.DTIEMPOPK, DWHA01702686.DProducto.DPRODUCTOPK,sum(QUANTITY),sum(QUANTITY*LIST_PRICE), SUM((QUANTITY*LIST_PRICE)*(1-DISCOUNT))
from DWHA01702686.ORDERS_UNION
join DWHA01702686.DPRODUCTO on DWHA01702686.ORDERS_UNION.PRODUCT_ID = DWHA01702686.DPRODUCTO.CODIGO
join DWHA01702686.DTIEMPO on to_date(ORDER_DATE,'YYYY-MM-DD') = DWHA01702686.DTIEMPO.FECHA
group by DWHA01702686.DTiempo.FECHA, DWHA01702686.DPRODUCTO.DPRODUCTOPK, DWHA01702686.DTiempo.DTIEMPOPK ;

BEGIN
  vFechaInicial := fechainicial;
  vFechaFinal := fechafinal;

  open c_tiempo;
    loop
        fetch c_tiempo into vdTiempoPk;
        exit when c_tiempo%NOTFOUND;
        delete from DWHA01702686.HPRODUCTO where DTIEMPOPK = vdTiempoPk;
        commit;
    end loop;
    close c_tiempo;

    open c_producto;
    loop
        fetch c_producto into vdTiempoPk, vdProPk, v_cantidad, v_ingresos, v_ingresosdescuento;
        exit when c_producto%NOTFOUND;
        insert into DWHA01702686.HProducto (hproductopk,dtiempopk,dproductopk, cantidadvendida, ingresototal,ingresodescuento)
        values (dwha01702686.secuenciahproducto.nextval, vdTiempoPk, vdProPk, v_cantidad, v_ingresos, v_ingresosdescuento);
        commit ;
    end loop;
    close c_producto;
END ACTUALIZA_HPRODUCTO;

/
--------------------------------------------------------
--  DDL for Procedure ACTUALIZA_HSTAFF
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "DWHA01702686"."ACTUALIZA_HSTAFF" 
(
  FECHAINICIAL IN DATE  
, FECHAFINAL IN DATE  
) AS 
  vFechaInicial date;
  vFechaFinal   date;
  vdStaPk       number;
  vdTiempoPk    number;
  v_cantidad    number;
  v_ingresos    number;
  v_ingresosdescuento    number;

  cursor c_tiempo is
  select dtiempopk
  from dwhA01702686.dtiempo
  WHERE fecha between vFechaInicial and vFechaFinal;




cursor c_staff is
select tiempo.DTIEMPOPK, staffs.dstaffpk,sum(ORDERS.QUANTITY),sum(ORDERS.QUANTITY*ORDERS.LIST_PRICE), SUM((ORDERS.QUANTITY*ORDERS.LIST_PRICE)*(1-ORDERS.DISCOUNT))
from DWHA01702686.ORDERS_UNION ORDERS, DWHA01702686.Dstaff staffs, DWHA01702686.DTIEMPO TIEMPO
WHERE ORDERS.staff_id = staffs.CODIGO
AND to_date(ORDERS.ORDER_DATE,'YYYY-MM-DD') = TIEMPO.FECHA
group by TIEMPO.FECHA,staffs.dstaffpk, TIEMPO.DTIEMPOPK ;

BEGIN
  vFechaInicial := fechainicial;
  vFechaFinal := fechafinal;

  open c_tiempo;
    loop
        fetch c_tiempo into vdTiempoPk;
        exit when c_tiempo%NOTFOUND;
        delete from DWHA01702686.HSTAFF where DTIEMPOPK = vdTiempoPk;
        commit;
    end loop;
    close c_tiempo;

    open c_staff;
    loop
        fetch c_staff into vdTiempoPk, vdStaPk, v_cantidad, v_ingresos, v_ingresosdescuento;
        exit when c_staff%NOTFOUND;
        insert into DWHA01702686.HStaff (hstaffpk,dtiempopk,dstaffpk, cantidadvendida, ingresototal,ingresodescuento)
        values (dwha01702686.secuenciahstaff.nextval, vdTiempoPk, vdStaPk, v_cantidad, v_ingresos, v_ingresosdescuento);
        commit ;
    end loop;
    close c_staff;
END ACTUALIZA_HStaff;

/
--------------------------------------------------------
--  DDL for Procedure ACTUALIZA_HTIENDA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "DWHA01702686"."ACTUALIZA_HTIENDA" 
(
  FECHAINICIAL IN DATE  
, FECHAFINAL IN DATE  
) AS 
  vFechaInicial date;
  vFechaFinal   date;
  vdTienPk       number;
  vdTiempoPk    number;
  v_cantidad    number;
  v_ingresos    number;
  v_ingresosdescuento    number;

  cursor c_tiempo is
  select dtiempopk
  from dwhA01702686.dtiempo
  WHERE fecha between vFechaInicial and vFechaFinal;




cursor c_tienda is
select DTiempo.DTIEMPOPK, DTienda.DtiendaPK,sum(QUANTITY),sum(QUANTITY*LIST_PRICE), SUM((QUANTITY*LIST_PRICE)*(1-DISCOUNT))
from DWHA01702686.ORDERS_UNION
join DWHA01702686.DTIENDA on ORDERS_UNION.STORE_ID = DTIENDA.CODIGO
join DWHA01702686.DTIEMPO on to_date(orders_union.ORDER_DATE,'YYYY-MM-DD') = DTIEMPO.FECHA
group by DTiempo.FECHA, DTienda.DtiendaPK, DTiempo.DTIEMPOPK ;

BEGIN
  vFechaInicial := fechainicial;
  vFechaFinal := fechafinal;

  open c_tiempo;
    loop
        fetch c_tiempo into vdTiempoPk;
        exit when c_tiempo%NOTFOUND;
        delete from DWHA01702686.HPRODUCTO where DTIEMPOPK = vdTiempoPk;
        commit;
    end loop;
    close c_tiempo;

    open c_tienda;
    loop
        fetch c_tienda into vdTiempoPk, vdTienPk, v_cantidad, v_ingresos, v_ingresosdescuento;
        exit when c_tienda%NOTFOUND;
        insert into DWHA01702686.HTienda (htiendapk,dtiempopk,dtiendapk, cantidadvendida, ingresototal,ingresodescuento)
        values (DWHA01702686.secuenciahtienda.nextval, vdTiempoPk, vdTienPk, v_cantidad, v_ingresos, v_ingresosdescuento);
        commit ;
    end loop;
    close c_tienda;
END ACTUALIZA_HTIENDA;

/
--------------------------------------------------------
--  DDL for Procedure PDIMTIEMPO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "DWHA01702686"."PDIMTIEMPO" (FechaInicial in date, FechaFinal in date) AS
vFechaInicial date;
vFechaFinal date;
v_numdias  number;
vAnio      varchar2(4);
vMes       varchar2(10);
vDia       number;
vNDia      varchar2(20);

BEGIN
  vFechaInicial := FechaInicial;
  vFechaFinal := FechaFinal;
  v_numdias := vFechaFinal - vFechaInicial;

  for contador in 1..v_numdias
  LOOP
  vAnio := to_char(vFechaInicial, 'YYYY');
  vMes  := to_char(vFechaInicial, 'MONTH');
  vDia  := to_number(to_char(vFechaInicial,'DD'));
  vNDia := to_char(vFechaInicial,'FMDAY');
  insert into DWHA01702686.dtiempo values (DWHA01702686.secuenciadtiempo.nextval, vFechaInicial, vAnio, vMes, vDia,vNDia);
  commit;
  vFechaInicial := vFechaInicial+1;
  END LOOP;

END PDIMTIEMPO;

/

---------------------------------------------------------------------
--------------
-- RUN PDIMTIEMPO
--------------

DECLARE
  FECHAINICIAL DATE;
  FECHAFINAL DATE;
BEGIN
  FECHAINICIAL := to_date('2016-01-01','yyyy-MM-dd');
  FECHAFINAL := to_date('2018-12-29','yyyy-MM-dd');

  dwha01702686.PDIMTIEMPO(
    FECHAINICIAL => FECHAINICIAL,
    FECHAFINAL => FECHAFINAL
  );
--rollback; 
END;
/








--------------------------
-- RUN ACTUALIZA DPRODUCTO
---------------------------
BEGIN
  dwha01702686.ACTUALIZA_DPRODUCTO();
--rollback; 
END;

/
------------------------
-- RUN ACTUALIZA_DTIENDA
-------------------------
BEGIN
  dwha01702686.ACTUALIZA_DTIENDA();
--rollback; 
END;

/
------------------------
-- RUN ACTUALIZA_DSTAFF
-------------------------
BEGIN
  dwha01702686.ACTUALIZA_DSTAFF();
--rollback; 
END;

/
------------------------
-- RUN ACTUALIZA_DCliente
-------------------------
BEGIN
  dwha01702686.ACTUALIZA_DCLIENTE();
--rollback; 
END;

/
--------------
-- RUN HPRODUCTO
--------------
DECLARE
  FECHAINICIAL DATE;
  FECHAFINAL DATE;
BEGIN
  FECHAINICIAL := to_date('2016-01-01','yyyy-MM-dd');
  FECHAFINAL := to_date('2018-12-29','yyyy-MM-dd');

  dwha01702686.ACTUALIZA_HPRODUCTO(
    FECHAINICIAL => FECHAINICIAL,
    FECHAFINAL => FECHAFINAL
  );
--rollback; 
END;

/
---------------
-- RUN HTIENDA
---------------

DECLARE
  FECHAINICIAL DATE;
  FECHAFINAL DATE;
BEGIN
  FECHAINICIAL := to_date('2016-01-01','yyyy-MM-dd');
  FECHAFINAL := to_date('2018-12-29','yyyy-MM-dd');

  dwha01702686.ACTUALIZA_HTIENDA(
    FECHAINICIAL => FECHAINICIAL,
    FECHAFINAL => FECHAFINAL
  );
--rollback; 
END;

/
---------------
-- RUN HSTAFF
---------------

DECLARE
  FECHAINICIAL DATE;
  FECHAFINAL DATE;
BEGIN
  FECHAINICIAL := to_date('2016-01-01','yyyy-MM-dd');
  FECHAFINAL := to_date('2018-12-29','yyyy-MM-dd');

  dwha01702686.ACTUALIZA_HSTAFF(
    FECHAINICIAL => FECHAINICIAL,
    FECHAFINAL => FECHAFINAL
  );
--rollback; 
END;

/

---------------
-- RUN HCLIENTE
---------------

DECLARE
  FECHAINICIAL DATE;
  FECHAFINAL DATE;
BEGIN
  FECHAINICIAL := to_date('2016-01-01','yyyy-MM-dd');
  FECHAFINAL := to_date('2018-12-29','yyyy-MM-dd');

  dwha01702686.ACTUALIZA_HCLIENTE(
    FECHAINICIAL => FECHAINICIAL,
    FECHAFINAL => FECHAFINAL
  );
--rollback; 
END;


/
