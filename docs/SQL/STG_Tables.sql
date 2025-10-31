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
    PORTE_DA_EMPRESA            VARCHAR(10),  
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
