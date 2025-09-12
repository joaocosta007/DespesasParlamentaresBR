USE [NomeDoSeuBancoDeDados];


DROP TABLE IF EXISTS dbo.stg_cota_brasil_io;
CREATE TABLE dbo.stg_cota_brasil_io (
    txNomeParlamentar VARCHAR(MAX),
    sgPartido VARCHAR(MAX),
    sgUF VARCHAR(MAX),
    nuAno INT,
    nuMes INT,
    txNomeFornecedor VARCHAR(MAX),
    nuCPFCNPJ VARCHAR(MAX),
    deValorLiquido DECIMAL(18, 2),
    nuCarteiraParlamentar VARCHAR(MAX),
    txDescricao VARCHAR(MAX)
);

BULK INSERT dbo.stg_cota_brasil_io
FROM 'C:\Caminho\Para\Seu\Arquivo\cota_parlamentar.csv' 
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Criação da tabela de staging para as despesas anuais da Câmara
DROP TABLE IF EXISTS dbo.stg_despesas_camara_anual;
CREATE TABLE dbo.stg_despesas_camara_anual (
    txNomeParlamentar VARCHAR(MAX),
    cpf VARCHAR(MAX),
    ideCadastro VARCHAR(MAX),
    nuCarteiraParlamentar VARCHAR(MAX),
    nuLegislatura VARCHAR(MAX),
    sgUF VARCHAR(MAX),
    sgPartido VARCHAR(MAX),
    codLegislatura INT,
    numSubCota VARCHAR(MAX),
    txtDescricao VARCHAR(MAX),
    numEspecificacaoSubCota VARCHAR(MAX),
    txtDescricaoEspecificacao VARCHAR(MAX),
    txtFornecedor VARCHAR(MAX),
    txtCNPJCPF VARCHAR(MAX),
    txtNumero VARCHAR(MAX),
    indTipoDocumento VARCHAR(MAX),
    datEmissao DATE,
    vlrDocumento DECIMAL(18, 2),
    vlrGlosa DECIMAL(18, 2),
    vlrLiquido DECIMAL(18, 2),
    numMes INT,
    numAno INT,
    numParcela VARCHAR(MAX),
    txtPassageiro VARCHAR(MAX),
    txtTrecho VARCHAR(MAX),
    numLote VARCHAR(MAX),
    numRessarcimento VARCHAR(MAX),
    datPagamentoRestituicao DATE,
    vlrRestituicao DECIMAL(18, 2),
    nuDeputadoId INT,
    ideDocumento VARCHAR(MAX),
    urlDocumento VARCHAR(MAX)
);

-- Ingestão de cada arquivo anual
BULK INSERT dbo.stg_despesas_camara_anual FROM 'C:\Caminho\Para\Seu\Arquivo\despesas_2022.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');
BULK INSERT dbo.stg_despesas_camara_anual FROM 'C:\Caminho\Para\Seu\Arquivo\despesas_2023.csv' WITH (FIRSTROW = 1, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');
BULK INSERT dbo.stg_despesas_camara_anual FROM 'C:\Caminho\Para\Seu\Arquivo\despesas_2024.csv' WITH (FIRSTROW = 1, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');
BULK INSERT dbo.stg_despesas_camara_anual FROM 'C:\Caminho\Para\Seu\Arquivo\despesas_2025.csv' WITH (FIRSTROW = 1, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');

-- Tabela para os dados de empresas
DROP TABLE IF EXISTS dbo.stg_cnpj_empresas;
CREATE TABLE dbo.stg_cnpj_empresas (
    -- Adicione as colunas conforme o seu arquivo Empresas.csv
    cnpj VARCHAR(20),
    razao_social VARCHAR(255),
    cnae_principal VARCHAR(10),
    -- ...
);

-- BULK INSERT para o arquivo de empresas (provavelmente ; como delimitador)
BULK INSERT dbo.stg_cnpj_empresas
FROM 'C:\Caminho\Para\Seu\Arquivo\empresas.csv' 
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ';', 
    ROWTERMINATOR = '\n'
);

-- Tabela para os dados de estabelecimentos
DROP TABLE IF EXISTS dbo.stg_cnpj_estabelecimentos;
CREATE TABLE dbo.stg_cnpj_estabelecimentos (
    -- Adicione as colunas conforme o seu arquivo Estabelecimentos.csv
    cnpj_basico VARCHAR(20),
    cnpj_ordem VARCHAR(4),
    cnpj_dv VARCHAR(2),
    cnae_fiscal_principal VARCHAR(10),
    -- ...
);

-- BULK INSERT para o arquivo de estabelecimentos
BULK INSERT dbo.stg_cnpj_estabelecimentos
FROM 'C:\Caminho\Para\Seu\Arquivo\estabelecimentos.csv' 
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ';', 
    ROWTERMINATOR = '\n'
);