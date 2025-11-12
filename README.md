 # [**BACKUP <- CLIQUE AQUI**](https://drive.google.com/file/d/1FtKeq2PcvFYq1RvIJfTwpL3ouF4ARk5o/view?usp=sharing)
#[POWER BI](https://drive.google.com/drive/folders/1QBW0c7N6BobvXvFN52fycvkYf2-JrYpw?usp=drive_link)
# 🇧🇷 Análise Eleitoral Brasileira — SQL Server

> **Projeto Acadêmico • Data Warehouse • SQL Server**  
> Implementação completa de um **data warehouse** para análise do comportamento eleitoral no Brasil, utilizando exclusivamente **SQL Server**.  
> O projeto demonstra **proficiência em engenharia de dados**, da modelagem dimensional à geração de **insights estratégicos** sobre o cenário político nacional.

---

##  Visão Geral

A análise eleitoral é um desafio de **alta escala e complexidade**, envolvendo milhões de registros e múltiplas fontes.  
Este projeto transforma **dados brutos do TSE** em um **modelo analítico otimizado**, capaz de responder a **perguntas estratégicas** sobre:

- Eficiência partidária  
- Perfil dos candidatos eleitos  
- Geografia e padrões regionais  
- Evolução temporal e ciclos políticos  

---

##  Problema de Negócio

> Como transformar dados eleitorais massivos em **informações estratégicas** para entender o comportamento político brasileiro?

A partir dessa pergunta, o projeto explora **padrões de votação**, **eficiência partidária** e **fatores determinantes de sucesso eleitoral**, otimizando a análise por meio de um **modelo dimensional escalável**.

---

##  Perguntas Estratégicas

###  Eficiência Partidária
- Qual a taxa de conversão candidatura → eleição por partido?  
- Qual o custo médio por voto conquistado?  
- Partidos focam em muitos candidatos ou poucos com mais recursos?

###  Perfil do Candidato Ideal
- Quais características demográficas são mais comuns entre os eleitos?  
- Qual o impacto da escolaridade, gênero e idade no sucesso eleitoral?  
- Existem diferenças regionais no perfil vencedor?

###  Geografia Eleitoral
- Quais são as fortalezas regionais de cada partido?  
- Como varia o voto nominal vs legenda?  
- Há padrões distintos entre áreas urbanas e rurais?

###  Evolução Temporal
- Como evoluem os ciclos partidários ao longo dos anos?  
- Mudou o perfil do eleitorado entre diferentes eleições?  
- Quais fatores externos impactam o comportamento eleitoral?

---

##  Métricas-Chave

| Métrica                         | Descrição                                                                 |
|---------------------------------|---------------------------------------------------------------------------|
| **Taxa de sucesso eleitoral**   | Proporção de candidatos eleitos por partido                               |
| **Custo por voto**              | Eficiência financeira das campanhas                                       |
| **ROI eleitoral**               | Relação entre gastos e resultados obtidos                                |
| **Diversidade representativa**  | Análise de gênero, escolaridade e idade entre eleitos                    |
| **Volatilidade regional**       | Variação do comportamento eleitoral entre regiões                        |

---

##  Arquitetura e Coleta de Dados

###  Fontes
- **Candidatos 2022** — Dados completos de todos os candidatos  
- **Votação 2022** — Resultados por seção eleitoral  
- **Prestação de Contas** — Receitas e despesas de campanha  

> **+100 milhões de registros** processados e consolidados em um **modelo estrela**.

###  Estrutura do Data Warehouse
- **Fact_Votacao** — 1.8M registros agregados (de 98M originais)  
- **Fact_Receitas** — Transações financeiras  
- **Fact_Despesas** — Gastos detalhados  
- **Fact_Bens** — Patrimônio declarado  

###  Objetos Programáticos
- 5 **Views** (ex: `vw_Eficiencia_Partidaria`, `vw_Analise_Financeira_Campanhas`)  
- 5 **Stored Procedures** (3 ETL/CRUD + 2 analíticas)  
- 2 **Functions** (classificação de idade e patrimônio)  
- 2 **Triggers** (auditoria e validação de dados)  
- 3 **Perfis de Segurança** (`Administrador`, `Analista`, `Consulta`)

---

##  Otimizações de Performance

- Índices **covering** para consultas complexas  
- **Tabelas materializadas** para agregações pesadas  
- **Particionamento estratégico** de dados  
- Redução de **98M → 1.8M registros** na *Fact_Votacao*

---

##  Roadmap do Projeto

| Fase | Etapa | Status |
|------|-------|--------|
| **1** | Modelagem e Análise Exploratória |  Concluída |
| **2** | Implementação e ETL |  Concluída |
| **3** | Desenvolvimento Analítico |  Concluída |
| **4** | Documentação e Entrega |  Em andamento |

 Acompanhamento via **Kanban (Constraint)**  
 Repositório completo disponível no GitHub

---

##  Próximos Passos

- [ ] Incluir dados de múltiplos anos  
- [ ] Desenvolver dashboard interativo em **Power BI**  
- [ ] Aplicar **Machine Learning** para previsão eleitoral  
- [ ] Integrar dados de redes sociais dos candidatos  
- [ ] Expandir para eleições municipais  

---

##  Como Contribuir

Quer expandir esta análise?  
Sinta-se à vontade para **abrir uma _issue_ ou _pull request_**   
Consulte a **documentação técnica** para entender a estrutura completa do projeto.

---

##  Tecnologias Utilizadas

| Categoria | Ferramentas |
|------------|-------------|
| **Banco de Dados** | SQL Server |
| **Linguagem** | T-SQL |
| **Modelagem** | Data Warehouse (Esquema Estrela) |
| **ETL** | T-SQL Scripts |
| **Dados** | Tribunal Superior Eleitoral (TSE) |
| **Volume** | +100 milhões de registros (Eleições 2022) |

---

## 📎 Backup e Repositório

**Backup:** [Google Drive](https://drive.google.com/drive/folders/1bYgCf3rgoq-W2OIE1EEgS0Y0G5cn-WR1?usp=sharing)

---

##  Resultado Esperado

Um **ecossistema analítico robusto**, capaz de:
- Suportar análises políticas complexas  
- Gerar insights estratégicos para estudos eleitorais  
- Servir como **base escalável** para futuras análises com BI e IA  

---

> Desenvolvido por **Enzo Giuliano Cardoso Santana, Lucas dos Santos Garreto, Ryan Markus Maciel Araujo, João Pedro Pirani e Victor Will dos Santos**  
>  Ciência de Dados • Engenharia de Dados • SQL Server
