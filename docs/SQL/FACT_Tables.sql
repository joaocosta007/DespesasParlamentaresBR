USE Analise_Gastos

CREATE TABLE FatoGastoParlamentar (

    ID_Gasto            BIGINT IDENTITY(1,1) PRIMARY KEY,
    ID_Deputado_FK      INT             NOT NULL,
    ID_Fornecedor_FK    INT             NOT NULL,
    ID_Categoria_FK     INT             NOT NULL,
    ID_Tempo_FK         INT             NOT NULL,
    Valor               DECIMAL(18,2)   NOT NULL, 
    ID_Fonte_Origem     INT             NOT NULL, 
    NumDocumento        VARCHAR(50),
       -- CONSTRAINT FK_FatoGasto_Deputado FOREIGN KEY (ID_Deputado_FK)
       --     REFERENCES DimDeputado (ID_Deputado),
       -- CONSTRAINT FK_FatoGasto_Fornecedor FOREIGN KEY (ID_Fornecedor_FK)
      --      REFERENCES DimFornecedor (ID_Fornecedor),
      --  CONSTRAINT FK_FatoGasto_Categoria FOREIGN KEY (ID_Categoria_FK)
       --     REFERENCES DimCategoriaDespesa (ID_Categoria),
      --  CONSTRAINT FK_FatoGasto_Tempo FOREIGN KEY (ID_Tempo_FK)
       --     REFERENCES DimTempo (ID_Tempo)

);

CREATE NONCLUSTERED INDEX IX_FatoGasto_Lookup 
            ON FatoGastoParlamentar (ID_Tempo_FK, ID_Deputado_FK, ID_Fornecedor_FK)

CREATE TABLE FatoVotacaoPresenca (

    ID_Registro     BIGINT IDENTITY(1,1) PRIMARY KEY,
    ID_Deputado_FK  INT             NOT NULL,
    ID_Tempo_FK     INT             NOT NULL,
    ID_Votacao_FK   INT             NOT NULL,
    Presenca        VARCHAR(10)     NOT NULL,
    Voto            VARCHAR(50),

      --  CONSTRAINT FK_FatoVotacao_Deputado FOREIGN KEY (ID_Deputado_FK)
      --      REFERENCES DimDeputado (ID_Deputado),
      --  CONSTRAINT FK_FatoVotacao_Tempo FOREIGN KEY (ID_Tempo_FK)
      --      REFERENCES DimTempo (ID_Tempo),
      --  CONSTRAINT FK_FatoVotacao_Votacao FOREIGN KEY (ID_Votacao_FK)
       --     REFERENCES DimVotacao (ID_Votacao),
        
);