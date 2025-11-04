USE Analise

DROP TABLE IF EXISTS Fact_Votacao

CREATE TABLE Fact_Votacao (
    Votacao_ID BIGINT PRIMARY KEY IDENTITY(1,1),
    Municipio_ID INT,
    Data_ID INT,
    Cargo_ID INT,
    Partido_ID INT,
    NR_ZONA NVARCHAR(10),
    QT_VOTOS_NOMINAIS INT,
    QT_VOTOS_LEGENDA INT,
    QT_APTOS INT,
    QT_COMPARECIMENTO INT,
    QT_ABSTENCOES INT
    
    CONSTRAINT FK_Votacao_Municipio FOREIGN KEY (Municipio_ID) REFERENCES Dim_Municipio(Municipio_ID),
    CONSTRAINT FK_Votacao_Tempo FOREIGN KEY (Data_ID) REFERENCES Dim_Tempo(Data_ID),
    CONSTRAINT FK_Votacao_Cargo FOREIGN KEY (Cargo_ID) REFERENCES Dim_Cargo(Cargo_ID),
    CONSTRAINT FK_Votacao_Partido FOREIGN KEY (Partido_ID) REFERENCES Dim_Partido(Partido_ID)
);
GO

DROP TABLE IF EXISTS Fact_Despesas

CREATE TABLE Fact_Despesas (
    Despesa_ID BIGINT PRIMARY KEY IDENTITY(1,1),
    Candidato_ID INT,
    Fornecedor_ID INT,
    Tipo_Despesa_ID INT,
    Data_ID INT,
    VR_DESPESA_CONTRATADA DECIMAL(15,2),
    VR_PAGTO_DESPESA DECIMAL(15,2),
    DS_DESPESA NVARCHAR(500),
    
    CONSTRAINT FK_Despesas_Candidato FOREIGN KEY (Candidato_ID) REFERENCES Dim_Candidato(Candidato_ID),
    CONSTRAINT FK_Despesas_Fornecedor FOREIGN KEY (Fornecedor_ID) REFERENCES Dim_Fornecedor(Fornecedor_ID),
    CONSTRAINT FK_Despesas_Tipo_Despesa FOREIGN KEY (Tipo_Despesa_ID) REFERENCES Dim_Tipo_Despesa(Tipo_Despesa_ID),
    CONSTRAINT FK_Despesas_Tempo FOREIGN KEY (Data_ID) REFERENCES Dim_Tempo(Data_ID)
);
GO

DROP TABLE IF EXISTS Fact_Receitas

CREATE TABLE Fact_Receitas (
    Receita_ID BIGINT PRIMARY KEY IDENTITY(1,1),
    Candidato_ID INT,
    Doador_ID INT,
    Tipo_Receita_ID INT,
    Data_ID INT,
    VR_RECEITA DECIMAL(15,2),
    DS_RECEITA NVARCHAR(500),
    
    CONSTRAINT FK_Receitas_Candidato FOREIGN KEY (Candidato_ID) REFERENCES Dim_Candidato(Candidato_ID),
    CONSTRAINT FK_Receitas_Doador FOREIGN KEY (Doador_ID) REFERENCES Dim_Doador(Doador_ID),
    CONSTRAINT FK_Receitas_Tipo_Receita FOREIGN KEY (Tipo_Receita_ID) REFERENCES Dim_Tipo_Receita(Tipo_Receita_ID),
    CONSTRAINT FK_Receitas_Tempo FOREIGN KEY (Data_ID) REFERENCES Dim_Tempo(Data_ID)
);
GO

DROP TABLE IF EXISTS Fact_Bens

CREATE TABLE Fact_Bens (
    Bem_ID BIGINT PRIMARY KEY IDENTITY(1,1),
    Candidato_ID INT,
    Data_ID INT,
    DS_TIPO_BEM_CANDIDATO NVARCHAR(200),
    DS_BEM_CANDIDATO NVARCHAR(500),
    VR_BEM_CANDIDATO DECIMAL(15,2),
    
    CONSTRAINT FK_Bens_Candidato FOREIGN KEY (Candidato_ID) REFERENCES Dim_Candidato(Candidato_ID),
    CONSTRAINT FK_Bens_Tempo FOREIGN KEY (Data_ID) REFERENCES Dim_Tempo(Data_ID)
);
GO

SELECT 'Dim_Tempo' as Tabela, COUNT(*) as Total_Registros FROM Dim_Tempo
UNION ALL
SELECT 'Dim_UF', COUNT(*) FROM Dim_UF
UNION ALL
SELECT 'Dim_Cargo', COUNT(*) FROM Dim_Cargo
UNION ALL
SELECT 'Dim_Partido', COUNT(*) FROM Dim_Partido
UNION ALL
SELECT 'Dim_Municipio', COUNT(*) FROM Dim_Municipio
UNION ALL
SELECT 'Dim_Candidato', COUNT(*) FROM Dim_Candidato
UNION ALL
SELECT 'Dim_Fornecedor', COUNT(*) FROM Dim_Fornecedor
UNION ALL
SELECT 'Dim_Doador', COUNT(*) FROM Dim_Doador
UNION ALL
SELECT 'Dim_Tipo_Despesa', COUNT(*) FROM Dim_Tipo_Despesa
UNION ALL
SELECT 'Dim_Tipo_Despesa_Contratada', COUNT(*) FROM Dim_Tipo_Despesa_Contratada
UNION ALL
SELECT 'Dim_Tipo_Receita', COUNT(*) FROM Dim_Tipo_Receita
UNION ALL
SELECT 'Fact_Votacao', COUNT(*) FROM Fact_Votacao
UNION ALL
SELECT 'Fact_Receitas', COUNT(*) FROM Fact_Receitas
UNION ALL
SELECT 'Fact_Despesas', COUNT(*) FROM Fact_Despesas
UNION ALL
SELECT 'Fact_Bens', COUNT(*) FROM Fact_Bens
ORDER BY Tabela;


CREATE INDEX IX_FactVotacao_Analise 
ON Fact_Votacao (Municipio_ID, Data_ID, Cargo_ID)
INCLUDE (Partido_ID, QT_VOTOS_NOMINAIS, QT_VOTOS_LEGENDA, QT_APTOS, QT_COMPARECIMENTO)
WITH (MAXDOP = 2, ONLINE = OFF);

CREATE INDEX IX_FactVotacao_Partido 
ON Fact_Votacao (Partido_ID, Data_ID)
INCLUDE (Cargo_ID, QT_VOTOS_NOMINAIS, QT_VOTOS_LEGENDA)
WITH (MAXDOP = 2, ONLINE = OFF);

CREATE INDEX IX_FactReceitas_Analise 
ON Fact_Receitas (Candidato_ID, Data_ID)
INCLUDE (VR_RECEITA, Tipo_Receita_ID)
WITH (MAXDOP = 2, ONLINE = OFF);

CREATE INDEX IX_FactDespesas_Analise 
ON Fact_Despesas (Candidato_ID, Data_ID)
INCLUDE (VR_DESPESA_CONTRATADA, Tipo_Despesa_ID)
WITH (MAXDOP = 2, ONLINE = OFF);

CREATE INDEX IX_FactReceitas_Covering ON Fact_Receitas (Candidato_ID) INCLUDE (VR_RECEITA);
CREATE INDEX IX_FactDespesas_Covering ON Fact_Despesas (Candidato_ID) INCLUDE (VR_DESPESA_CONTRATADA, VR_PAGTO_DESPESA);
CREATE INDEX IX_FactBens_Covering ON Fact_Bens (Candidato_ID) INCLUDE (VR_BEM_CANDIDATO);
CREATE INDEX IX_DimCandidato_Covering ON Dim_Candidato (Partido_ID, Cargo_ID, UF_ID) INCLUDE (DS_SIT_TOT_TURNO, DS_GENERO, DS_COR_RACA, DS_GRAU_INSTRUCAO);

CREATE INDEX IX_DimCandidato_PartidoCargoUF ON Dim_Candidato (Partido_ID, Cargo_ID, UF_ID) 
INCLUDE (DS_SIT_TOT_TURNO);

CREATE INDEX IX_FactVotacao_PartidoCargo ON Fact_Votacao (Partido_ID, Cargo_ID) 
INCLUDE (QT_VOTOS_NOMINAIS, QT_VOTOS_LEGENDA);

CREATE INDEX IX_DimCandidato_Financeiro ON Dim_Candidato (Partido_ID, Cargo_ID, UF_ID, Candidato_ID);