USE Analise_Gastos

TRUNCATE TABLE DimSetor;


WITH CNAE_PRINCIPAL AS (
    
    SELECT DISTINCT
        T1.CNAE_FISCAL_PRINCIPAL AS CodCNAE
    FROM
        Analise_Gastos.dbo.stg_CNPJ_Estabelecimentos T1
    WHERE
        T1.CNAE_FISCAL_PRINCIPAL IS NOT NULL AND T1.CNAE_FISCAL_PRINCIPAL <> ''

),
CNAE_SECUNDARIO AS (
    
    SELECT DISTINCT
        TRIM(value) AS CodCNAE
    FROM
        Analise_Gastos.dbo.stg_CNPJ_Estabelecimentos T2
        CROSS APPLY STRING_SPLIT(T2.CNAE_FISCAL_SECUNDARIA, ',')
    WHERE
        T2.CNAE_FISCAL_SECUNDARIA IS NOT NULL AND T2.CNAE_FISCAL_SECUNDARIA <> ''
        
        AND LEN(TRIM(value)) = 7
),

CNAE_UNICO AS (
    SELECT CodCNAE FROM CNAE_PRINCIPAL
    UNION
    SELECT CodCNAE FROM CNAE_SECUNDARIO
)


INSERT INTO Analise_Gastos.dbo.DimSetor (
    CodCNAE,
    Cod_Divisao
)
SELECT 
    T1.CodCNAE,
    
    SUBSTRING(T1.CodCNAE, 1, 2) AS Cod_Divisao
FROM
    CNAE_UNICO T1
WHERE
    
    LEN(T1.CodCNAE) = 7 
ORDER BY T1.CodCNAE;


SELECT 
    COUNT(*) AS TotalSetoresCarregados 
FROM 
    DimSetor;
GO



