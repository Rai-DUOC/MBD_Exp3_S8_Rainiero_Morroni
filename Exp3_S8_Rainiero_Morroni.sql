-- === Construcción de Modelo Relacional ===

-- Caso 1: IMPLEMENTACION DEL MODELO MR NORMALIZADO

-- ===========================================
-- BORRADO DE OBJETOS
DROP TABLE ADMINISTRATIVO CASCADE CONSTRAINTS;
DROP TABLE VENDEDOR CASCADE CONSTRAINTS;
DROP TABLE DETALLE_VENTA CASCADE CONSTRAINTS;
DROP TABLE VENTA CASCADE CONSTRAINTS;
DROP TABLE EMPLEADO CASCADE CONSTRAINTS;
DROP TABLE PRODUCTO CASCADE CONSTRAINTS;
DROP TABLE PROVEEDOR CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE CATEGORIA CASCADE CONSTRAINTS;
DROP TABLE MARCA CASCADE CONSTRAINTS;
DROP TABLE MEDIO_PAGO CASCADE CONSTRAINTS;
DROP TABLE SALUD CASCADE CONSTRAINTS;
DROP TABLE AFP CASCADE CONSTRAINTS;
DROP SEQUENCE SEQ_SALUD;
DROP SEQUENCE SEQ_EMPLEADO;
-- ===========================================

-- ========================================================
-- 1) Creación de tablas a partir del modelo por jerarquía.
-- ========================================================

CREATE TABLE AFP (
    id_afp              NUMBER(5) GENERATED AS IDENTITY --PK
        (START WITH 210 INCREMENT BY 6) NOT NULL,   
    nom_afp             VARCHAR2(255)   NOT NULL
);
ALTER TABLE AFP
    ADD CONSTRAINT AFP_PK PRIMARY KEY (id_afp);
    
CREATE TABLE SALUD (
    id_salud            NUMBER(4)       NOT NULL,   --PK
    nom_salud           VARCHAR2(40)    NOT NULL
);
ALTER TABLE SALUD
    ADD CONSTRAINT SALUD_PK PRIMARY KEY (id_salud);

CREATE TABLE MEDIO_PAGO (
    id_mpago            NUMBER(3)       NOT NULL,   --PK
    nombre_mpago        VARCHAR2(50)    NOT NULL
);
ALTER TABLE MEDIO_PAGO
    ADD CONSTRAINT MEDIO_PAGO_PK PRIMARY KEY (id_mpago);

CREATE TABLE MARCA (
    id_marca            NUMBER(3)       NOT NULL,   --PK
    nombre_marca        VARCHAR2(25)    NOT NULL
);
ALTER TABLE MARCA
    ADD CONSTRAINT MARCA_PK PRIMARY KEY (id_marca);

CREATE TABLE CATEGORIA (
    id_categoria        NUMBER(3)       NOT NULL,   --PK
    nombre_categoria    VARCHAR2(255)   NOT NULL
);
ALTER TABLE CATEGORIA
    ADD CONSTRAINT CATEGORIA_PK PRIMARY KEY (id_categoria);
    
CREATE TABLE REGION (
    id_region           NUMBER(4)       NOT NULL,   --PK
    nom_region          VARCHAR2(255)   NOT NULL
);
ALTER TABLE REGION
    ADD CONSTRAINT REGION_PK PRIMARY KEY (id_region);
    
CREATE TABLE COMUNA (
    id_comuna           NUMBER(4)       NOT NULL,   --PK
    nom_comuna          VARCHAR2(100)   NOT NULL,
    cod_region          NUMBER(4)       NOT NULL    --FK
);
ALTER TABLE COMUNA
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna);
    
CREATE TABLE PROVEEDOR (
    id_proveedor        NUMBER(5)       NOT NULL,   --PK
    nombre_proveedor    VARCHAR2(150)   NOT NULL,
    rut_proveedor       VARCHAR2(10)    NOT NULL,
    telefono            VARCHAR2(10)    NOT NULL,
    email               VARCHAR2(200)   NOT NULL,
    direccion           VARCHAR2(200)   NOT NULL,
    cod_comuna          NUMBER(4)       NOT NULL    --FK
);
ALTER TABLE PROVEEDOR
    ADD CONSTRAINT PROVEEDOR_PK PRIMARY KEY (id_proveedor);

CREATE TABLE PRODUCTO (
    id_producto         NUMBER(4)       NOT NULL,   --PK
    nombre_producto     VARCHAR2(100)   NOT NULL,
    precio_unitario     NUMBER          NOT NULL,
    origen_nacional     CHAR(1)         NOT NULL,
    stock_minimo        NUMBER(3)       NOT NULL,
    activo              CHAR(1)         NOT NULL,
    cod_marca           NUMBER(3)       NOT NULL,   --FK
    cod_categoria       NUMBER(3)       NOT NULL,   --FK
    cod_proveedor       NUMBER(5)       NOT NULL    --FK
);
ALTER TABLE PRODUCTO
    ADD CONSTRAINT PRODUCTO_PK PRIMARY KEY (id_producto);
    
CREATE TABLE EMPLEADO (
    id_empleado         NUMBER(4)       NOT NULL,   --PK
    rut_empleado        VARCHAR2(10)    NOT NULL,
    nombre_empleado     VARCHAR2(25)    NOT NULL,
    apellido_paterno    VARCHAR2(25)    NOT NULL,
    apellido_materno    VARCHAR2(25)    NOT NULL,
    fecha_contratacion  DATE            NOT NULL,
    sueldo_base         NUMBER(10)      NOT NULL,
    bono_jefatura       NUMBER(10),
    activo              CHAR(1)         NOT NULL,
    tipo_empleado       VARCHAR2(25)    NOT NULL,
    cod_empleado        NUMBER(4),                  --FK
    cod_salud           NUMBER(4)       NOT NULL,   --FK
    cod_afp             NUMBER(5)       NOT NULL    --FK
);
ALTER TABLE EMPLEADO
    ADD CONSTRAINT EMPLEADO_PK PRIMARY KEY (id_empleado);
    
CREATE TABLE VENTA (
    id_venta            NUMBER(4) GENERATED AS IDENTITY --PK
        (START WITH 5050 INCREMENT BY 3)    NOT NULL,   
    fecha_venta         DATE            NOT NULL,
    total_venta         NUMBER(10)      NOT NULL,
    cod_mpago           NUMBER(3)       NOT NULL,   --FK
    cod_empleado        NUMBER(4)       NOT NULL    --FK
);
ALTER TABLE VENTA
    ADD CONSTRAINT VENTA_PK PRIMARY KEY (id_venta);

CREATE TABLE DETALLE_VENTA (
    cod_venta           NUMBER(4)       NOT NULL,   --PF
    cod_producto        NUMBER(4)       NOT NULL,   --PF
    cantidad            NUMBER(6)       NOT NULL
);
ALTER TABLE DETALLE_VENTA
    ADD CONSTRAINT DETALLE_VENTA_PK PRIMARY KEY (cod_venta, cod_producto);
    
CREATE TABLE VENDEDOR (
    id_empleado         NUMBER(4)       NOT NULL,   --PF
    comision_venta      NUMBER(5,2)     NOT NULL
);
ALTER TABLE VENDEDOR
    ADD CONSTRAINT VENDEDOR_PK PRIMARY KEY (id_empleado);
    
CREATE TABLE ADMINISTRATIVO (
    id_empleado         NUMBER(4)       NOT NULL    --PF
);
ALTER TABLE ADMINISTRATIVO
    ADD CONSTRAINT ADMINISTRATIVO_PK PRIMARY KEY (id_empleado);
    
-- ==============
-- 2) Relaciones.
-- ==============

ALTER TABLE COMUNA
    ADD CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (cod_region)
        REFERENCES REGION (id_region);
        
ALTER TABLE PROVEEDOR
    ADD CONSTRAINT PROVEEDOR_FK_COMUNA FOREIGN KEY (cod_comuna)
        REFERENCES COMUNA (id_comuna);
        
ALTER TABLE PRODUCTO ADD (
    CONSTRAINT PRODUCTO_FK_MARCA FOREIGN KEY (cod_marca)
        REFERENCES MARCA (id_marca),
    CONSTRAINT PRODUCTO_FK_CATEGORIA FOREIGN KEY (cod_categoria)
        REFERENCES CATEGORIA (id_categoria),
    CONSTRAINT PRODUCTO_FK_PROVEEDOR FOREIGN KEY (cod_proveedor)
        REFERENCES PROVEEDOR (id_proveedor)        
);

ALTER TABLE VENTA ADD (
    CONSTRAINT VENTA_FK_EMPLEADO FOREIGN KEY (cod_empleado)
        REFERENCES EMPLEADO (id_empleado),
    CONSTRAINT VENTA_FK_MEDIO_PAGO FOREIGN KEY (cod_mpago)
        REFERENCES MEDIO_PAGO (id_mpago)
);

ALTER TABLE DETALLE_VENTA ADD (
    CONSTRAINT DET_VENTA_FK_VENTA FOREIGN KEY (cod_venta)
        REFERENCES VENTA (id_venta),
    CONSTRAINT DET_VENTA_FK_PRODUCTO FOREIGN KEY (cod_producto)
        REFERENCES PRODUCTO (id_producto)
);

ALTER TABLE EMPLEADO ADD (
    CONSTRAINT EMPLEADO_FK_SALUD FOREIGN KEY (cod_salud)
        REFERENCES SALUD (id_salud),
    CONSTRAINT EMPLEADO_FK_AFP FOREIGN KEY (cod_afp)
        REFERENCES AFP (id_afp),
    CONSTRAINT EMPLEADO_FK_EMPLEADO FOREIGN KEY (cod_empleado)
        REFERENCES EMPLEADO (id_empleado)
);
    
ALTER TABLE VENDEDOR
    ADD CONSTRAINT VENDEDOR_FK_EMPLEADO FOREIGN KEY (id_empleado)
        REFERENCES EMPLEADO (id_empleado);
        
ALTER TABLE ADMINISTRATIVO
    ADD CONSTRAINT ADMIN_FK_EMPLEADO FOREIGN KEY (id_empleado)
        REFERENCES EMPLEADO (id_empleado);
    

-- ================================
-- Caso 2: MODIFICACION DEL MODELO
-- ================================

-- Sueldo minimo no debe ser inferior a $400.000:
ALTER TABLE EMPLEADO
    ADD CONSTRAINT EMPLEADO_SUELDO_CK CHECK (sueldo_base >= 400000);

-- Comision por venta debe ser entre 0 y 0.25 (Máx. 25%):
ALTER TABLE VENDEDOR
    ADD CONSTRAINT MAX_COMISION_CK CHECK (comision_venta BETWEEN 0 AND 0.25);

-- Stock minimo por producto de 3 unidades:
ALTER TABLE PRODUCTO
    ADD CONSTRAINT MIN_STOCK_CK CHECK (stock_minimo >= 3);

-- Correo electronico debe ser único por proveedor:
ALTER TABLE PROVEEDOR
    ADD CONSTRAINT PROVEEDOR_EMAIL_UN UNIQUE (email);

-- Nombre de MARCA debe ser único:
ALTER TABLE MARCA
    ADD CONSTRAINT MARCA_NOMBRE_UN UNIQUE (nombre_marca);

-- El numero de productos vendidos debe ser igual o mayor a 1:
ALTER TABLE DETALLE_VENTA
    ADD CONSTRAINT DET_VENTA_CANT_CK CHECK (cantidad >= 1);

-- ===============================
-- Caso 3: Poblamiento del modelo
-- ===============================

-- SALUD: id_salud comienza en 2050 y se incremente en 10.
CREATE SEQUENCE SEQ_SALUD START WITH 2050 INCREMENT BY 10;

-- EMPLEADO: id_empleado comienza en 750 y se incremente en 3.
CREATE SEQUENCE SEQ_EMPLEADO START WITH 750 INCREMENT BY 3;

-- Poblamiento en orden de integridad y dependencias:

-- 1) Tabla AFP con IDENTITY
INSERT INTO AFP (nom_afp) VALUES ('AFP Habitat');
INSERT INTO AFP (nom_afp) VALUES ('AFP Cuprum');
INSERT INTO AFP (nom_afp) VALUES ('AFP Provida');
INSERT INTO AFP (nom_afp) VALUES ('AFP PlanVital');

-- 2) Tabla SALUD con SEQUENCE
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Fonasa');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Isapre Colmena');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Isapre Banmédica');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Isapre Cruz Blanca');

-- 3) Tabla MEDIO_PAGO
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (11, 'Efectivo');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (12, 'Tarjeta Débito');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (13, 'Tarjeta Crédito');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (14, 'Cheque');

-- 4) Table EMPLEADO con SEQUENCE
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '11111111-1', 'Marcela', 'González', 'Pérez', '15-03-2022', 950000, 80000, 'S', 'Administrativo', NULL, 2050, 210);
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '22222222-2', 'José', 'Muñoz', 'Ramirez', '10-07-2021', 900000, 75000, 'S', 'Administrativo', NULL, 2060, 216);
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '33333333-3', 'Veronica', 'Soto', 'Alarcón', '05-01-2020', 880000, 70000, 'S', 'Vendedor', 750, 2060, 228);
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '44444444-4', 'Luis', 'Reyes', 'Fuentes', '01-04-2023', 560000, NULL, 'S', 'Vendedor', 750, 2070, 228);
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '55555555-5', 'Claudia', 'Fernández', 'Lagos', '15-04-2023', 600000, NULL, 'S', 'Vendedor', 753, 2070, 216);
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '66666666-6', 'Carlos', 'Navarro', 'Vega', '01-05-2023', 610000, NULL, 'S', 'Administrativo', 753, 2060, 210);
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '77777777-7', 'Javiera', 'Pino', 'Rojas', '10-05-2023', 650000, NULL, 'S', 'Administrativo', 750, 2050, 210);
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '88888888-8', 'Diego', 'Mella', 'Contreras', '12-05-2023', 620000, NULL, 'S', 'Vendedor', 750, 2060, 216);
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '99999999-9', 'Fernanda', 'Salas', 'Herrera', '18-05-2023', 570000, NULL, 'S', 'Vendedor', 753, 2070, 228);
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '10101010-0', 'Tomás', 'Vidal', 'Espinoza', '01-06-2023', 530000, NULL, 'S', 'Vendedor', NULL, 2050, 222);

-- 5) Tabla VENTA con IDENTITY
INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado) VALUES ('12-05-2023', 225990, 12, 771);
INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado) VALUES ('23-10-2023', 524990, 13, 777);
INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado) VALUES ('17-02-2023', 466990, 11, 759);

-- ===============================
-- Caso 4: Recuperación de datos
-- ===============================

-- INFORME 1 - Sueldo total estimado empleados ACTIVOS y CON bono jefatura.
-- Incluir nombre completo, sueldo base, bono jefatura, total estimado.
-- Ordenado por Salario Simulado descendente y en cas de empate por apellido_paterno descendente.
SELECT
    id_empleado AS "IDENTIFICADOR",
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "NOMBRE COMPLETO",
    sueldo_base AS "SALARIO", bono_jefatura AS "BONIFICACION", sueldo_base + bono_jefatura AS "SALARIO SIMULADO"
        FROM EMPLEADO
        WHERE activo = 'S' AND bono_jefatura IS NOT NULL
        ORDER BY "SALARIO SIMULADO" DESC, apellido_paterno DESC;
        
-- INFORME 2 - Listado de empleados con sueldo base entre $550.000 y $800.000
-- Incluir nombre completo, sueldo base, valor de aumento 8% y sueldo con aumento.
-- Ordenado sueldo_base ascendente.
SELECT
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "EMPLEADO",
    sueldo_base AS "SUELDO", sueldo_base * 0.08 AS "POSIBLE AUMENTO",
    sueldo_base * 1.08 AS "SUELDO SIMULADO"
        FROM EMPLEADO
        WHERE sueldo_base BETWEEN 550000 AND 800000
        ORDER BY "SUELDO" ASC;

/* Consultas para validar las tablas pobladas.
SELECT * FROM AFP;
SELECT * FROM SALUD;
SELECT * FROM EMPLEADO;
SELECT * FROM VENTA;
*/
