PRINT 'Criando Function 1: fn_Calcular_Faixa_Etaria...';
GO
CREATE OR ALTER FUNCTION fn_Calcular_Faixa_Etaria(@DataNascimento DATE)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @Idade INT = DATEDIFF(YEAR, @DataNascimento, GETDATE());
    
    RETURN CASE 
        WHEN @Idade < 25 THEN 'Jovem (18-24)'
        WHEN @Idade BETWEEN 25 AND 34 THEN 'Adulto Jovem (25-34)'
        WHEN @Idade BETWEEN 35 AND 44 THEN 'Adulto (35-44)'
        WHEN @Idade BETWEEN 45 AND 59 THEN 'Meia Idade (45-59)'
        WHEN @Idade >= 60 THEN 'Idoso (60+)'
        ELSE 'Idade não informada'
    END;
END;
GO
PRINT 'Function 1 criada: fn_Calcular_Faixa_Etaria';
GO

PRINT 'Criando Function 2: fn_Classificar_Patrimonio...';
GO
CREATE OR ALTER FUNCTION fn_Classificar_Patrimonio(@Valor DECIMAL(15,2))
RETURNS NVARCHAR(30)
AS
BEGIN
    RETURN CASE 
        WHEN @Valor IS NULL THEN 'NÃO DECLARADO'
        WHEN @Valor = 0 THEN 'PATRIMÔNIO ZERADO'
        WHEN @Valor <= 50000 THEN 'ATÉ R$ 50 MIL'
        WHEN @Valor <= 200000 THEN 'R$ 50 MIL - R$ 200 MIL'
        WHEN @Valor <= 1000000 THEN 'R$ 200 MIL - R$ 1 MILHÃO'
        WHEN @Valor <= 5000000 THEN 'R$ 1 MILHÃO - R$ 5 MILHÕES'
        ELSE 'ACIMA DE R$ 5 MILHÕES'
    END;
END;
GO
PRINT 'Function 2 criada: fn_Classificar_Patrimonio';
GO

PRINT 'Criando Function 2: fn_Classificar_Patrimonio...';
GO
CREATE OR ALTER FUNCTION fn_Classificar_Patrimonio(@Valor DECIMAL(18,2))
RETURNS NVARCHAR(30)
AS
BEGIN
    IF @Valor IS NULL
        RETURN 'NÃO DECLARADO';
    
    RETURN CASE 
        WHEN @Valor = 0 THEN 'PATRIMÔNIO ZERADO'
        WHEN @Valor <= 50000 THEN 'ATÉ R$ 50 MIL'
        WHEN @Valor <= 200000 THEN 'R$ 50 MIL - R$ 200 MIL'
        WHEN @Valor <= 1000000 THEN 'R$ 200 MIL - R$ 1 MILHÃO'
        WHEN @Valor <= 5000000 THEN 'R$ 1 MILHÃO - R$ 5 MILHÕES'
        ELSE 'ACIMA DE R$ 5 MILHÕES'
    END;
END;
GO
PRINT 'Function 2 criada: fn_Classificar_Patrimonio';
GO