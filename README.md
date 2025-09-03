Projeto: Engenharia e Análise de Dados com T-SQL

    Visão geral: Este projeto acadêmico simula um pipeline de dados completo, do levantamento de requisitos à entrega de insights, utilizando exclusivamente T-SQL. O objetivo é demonstrar proficiência em engenharia de dados, cobrindo modelagem dimensional, processos de ETL, otimização de consultas e implementação de segurança. O tema escolhido, a análise dos gastos parlamentares no Brasil, oferece um cenário real e desafiador.

O PROBLEMA DE NEGÓCIO

O projeto se concentra no impacto econômico da Cota para o Exercício da Atividade Parlamentar (CEAP). Embora a transparência seja essencial, a análise dos dados brutos é complexa. O desafio aqui é transformar dados fragmentados de diversas fontes públicas em um modelo de banco de dados analítico, capaz de responder a perguntas estratégicas e revelar padrões de gastos, concentração de mercado e correlações de comportamento.

PERGUNTAS DE NEGÓCIO

As seguintes perguntas guiaram a modelagem e a análise dos dados:

    Quem são os maiores fornecedores dos deputados?

    Quais setores econômicos mais lucram com a cota parlamentar (via CNAE)?

    Há concentração de mercado (poucas empresas dominam)?

    Quais partidos/estados concentram mais gastos em determinados setores?

    Existe sazonalidade nos gastos (ex.: anos eleitorais)?

    Deputados mais gastadores em publicidade têm comportamento diferente em votações/presenças?

    Empresas fornecedoras atuam em vários estados ou se concentram em regiões específicas?

ARQUITETURA E COLETA DE DADOS

Este projeto utiliza um conjunto de dados robusto, com mais de 200.000 registros. A solução foi arquitetada em um esquema em estrela (star schema) para otimizar as consultas analíticas.

Fontes e Processo de Coleta

A coleta de dados foi um processo manual e cuidadoso, garantindo a integração de informações de diferentes origens para uma análise completa. As principais fontes e como os dados foram obtidos são detalhados abaixo:

    Cota Parlamentar - Brasil.io: A fonte principal de dados sobre despesas parlamentares. Os dados foram baixados como um arquivo CSV, contendo informações detalhadas sobre cada despesa, como valor, tipo de gasto e o fornecedor.

    Câmara dos Deputados - Dados Abertos: Para obter informações sobre os deputados, como o nome completo, o partido e o estado, utilizamos a API de Dados Abertos da Câmara. O processo envolveu consultar a API para cada legislatura e extrair os dados relevantes, que foram salvos em formato JSON e, em seguida, transformados em um formato tabular para o carregamento no banco de dados.

    Receita Federal - CNPJs: Para a análise setorial, a classificação dos fornecedores por setor econômico (CNAE) foi crucial. As informações de CNPJ foram cruzadas com um conjunto de dados públicos da Receita Federal, obtido em formato CSV de uma fonte externa, que relaciona CNPJs a seus respectivos CNAEs.

MODELAGEM DE DADOS

O modelo de dados lógico foi traduzido para um modelo físico, otimizado para um ambiente de data warehouse (OLAP).

    Esquema em Estrela: O modelo é centrado nas tabelas de fato FatoGastoParlamentar e FatoVotacaoPresenca, que se conectam diretamente a dimensões como DimDeputado, DimFornecedor, DimTempo, etc.

    Tabela de Ponte: A complexidade da afiliação partidária, que pode mudar ao longo do tempo, foi resolvida com uma tabela de ponte (BridgeDeputadoLegislaturaPartido). Isso garante a precisão histórica ao associar cada gasto à afiliação partidária correta no momento da despesa.

    Dimensões Conformadas: As dimensões DimDeputado e DimTempo são compartilhadas entre as duas tabelas de fato, permitindo a análise de correlação entre os gastos e o comportamento de votação e presença dos deputados.

REQUISITOS TÉCNICOS E IMPLEMENTAÇÃO

Todo o projeto foi desenvolvido estritamente em T-SQL, seguindo os requisitos acadêmicos.

    Processo de ETL: Implementado via Stored Procedures e scripts T-SQL para a ingestão, limpeza e carga dos dados.

    Objetos Programáticos:

        5 Views para análises pré-agregadas.

        5 Stored Procedures (3 de ETL/CRUD e 2 analíticas).

        2 Functions para lógicas de negócio específicas.

        2 Triggers para validação e auditoria.

    Segurança (DCL): Criação de 3 perfis de acesso (Roles) distintos para simular um ambiente de produção.

    Documentação: Dicionário de dados completo e manual de uso das rotinas.

    Versionamento: Todo o código SQL e a documentação serão versionados no GitHub, com o acompanhamento de tarefas via quadro Trello.

COMO CONTRIBUIR

Interessado em ajudar a tornar este projeto ainda mais robusto? Sinta-se à vontade para abrir uma issue ou um pull request. Leia o nosso manual de contribuição para saber mais sobre como começar.
