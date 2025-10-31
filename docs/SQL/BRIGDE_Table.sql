USE Analise_Gastos

CREATE TABLE BridgeDeputadoLegislaturaPartido (

    ID_Registro             INT IDENTITY(1,1) PRIMARY KEY,
    ID_Deputado_FK          INT     NOT NULL,
    ID_Partido_FK           INT     NOT NULL,
    ID_Legislatura_FK       INT     NOT NULL,
    DataInicio              DATE    NOT NULL,
    DataFim                 DATE,

       -- CONSTRAINT FK_Bridge_Deputado FOREIGN KEY (ID_Deputado_FK)
           -- REFERENCES DimDeputado (ID_Deputado),
        --CONSTRAINT FK_Bridge_Partido FOREIGN KEY (ID_Partido_FK)
         --   REFERENCES DimPartido (ID_Partido),
       -- CONSTRAINT FK_Bridge_Legislatura FOREIGN KEY (ID_Legislatura_FK)
         --   REFERENCES DimLegislatura (ID_Legislatura)

);