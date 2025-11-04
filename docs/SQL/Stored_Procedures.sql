PRINT 'Criando Stored Procedure 1: sp_Atualizar_Candidato...';
GO
CREATE OR ALTER PROCEDURE sp_Atualizar_Candidato
    @SQ_CANDIDATO BIGINT,
    @NM_CANDIDATO NVARCHAR(200) = NULL,
    @DS_GENERO NVARCHAR(20) = NULL,
    @DS_COR_RACA NVARCHAR(50) = NULL,
    @DS_GRAU_INSTRUCAO NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        UPDATE Dim_Candidato 
        SET 
            NM_CANDIDATO = ISNULL(@NM_CANDIDATO, NM_CANDIDATO),
            DS_GENERO = ISNULL(@DS_GENERO, DS_GENERO),
            DS_COR_RACA = ISNULL(@DS_COR_RACA, DS_COR_RACA),
            DS_GRAU_INSTRUCAO = ISNULL(@DS_GRAU_INSTRUCAO, DS_GRAU_INSTRUCAO)
        WHERE SQ_CANDIDATO = @SQ_CANDIDATO;
        
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Candidato não encontrado com o SQ_CANDIDATO informado.', 16, 1);
        END
        
        COMMIT TRANSACTION;
        PRINT 'Candidato atualizado com sucesso!';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Erro ao atualizar candidato: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
PRINT 'Stored Procedure 1 criada: sp_Atualizar_Candidato';
GO

PRINT 'Criando Stored Procedure 1: sp_Atualizar_Candidato...';
GO
CREATE OR ALTER PROCEDURE sp_Atualizar_Candidato
    @SQ_CANDIDATO BIGINT,
    @NM_CANDIDATO NVARCHAR(200) = NULL,
    @DS_GENERO NVARCHAR(20) = NULL,
    @DS_COR_RACA NVARCHAR(50) = NULL,
    @DS_GRAU_INSTRUCAO NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        UPDATE Dim_Candidato 
        SET 
            NM_CANDIDATO = ISNULL(@NM_CANDIDATO, NM_CANDIDATO),
            DS_GENERO = ISNULL(@DS_GENERO, DS_GENERO),
            DS_COR_RACA = ISNULL(@DS_COR_RACA, DS_COR_RACA),
            DS_GRAU_INSTRUCAO = ISNULL(@DS_GRAU_INSTRUCAO, DS_GRAU_INSTRUCAO)
        WHERE SQ_CANDIDATO = @SQ_CANDIDATO;
        
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Candidato não encontrado com o SQ_CANDIDATO informado.', 16, 1);
        END
        
        COMMIT TRANSACTION;
        PRINT 'Candidato atualizado com sucesso!';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Erro ao atualizar candidato: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
PRINT 'Stored Procedure 1 criada: sp_Atualizar_Candidato';
GO


PRINT 'Criando Stored Procedure 2: sp_Inserir_Receita...';
GO
CREATE OR ALTER PROCEDURE sp_Inserir_Receita
    @SQ_CANDIDATO BIGINT,
    @VR_RECEITA DECIMAL(15,2),
    @DS_RECEITA NVARCHAR(500),
    @NR_CPF_CNPJ_DOADOR NVARCHAR(100) = NULL,
    @NM_DOADOR NVARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @Candidato_ID INT;
        DECLARE @Doador_ID INT = NULL;
        DECLARE @Data_ID INT = (SELECT Data_ID FROM Dim_Tempo WHERE Data_Completa = CAST(GETDATE() AS DATE));
        DECLARE @Tipo_Receita_ID INT = (SELECT TOP 1 Tipo_Receita_ID FROM Dim_Tipo_Receita);
        
        -- Buscar Candidato_ID
        SELECT @Candidato_ID = Candidato_ID 
        FROM Dim_Candidato 
        WHERE SQ_CANDIDATO = @SQ_CANDIDATO;
        
        IF @Candidato_ID IS NULL
        BEGIN
            RAISERROR('Candidato não encontrado com o SQ_CANDIDATO informado.', 16, 1);
        END
        
        -- Buscar ou criar Doador (apenas se CPF/CNPJ for fornecido)
        IF @NR_CPF_CNPJ_DOADOR IS NOT NULL AND @NR_CPF_CNPJ_DOADOR != ''
        BEGIN
            SELECT @Doador_ID = Doador_ID 
            FROM Dim_Doador 
            WHERE NR_CPF_CNPJ_DOADOR = @NR_CPF_CNPJ_DOADOR;
            
            IF @Doador_ID IS NULL
            BEGIN
                INSERT INTO Dim_Doador (NR_CPF_CNPJ_DOADOR, NM_DOADOR, DS_TIPO_DOADOR)
                VALUES (@NR_CPF_CNPJ_DOADOR, ISNULL(@NM_DOADOR, 'Não Informado'), 'Pessoa Física/Jurídica');
                
                SET @Doador_ID = SCOPE_IDENTITY();
            END
        END

        INSERT INTO Fact_Receitas (
            Candidato_ID, 
            Doador_ID, 
            Tipo_Receita_ID, 
            Data_ID, 
            VR_RECEITA, 
            DS_RECEITA
        )
        VALUES (
            @Candidato_ID,
            @Doador_ID,
            @Tipo_Receita_ID,
            @Data_ID,
            @VR_RECEITA,
            @DS_RECEITA
        );
        
        COMMIT TRANSACTION;
        PRINT 'Receita inserida com sucesso! ID: ' + CAST(SCOPE_IDENTITY() AS NVARCHAR(20));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Erro ao inserir receita: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
PRINT 'Stored Procedure 2 criada: sp_Inserir_Receita';
GO

PRINT 'Criando Stored Procedure 3: sp_Excluir_Despesa...';
GO
CREATE OR ALTER PROCEDURE sp_Excluir_Despesa
    @Despesa_ID BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DELETE FROM Fact_Despesas 
        WHERE Despesa_ID = @Despesa_ID;
        
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Despesa não encontrada com o ID informado.', 16, 1);
        END
        
        COMMIT TRANSACTION;
        PRINT 'Despesa excluída com sucesso!';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Erro ao excluir despesa: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
PRINT 'Stored Procedure 3 criada: sp_Excluir_Despesa';
GO

PRINT 'Recriando Stored Procedure 4: sp_Ranking_Partidos...';
GO
CREATE OR ALTER PROCEDURE sp_Ranking_Partidos
    @Cargo NVARCHAR(50) = NULL,
    @UF NVARCHAR(2) = NULL,
    @TopN INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Usar a tabela materializada (super rápida)
    SELECT TOP (@TopN)
        SG_PARTIDO,
        NM_PARTIDO,
        DS_CARGO,
        SG_UF,
        Total_Candidatos,
        Total_Eleitos,
        Taxa_Sucesso,
        Receita_Media_Por_Candidato,
        Total_Votos_Nominais
    FROM vw_Eficiencia_Partidaria
    WHERE (@Cargo IS NULL OR DS_CARGO = @Cargo)
      AND (@UF IS NULL OR SG_UF = @UF)
      AND Total_Candidatos > 0  -- Filtro para evitar divisão por zero
    ORDER BY Taxa_Sucesso DESC;
END;
GO
PRINT 'Stored Procedure 4 criada: sp_Ranking_Partidos';
GO

PRINT 'Recriando Stored Procedure 5: sp_Custo_Por_Voto...';
GO
CREATE OR ALTER PROCEDURE sp_Custo_Por_Voto
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        SG_PARTIDO,
        NM_PARTIDO,
        DS_CARGO,
        SG_UF,
        (Receita_Media_Por_Candidato * Total_Candidatos) as Receita_Total_Estimada,
        (Despesa_Media_Por_Candidato * Total_Candidatos) as Despesa_Total_Estimada,
        Total_Votos_Nominais as Total_Votos,
        CASE 
            WHEN Total_Votos_Nominais > 0 
            THEN (Receita_Media_Por_Candidato * Total_Candidatos) / Total_Votos_Nominais
            ELSE NULL 
        END as Custo_Por_Voto,
        CASE 
            WHEN (Receita_Media_Por_Candidato * Total_Candidatos) > 0 
            THEN CAST(Total_Votos_Nominais * 1000.0 / (Receita_Media_Por_Candidato * Total_Candidatos) AS DECIMAL(10,2))
            ELSE NULL 
        END as Votos_Por_Mil_Real,
        CASE 
            WHEN Total_Votos_Nominais = 0 THEN 'N/A'
            WHEN (Receita_Media_Por_Candidato * Total_Candidatos) / Total_Votos_NominaIS < 10 THEN 'Muito Baixo'
            WHEN (Receita_Media_Por_Candidato * Total_Candidatos) / Total_Votos_NominaIS < 50 THEN 'Baixo'
            WHEN (Receita_Media_Por_Candidato * Total_Candidatos) / Total_Votos_NominaIS < 100 THEN 'Médio'
            WHEN (Receita_Media_Por_Candidato * Total_Candidatos) / Total_Votos_NominaIS < 200 THEN 'Alto'
            ELSE 'Muito Alto'
        END as Classificacao_Custo
    FROM vw_Eficiencia_Partidaria
    WHERE Total_Votos_Nominais > 1000  -- Filtro para partidos relevantes
      AND Total_Candidatos > 0
      AND Receita_Media_Por_Candidato > 0
    ORDER BY Custo_Por_Voto DESC;
END;
GO
PRINT 'Stored Procedure 5criada: sp_Custo_Por_Voto';
GO

