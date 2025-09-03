# Projeto: Engenharia e Análise de Dados com T-SQL

### Visão geral
Este projeto acadêmico simula um pipeline de dados completo, do levantamento de requisitos à entrega de insights, utilizando exclusivamente T-SQL. O objetivo é demonstrar proficiência em engenharia de dados, cobrindo modelagem dimensional, processos de ETL, otimização de consultas e implementação de segurança. O tema escolhido, a análise dos gastos parlamentares no Brasil, oferece um cenário real e desafiador.

---

### O PROBLEMA DE NEGÓCIO
O projeto se concentra no impacto econômico da Cota para o Exercício da Atividade Parlamentar (CEAP). Embora a transparência seja essencial, a análise dos dados brutos é complexa. O desafio aqui é transformar dados fragmentados de diversas fontes públicas em um modelo de banco de dados analítico, capaz de responder a perguntas estratégicas e revelar padrões de gastos, concentração de mercado e correlações de comportamento.

### PERGUNTAS DE NEGÓCIO
As seguintes perguntas guiaram a modelagem e a análise dos dados:
- Quem são os maiores fornecedores dos deputados?
- Quais setores econômicos mais lucram com a cota parlamentar (via CNAE)?
- Há concentração de mercado (poucas empresas dominam)?
- Quais partidos/estados concentram mais gastos em determinados setores?
- Existe sazonalidade nos gastos (ex.: anos eleitorais)?
- Deputados mais gastadores em publicidade têm comportamento diferente em votações/presenças?
- Empresas fornecedoras atuam em vários estados ou se concentram em regiões específicas?

---

### ARQUITETURA E COLETA DE DADOS
Este projeto utiliza um conjunto de dados robusto, com mais de 200.000 registros. A solução foi arquitetada em um esquema em estrela (star schema) para otimizar as consultas analíticas.

#### Fontes e Processo de Coleta
A coleta de dados foi um processo manual e cuidadoso, garantindo a integração de informações de diferentes origens para uma análise completa. As principais fontes e como os dados foram obtidos são detalhados abaixo:
- **Cota Parlamentar - Brasil.io:** A fonte principal de dados sobre despesas parlamentares. Os dados foram baixados como um arquivo CSV, contendo informações detalhadas sobre cada despesa, como valor, tipo de gasto e o fornecedor.
- **Câmara dos Deputados - Dados Abertos:** Para obter informações sobre os deputados, como o nome completo, o partido e o estado, utilizamos a API de Dados Abertos da Câmara. O processo envolveu consultar a API para cada legislatura e extrair os dados relevantes, que foram salvos em formato JSON e, em seguida, transformados em um formato tabular para o carregamento no banco de dados.
- **Receita Federal - CNPJs:** Para a análise setorial, a classificação dos fornecedores por setor econômico (CNAE) foi crucial. As informações de CNPJ foram cruzadas com um conjunto de dados públicos da Receita Federal, obtido em formato CSV de uma fonte externa, que relaciona CNPJs a seus respectivos CNAEs.

---

### MODELAGEM DE DADOS
O modelo de dados lógico foi traduzido para um modelo físico, otimizado para um ambiente de data warehouse (OLAP).
- **Esquema em Estrela:** O modelo é centrado nas tabelas de fato `FatoGastoParlamentar` e `FatoVotacaoPresenca`, que se conectam diretamente a dimensões como `DimDeputado`, `DimFornecedor`, `DimTempo`, etc.
- **Tabela de Ponte:** A complexidade da afiliação partidária, que pode mudar ao longo do tempo, foi resolvida com uma tabela de ponte (`BridgeDeputadoLegislaturaPartido`). Isso garante a precisão histórica ao associar cada gasto à afiliação partidária correta no momento da despesa.
- **Dimensões Conformadas:** As dimensões `DimDeputado` e `DimTempo` são compartilhadas entre as duas tabelas de fato, permitindo a análise de correlação entre os gastos e o comportamento de votação e presença dos deputados.

### REQUISITOS TÉCNICOS E IMPLEMENTAÇÃO
Todo o projeto foi desenvolvido estritamente em T-SQL, seguindo os requisitos acadêmicos.
- **Processo de ETL:** Implementado via Stored Procedures e scripts T-SQL para a ingestão, limpeza e carga dos dados.
- **Objetos Programáticos:**
  - 5 Views para análises pré-agregadas.
  - 5 Stored Procedures (3 de ETL/CRUD e 2 analíticas).
  - 2 Functions para lógicas de negócio específicas.
  - 2 Triggers para validação e auditoria.
- **Segurança (DCL):** Criação de 3 perfis de acesso (Roles) distintos para simular um ambiente de produção.
- **Documentação:** Dicionário de dados completo e manual de uso das rotinas.
- **Versionamento:** Todo o código SQL e a documentação serão versionados no GitHub, com o acompanhamento de tarefas via quadro Trello.

---

### Roadmap do Projeto
Este é um resumo do nosso planejamento, detalhando as fases do projeto para acompanhamento do progresso:
https://trello.com/invite/b/68a77556870866ca5480bb13/ATTI39e00b260e3e3ee2a0d8ecb67ed4329cEB4CE16C/constraint 

1.  **Fase 1: Modelagem Dimensional (Concluída)**
    - Definição das perguntas de negócio.
    - Análise e extração das fontes de dados.
    - Criação do modelo lógico e físico.
    - Estruturação do repositório no GitHub e elaboração do `README.md`.

2.  **Fase 2: Implementação e ETL (Em Andamento)**
    - Criação do banco de dados e das tabelas.
    - Desenvolvimento dos scripts e stored procedures de ETL.
    - Ingestão, tratamento e carga dos dados.
    - Implementação dos objetos programáticos (Views, Functions, Triggers).

3.  **Fase 3: Análise e Visualização (Próxima Etapa)**
    - Execução de queries analíticas para responder às perguntas de negócio.
    - Criação de dashboards e relatórios para visualização dos dados.
    - Geração de insights e conclusões para o estudo de caso.

---

### COMO CONTRIBUIR
Interessado em ajudar a tornar este projeto ainda mais robusto? Sinta-se à vontade para abrir uma issue ou um pull request. Leia o nosso manual de contribuição para saber mais sobre como começar.

---

### **Dicionário de Dados**

Este dicionário descreve as tabelas, colunas, tipos de dados e a finalidade de cada elemento no banco de dados analítico do projeto.

---

**FatoGastoParlamentar**
- **GastoID:** `INT` - Chave primária. Identificador único de cada despesa.
- **DeputadoID:** `INT` - Chave estrangeira para a tabela `DimDeputado`.
- **FornecedorID:** `INT` - Chave estrangeira para a tabela `DimFornecedor`.
- **DataID:** `INT` - Chave estrangeira para a tabela `DimTempo`.
- **ValorGasto:** `DECIMAL(18,2)` - Valor total da despesa.
- **TipoDespesa:** `VARCHAR(100)` - Categoria da despesa (ex.: "DIVULGACAO DA ATIVIDADE PARLAMENTAR").
- **NumeroDocumento:** `VARCHAR(50)` - Número do documento fiscal da despesa.

---

**FatoVotacaoPresenca**
- **VotacaoPresencaID:** `INT` - Chave primária. Identificador único de cada registro de voto/presença.
- **DeputadoID:** `INT` - Chave estrangeira para a tabela `DimDeputado`.
- **DataID:** `INT` - Chave estrangeira para a tabela `DimTempo`.
- **Voto:** `VARCHAR(50)` - Voto do deputado (ex.: "Sim", "Não", "Abstenção").
- **Presenca:** `VARCHAR(50)` - Status de presença do deputado (ex.: "Presente", "Ausente").

---

**DimDeputado**
- **DeputadoID:** `INT` - Chave primária. Identificador único do deputado.
- **NomeDeputado:** `VARCHAR(255)` - Nome completo do deputado.
- **UF:** `VARCHAR(2)` - Unidade Federativa do deputado (ex.: "SP", "RJ").
- **URLFoto:** `VARCHAR(255)` - Link para a foto do deputado.

---

**DimFornecedor**
- **FornecedorID:** `INT` - Chave primária. Identificador único do fornecedor.
- **NomeFornecedor:** `VARCHAR(255)` - Nome ou razão social do fornecedor.
- **CNPJ:** `VARCHAR(20)` - CNPJ do fornecedor.
- **SetorCNAE:** `VARCHAR(255)` - Setor econômico do fornecedor.

---

**DimTempo**
- **DataID:** `INT` - Chave primária. Formato `YYYYMMDD`.
- **DataCompleta:** `DATE` - Data completa.
- **Ano:** `INT` - Ano da despesa.
- **Mes:** `INT` - Mês da despesa.
- **NomeMes:** `VARCHAR(20)` - Nome do mês.
- **Trimestre:** `INT` - Trimestre do ano.
- **Semestre:** `INT` - Semestre do ano.

---

**BridgeDeputadoLegislaturaPartido**
- **BridgeID:** `INT` - Chave primária. Identificador único da relação.
- **DeputadoID:** `INT` - Chave estrangeira para a tabela `DimDeputado`.
- **PartidoID:** `INT` - Chave estrangeira para a tabela de dimensão de partidos (a ser criada).
- **DataInicio:** `DATE` - Data de início da afiliação do deputado ao partido.
- **DataFim:** `DATE` - Data de término da afiliação.

