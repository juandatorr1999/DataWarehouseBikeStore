--Pregunta 1
--¿Qué producto se vendió más el mes de marzo en el año 2018?

CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."PRODUCTOVENDIDOMARZO2018_1" ("NOMBRE", "CANTIDADVENDIDA") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select dp.nombre, SUM(hp.cantidadvendida) AS VENTAS
from dwha01702686.dproducto dp,dwha01702686.dtiempo dt, dwha01702686.hproducto hp
where dp.dproductopk = hp.dproductopk 
and dt.dtiempopk = hp.dtiempopk
and dt.fecha BETWEEN to_date('2018-03-01','YYYY-MM-DD') and (to_date('2018-04-01','YYYY-MM-DD')-1) group by dp.nombre 
ORDER BY VENTAS DESC
fetch first row only;

--Pregunta 2
--¿Qué productos se vendieron durante los meses del verano Junio Julio, Agosto y Septiembre  en 2017 del modelo 2016?
CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."PRODUCTOSVERANOMODELO2016_2" ("NOMBRE", "CANTIDADVENDIDA", "ANIOMODELO") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select dp.nombre, SUM(hp.cantidadvendida) AS VENTAS, dp.aniomodelo
from dwha01702686.dproducto dp,dwha01702686.dtiempo dt, dwha01702686.hproducto hp
where dp.dproductopk = hp.dproductopk 
and dt.dtiempopk = hp.dtiempopk
AND dp.aniomodelo = 2016
and dt.fecha BETWEEN to_date('2017-06-01','YYYY-MM-DD') and (to_date('2017-10-01','YYYY-MM-DD')-1)
group by dp.nombre, dp.aniomodelo
ORDER BY VENTAS DESC

--Pregunta 3
--¿Qué producto se vende más los Sabados de la marca electra? 

CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."PRODUCTOSABADOSELECTRA_3" ("NOMBRE", "CANTIDADVENDIDA") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select dp.nombre, SUM(hp.cantidadvendida) VENTAS
from dwha01702686.dproducto dp,dwha01702686.dtiempo dt, dwha01702686.hproducto hp
where dp.dproductopk = hp.dproductopk 
and dt.dtiempopk = hp.dtiempopk
and dt.nombredia = 'SATURDAY'
and dp.nombremarca = 'Electra' 
group by dp.nombre
ORDER BY VENTAS DESC
fetch first row only;

--Pregunta 4
--¿Qué empleado obtuvo mas ingresos con descuento vendiendo en diciembre 2016?
CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."EMPLEADOINGRESODIC2016_4" ("FIRST_NAME", "LAST_NAME", "VENTAS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select ds.first_name,ds.last_name, sum(hs.ingresodescuento) AS VENTAS
from dwha01702686.dstaff ds,dwha01702686.dtiempo dt, dwha01702686.hstaff hs
where ds.dstaffpk = hs.dstaffpk
and dt.fecha BETWEEN to_date('2016-12-01','YYYY-MM-DD') and (to_date('2017-01-01','YYYY-MM-DD')-1)
and dt.dtiempopk = hs.dtiempopk 
group by ds.first_name, ds.last_name
order by Ventas desc
fetch first row only;


--Pregunta 5
--¿Qué empleado le dio mas descuento a los clientes en 2017?
CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."EMPLEADODESCUENTO2017_5" ("FIRST_NAME", "LAST_NAME", "DESCUENTO") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select ds.first_name,ds.last_name, sum(hs.ingresototal-hs.ingresodescuento) AS DESCUENTO
from dwha01702686.dstaff ds,dwha01702686.dtiempo dt, dwha01702686.hstaff hs
where ds.dstaffpk = hs.dstaffpk
and dt.anio = '2017'
and dt.dtiempopk = hs.dtiempopk 
group by ds.first_name, ds.last_name
order by DESCUENTO desc
fetch first row only;



--Pregunta 6
--¿Qué empleado vendió menos entre la tienda de Baldwin Bikes y Santa Cruz Bikes el año 2018?


  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."EMPLEADOMENOSBALDSAN2018_6" ("FIRST_NAME", "LAST_NAME", "STORE_NAME", "CANTIDADVENDIDA") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select ds.first_name,ds.last_name,ds.store_name, sum(hs.cantidadvendida) AS CANTIDADVENDIDA
from dwha01702686.dstaff ds,dwha01702686.dtiempo dt, dwha01702686.hstaff hs
where ds.dstaffpk = hs.dstaffpk
and dt.anio = '2018'
and dt.dtiempopk = hs.dtiempopk 
and (ds.store_name = 'Baldwin Bikes' or ds.store_name = 'Santa Cruz Bikes')
group by ds.first_name, ds.last_name, ds.store_name
order by CANTIDADVENDIDA asc
fetch first row only;



--Pregunta 7
--¿Qué tienda genero más ingresos con descuento en el año 2018?
CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."TIENDADESCUENTO2018_7" ("NOMBRE", "INGRESO_CON_DESCUENTO") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select dtien.nombre, SUM(ht.INGRESODESCUENTO) AS INGRESO_CON_DESCUENTO
from dwha01702686.dtienda dtien,dwha01702686.dtiempo dt, dwha01702686.htienda ht
where dtien.dtiendapk = ht.dtiendapk
and dt.dtiempopk = ht.dtiempopk
and dt.ANIO = '2018'
GROUP BY DTIEN.NOMBRE
order by INGRESO_CON_DESCUENTO desc
FETCH FIRST ROW ONLY;



--Pregunta 8
--¿Cuántas ventas hizo la tienda de Rowlett Bikes el año 2016?
CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."TIENDAROWLETT2016_8" ("NOMBRE", "CANTIDADVENDIDA") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select dtien.nombre, SUM(ht.CANTIDADVENDIDA) AS CANTIDADVENDIDA
from dwha01702686.dtienda dtien,dwha01702686.dtiempo dt, dwha01702686.htienda ht
where dtien.dtiendapk = ht.dtiendapk
and dt.dtiempopk = ht.dtiempopk
and dt.ANIO = '2016'
AND dtien.NOMBRE = 'Rowlett Bikes'
GROUP BY DTIEN.NOMBRE
FETCH FIRST ROW ONLY;



--Pregunta 9
--¿Cuales fueron los ingresos sin descuento de las tiendas el año 2017?
CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."TIENDASINGRESOS2017_9" ("NOMBRE", "INGRESOS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select dtien.nombre, SUM(ht.INGRESOTOTAL) AS INGRESOS
from dwha01702686.dtienda dtien,dwha01702686.dtiempo dt, dwha01702686.htienda ht
where dtien.dtiendapk = ht.dtiendapk
and dt.dtiempopk = ht.dtiempopk
and dt.ANIO = '2017'
GROUP BY DTIEN.NOMBRE;


--Pregunta 10
--¿Qué cliente compró más bicicletas el año 2018?
CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."CLIENTECOMPRA2018_10" ("FIRST_NAME", "LAST_NAME", "CANTIDADVENDIDA") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select dc.FIRST_NAME,dc.LAST_NAME, SUM(hc.cantidadvendida) AS CANTIDADVENDIDA
from dwha01702686.dcliente dc,dwha01702686.dtiempo dt, dwha01702686.hcliente hc
where dc.dclientepk = hc.dclientepk
and dt.dtiempopk = hc.dtiempopk
and dt.ANIO = '2018'
GROUP BY  dc.FIRST_NAME, dc.LAST_NAME
order by cantidadvendida desc
fetch first row only;


--Pregunta 11
--¿Cuáles clientes compraron en 2017 que son del estado de NY?
CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."CLIENTENY2017_11" ("FIRST_NAME", "LAST_NAME", "STATE", "CANTIDADCOMPRADA") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select dc.FIRST_NAME,dc.LAST_NAME,dc.state, SUM(hc.cantidadvendida) AS CANTIDADCOMPRADA
from dwha01702686.dcliente dc,dwha01702686.dtiempo dt, dwha01702686.hcliente hc
where dc.dclientepk = hc.dclientepk
and dt.dtiempopk = hc.dtiempopk
and dt.ANIO = '2017'
and dc.state = 'NY'
GROUP BY  dc.FIRST_NAME, dc.LAST_NAME, dc.state
order by cantidadcomprada desc;



--Pregunta 12
--¿Que cliente ahorro mas en el 2016?


CREATE OR REPLACE FORCE EDITIONABLE VIEW "DWHA01702686"."CLIENEAHORRO2016_12" ("FIRST_NAME", "LAST_NAME", "CANTIDADAHORRADA") DEFAULT COLLATION "USING_NLS_COMP"  AS 
select dc.FIRST_NAME,dc.LAST_NAME, SUM(hc.ingresototal-hc.ingresodescuento) AS CANTIDADAHORRADA
from dwha01702686.dcliente dc,dwha01702686.dtiempo dt, dwha01702686.hcliente hc
where dc.dclientepk = hc.dclientepk
and dt.dtiempopk = hc.dtiempopk
and dt.ANIO = '2016'
GROUP BY  dc.FIRST_NAME, dc.LAST_NAME
order by CANTIDADAHORRADA desc
fetch first row only;

