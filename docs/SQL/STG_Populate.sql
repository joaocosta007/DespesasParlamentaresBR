USE Analise_Gastos

-- Popular stg_CotaParlamentar

DROP TABLE IF EXISTS stg_CotaParlamentar_FLAT;

CREATE TABLE stg_CotaParlamentar_FLAT (
    codLegislatura              VARCHAR(MAX), datEmissao VARCHAR(MAX), ideDocumento VARCHAR(MAX), ideCadastro VARCHAR(MAX),
    indTipoDocumento            VARCHAR(MAX), nuCarteiraParlamentar VARCHAR(MAX), nuDeputadoId VARCHAR(MAX), nuLegislatura VARCHAR(MAX),
    numAno                      VARCHAR(MAX), numEspecificacaoSubcota VARCHAR(MAX), numLote VARCHAR(MAX), numMes VARCHAR(MAX),
    numParcela                  VARCHAR(MAX), numRessarcimento VARCHAR(MAX), numSubCota VARCHAR(MAX), sgPartido VARCHAR(MAX),
    sgUF                        VARCHAR(MAX), txNomeParlamentar VARCHAR(MAX), txtCNPJCPF VARCHAR(MAX), txtDescricao VARCHAR(MAX),
    txtDescricaoEspecificacao   VARCHAR(MAX), txtFornecedor VARCHAR(MAX), txtNumero VARCHAR(MAX), txtPassageiro VARCHAR(MAX),
    txtTrecho                   VARCHAR(MAX), vlrDocumento VARCHAR(MAX), vlrGlosa VARCHAR(MAX), vlrLiquido VARCHAR(MAX),
    vlrRestituicao              VARCHAR(MAX), 
    CampoExtra_DoCSV            VARCHAR(MAX) 
);
GO

TRUNCATE TABLE stg_CotaParlamentar_FLAT;

BULK INSERT stg_CotaParlamentar_FLAT

FROM '/tmp/bulk/cota_parlamentar_final.csv'

WITH
(

    FIRSTROW = 2,           
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0a', 
    TABLOCK,
    MAXERRORS = 1000, 
    ERRORFILE = '/tmp/bulk/cota_parlamentar_erros.log',
    FIELDQUOTE = '"' 
    
);
GO

SELECT COUNT(*) AS RegistrosCarregadosNaTabelaIntermediaria FROM stg_CotaParlamentar_FLAT;

GO


TRUNCATE TABLE stg_CotaParlamentar;

INSERT INTO stg_CotaParlamentar (

    codLegislatura, datEmissao, ideDocumento, ideCadastro, indTipoDocumento, nuCarteiraParlamentar, 
    nuDeputadoId, nuLegislatura, numAno, numEspecificacaoSubcota, numLote, numMes, numParcela, 
    numRessarcimento, numSubCota, sgPartido, sgUF, txNomeParlamentar, txtCNPJCPF, txtDescricao, 
    txtDescricaoEspecificacao, txtFornecedor, txtNumero, txtPassageiro, txtTrecho, vlrDocumento, 
    vlrGlosa, vlrLiquido, vlrRestituicao

)

SELECT 

    codLegislatura, datEmissao, ideDocumento, ideCadastro, indTipoDocumento, nuCarteiraParlamentar, 
    nuDeputadoId, nuLegislatura, numAno, numEspecificacaoSubcota, numLote, numMes, numParcela, 
    numRessarcimento, numSubCota, sgPartido, sgUF, txNomeParlamentar, txtCNPJCPF, txtDescricao, 
    txtDescricaoEspecificacao, txtFornecedor, txtNumero, txtPassageiro, txtTrecho, vlrDocumento, 
    vlrGlosa, vlrLiquido, vlrRestituicao

FROM 

    stg_CotaParlamentar_FLAT; 

SELECT COUNT(*) AS RegistrosInseridosNaStagingFinal FROM stg_CotaParlamentar;

GO

DROP TABLE IF EXISTS stg_CotaParlamentar_FLAT;

GO

-- Popular stg_Deputados

DROP TABLE IF EXISTS stg_Deputados_FLAT;

CREATE TABLE stg_Deputados_FLAT (

    txNomeParlamentar           VARCHAR(MAX), cpf VARCHAR(MAX),ideCadastro VARCHAR(MAX),nuCarteiraParlamentar VARCHAR(MAX),
    nuLegislatura               VARCHAR(MAX),sgUF VARCHAR(MAX),sgPartido VARCHAR(MAX),codLegislatura VARCHAR(MAX),
    numSubCota                  VARCHAR(MAX),txtDescricao VARCHAR(MAX),numEspecificacaoSubCota VARCHAR(MAX),txtDescricaoEspecificacao VARCHAR(MAX),
    txtFornecedor               VARCHAR(MAX),txtCNPJCPF VARCHAR(MAX),txtNumero VARCHAR(MAX),indTipoDocumento VARCHAR(MAX),
    datEmissao                  VARCHAR(MAX),vlrDocumento VARCHAR(MAX),vlrGlosa VARCHAR(MAX),vlrLiquido VARCHAR(MAX),
    numMes                      VARCHAR(MAX),numAno VARCHAR(MAX),numParcela VARCHAR(MAX),txtPassageiro VARCHAR(MAX),
    txtTrecho                   VARCHAR(MAX),numLote VARCHAR(MAX),numRessarcimento VARCHAR(MAX),datPagamentoRestituicao VARCHAR(MAX),
    vlrRestituicao              VARCHAR(MAX),nuDeputadoId VARCHAR(MAX),ideDocumento VARCHAR(MAX),urlDocumento VARCHAR(MAX)

);

GO

TRUNCATE TABLE stg_Deputados_FLAT;

BULK INSERT stg_Deputados_FLAT

FROM '/tmp/bulk/2025.csv' -- <<< ATUALIZE O NOME E CAMINHO DO ARQUIVO / Faca o mesmo com 2023, 2024 e 2025

WITH
(

    FIRSTROW = 2,           
    FIELDTERMINATOR = ';',  
    ROWTERMINATOR = '0x0a', 
    TABLOCK,
    MAXERRORS = 1000, 
    ERRORFILE = '/tmp/bulk/2025_erros.log',
    FIELDQUOTE = '"'
    
);

GO

SELECT COUNT(*) AS RegistrosCarregadosNaTabelaFlat_Deputados FROM stg_Deputados_FLAT;

GO

TRUNCATE TABLE stg_Deputados;

INSERT INTO stg_Deputados (

    txNomeParlamentar, cpf, ideCadastro, nuCarteiraParlamentar, nuLegislatura, sgUF, sgPartido, codLegislatura, numSubCota, txtDescricao, 
    numEspecificacaoSubCota, txtDescricaoEspecificacao, txtFornecedor, txtCNPJCPF, txtNumero, indTipoDocumento, datEmissao, vlrDocumento, 
    vlrGlosa, vlrLiquido, numMes, numAno, numParcela, txtPassageiro, txtTrecho, numLote, numRessarcimento, datPagamentoRestituicao, vlrRestituicao, 
    nuDeputadoId, ideDocumento, urlDocumento

)
SELECT 

    txNomeParlamentar, cpf, ideCadastro, nuCarteiraParlamentar, nuLegislatura, sgUF, sgPartido, codLegislatura, numSubCota, txtDescricao, 
    numEspecificacaoSubCota, txtDescricaoEspecificacao, txtFornecedor, txtCNPJCPF, txtNumero, indTipoDocumento, datEmissao, vlrDocumento, 
    vlrGlosa, vlrLiquido, numMes, numAno, numParcela, txtPassageiro, txtTrecho, numLote, numRessarcimento, datPagamentoRestituicao, vlrRestituicao, 
    nuDeputadoId, ideDocumento, urlDocumento

FROM 

    stg_Deputados_FLAT;

SELECT COUNT(*) AS RegistrosInseridosNaStaging_Deputados FROM stg_Deputados;

GO

DROP TABLE IF EXISTS stg_Deputados_FLAT;

GO

