PRINT 'Recriando Stored Procedure 1: sp_Atualizar_Candidato...';
GO
CREATE OR ALTER PROCEDURE sp_Atualizar_Candidato
    @SQ_CANDIDATO BIGINT = NULL,
    @NM_CANDIDATO NVARCHAR(200) = NULL,
    @DS_GENERO NVARCHAR(20) = NULL,
    @DS_COR_RACA NVARCHAR(50) = NULL,
    @DS_GRAU_INSTRUCAO NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @SQ_CANDIDATO IS NULL
    BEGIN
        SELECT TOP 100 
            c.SQ_CANDIDATO,
            c.NM_CANDIDATO,
            c.NM_URNA_CANDIDATO,
            p.SG_PARTIDO,
            car.DS_CARGO,
            uf.SG_UF,
            c.DS_GENERO,
            c.DS_COR_RACA,
            c.DS_GRAU_INSTRUCAO,
            c.NR_CANDIDATO
        FROM Dim_Candidato c
        INNER JOIN Dim_Partido p ON c.Partido_ID = p.Partido_ID
        INNER JOIN Dim_Cargo car ON c.Cargo_ID = car.Cargo_ID
        INNER JOIN Dim_UF uf ON c.UF_ID = uf.UF_ID
        ORDER BY c.NM_CANDIDATO;
        RETURN;
    END

    IF @NM_CANDIDATO IS NULL 
       AND @DS_GENERO IS NULL 
       AND @DS_COR_RACA IS NULL 
       AND @DS_GRAU_INSTRUCAO IS NULL
    BEGIN
        RAISERROR('Pelo menos um campo deve ser fornecido para atualização (NM_CANDIDATO, DS_GENERO, DS_COR_RACA ou DS_GRAU_INSTRUCAO).', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Dim_Candidato WHERE SQ_CANDIDATO = @SQ_CANDIDATO)
        BEGIN
            RAISERROR('Candidato não encontrado com o SQ_CANDIDATO informado.', 16, 1);
            RETURN;
        END
        
        UPDATE Dim_Candidato 
        SET 
            NM_CANDIDATO = ISNULL(@NM_CANDIDATO, NM_CANDIDATO),
            DS_GENERO = ISNULL(@DS_GENERO, DS_GENERO),
            DS_COR_RACA = ISNULL(@DS_COR_RACA, DS_COR_RACA),
            DS_GRAU_INSTRUCAO = ISNULL(@DS_GRAU_INSTRUCAO, DS_GRAU_INSTRUCAO)
        WHERE SQ_CANDIDATO = @SQ_CANDIDATO;
        
        COMMIT TRANSACTION;
        PRINT 'Candidato atualizado com sucesso! SQ_CANDIDATO: ' + CAST(@SQ_CANDIDATO AS NVARCHAR(20));
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

exec sp_Atualizar_Candidato;

EXEC sp_Atualizar_Candidato 
    @SQ_CANDIDATO = '210001620050',
    @NM_CANDIDATO = 'Leandra',
    @DS_GENERO = 'Feminino',
    @DS_COR_RACA = 'Parda',
    @DS_GRAU_INSTRUCAO = 'Superior Completo';

select SQ_CANDIDATO,NM_CANDIDATO, DS_GENERO, DS_COR_RACA, DS_GRAU_INSTRUCAO  from Dim_Candidato where SQ_CANDIDATO = 210001620050

PRINT 'Recriando Stored Procedure 2: sp_Inserir_Receita...';
GO
CREATE OR ALTER PROCEDURE sp_Inserir_Receita
    @SQ_CANDIDATO BIGINT = NULL,
    @VR_RECEITA DECIMAL(15,2) = NULL,
    @DS_RECEITA NVARCHAR(500) = NULL,
    @NR_CPF_CNPJ_DOADOR NVARCHAR(100) = NULL,
    @NM_DOADOR NVARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @SQ_CANDIDATO IS NULL
    BEGIN
        SELECT TOP 100 
            c.SQ_CANDIDATO,
            c.NM_CANDIDATO,
            c.NM_URNA_CANDIDATO,
            p.SG_PARTIDO,
            p.NM_PARTIDO,
            car.DS_CARGO,
            uf.SG_UF,
            c.NR_CANDIDATO
        FROM Dim_Candidato c
        INNER JOIN Dim_Partido p ON c.Partido_ID = p.Partido_ID
        INNER JOIN Dim_Cargo car ON c.Cargo_ID = car.Cargo_ID
        INNER JOIN Dim_UF uf ON c.UF_ID = uf.UF_ID
        ORDER BY c.NM_CANDIDATO;
        RETURN;
    END

    IF @VR_RECEITA IS NULL OR @DS_RECEITA IS NULL
    BEGIN
        RAISERROR('Para inserir receita, os parâmetros @VR_RECEITA e @DS_RECEITA são obrigatórios.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @Candidato_ID INT;
        DECLARE @Doador_ID INT = NULL;
        DECLARE @Data_ID INT = (SELECT Data_ID FROM Dim_Tempo WHERE Data_Completa = CAST(GETDATE() AS DATE));
        DECLARE @Tipo_Receita_ID INT = (SELECT TOP 1 Tipo_Receita_ID FROM Dim_Tipo_Receita);

        SELECT @Candidato_ID = Candidato_ID 
        FROM Dim_Candidato 
        WHERE SQ_CANDIDATO = @SQ_CANDIDATO;
        
        IF @Candidato_ID IS NULL
        BEGIN
            RAISERROR('Candidato não encontrado com o SQ_CANDIDATO informado.', 16, 1);
            RETURN;
        END
        
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

EXEC sp_Inserir_Receita;


PRINT 'Recriando Stored Procedure 3: sp_Excluir_Despesa...';
GO
CREATE OR ALTER PROCEDURE sp_Excluir_Despesa
    @Despesa_ID BIGINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Despesa_ID IS NULL
    BEGIN
        SELECT TOP 100 
            fd.Despesa_ID,
            c.NM_CANDIDATO,
            p.SG_PARTIDO,
            car.DS_CARGO,
            uf.SG_UF,
            fd.DS_DESPESA,
            f.NM_FORNECEDOR,
            t.DS_ORIGEM_DESPESA,
            td.Data_Completa as DATA_DESPESA
        FROM Fact_Despesas fd
        INNER JOIN Dim_Candidato c ON fd.Candidato_ID = c.Candidato_ID
        INNER JOIN Dim_Partido p ON c.Partido_ID = p.Partido_ID
        INNER JOIN Dim_Cargo car ON c.Cargo_ID = car.Cargo_ID
        INNER JOIN Dim_UF uf ON c.UF_ID = uf.UF_ID
        LEFT JOIN Dim_Fornecedor f ON fd.Fornecedor_ID = f.Fornecedor_ID
        LEFT JOIN Dim_Tipo_Despesa t ON fd.Tipo_Despesa_ID = t.Tipo_Despesa_ID
        LEFT JOIN Dim_Tempo td ON fd.Data_ID = td.Data_ID
        ORDER BY fd.Despesa_ID DESC;
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Fact_Despesas WHERE Despesa_ID = @Despesa_ID)
        BEGIN
            RAISERROR('Despesa não encontrada com o ID informado.', 16, 1);
            RETURN;
        END
        
        DELETE FROM Fact_Despesas 
        WHERE Despesa_ID = @Despesa_ID;
        
        COMMIT TRANSACTION;
        PRINT 'Despesa excluída com sucesso! ID: ' + CAST(@Despesa_ID AS NVARCHAR(20));
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

PRINT 'Recriando Stored Procedure 4: sp_Custo_Por_Voto...';
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
    WHERE Total_Votos_Nominais > 1000 
      AND Total_Candidatos > 0
      AND Receita_Media_Por_Candidato > 0
    ORDER BY Custo_Por_Voto DESC;
END;
GO
PRINT 'Stored Procedure 4 criada: sp_Custo_Por_Voto';
GO

exec sp_Custo_Por_Voto;



