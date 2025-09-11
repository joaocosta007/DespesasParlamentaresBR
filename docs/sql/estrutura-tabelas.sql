-- TABELAS DE DIMENSÃO - sem dependências de chaves estrangeiras
CREATE TABLE DimDeputado (
id_deputado INT PRIMARY KEY,
nome_deputado VARCHAR(255) NOT NULL,
uf VARCHAR(2) NOT NULL,
url_foto VARCHAR(255) NOT NULL
);

CREATE TABLE DimCategoriaDespesa (
id_categoria INT PRIMARY KEY,
nome_categoria VARCHAR(100) NOT NULL
);

CREATE TABLE DimVotacao (
id_votacao INT PRIMARY KEY,
descricao_votacao VARCHAR(255) NOT NULL,
tema VARCHAR(255) NOT NULL
);

CREATE TABLE DimSetor (
id_setor INT PRIMARY KEY,
descricao_cnae VARCHAR(255) NOT NULL,
sub_setor VARCHAR(255) NOT NULL
);

CREATE TABLE DimTempo (
id_data INT PRIMARY KEY,
data_completa DATE NOT NULL,
dia INT NOT NULL,
ano INT NOT NULL,
mes INT NOT NULL,
nome_mes VARCHAR(20) NOT NULL,
trimestre INT NOT NULL,
semestre INT NOT NULL,
ano_eleitoral BIT NOT NULL
);

CREATE TABLE DimPartido (
id_partido INT PRIMARY KEY,
sigla VARCHAR(10) NOT NULL,
nome VARCHAR(100) NOT NULL
);

CREATE TABLE DimLegislatura (
id_legislatura INT PRIMARY KEY,
ano_incio INT NOT NULL,
ano_fim INT NOT NULL
);

-- TABELAS QUE DEPENDEM DE OUTRAS TABELAS
CREATE TABLE DimFornecedor (
id_fornecedor INT PRIMARY KEY,
nome_fornecedor VARCHAR(255) NOT NULL,
cnpj VARCHAR(20) NOT NULL,
id_setor INT NOT NULL,
uf VARCHAR(2) NOT NULL,
FOREIGN KEY (id_setor) REFERENCES DimSetor (id_setor)
);

CREATE TABLE FatoGastoParlamentar (
id_gasto INT PRIMARY KEY,
id_deputado INT NOT NULL,
id_fornecedor INT NOT NULL,
id_categoria INT NOT NULL,
id_data INT NOT NULL,
valor_gasto DECIMAL(18,2) NOT NULL,
tipo_despesa VARCHAR(100) NOT NULL,
numero_documento VARCHAR(50) NOT NULL,
FOREIGN KEY (id_deputado) REFERENCES DimDeputado(id_deputado),
FOREIGN KEY (id_fornecedor) REFERENCES DimFornecedor(id_fornecedor),
FOREIGN KEY (id_data) REFERENCES DimTempo(id_data),
FOREIGN KEY (id_categoria) REFERENCES DimCategoriaDespesa(id_categoria)
);

CREATE TABLE FatoVotacaoPresenca (
id_votacaoPresenca INT PRIMARY KEY,
id_deputado INT NOT NULL,
id_data INT NOT NULL,
id_votacao INT NOT NULL,
voto VARCHAR(50) NOT NULL,
presenca VARCHAR(50) NOT NULL,
FOREIGN KEY (id_deputado) REFERENCES DimDeputado (id_deputado),
FOREIGN KEY (id_data) REFERENCES DimTempo (id_data),
FOREIGN KEY (id_votacao) REFERENCES DimVotacao (id_votacao)
);

CREATE TABLE BridgeDeputadoLegislaturaPartido (
id_bridge INT PRIMARY KEY,
id_deputado INT NOT NULL,
id_partido INT NOT NULL,
data_inicio DATE NOT NULL,
data_fim DATE NOT NULL,
id_legislatura INT NOT NULL,
FOREIGN KEY (id_deputado) REFERENCES DimDeputado (id_deputado),
FOREIGN KEY (id_partido) REFERENCES DimPartido (id_partido),
FOREIGN KEY (id_legislatura) REFERENCES DimLegislatura (id_legislatura)
);
