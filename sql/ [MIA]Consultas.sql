--------------------- CONSULTAS PARA LOS REPORTES  -----------------------

--------------------------------------------------------------------------
----------------------------  CONSULTA 1 ---------------------------------
--------------------------------------------------------------------------
SELECT Proveedor.nombre, Proveedor.telefono, Orden.id, Orden.total
FROM usuario Proveedor 
INNER JOIN transaccion Orden ON Orden.usuario = Proveedor.id
WHERE Proveedor.tipo=1 AND 
Orden.total = (
	SELECT MAX(Orden.total) 
	FROM transaccion Orden
);

--------------------------------------------------------------------------
----------------------------  CONSULTA 2 ---------------------------------
--------------------------------------------------------------------------
SELECT Cliente.id, Cliente.nombre, 
SUM(Detalle.cantidad*Producto.precio) AS totalGastado,
SUM(Detalle.cantidad) AS totalComprado
FROM transaccion Transaccion
INNER JOIN usuario Cliente ON Transaccion.usuario = Cliente.id
INNER JOIN detalle_transaccion Detalle ON Detalle.transaccion = Transaccion.id
INNER JOIN producto Producto ON Detalle.producto = Producto.id
WHERE Cliente.tipo=2
GROUP BY Cliente.id, Cliente.nombre
ORDER BY totalComprado DESC LIMIT 1;

--------------------------------------------------------------------------
----------------------------  CONSULTA 3 ---------------------------------
--------------------------------------------------------------------------
(SELECT Ubicacion.description AS direccion,
Ciudad.codigoPostal AS codigoPostal,
Ciudad.nombre AS ciudad,
Region.nombre AS region,
COUNT(Venta.id) AS ventas
FROM usuario Proveedor 
INNER JOIN transaccion Venta ON Venta.usuario = Proveedor.id
INNER JOIN ubicacion Ubicacion ON Ubicacion.id = Proveedor.ubicacion
INNER JOIN ciudad Ciudad ON Ciudad.codigoPostal = Ubicacion.ciudad
INNER JOIN region Region ON Region.id = Ciudad.region
WHERE Proveedor.tipo=1
GROUP BY Proveedor.ubicacion
ORDER BY ventas DESC LIMIT 1)
UNION
(SELECT Ubicacion.description AS direccion,
Ciudad.codigoPostal AS codigoPostal,
Ciudad.nombre AS ciudad,
Region.nombre AS region,
COUNT(Venta.id) AS ventas
FROM usuario Proveedor 
INNER JOIN transaccion Venta ON Venta.usuario = Proveedor.id
INNER JOIN ubicacion Ubicacion ON Ubicacion.id = Proveedor.ubicacion
INNER JOIN ciudad Ciudad ON Ciudad.codigoPostal = Ubicacion.ciudad
INNER JOIN region Region ON Region.id = Ciudad.region
WHERE Proveedor.tipo=1
GROUP BY Proveedor.ubicacion
ORDER BY ventas ASC LIMIT 1);

--------------------------------------------------------------------------
----------------------------  CONSULTA 4 ---------------------------------
--------------------------------------------------------------------------
SELECT Cliente.id, Cliente.nombre, COUNT(Orden.id) AS ordenes, SUM(Producto.precio*Detalle.cantidad) AS total
FROM usuario Cliente 
INNER JOIN transaccion Orden ON Orden.usuario = Cliente.id
INNER JOIN detalle_transaccion Detalle ON Detalle.transaccion = Orden.id
INNER JOIN producto Producto ON Detalle.producto = Producto.id
INNER JOIN categoria_producto Categoria ON Producto.categoria=Categoria.id AND Categoria.nombre="Cheese"
WHERE Cliente.tipo=2
GROUP BY Cliente.id
ORDER BY SUM(Detalle.cantidad) DESC, total DESC LIMIT 5;

--------------------------------------------------------------------------
----------------------------  CONSULTA 5 ---------------------------------
--------------------------------------------------------------------------
(SELECT Cliente.nombre, MONTH(Cliente.createdAt) AS mes
FROM usuario Cliente 
INNER JOIN transaccion Orden ON Orden.usuario = Cliente.id
WHERE Cliente.tipo=2 
GROUP BY Cliente.id
ORDER BY SUM(Orden.total) DESC LIMIT 5)
UNION
(SELECT Cliente.nombre, MONTH(Cliente.createdAt)
FROM usuario Cliente 
INNER JOIN transaccion Orden ON Orden.usuario = Cliente.id
WHERE Cliente.tipo=2 
GROUP BY Cliente.id
ORDER BY SUM(Orden.total) ASC LIMIT 5)
;

--------------------------------------------------------------------------
----------------------------  CONSULTA 6 ---------------------------------
--------------------------------------------------------------------------
(SELECT Categoria.nombre, SUM(Producto.precio*Detalle.cantidad) AS total
FROM categoria_producto Categoria 
INNER JOIN producto Producto ON Producto.categoria = Categoria.id
INNER JOIN detalle_transaccion Detalle ON Detalle.producto = Producto.id
INNER JOIN transaccion Orden ON Orden.id = Detalle.transaccion
INNER JOIN usuario Cliente ON Orden.usuario = Cliente.id AND Cliente.tipo=2
GROUP BY Categoria.nombre
ORDER BY total DESC LIMIT 1)
UNION
(SELECT Categoria.nombre, SUM(Producto.precio*Detalle.cantidad) AS total
FROM categoria_producto Categoria 
INNER JOIN producto Producto ON Producto.categoria = Categoria.id
INNER JOIN detalle_transaccion Detalle ON Detalle.producto = Producto.id
INNER JOIN transaccion Orden ON Orden.id = Detalle.transaccion
INNER JOIN usuario Cliente ON Orden.usuario = Cliente.id AND Cliente.tipo=2
GROUP BY Categoria.nombre
ORDER BY total ASC LIMIT 1);

--------------------------------------------------------------------------
----------------------------  CONSULTA 7 ---------------------------------
--------------------------------------------------------------------------
SELECT Proveedor.id, Proveedor.nombre, SUM(Producto.precio*Detalle.cantidad) AS total
FROM usuario Proveedor 
INNER JOIN transaccion Pedido ON Pedido.usuario = Proveedor.id
INNER JOIN detalle_transaccion Detalle ON Detalle.transaccion = Pedido.id
INNER JOIN producto Producto ON Producto.id = Detalle.producto
INNER JOIN categoria_producto Categoria ON Producto.categoria=Categoria.id AND Categoria.nombre="Fresh Vegetables"
WHERE Proveedor.tipo=1
GROUP BY Proveedor.id
ORDER BY total DESC LIMIT 5;

--------------------------------------------------------------------------
----------------------------  CONSULTA 8 ---------------------------------
--------------------------------------------------------------------------
(SELECT Ubicacion.description AS direccion,
Ciudad.codigoPostal AS codigoPostal,
Ciudad.nombre AS ciudad,
Region.nombre AS region,
SUM(Venta.total) total
FROM usuario Cliente 
INNER JOIN transaccion Venta ON Venta.usuario = Cliente.id
INNER JOIN ubicacion Ubicacion ON Ubicacion.id = Cliente.ubicacion
INNER JOIN ciudad Ciudad ON Ciudad.codigoPostal = Ubicacion.ciudad
INNER JOIN region Region ON Region.id = Ciudad.region
WHERE Cliente.tipo=2
GROUP BY Cliente.id
ORDER BY total DESC LIMIT 5)
UNION
(SELECT Ubicacion.description AS direccion,
Ciudad.codigoPostal AS codigoPostal,
Ciudad.nombre AS ciudad,
Region.nombre AS region,
SUM(Venta.total) total
FROM usuario Cliente 
INNER JOIN transaccion Venta ON Venta.usuario = Cliente.id
INNER JOIN ubicacion Ubicacion ON Ubicacion.id = Cliente.ubicacion
INNER JOIN ciudad Ciudad ON Ciudad.codigoPostal = Ubicacion.ciudad
INNER JOIN region Region ON Region.id = Ciudad.region
WHERE Cliente.tipo=2
GROUP BY Cliente.id
ORDER BY total ASC LIMIT 5);

--------------------------------------------------------------------------
----------------------------  CONSULTA 9 ---------------------------------
--------------------------------------------------------------------------
SELECT Proveedor.nombre, Proveedor.telefono, Pedido.id AS orden,
SUM(Producto.precio*Detalle.cantidad) AS total,
SUM(Detalle.cantidad) AS cantidad
FROM usuario Proveedor 
INNER JOIN transaccion Pedido ON Pedido.usuario = Proveedor.id
INNER JOIN detalle_transaccion Detalle ON Detalle.transaccion = Pedido.id
INNER JOIN producto Producto ON Producto.id = Detalle.producto
WHERE Proveedor.tipo=1 
GROUP BY Pedido.id
ORDER BY cantidad ASC, total ASC LIMIT 1;

--------------------------------------------------------------------------
----------------------------  CONSULTA 10 --------------------------------
--------------------------------------------------------------------------
SELECT Cliente.nombre, SUM(Detalle.cantidad) AS cantidad, SUM(Producto.precio*Detalle.cantidad) AS total
FROM usuario Cliente 
INNER JOIN transaccion Orden ON Orden.usuario = Cliente.id
INNER JOIN detalle_transaccion Detalle ON Detalle.transaccion = Orden.id
INNER JOIN producto Producto ON Detalle.producto = Producto.id
INNER JOIN categoria_producto Categoria ON Producto.categoria=Categoria.id AND Categoria.nombre="Seafood"
WHERE Cliente.tipo=2
GROUP BY Cliente.id
ORDER BY cantidad DESC, total DESC LIMIT 10;

--------------------------------------------------------------------------
---------------  ELIMINAR DATOS DE LA TABLA TEMPORAL ---------------------
--------------------------------------------------------------------------
TRUNCATE TABLE temporal;