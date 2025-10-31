CREATE DATABASE Analise_Gastos

USE Analise_Gastos

DROP TABLE IF EXISTS stg_CotaParlamentar;

CREATE TABLE stg_CotaParlamentar (

    stg_id                      BIGINT IDENTITY(1,1) PRIMARY KEY,
    codLegislatura              VARCHAR(50),
    datEmissao                  VARCHAR(50),
    ideDocumento                VARCHAR(50),
    ideCadastro                 VARCHAR(50),
    indTipoDocumento            VARCHAR(50),
    nuCarteiraParlamentar       VARCHAR(50),
    nuDeputadoId                VARCHAR(50),
    nuLegislatura               VARCHAR(50),
    numAno                      VARCHAR(50),
    numEspecificacaoSubcota     VARCHAR(50),
    numLote                     VARCHAR(50),
    numMes                      VARCHAR(50),
    numParcela                  VARCHAR(50),
    numRessarcimento            VARCHAR(50),
    numSubCota                  VARCHAR(50),
    sgPartido                   VARCHAR(50), 
    sgUF                        VARCHAR(50), 
    txNomeParlamentar           VARCHAR(255),
    txtCNPJCPF                  VARCHAR(20),
    txtDescricao                VARCHAR(MAX),             
    txtDescricaoEspecificacao   VARCHAR(MAX),             
    txtFornecedor               VARCHAR(255),
    txtNumero                   VARCHAR(255), 
    txtPassageiro               VARCHAR(255),
    txtTrecho                   VARCHAR(MAX),
    vlrDocumento                VARCHAR(100), 
    vlrGlosa                    VARCHAR(100),
    vlrLiquido                  VARCHAR(100),
    vlrRestituicao              VARCHAR(100)

);
GO

DROP TABLE IF EXISTS stg_CNPJ_Empresas;

CREATE TABLE stg_CNPJ_Empresas (

    CNPJ_BASICO                 VARCHAR(10) NOT NULL, 
    RAZAO_SOCIAL_NOME_EMPRESARIAL VARCHAR(255),
    NATUREZA_JURIDICA           VARCHAR(50),
    QUALIFICACAO_DO_RESPONSAVEL VARCHAR(50),
    CAPITAL_SOCIAL_DA_EMPRESA   VARCHAR(50), 
    PORTE_DA_EMPRESA            VARCHAR(2),  
    ENTE_FEDERATIVO_RESPONSAVEL VARCHAR(255),
    stg_id                      BIGINT IDENTITY(1,1)

);

GO

DROP TABLE IF EXISTS stg_CNPJ_Estabelecimentos;

CREATE TABLE stg_CNPJ_Estabelecimentos (
    CNPJ_BASICO                 VARCHAR(8),
    CNPJ_ORDEM                  VARCHAR(4),
    CNPJ_DV                     VARCHAR(2),
    IDENTIFICADOR_MATRIZ_FILIAL CHAR(1),  
    NOME_FANTASIA               VARCHAR(255),
    SITUACAO_CADASTRAL          VARCHAR(2), 
    DATA_SITUACAO_CADASTRAL     VARCHAR(50), 
    MOTIVO_SITUACAO_CADASTRAL   VARCHAR(50),
    NOME_CIDADE_EXTERIOR        VARCHAR(255),
    PAIS                        VARCHAR(50), 
    DATA_DE_INICIO_ATIVIDADE    VARCHAR(50), 
    CNAE_FISCAL_PRINCIPAL       VARCHAR(7),  
    CNAE_FISCAL_SECUNDARIA      VARCHAR(MAX),  
    TIPO_DE_LOGRADOURO          VARCHAR(255), 
    LOGRADOURO                  VARCHAR(255),
    NUMERO                      VARCHAR(50), 
    COMPLEMENTO                 VARCHAR(255),
    BAIRRO                      VARCHAR(255),
    CEP                         VARCHAR(50),
    UF                          CHAR(2),     
    MUNICIPIO                   VARCHAR(50), 
    DDD_1                       VARCHAR(10),
    TELEFONE_1                  VARCHAR(50),
    DDD_2                       VARCHAR(10),
    TELEFONE_2                  VARCHAR(50),
    DDD_DO_FAX                  VARCHAR(10),
    FAX                         VARCHAR(50),
    CORREIO_ELETRONICO          VARCHAR(255),
    SITUACAO_ESPECIAL           VARCHAR(255),
    DATA_DA_SITUACAO_ESPECIAL   VARCHAR(50),
    stg_id                      BIGINT IDENTITY(1,1) PRIMARY KEY
);
GO


DROP TABLE IF EXISTS stg_Deputados;

CREATE TABLE stg_Deputados (

    stg_id                      BIGINT IDENTITY(1,1) PRIMARY KEY,
    txNomeParlamentar           VARCHAR(MAX),
    cpf                         VARCHAR(MAX),
    ideCadastro                 VARCHAR(MAX),
    nuCarteiraParlamentar       VARCHAR(MAX),
    nuLegislatura               VARCHAR(MAX),
    sgUF                        VARCHAR(MAX),
    sgPartido                   VARCHAR(MAX),
    codLegislatura              VARCHAR(MAX),
    numSubCota                  VARCHAR(MAX),
    txtDescricao                VARCHAR(MAX),
    numEspecificacaoSubCota     VARCHAR(MAX),
    txtDescricaoEspecificacao   VARCHAR(MAX),
    txtFornecedor               VARCHAR(MAX),
    txtCNPJCPF                  VARCHAR(MAX),
    txtNumero                   VARCHAR(MAX),
    indTipoDocumento            VARCHAR(MAX),
    datEmissao                  VARCHAR(MAX),
    vlrDocumento                VARCHAR(MAX),
    vlrGlosa                    VARCHAR(MAX),
    vlrLiquido                  VARCHAR(MAX),
    numMes                      VARCHAR(MAX),
    numAno                      VARCHAR(MAX),
    numParcela                  VARCHAR(MAX),
    txtPassageiro               VARCHAR(MAX),
    txtTrecho                   VARCHAR(MAX),
    numLote                     VARCHAR(MAX),
    numRessarcimento            VARCHAR(MAX),
    datPagamentoRestituicao     VARCHAR(MAX),
    vlrRestituicao              VARCHAR(MAX),
    nuDeputadoId                VARCHAR(MAX),
    ideDocumento                VARCHAR(MAX),
    urlDocumento                VARCHAR(MAX)

);

GO


CREATE TABLE DimSetor (

    ID_Setor        INT IDENTITY(1,1)           PRIMARY KEY,
    CodCNAE         VARCHAR(7)      NOT NULL    UNIQUE,
    DescricaoCNAE   VARCHAR(255)    NOT NULL,
    SubSetor        VARCHAR(255),
    SetorPrincipal  VARCHAR(100)

);

CREATE TABLE DimFornecedor (

    ID_Fornecedor   INT IDENTITY(1,1)               PRIMARY KEY,
    ID_Setor_FK     INT                 NOT NULL,
    CNPJ_CPF        VARCHAR(14)         NOT NULL    UNIQUE,
    Nome            VARCHAR(255)        NOT NULL,
    UF              CHAR(2),
    TipoPessoa      CHAR(1)             NOT NULL,
    DataCadastro    DATE,

       -- CONSTRAINT FK_DimFornecedor_DimSetor FOREIGN KEY (ID_Setor_FK)
           -- REFERENCES DimSetor (ID_Setor)

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

CREATE TABLE BridgeDeputadoLegislaturaPartido (

    ID_Registro             INT IDENTITY(1,1) PRIMARY KEY,
    ID_Deputado_FK          INT     NOT NULL,
    ID_Partido_FK           INT     NOT NULL,
    ID_Legislatura_FK       INT     NOT NULL,
    DataInicio              DATE    NOT NULL,
    DataFim                 DATE,

      -- CONSTRAINT FK_Bridge_Deputado FOREIGN KEY (ID_Deputado_FK)
         --   REFERENCES DimDeputado (ID_Deputado),
        --CONSTRAINT FK_Bridge_Partido FOREIGN KEY (ID_Partido_FK)
       --     REFERENCES DimPartido (ID_Partido),
      --  CONSTRAINT FK_Bridge_Legislatura FOREIGN KEY (ID_Legislatura_FK)
      --      REFERENCES DimLegislatura (ID_Legislatura)

);

CREATE TABLE FatoGastoParlamentar (

    ID_Gasto            BIGINT IDENTITY(1,1) PRIMARY KEY,
    ID_Deputado_FK      INT             NOT NULL,
    ID_Fornecedor_FK    INT             NOT NULL,
    ID_Categoria_FK     INT             NOT NULL,
    ID_Tempo_FK         INT             NOT NULL,
    Valor               DECIMAL(18,2)   NOT NULL, 
    ID_Fonte_Origem     INT             NOT NULL, 
    NumDocumento        VARCHAR(50),
       -- CONSTRAINT FK_FatoGasto_Deputado FOREIGN KEY (ID_Deputado_FK)
       --     REFERENCES DimDeputado (ID_Deputado),
       -- CONSTRAINT FK_FatoGasto_Fornecedor FOREIGN KEY (ID_Fornecedor_FK)
       --     REFERENCES DimFornecedor (ID_Fornecedor),
      --  CONSTRAINT FK_FatoGasto_Categoria FOREIGN KEY (ID_Categoria_FK)
      --      REFERENCES DimCategoriaDespesa (ID_Categoria),
      --  CONSTRAINT FK_FatoGasto_Tempo FOREIGN KEY (ID_Tempo_FK)
      --      REFERENCES DimTempo (ID_Tempo)

);

CREATE NONCLUSTERED INDEX IX_FatoGasto_Lookup 
            ON FatoGastoParlamentar (ID_Tempo_FK, ID_Deputado_FK, ID_Fornecedor_FK)

CREATE TABLE FatoVotacaoPresenca (

    ID_Registro     BIGINT IDENTITY(1,1) PRIMARY KEY,
    ID_Deputado_FK  INT             NOT NULL,
    ID_Tempo_FK     INT             NOT NULL,
    ID_Votacao_FK   INT             NOT NULL,
    Presenca        VARCHAR(10)     NOT NULL,
    Voto            VARCHAR(50),

     --   CONSTRAINT FK_FatoVotacao_Deputado FOREIGN KEY (ID_Deputado_FK)
      --      REFERENCES DimDeputado (ID_Deputado),
      --  CONSTRAINT FK_FatoVotacao_Tempo FOREIGN KEY (ID_Tempo_FK)
      --      REFERENCES DimTempo (ID_Tempo),
      --  CONSTRAINT FK_FatoVotacao_Votacao FOREIGN KEY (ID_Votacao_FK)
      --      REFERENCES DimVotacao (ID_Votacao)

);