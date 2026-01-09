-- Asegurarnos de que las tablas se creen dentro del esquema 'dw'
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dw')
BEGIN
    EXEC('CREATE SCHEMA dw')
END
GO

-- DIMENSIÓN: JUGADOR
CREATE TABLE dw.dim_jugador (
    id_jugador_sk INT IDENTITY(1,1) PRIMARY KEY,
    id_jugador_nk INTEGER NOT NULL,
    nombre_usuario NVARCHAR(255) NOT NULL,
    correo NVARCHAR(255),
    fecha_registro DATE,
    pais NVARCHAR(100)
);

-- DIMENSIÓN: PERSONAJE
CREATE TABLE dw.dim_personaje (
    id_personaje_sk INT IDENTITY(1,1) PRIMARY KEY,
    id_personaje_nk INTEGER NOT NULL,
    clase NVARCHAR(100) NOT NULL,
    nivel_inicial INTEGER CHECK (nivel_inicial >= 1),
    raza NVARCHAR(100)
);

-- DIMENSIÓN: TIEMPO
CREATE TABLE dw.dim_tiempo (
    id_tiempo_sk INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL UNIQUE,
    dia INTEGER NOT NULL CHECK (dia BETWEEN 1 AND 31),
    mes INTEGER NOT NULL CHECK (mes BETWEEN 1 AND 12),
    anio INTEGER NOT NULL CHECK (anio >= 2000),
    trimestre INTEGER NOT NULL CHECK (trimestre BETWEEN 1 AND 4)
);

-- DIMENSIÓN: EVENTO
CREATE TABLE dw.dim_evento (
    id_evento_sk INT IDENTITY(1,1) PRIMARY KEY,
    tipo_evento NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX),
    dificultad NVARCHAR(20) CHECK (dificultad IN ('baja', 'media', 'alta'))
);

-- TABLA DE HECHOS: PROGRESO
CREATE TABLE dw.fact_progreso (
    id_progreso INT IDENTITY(1,1) PRIMARY KEY,
    id_jugador_sk INTEGER NOT NULL FOREIGN KEY REFERENCES dw.dim_jugador(id_jugador_sk),
    id_personaje_sk INTEGER NOT NULL FOREIGN KEY REFERENCES dw.dim_personaje(id_personaje_sk),
    id_tiempo_sk INTEGER NOT NULL FOREIGN KEY REFERENCES dw.dim_tiempo(id_tiempo_sk),
    id_evento_sk INTEGER NOT NULL FOREIGN KEY REFERENCES dw.dim_evento(id_evento_sk),
    xp_ganada INTEGER NOT NULL CHECK (xp_ganada >= 0),
    oro_ganado INTEGER NOT NULL CHECK (oro_ganado >= 0),
    nivel_resultante INTEGER CHECK (nivel_resultante >= 1),
    duracion_evento INTEGER CHECK (duracion_evento >= 0)
);
