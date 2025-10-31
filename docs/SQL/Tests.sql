USE Analise_Gastos

SELECT 
    f.name AS TabelaFilha,
    c.name AS ColunaFilha,
    tp.name AS TabelaPai,
    cp.name AS ColunaPai
FROM 
    sys.foreign_keys AS fk
INNER JOIN 
    sys.foreign_key_columns AS fkc ON fkc.constraint_object_id = fk.object_id
INNER JOIN 
    sys.tables AS f ON f.object_id = fkc.parent_object_id
INNER JOIN 
    sys.columns AS c ON c.object_id = f.object_id AND c.column_id = fkc.parent_column_id
INNER JOIN 
    sys.tables AS tp ON tp.object_id = fkc.referenced_object_id
INNER JOIN 
    sys.columns AS cp ON cp.object_id = tp.object_id AND cp.column_id = fkc.referenced_column_id
WHERE 
    f.name IN ('FatoGastoParlamentar', 'FatoVotacaoPresenca', 'BridgeDeputadoLegislaturaPartido');

-- O resultado deve mostrar todas as suas FKs (ID_Deputado_FK, ID_Tempo_FK, etc.)



BEGIN TRY
    INSERT INTO FatoGastoParlamentar (ID_Deputado_FK, ID_Fornecedor_FK, ID_Categoria_FK, ID_Tempo_FK, Valor, ID_Fonte_Origem)
    VALUES (99999, 1, 1, 20251030, 100.00, 1);
    
    PRINT 'ERRO: A FOREIGN KEY falhou! A inserção funcionou, mas não deveria.';
END TRY
BEGIN CATCH
    PRINT 'SUCESSO: A FOREIGN KEY bloqueou a inserção inválida. (Erro: ' + ERROR_MESSAGE() + ')';
END CATCH



SELECT 
    t.name AS NomeTabela,
    c.name AS NomeColuna,
    c.is_nullable AS PermiteNulo
FROM 
    sys.columns c
INNER JOIN 
    sys.tables t ON t.object_id = c.object_id
WHERE 
    t.name IN ('DimDeputado', 'DimFornecedor', 'DimSetor') 
    AND c.name IN ('ideCadastro_Negocio', 'CNPJ_CPF', 'CodCNAE');

-- Verifique se 'PermiteNulo' é 0 (FALSE) e se a coluna tem uma restrição UNIQUE.

SELECT 
    name, 
    precision, 
    scale 
FROM 
    sys.columns 
WHERE 
    object_id = OBJECT_ID('FatoGastoParlamentar') 
    AND name = 'Valor';

-- O resultado deve ser 'Valor' com precision 18 e scale 2 (DECIMAL(18,2)).

SELECT 
    t.name AS NomeTabela,
    i.name AS NomeIndice,
    i.type_desc AS TipoIndice -- Deve ser CLUSTERED para a PK
FROM 
    sys.indexes i
INNER JOIN 
    sys.tables t ON t.object_id = i.object_id
WHERE 
    i.is_primary_key = 1
    AND t.name IN ('DimDeputado', 'FatoGastoParlamentar', 'DimTempo');

-- Todos devem ter um índice e o TipoIndice deve ser CLUSTERED (a menos que você tenha definido como NONCLUSTERED).