select @@global.secure_file_priv; -- devuelve la ruta de sql

set global local_infile = true;

create database henry_3;

use henry_3;
select * from canalventa;
select * from clientes;
select * from compra;
select * from empleados;
select * from gasto;
select * from productos;
select * from proveedores;
select * from sucursales;
select * from tipogasto;
select * from venta;