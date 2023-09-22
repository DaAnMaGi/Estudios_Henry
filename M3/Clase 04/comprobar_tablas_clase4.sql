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

drop table if exists canalventa;
drop table if exists clientes;
drop table if exists compra;
drop table if exists empleados;
drop table if exists gasto;
drop table if exists productos;
drop table if exists proveedores;
drop table if exists sucursales;
drop table if exists tipogasto;
drop table if exists venta;
