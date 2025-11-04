PRINT 'Criando Trigger 1: Auditoria em Receitas...';
GO

DROP TABLE IF EXISTS Auditoria_Receitas

CREATE TABLE Auditoria_Receitas (
    Auditoria_ID BIGINT PRIMARY KEY IDENTITY(1,1),
    Receita_ID BIGINT,
    VR_RECEITA_ANTIGO DECIMAL(15,2),
    VR_RECEITA_NOVO DECIMAL(15,2),
    DS_RECEITA_ANTIGO NVARCHAR(500),
    DS_RECEITA_NOVO NVARCHAR(500),
    Candidato_ID INT,
    Tipo_Operacao NVARCHAR(10), 
    Data_Operacao DATETIME DEFAULT GETDATE(),
    Usuario NVARCHAR(128)
);
GO

CREATE OR ALTER TRIGGER tr_Auditoria_Receitas
ON Fact_Receitas
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria_Receitas (
            Receita_ID, VR_RECEITA_NOVO, DS_RECEITA_NOVO, Candidato_ID, 
            Tipo_Operacao, Usuario
        )
        SELECT 
            i.Receita_ID, i.VR_RECEITA, i.DS_RECEITA, i.Candidato_ID,
            'INSERT', SYSTEM_USER
        FROM inserted i;
    END

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria_Receitas (
            Receita_ID, VR_RECEITA_ANTIGO, VR_RECEITA_NOVO, 
            DS_RECEITA_ANTIGO, DS_RECEITA_NOVO, Candidato_ID,
            Tipo_Operacao, Usuario
        )
        SELECT 
            i.Receita_ID, d.VR_RECEITA, i.VR_RECEITA,
            d.DS_RECEITA, i.DS_RECEITA, i.Candidato_ID,
            'UPDATE', SYSTEM_USER
        FROM inserted i
        INNER JOIN deleted d ON i.Receita_ID = d.Receita_ID;
    END

    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria_Receitas (
            Receita_ID, VR_RECEITA_ANTIGO, DS_RECEITA_ANTIGO, Candidato_ID,
            Tipo_Operacao, Usuario
        )
        SELECT 
            d.Receita_ID, d.VR_RECEITA, d.DS_RECEITA, d.Candidato_ID,
            'DELETE', SYSTEM_USER
        FROM deleted d;
    END
END;
GO
PRINT 'Trigger 1 criado: tr_Auditoria_Receitas';
GO

PRINT 'Criando Trigger 2: Validação de Despesas...';
GO

CREATE OR ALTER TRIGGER tr_Validacao_Despesas
ON Fact_Despesas
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM inserted WHERE VR_DESPESA_CONTRATADA < 0)
        BEGIN
            RAISERROR('Valor de despesa não pode ser negativo.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM inserted i 
            LEFT JOIN Dim_Candidato c ON i.Candidato_ID = c.Candidato_ID 
            WHERE c.Candidato_ID IS NULL
        )
        BEGIN
            RAISERROR('Candidato não encontrado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM inserted i 
            LEFT JOIN Dim_Tempo t ON i.Data_ID = t.Data_ID 
            WHERE t.Data_ID IS NULL
        )
        BEGIN
            RAISERROR('Data não encontrada na dimensão tempo.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO Fact_Despesas (
            Candidato_ID, Fornecedor_ID, Tipo_Despesa_ID, Data_ID,
            VR_DESPESA_CONTRATADA, VR_PAGTO_DESPESA, DS_DESPESA
        )
        SELECT 
            Candidato_ID, Fornecedor_ID, Tipo_Despesa_ID, Data_ID,
            VR_DESPESA_CONTRATADA, VR_PAGTO_DESPESA, DS_DESPESA
        FROM inserted;
        
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Erro na validação de despesa: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
PRINT 'Trigger 2 criado: tr_Validacao_Despesas';
GO