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

select max(Fecha_Ultima_Modificacion) from clientes;

# Pregunta 5 -- ¿Hay claves duplicadas?
select count(*), count(distinct codigo) from canalventa;
select count(ID), count(distinct ID) from clientes;
select count(IdCompra), count(distinct IdCompra) from compra;
select count(ID_empleado), count(distinct ID_empleado) from empleados;
select count(IdGasto), count(distinct IdGasto) from gasto;
select count(ID_PRODUCTO), count(distinct ID_PRODUCTO) from productos;
select count(IDProveedor), count(distinct IDProveedor) from proveedores;
select count(ID), count(distinct ID) from sucursales;
select count(IdTipoGasto), count(distinct IdTipoGasto) from tipogasto;
select count(IdVenta), count(distinct IdVenta) from venta;

