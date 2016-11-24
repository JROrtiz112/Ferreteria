SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `ferreteria` DEFAULT CHARACTER SET utf8 ;
USE `ferreteria`;

CREATE TABLE IF NOT EXISTS `ferreteria`.`sedes`(
	`idSede` INT NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(100) NOT NULL,
	`ubicacion` POLYGON NOT NULL,
	PRIMARY KEY(`idSede`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`departamentos`(
	`idDepartamento` INT NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(50) NOT NULL,
	PRIMARY KEY(`idDepartamento`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`planillas`(
	`cedula` INT NOT NULL,
	`nombre` VARCHAR(50) NOT NULL,
	`apellidoP` VARCHAR(50) NOT NULL,
	`apellidoM` VARCHAR(50) NOT NULL,
	`idSede` INT NOT NULL,
	`fechaContratado` DATE NOT NULL,
	`estado` INT NOT NULL, /*0 si esta despedido, 1 si esta trabajando, 2 si esta suspendido, 3 si esta de vacaciones*/
	PRIMARY KEY(`cedula`),
	FOREIGN KEY(`idSede`) REFERENCES `ferreteria`.`sedes`(`idSede`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`vacacionesXempleado`(
	`idVxE` INT NOT NULL AUTO_INCREMENT,
	`cedEmpleado` INT NOT NULL,
	`fechaSalida` DATE NOT NULL,
	`fechaRegreso` DATE NOT NULL,
	PRIMARY KEY(`idVxE`),
	FOREIGN KEY(`cedEmpleado`) REFERENCES `ferreteria`.`planillas`(`cedula`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`amonestaciones`(
	`idAmonestacion` INT NOT NULL AUTO_INCREMENT,
	`tipo` VARCHAR(50) NOT NULL,
	`diasSuspendido` INT NOT NULL,
	PRIMARY KEY(`idAmonestacion`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`amonestacionesXempleados`(
	`idAxE` INT NOT NULL AUTO_INCREMENT,
	`cedEmpleado` INT NOT NULL,
	`idAmonestacion` INT NOT NULL,
	`fechaAmonestacion` DATE NOT NULL,
	PRIMARY KEY(`idAxE`),
	FOREIGN KEY(`cedEmpleado`) REFERENCES `ferreteria`.`planillas`(`cedula`),
	FOREIGN KEY(`idAmonestacion`) REFERENCES `ferreteria`.`amonestaciones`(`idAmonestacion`)
)
ENGINE = InnoDB;

/*TABLA DE LAS FECHAS EN LAS QUE EL EMPLEADO ESTÉ LIBRE (?)*/	

CREATE TABLE IF NOT EXISTS `ferreteria`.`departamentosXsedes`(
	`idDxS` INT NOT NULL AUTO_INCREMENT,
	`idSede` INT NOT NULL,
	`idDepartamento` INT NOT NULL,
	`cedula` INT NOT NULL, /*Experto en el tema del departamento*/
	PRIMARY KEY(`idDxS`),
	FOREIGN KEY(`idSede`) REFERENCES `ferreteria`.`sedes`(`idSede`),
	FOREIGN KEY(`idDepartamento`) REFERENCES `ferreteria`.`departamentos`(`idDepartamento`),
	FOREIGN KEY(`cedula`) REFERENCES `ferreteria`.`planillas`(`cedula`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`marcas`(
	`idMarca` INT NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(50),
	PRIMARY KEY(`idMarca`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`productos`(
	`idProducto` INT NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(50) NOT NULL,
	`descripcion` VARCHAR(100),
	`utilidad` VARCHAR(50),
	`precio` DOUBLE PRECISION NOT NULL,
	`precioVenta` DOUBLE PRECISION NOT NULL,
	`idMarca` INT NOT NULL,
	PRIMARY KEY(`idProducto`),
	FOREIGN KEY(`idMarca`) REFERENCES `ferreteria`.`marcas`(`idMarca`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`imagenes`(
	`idImagen` INT NOT NULL AUTO_INCREMENT,
	`imagen` LONGBLOB NOT NULL,
	`idProducto` INT NOT NULL,
	PRIMARY KEY(`idImagen`),
	FOREIGN KEY(`idProducto`) REFERENCES `ferreteria`.`productos`(`idProducto`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`aspectosTecnicos`(
	`idAspectoT` INT NOT NULL AUTO_INCREMENT,
	`aspecto` VARCHAR(100),
	PRIMARY KEY(`idAspectoT`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`aspectosXproductos`(
	`idAxP` INT NOT NULL AUTO_INCREMENT,
	`idAspectoT` INT NOT NULL,
	`idProducto` INT NOT NULL,
	PRIMARY KEY(`idAxP`),
	FOREIGN KEY(`idAspectoT`) REFERENCES `ferreteria`.`aspectosTecnicos`(`idAspectoT`),
	FOREIGN KEY(`idProducto`) REFERENCES `ferreteria`.`productos`(`idProducto`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`inventariosXsedes`(
	`idIxS` INT NOT NULL AUTO_INCREMENT,
	`idProducto` INT NOT NULL,
	`idSede` INT NOT NULL,
    `idDepartamento` INT NOT NULL,
	`cantidad` INT NOT NULL,
	`pasillo` INT NOT NULL, /*del 1 al 4*/
	`estante` INT NOT NULL, /*del 1 al n*/
	PRIMARY KEY(`idIxS`),
	FOREIGN KEY(`idProducto`) REFERENCES `ferreteria`.`productos`(`idProducto`),
	FOREIGN KEY(`idSede`) REFERENCES `ferreteria`.`sedes`(`idSede`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`clientes`(
	`cedula` INT NOT NULL,
	`nombre` VARCHAR(50) NOT NULL,
	`apellidoP` VARCHAR(50) NOT NULL,
	`apellidoM` VARCHAR(50) NOT NULL,
	`correo` VARCHAR(100) NOT NULL,
	`numero` VARCHAR(9) NOT NULL,
	PRIMARY KEY(`cedula`),
	UNIQUE(`correo`),
	UNIQUE(`numero`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`pedidos`(
	`idPedido` INT NOT NULL AUTO_INCREMENT,
	`fechaPedido` DATE NOT NULL,
	`cedCliente` INT NOT NULL,
	`cedEmpleado` INT NOT NULL,
	`aprobado` BIT NOT NULL,
	PRIMARY KEY(`idPedido`),
	FOREIGN KEY(`cedCliente`) REFERENCES `ferreteria`.`clientes`(`cedula`),
	FOREIGN KEY(`cedEmpleado`) REFERENCES `ferreteria`.`planillas`(`cedula`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`productosXpedidos`(
	`idPxP` INT NOT NULL AUTO_INCREMENT,
	`idPedido` INT NOT NULL,
	`idProducto` INT NOT NULL,
	`cantidadSolicitada` INT NOT NULL, #Enviada
	`cantidadRecibida` INT NOT NULL,
	PRIMARY KEY(`idPxP`),
	FOREIGN KEY(`idPedido`) REFERENCES `ferreteria`.`pedidos`(`idPedido`),
	FOREIGN KEY(`idProducto`) REFERENCES `ferreteria`.`productos`(`idProducto`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`backorders`(
	`idBackorder` INT NOT NULL AUTO_INCREMENT,
	`cedCliente` INT NOT NULL,
	`cedEmpleado` INT NOT NULL,
	`idProducto` INT NOT NULL,
	`cantidad` INT NOT NULL,
	`pendiente` BIT NOT NULL, /*1 si se encuentra pendiente, 0 si se cumplió*/
	PRIMARY KEY(`idBackorder`),
	FOREIGN KEY(`cedCliente`) REFERENCES `ferreteria`.`clientes`(`cedula`),
	FOREIGN KEY(`cedEmpleado`) REFERENCES `ferreteria`.`planillas`(`cedula`),
	FOREIGN KEY(`idProducto`) REFERENCES `ferreteria`.`productos`(`idProducto`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ferreteria`.`envios`(
	`idEnvio` INT NOT NULL AUTO_INCREMENT,
	`idSede` INT NOT NULL,
	`destino` POLYGON NOT NULL,
	`idPedido` INT NOT NULL,
	`kmRecorrido` INT,
	PRIMARY KEY(`idEnvio`),
	FOREIGN KEY(`idSede`) REFERENCES `ferreteria`.`sedes`(`idSede`),
	FOREIGN KEY(`idPedido`) REFERENCES `ferreteria`.`pedidos`(`idPedido`)
)
ENGINE = InnoDB;

/*EN CASO DE QUE EL CHAT DEBA SER GUARDADO EN LA BASE*/
CREATE TABLE IF NOT EXISTS `ferreteria`.`mensajes`(
	`idMensaje` INT NOT NULL AUTO_INCREMENT,
	`cedEmpleado` INT NOT NULL,
	`cedCliente` INT NOT NULL,
	`remitente` BIT NOT NULL, /*Si es 0 corresponde al empleado que envia el mensaje, sino es el cliente.*/
	`mensaje` VARCHAR(300) NOT NULL,
	`fechaEnvio` DATE NOT NULL,
	PRIMARY KEY(`idMensaje`),
	FOREIGN KEY(`cedEmpleado`) REFERENCES `ferreteria`.`planillas`(`cedula`),
	FOREIGN KEY(`cedCliente`) REFERENCES `ferreteria`.`clientes`(`cedula`)
)
ENGINE = InnoDB;
