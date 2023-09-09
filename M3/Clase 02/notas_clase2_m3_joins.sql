use checkpoint_m2;

# Join or INNER JOIN
select 
	c.canal,
    sum(v.precio*v.cantidad) as "Total Ventas"
    from venta v
    join canal_venta c
		on (v.IdCanal = c.IdCanal)
    group by c.canal;

# Left join     
select 
	p.IdProducto,
    p.Concepto,
    v.IdVenta,
    v.precio*v.cantidad
    from producto p
    left join venta v
		on (p.IdProducto = v.IdProducto);

# Right join

select 
	p.IdProducto,
    p.Concepto,
    v.IdVenta,
    v.precio*v.cantidad
    from producto p
    right join venta v
		on (p.IdProducto = v.IdProducto);

# FULL OUTER JOIN

select 
	p.IdProducto,
    p.Concepto,
    v.IdVenta,
    v.precio*v.cantidad
    from producto p
    left join venta v
		on (p.IdProducto = v.IdProducto)
union 
select 
	p.IdProducto,
    p.Concepto,
    v.IdVenta,
    v.precio*v.cantidad
    from producto p
    right join venta v
		on (p.IdProducto = v.IdProducto);

# EJEMPLO DIFERENCIAS DE CONJUNTOS CON JOINS

-- Left join

Select distinct 
	p.IdProducto, 
    p.concepto,
    v.IdVenta,
    p.precio * v.Cantidad
    from producto p
    left join venta v
		on (p.IdProducto = v.IdProducto)
	where v.IdVenta is null;

-- right join
	Select distinct 
	p.IdProducto, 
    p.concepto,
    v.IdVenta,
    p.precio * v.Cantidad
    from producto p
    right join venta v
		on (p.IdProducto = v.IdProducto)
	where v.IdVenta is null;
    
