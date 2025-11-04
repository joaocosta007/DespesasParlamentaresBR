CREATE OR ALTER VIEW vw_Votacao_Com_Taxas AS
SELECT 
    Votacao_ID,
    Municipio_ID,
    Data_ID,
    Cargo_ID,
    Partido_ID,
    NR_ZONA,
    QT_VOTOS_NOMINAIS,
    QT_VOTOS_LEGENDA,
    QT_APTOS,
    QT_COMPARECIMENTO,
    QT_ABSTENCOES,
    CASE 
        WHEN QT_APTOS > 0 AND QT_ABSTENCOES IS NOT NULL
        THEN CAST(QT_ABSTENCOES * 100.0 / QT_APTOS AS DECIMAL(5,2))
        ELSE NULL 
    END AS TX_ABSTENCAO,
    CASE 
        WHEN QT_COMPARECIMENTO > 0 AND QT_VOTOS_NOMINAIS IS NOT NULL
        THEN CAST(QT_VOTOS_NOMINAIS * 100.0 / QT_COMPARECIMENTO AS DECIMAL(5,2))
        ELSE NULL 
    END AS TX_VOTOS_NOMINAIS,
    CASE 
        WHEN QT_COMPARECIMENTO > 0 AND QT_VOTOS_LEGENDA IS NOT NULL
        THEN CAST(QT_VOTOS_LEGENDA * 100.0 / QT_COMPARECIMENTO AS DECIMAL(5,2))
        ELSE NULL 
    END AS TX_VOTOS_LEGENDA
FROM Fact_Votacao;
GO
PRINT 'View 1 criada: vw_Votacao_Com_Taxas'
GO

CREATE OR ALTER VIEW vw_Analise_Financeira_Campanhas AS
SELECT 
    c.Candidato_ID,
    c.NM_CANDIDATO,
    c.NR_CANDIDATO,
    p.SG_PARTIDO,
    p.NM_PARTIDO,
    car.DS_CARGO,
    u.SG_UF,
    u.NM_UF,
    u.Regiao,
    ISNULL(SUM(r.VR_RECEITA), 0) as Total_Receita,
    ISNULL(SUM(d.VR_DESPESA_CONTRATADA), 0) as Total_Despesa_Contratada,
    ISNULL(SUM(d.VR_PAGTO_DESPESA), 0) as Total_Despesa_Paga,
    ISNULL(SUM(r.VR_RECEITA), 0) - ISNULL(SUM(d.VR_DESPESA_CONTRATADA), 0) as Saldo_Financeiro,
    ISNULL(SUM(b.VR_BEM_CANDIDATO), 0) as Patrimonio_Total,
    COUNT(b.Bem_ID) as Qtde_Bens,
    c.DS_SIT_TOT_TURNO,
    CASE WHEN c.DS_SIT_TOT_TURNO LIKE '%ELEITO%' THEN 1 ELSE 0 END as Eleito
FROM Dim_Candidato c
JOIN Dim_Partido p ON c.Partido_ID = p.Partido_ID
JOIN Dim_Cargo car ON c.Cargo_ID = car.Cargo_ID
JOIN Dim_UF u ON c.UF_ID = u.UF_ID
LEFT JOIN Fact_Receitas r ON c.Candidato_ID = r.Candidato_ID
LEFT JOIN Fact_Despesas d ON c.Candidato_ID = d.Candidato_ID
LEFT JOIN Fact_Bens b ON c.Candidato_ID = b.Candidato_ID
GROUP BY 
    c.Candidato_ID, c.NM_CANDIDATO, c.NR_CANDIDATO, p.SG_PARTIDO, p.NM_PARTIDO,
    car.DS_CARGO, u.SG_UF, u.NM_UF, u.Regiao, c.DS_SIT_TOT_TURNO;
GO
PRINT 'View 2 criada: vw_Analise_Financeira_Campanhas'
GO

DROP TABLE IF EXISTS vw_Eficiencia_Partidaria;

CREATE TABLE vw_Eficiencia_Partidaria (
    Partido_ID INT,
    SG_PARTIDO NVARCHAR(20),
    NM_PARTIDO NVARCHAR(100),
    DS_CARGO NVARCHAR(50),
    SG_UF NVARCHAR(2),
    Regiao NVARCHAR(20),
    Total_Candidatos INT,
    Total_Eleitos INT,
    Total_Suplentes INT,
    Taxa_Sucesso DECIMAL(5,2),
    Receita_Media_Por_Candidato DECIMAL(15,2),
    Despesa_Media_Por_Candidato DECIMAL(15,2),
    Total_Votos_Nominais BIGINT,
    Total_Votos_Legenda BIGINT,
    Data_Atualizacao DATETIME DEFAULT GETDATE()
);
GO

INSERT INTO vw_Eficiencia_Partidaria (
    Partido_ID, SG_PARTIDO, NM_PARTIDO, DS_CARGO, SG_UF, Regiao,
    Total_Candidatos, Total_Eleitos, Total_Suplentes, Taxa_Sucesso,
    Receita_Media_Por_Candidato, Despesa_Media_Por_Candidato,
    Total_Votos_Nominais, Total_Votos_Legenda
)
SELECT 
    p.Partido_ID,
    p.SG_PARTIDO,
    p.NM_PARTIDO,
    car.DS_CARGO,
    u.SG_UF,
    u.Regiao,
    ec.Total_Candidatos,
    ec.Total_Eleitos,
    ec.Total_Suplentes,
    CASE 
        WHEN ec.Total_Candidatos > 0 
        THEN CAST(ec.Total_Eleitos * 100.0 / ec.Total_Candidatos AS DECIMAL(5,2))
        ELSE 0 
    END as Taxa_Sucesso,
    ISNULL(ef.Receita_Media_Por_Candidato, 0),
    ISNULL(ef.Despesa_Media_Por_Candidato, 0),
    ISNULL(ev.Total_Votos_Nominais, 0),
    ISNULL(ev.Total_Votos_Legenda, 0)
FROM Dim_Partido p
JOIN (
    SELECT 
        Partido_ID,
        Cargo_ID,
        UF_ID,
        COUNT(*) as Total_Candidatos,
        SUM(CASE WHEN DS_SIT_TOT_TURNO LIKE '%ELEITO%' THEN 1 ELSE 0 END) as Total_Eleitos,
        SUM(CASE WHEN DS_SIT_TOT_TURNO LIKE '%SUPLENTE%' THEN 1 ELSE 0 END) as Total_Suplentes
    FROM Dim_Candidato
    GROUP BY Partido_ID, Cargo_ID, UF_ID
) ec ON p.Partido_ID = ec.Partido_ID
JOIN Dim_Cargo car ON ec.Cargo_ID = car.Cargo_ID
JOIN Dim_UF u ON ec.UF_ID = u.UF_ID
LEFT JOIN (
    SELECT 
        c.Partido_ID,
        c.Cargo_ID,
        c.UF_ID,
        AVG(fin.Total_Receita) as Receita_Media_Por_Candidato,
        AVG(fin.Total_Despesa_Contratada) as Despesa_Media_Por_Candidato
    FROM Dim_Candidato c
    JOIN vw_Analise_Financeira_Campanhas fin ON c.Candidato_ID = fin.Candidato_ID
    GROUP BY c.Partido_ID, c.Cargo_ID, c.UF_ID
) ef ON p.Partido_ID = ef.Partido_ID AND ec.Cargo_ID = ef.Cargo_ID AND ec.UF_ID = ef.UF_ID
LEFT JOIN (
    SELECT 
        Partido_ID,
        Cargo_ID,
        SUM(QT_VOTOS_NOMINAIS) as Total_Votos_Nominais,
        SUM(QT_VOTOS_LEGENDA) as Total_Votos_Legenda
    FROM Fact_Votacao
    GROUP BY Partido_ID, Cargo_ID
) ev ON p.Partido_ID = ev.Partido_ID AND ec.Cargo_ID = ev.Cargo_ID;
GO

CREATE INDEX IX_vwEficiencia_PartidoCargo ON vw_Eficiencia_Partidaria (Partido_ID, DS_CARGO);
CREATE INDEX IX_vwEficiencia_UF ON vw_Eficiencia_Partidaria (SG_UF);
CREATE INDEX IX_vwEficiencia_Taxa ON vw_Eficiencia_Partidaria (Taxa_Sucesso DESC);
GO

CREATE OR ALTER VIEW vw_Perfil_Demografico_Candidatos AS
SELECT 
    c.DS_GENERO,
    c.DS_COR_RACA,
    c.DS_GRAU_INSTRUCAO,
    c.DS_OCUPACAO,
    car.DS_CARGO,
    u.Regiao,
    COUNT(*) as Total_Candidatos,
    SUM(CASE WHEN c.DS_SIT_TOT_TURNO LIKE '%ELEITO%' THEN 1 ELSE 0 END) as Total_Eleitos,
    SUM(CASE WHEN c.DS_SIT_TOT_TURNO LIKE '%SUPLENTE%' THEN 1 ELSE 0 END) as Total_Suplentes,
    CASE 
        WHEN COUNT(*) > 0 
        THEN CAST(SUM(CASE WHEN c.DS_SIT_TOT_TURNO LIKE '%ELEITO%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2))
        ELSE 0 
    END as Taxa_Eleicao,
    AVG(DATEDIFF(YEAR, c.DT_NASCIMENTO, GETDATE())) as Idade_Media,
    AVG(fin.Patrimonio_Total) as Patrimonio_Medio,
    AVG(fin.Total_Receita) as Receita_Media_Campanha
FROM Dim_Candidato c
JOIN Dim_Cargo car ON c.Cargo_ID = car.Cargo_ID
JOIN Dim_UF u ON c.UF_ID = u.UF_ID
LEFT JOIN vw_Analise_Financeira_Campanhas fin ON c.Candidato_ID = fin.Candidato_ID
WHERE c.DT_NASCIMENTO IS NOT NULL
GROUP BY 
    c.DS_GENERO, c.DS_COR_RACA, c.DS_GRAU_INSTRUCAO, c.DS_OCUPACAO, 
    car.DS_CARGO, u.Regiao;
GO
PRINT 'View 4 criada: vw_Perfil_Demografico_Candidatos'
GO

CREATE OR ALTER VIEW vw_Geografia_Eleitoral AS
SELECT 
    u.UF_ID,
    u.SG_UF,
    u.NM_UF,
    u.Regiao,
    m.Municipio_ID,
    m.NM_MUNICIPIO,
    car.Cargo_ID,
    car.DS_CARGO,
    t.Ano as Ano_Eleicao,
    SUM(v.QT_APTOS) as Total_Eleitores,
    SUM(v.QT_COMPARECIMENTO) as Total_Comparecimento,
    SUM(v.QT_ABSTENCOES) as Total_Abstencoes,
    SUM(v.QT_VOTOS_NOMINAIS) as Total_Votos_Nominais,
    SUM(v.QT_VOTOS_LEGENDA) as Total_Votos_Legenda,
    CASE 
        WHEN SUM(v.QT_APTOS) > 0 
        THEN CAST(SUM(v.QT_ABSTENCOES) * 100.0 / SUM(v.QT_APTOS) AS DECIMAL(5,2))
        ELSE NULL 
    END as Taxa_Abstencao,
    CASE 
        WHEN SUM(v.QT_COMPARECIMENTO) > 0 
        THEN CAST(SUM(v.QT_VOTOS_NOMINAIS) * 100.0 / SUM(v.QT_COMPARECIMENTO) AS DECIMAL(5,2))
        ELSE NULL 
    END as Taxa_Votos_Nominais,
    CASE 
        WHEN SUM(v.QT_COMPARECIMENTO) > 0 
        THEN CAST(SUM(v.QT_VOTOS_LEGENDA) * 100.0 / SUM(v.QT_COMPARECIMENTO) AS DECIMAL(5,2))
        ELSE NULL 
    END as Taxa_Votos_Legenda,
    RANK() OVER (PARTITION BY car.DS_CARGO, u.Regiao ORDER BY SUM(v.QT_COMPARECIMENTO) * 100.0 / SUM(v.QT_APTOS) DESC) as Ranking_Participacao
FROM Fact_Votacao v
JOIN Dim_Municipio m ON v.Municipio_ID = m.Municipio_ID
JOIN Dim_UF u ON m.UF_ID = u.UF_ID
JOIN Dim_Cargo car ON v.Cargo_ID = car.Cargo_ID
JOIN Dim_Tempo t ON v.Data_ID = t.Data_ID
GROUP BY 
    u.UF_ID, u.SG_UF, u.NM_UF, u.Regiao, m.Municipio_ID, m.NM_MUNICIPIO,
    car.Cargo_ID, car.DS_CARGO, t.Ano;
GO
PRINT 'View 5 criada: vw_Geografia_Eleitoral'
GO