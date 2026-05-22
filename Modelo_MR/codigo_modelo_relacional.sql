-- ==========================================
-- 1. ENTIDADES PRINCIPALES (INDEPENDIENTES)
-- ==========================================

CREATE TABLE empleado (
    num_empleado NUMBER NOT NULL,
    rfc          VARCHAR2(13) NOT NULL,
    nombre       VARCHAR2(100) NOT NULL,
    domicilio    VARCHAR2(255),
    fecha_nac    DATE,
    sueldo       NUMBER(10, 2),
    foto         BLOB,
    CONSTRAINT empleado_pk PRIMARY KEY ( num_empleado )
);

CREATE TABLE clientes (
    id_cliente   NUMBER NOT NULL,
    rfc          VARCHAR2(13),
    razon_social VARCHAR2(150),
    nombre       VARCHAR2(100) NOT NULL,
    fecha_nac    DATE,
    email        VARCHAR2(100),
    domicilio    VARCHAR2(255),
    CONSTRAINT clientes_pk PRIMARY KEY ( id_cliente )
);

CREATE TABLE categoria (
    id_categoria NUMBER NOT NULL,
    nombre       VARCHAR2(50) NOT NULL,
    descripcion  VARCHAR2(255),
    CONSTRAINT categoria_pk PRIMARY KEY ( id_categoria )
);

-- ==========================================
-- 2. ENTIDADES DEPENDIENTES Y MULTIVALUADAS
-- ==========================================

-- Tabla para el atributo multivaluado 'telefonos'
CREATE TABLE empleado_telefono (
    num_empleado NUMBER NOT NULL,
    telefono     VARCHAR2(20) NOT NULL,
    CONSTRAINT empleado_telefono_pk PRIMARY KEY ( num_empleado, telefono ),
    CONSTRAINT emp_tel_emp_fk FOREIGN KEY ( num_empleado )
        REFERENCES empleado ( num_empleado )
);

-- Entidad débil 'DEPENDIENTE'
CREATE TABLE dependiente (
    num_empleado NUMBER NOT NULL,
    curp         VARCHAR2(18) NOT NULL,
    nombre       VARCHAR2(100) NOT NULL,
    parentesco   VARCHAR2(50),
    CONSTRAINT dependiente_pk PRIMARY KEY ( num_empleado, curp ),
    CONSTRAINT dep_emp_fk FOREIGN KEY ( num_empleado )
        REFERENCES empleado ( num_empleado )
);

-- ==========================================
-- 3. JERARQUÍA DE EMPLEADOS
-- ==========================================

CREATE TABLE mesero (
    num_empleado NUMBER NOT NULL,
    horario      VARCHAR2(100),
    CONSTRAINT mesero_pk PRIMARY KEY ( num_empleado ),
    CONSTRAINT mesero_emp_fk FOREIGN KEY ( num_empleado )
        REFERENCES empleado ( num_empleado )
);

CREATE TABLE cocinero (
    num_empleado NUMBER NOT NULL,
    especialidad VARCHAR2(100),
    CONSTRAINT cocinero_pk PRIMARY KEY ( num_empleado ),
    CONSTRAINT cocinero_emp_fk FOREIGN KEY ( num_empleado )
        REFERENCES empleado ( num_empleado )
);

CREATE TABLE administrativos (
    num_empleado NUMBER NOT NULL,
    rol          VARCHAR2(50),
    CONSTRAINT admin_pk PRIMARY KEY ( num_empleado ),
    CONSTRAINT admin_emp_fk FOREIGN KEY ( num_empleado )
        REFERENCES empleado ( num_empleado )
);

-- ==========================================
-- 4. JERARQUÍA Y ENTIDADES DE CONSUMIBLES
-- ==========================================

CREATE TABLE consumible (
    id_consumible  NUMBER NOT NULL,
    id_categoria   NUMBER NOT NULL, -- FK de la relación 'Pertenece'
    nombre         VARCHAR2(100) NOT NULL,
    descripcion    VARCHAR2(255),
    receta         VARCHAR2(1000),
    precio         NUMBER(10, 2) NOT NULL,
    disponibilidad NUMBER(1), -- Puede ser 1/0 para Booleano en Oracle
    CONSTRAINT consumible_pk PRIMARY KEY ( id_consumible ),
    CONSTRAINT cons_cat_fk FOREIGN KEY ( id_categoria )
        REFERENCES categoria ( id_categoria )
);

CREATE TABLE platillo (
    id_consumible NUMBER NOT NULL,
    CONSTRAINT platillo_pk PRIMARY KEY ( id_consumible ),
    CONSTRAINT platillo_cons_fk FOREIGN KEY ( id_consumible )
        REFERENCES consumible ( id_consumible )
);

CREATE TABLE bebida (
    id_consumible NUMBER NOT NULL,
    CONSTRAINT bebida_pk PRIMARY KEY ( id_consumible ),
    CONSTRAINT bebida_cons_fk FOREIGN KEY ( id_consumible )
        REFERENCES consumible ( id_consumible )
);

-- ==========================================
-- 5. TRANSACCIONES (ORDEN Y DETALLE)
-- ==========================================

CREATE TABLE orden (
    folio               NUMBER NOT NULL,
    id_cliente          NUMBER NOT NULL, -- FK de la relación 'Solicita'
    num_empleado_mesero NUMBER NOT NULL, -- FK de la relación 'Levanta'
    fecha_hora          TIMESTAMP NOT NULL,
    total               NUMBER(10, 2),
    CONSTRAINT orden_pk PRIMARY KEY ( folio ),
    CONSTRAINT orden_cliente_fk FOREIGN KEY ( id_cliente )
        REFERENCES clientes ( id_cliente ),
    CONSTRAINT orden_mesero_fk FOREIGN KEY ( num_empleado_mesero )
        REFERENCES mesero ( num_empleado )
);

-- Tabla intermedia para la relación N:M 'Contiene'
CREATE TABLE orden_consumible (
    folio         NUMBER NOT NULL,
    id_consumible NUMBER NOT NULL,
    cant_elem     NUMBER NOT NULL,
    precio_elem   NUMBER(10, 2) NOT NULL,
    CONSTRAINT orden_consumible_pk PRIMARY KEY ( folio, id_consumible ),
    CONSTRAINT oc_orden_fk FOREIGN KEY ( folio )
        REFERENCES orden ( folio ),
    CONSTRAINT oc_consumible_fk FOREIGN KEY ( id_consumible )
        REFERENCES consumible ( id_consumible )
);