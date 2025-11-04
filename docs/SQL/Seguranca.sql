PRINT 'Criando Perfil 1: db_administrador...';

CREATE ROLE db_administrador;
PRINT 'Perfil db_administrador criado!';

GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_Tempo TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_UF TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_Cargo TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_Partido TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_Municipio TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_Candidato TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_Fornecedor TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_Doador TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_Tipo_Despesa TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_Tipo_Despesa_Contratada TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Dim_Tipo_Receita TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Fact_Votacao TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Fact_Receitas TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Fact_Despesas TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Fact_Bens TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON vw_Eficiencia_Partidaria TO db_administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Auditoria_Receitas TO db_administrador;

GRANT EXECUTE ON sp_Atualizar_Candidato TO db_administrador;
GRANT EXECUTE ON sp_Inserir_Receita TO db_administrador;
GRANT EXECUTE ON sp_Excluir_Despesa TO db_administrador;
GRANT EXECUTE ON sp_Ranking_Partidos TO db_administrador;
GRANT EXECUTE ON sp_Custo_Por_Voto TO db_administrador;
GRANT EXECUTE ON fn_Calcular_Faixa_Etaria TO db_administrador;
GRANT EXECUTE ON fn_Classificar_Patrimonio TO db_administrador;

PRINT 'Permissões concedidas ao db_administrador!';

PRINT 'Criando Perfil 2: db_analista...';

CREATE ROLE db_analista;
PRINT 'Perfil db_analista criado!';

GRANT SELECT ON Dim_Tempo TO db_analista;
GRANT SELECT ON Dim_UF TO db_analista;
GRANT SELECT ON Dim_Cargo TO db_analista;
GRANT SELECT ON Dim_Partido TO db_analista;
GRANT SELECT ON Dim_Municipio TO db_analista;
GRANT SELECT ON Dim_Candidato TO db_analista;
GRANT SELECT ON Dim_Fornecedor TO db_analista;
GRANT SELECT ON Dim_Doador TO db_analista;
GRANT SELECT ON Dim_Tipo_Despesa TO db_analista;
GRANT SELECT ON Dim_Tipo_Despesa_Contratada TO db_analista;
GRANT SELECT ON Dim_Tipo_Receita TO db_analista;
GRANT SELECT ON Fact_Votacao TO db_analista;
GRANT SELECT ON Fact_Receitas TO db_analista;
GRANT SELECT ON Fact_Despesas TO db_analista;
GRANT SELECT ON Fact_Bens TO db_analista;
GRANT SELECT ON vw_Eficiencia_Partidaria TO db_analista;
GRANT SELECT ON Auditoria_Receitas TO db_analista;

GRANT EXECUTE ON sp_Atualizar_Candidato TO db_analista;
GRANT EXECUTE ON sp_Inserir_Receita TO db_analista;
GRANT EXECUTE ON sp_Excluir_Despesa TO db_analista;
GRANT EXECUTE ON sp_Ranking_Partidos TO db_analista;
GRANT EXECUTE ON sp_Custo_Por_Voto TO db_analista;
GRANT EXECUTE ON fn_Calcular_Faixa_Etaria TO db_analista;
GRANT EXECUTE ON fn_Classificar_Patrimonio TO db_analista;

GRANT SELECT ON vw_Votacao_Com_Taxas TO db_analista;
GRANT SELECT ON vw_Analise_Financeira_Campanhas TO db_analista;
GRANT SELECT ON vw_Eficiencia_Partidaria TO db_analista;
GRANT SELECT ON vw_Perfil_Demografico_Candidatos TO db_analista;
GRANT SELECT ON vw_Geografia_Eleitoral TO db_analista;

PRINT 'Permissões concedidas ao db_analista!';

PRINT 'Criando Perfil 3: db_consulta_basica...';

CREATE ROLE db_consulta_basica;
PRINT 'Perfil db_consulta_basica criado!';

GRANT SELECT ON vw_Votacao_Com_Taxas TO db_consulta_basica;
GRANT SELECT ON vw_Analise_Financeira_Campanhas TO db_consulta_basica;
GRANT SELECT ON vw_Eficiencia_Partidaria TO db_consulta_basica;
GRANT SELECT ON vw_Perfil_Demografico_Candidatos TO db_consulta_basica;
GRANT SELECT ON vw_Geografia_Eleitoral TO db_consulta_basica;

GRANT EXECUTE ON sp_Ranking_Partidos TO db_consulta_basica;
GRANT EXECUTE ON sp_Custo_Por_Voto TO db_consulta_basica;

PRINT 'Permissões concedidas ao db_consulta_basica!';