ALTER TABLE sedes AUTO_INCREMENT = 1;
ALTER TABLE departamentos AUTO_INCREMENT = 1;
ALTER TABLE departamentosxsedes AUTO_INCREMENT = 1;
ALTER TABLE planillas AUTO_INCREMENT = 1;
ALTER TABLE marcas AUTO_INCREMENT = 1;
ALTER TABLE productos AUTO_INCREMENT = 1;
ALTER TABLE productosxpedidos AUTO_INCREMENT = 1;
ALTER TABLE imagenes AUTO_INCREMENT = 1;
ALTER TABLE aspectostecnicos AUTO_INCREMENT = 1;
ALTER TABLE aspectosxproductos AUTO_INCREMENT = 1;
ALTER TABLE inventariosxsedes AUTO_INCREMENT = 1;
ALTER TABLE clientes AUTO_INCREMENT = 1;
ALTER TABLE pedidos AUTO_INCREMENT = 1;
ALTER TABLE productosxpedidos AUTO_INCREMENT = 1;

CALL usp_InsertarSede ('Heredia', GeomFromText('POLYGON((0 0, 0 8, 3 8, 3 0, 0 0))'));
CALL usp_InsertarSede ('Alajuela', GeomFromText('POLYGON((7 4, 7 8, 8 10, 10 4, 7 4))'));

SELECT * FROM sedes;

CALL usp_InsertarEnPlantilla(12345678,'Jorge','Chaves','Badilla','Heredia');
CALL usp_ModificarEnPlantilla(12345678,null,null,null,null,0,3);
CALL usp_ObtenerPlantilla();

SELECT * FROM planillas;

CALL usp_InsertarDepartamento('Plomeria','Heredia','Jorge','Chaves','Badilla');

SELECT * FROM departamentos;
SELECT * FROM departamentosxsedes;

CALL usp_InsertarMarcas ('SupremoL');

SELECT * FROM marcas;

CALL usp_InsertarProducto('Tornillo','descripcion del tornillo','utilidad del tornillo',20.80,25.10,'SupremoL');
CALL usp_InsertarProducto('Martillo','descripcion del martillo','utilidad del martillo',150,150,'SupremoL');

SELECT * FROM productos;

CALL usp_InsertarImagenProducto('path/imagen','Tornillo');
CALL usp_InsertarImagenProducto('path/imagen','Martillo');

SELECT * FROM imagenes;

CALL usp_InsertarAspectosTecnicos('rompe paredes');

SELECT * FROM aspectostecnicos;

CALL usp_InsertarAspectosXProducto('rompe paredes','Tornillo');
CALL usp_InsertarAspectosXProducto('rompe paredes','Martillo');

SELECT * FROM aspectosxproductos;

CALL usp_InsertarInventarioXSedes('Heredia','Plomeria','Tornillo',1000,1,10);
CALL usp_InsertarInventarioXSedes('Heredia','Plomeria','Martillo',1000,1,2);
SELECT * FROM inventariosxsedes;

CALL usp_InsertarClientes(398745612,'Alejandro','Chaves','Campos','alech@gmail.com','88682776');

SELECT * FROM clientes;

CALL usp_InsertarPedido('Alejandro','alech@gmail.com','Jorge','Tornillo',250);
CALL usp_InsertarPedido('Alejandro','alech@gmail.com','Jorge','Tornillo',500);
CALL usp_InsertarPedido('Alejandro','alech@gmail.com','Jorge','Martillo',2);

SELECT * FROM pedidos;
SELECT * FROM productosxpedidos;

CALL usp_ObtenerProductosxSedexDepartamento('Heredia','Plomeria');

select curdate() - interval (day(curdate())-1) day;