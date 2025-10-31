USE Analise_Gastos

DROP TABLE IF EXISTS DimSetor;

CREATE TABLE DimSetor (

    ID_Setor            INT IDENTITY(1,1) PRIMARY KEY,
    CodCNAE             VARCHAR(7) NOT NULL UNIQUE,     
    Cod_Divisao         VARCHAR(2)                      
);

GO

CREATE TABLE DimFornecedor (

    ID_Fornecedor   INT IDENTITY(1,1)               PRIMARY KEY,
    ID_Setor_FK     INT                 NOT NULL,
    CNPJ_CPF        VARCHAR(14)         NOT NULL    UNIQUE,
    Nome            VARCHAR(255)        NOT NULL,
    UF              CHAR(2),
    TipoPessoa      CHAR(1)             NOT NULL,
    DataCadastro    DATE,

        CONSTRAINT FK_DimFornecedor_DimSetor FOREIGN KEY (ID_Setor_FK)
            REFERENCES DimSetor (ID_Setor)

);

CREATE TABLE DimDeputado (

    ID_Deputado             INT IDENTITY(1,1)           PRIMARY KEY,
    ideCadastro_Negocio     VARCHAR(50)     NOT NULL    UNIQUE,
    Nome                    VARCHAR(255)    NOT NULL,
    UF                      CHAR(2)         NOT NULL,
    NomeCivil               VARCHAR(255),
    URLFoto                 VARCHAR(MAX)

);

CREATE TABLE DimPartido (

    ID_Partido      INT IDENTITY(1,1)           PRIMARY KEY,
    Sigla           VARCHAR(10)     NOT NULL    UNIQUE,
    Nome            VARCHAR(100)    NOT NULL,
    DataCriacao     DATE

);

CREATE TABLE DimLegislatura (

    ID_Legislatura      INT IDENTITY(1,1) PRIMARY KEY,
    AnoInicio           INT     NOT NULL,
    AnoFim              INT     NOT NULL,
    Descricao           VARCHAR(100)
);

CREATE TABLE DimTempo (

    ID_Tempo        INT                         PRIMARY KEY,
    DataCompleta    DATE            NOT NULL    UNIQUE,
    Dia             INT             NOT NULL,
    Mes             INT             NOT NULL,
    NomeMes         VARCHAR(20)     NOT NULL,
    Ano             INT             NOT NULL,
    Trimestre       INT             NOT NULL,
    Semestre        INT             NOT NULL,
    AnoEleitoral    BIT             NOT NULL    DEFAULT 0,
    FimDeSemana     BIT             NOT NULL    DEFAULT 0

);

CREATE TABLE DimCategoriaDespesa (

    ID_Categoria        INT IDENTITY(1,1)               PRIMARY KEY,
    NomeCategoria       VARCHAR(100)        NOT NULL    UNIQUE,
    DescricaoDetalhada  VARCHAR(255)

);

CREATE TABLE DimVotacao (
    ID_Votacao          INT IDENTITY(1,1)           PRIMARY KEY,
    DescricaoVotacao    VARCHAR(255)    NOT NULL    UNIQUE,
    Tema                VARCHAR(255)
);