# Plano de testes funcionais - API ServeRest

## 1. Objetivo

Validar os principais fluxos funcionais da API ServeRest por meio de testes automatizados de API, garantindo cobertura para login, usuarios, produtos e carrinhos em cenarios positivos e negativos.

O projeto tambem tem como objetivo demonstrar uma estrutura de testes documentada, rastreavel e executavel em pipeline, com relatorio HTML publicado automaticamente pelo GitHub Pages.

## 2. Escopo

Entram no escopo desta suite:

- Login com credenciais validas e invalidas.
- Cadastro, consulta, edicao e exclusao de usuarios.
- Validacoes especificas de usuario, como dominio de e-mail e tamanho de senha.
- Cadastro, consulta, edicao e exclusao de produtos.
- Validacoes de produto, como permissao, token, quantidade, preco e vinculo com carrinho.
- Cadastro, consulta, edicao, conclusao e cancelamento de carrinhos.
- Validacoes de carrinho, como produto inexistente, quantidade acima do estoque, carrinho duplicado e ausencia de autenticacao.
- Execucao automatizada dos testes funcionais.
- Geracao de relatorio HTML funcional.
- Publicacao do relatorio pelo GitHub Actions/GitHub Pages.

## 3. Fora do escopo

Nao fazem parte desta etapa:

- Testes de performance, carga, stress ou endurance.
- Testes de seguranca avancados.
- Testes visuais ou de interface grafica.
- Validacoes internas de banco de dados.
- Testes manuais exploratorios extensos.
- Testes de contrato com ferramenta dedicada.
- Correcao de defeitos da API ServeRest.

## 4. Ferramentas utilizadas

| Ferramenta | Uso no projeto |
| --- | --- |
| Apache JMeter 5.6.3 | Criacao e execucao dos testes funcionais de API |
| Taurus 1.16.50 | Orquestracao da execucao via `config/bzt-functional.yml` |
| PowerShell | Geracao do relatorio HTML funcional customizado |
| Java 21 | Runtime usado pelo JMeter no pipeline |
| Python 3.12 | Instalacao e execucao do Taurus |
| Node.js 24 | Execucao do pacote ServeRest no pipeline |
| ServeRest via NPM | API local usada como ambiente de testes |
| GitHub Actions | Execucao automatica da suite |
| GitHub Pages | Publicacao do relatorio HTML |
| Excel/Word/Markdown | Documentacao, gestao de testes e rastreabilidade |

## 5. Ambiente de teste

| Item | Valor |
| --- | --- |
| API | ServeRest |
| URL base | http://localhost:3000/ |
| Ambiente local | http://localhost:3000/ |
| Ambiente CI | GitHub Actions |
| Servico da API no CI | ServeRest via `npx serverest@latest` |
| Publicacao do relatorio | GitHub Pages |
| Repositorio GitHub | `https://github.com/pedjnr/serverest-api-jmeter-functional-tests` |
| URL prevista do relatorio | `https://pedjnr.github.io/serverest-api-jmeter-functional-tests/` |
| Massa de dados | Dados criados/consultados durante a execucao dos testes |
| Arquivo de testes | `jmeter/ServeRest.jmx` |
| Configuracao da execucao | `config/bzt-functional.yml` |

## 6. Estrategia de testes

A estrategia adotada e funcional, com foco em validar regras de negocio e respostas esperadas da API. Os testes foram classificados por natureza, prioridade e uso em suites de execucao.

| Classificacao | Quantidade |
| --- | ---: |
| Total de casos | 67 |
| Casos positivos | 24 |
| Casos negativos | 43 |
| Prioridade alta | 48 |
| Prioridade media | 14 |
| Prioridade baixa | 5 |
| Casos marcados como smoke | 23 |
| Casos marcados como regressao | 35 |

## 7. Cobertura por suite

| Suite | Total | Passaram | Falharam | Observacao |
| --- | ---: | ---: | ---: | --- |
| `[API LOGIN]` | 4 | 2 | 2 | Cobre login valido, credenciais invalidas e requisicoes incompletas. |
| `[API USUARIOS]` | 21 | 15 | 6 | Cobre consulta, cadastro, edicao, exclusao e validacoes especificas. |
| `[API PRODUTOS]` | 29 | 25 | 4 | Cobre consulta, cadastro, edicao, exclusao, permissao e regras de produto. |
| `[API CARRINHOS]` | 13 | 10 | 3 | Cobre consulta, cadastro, edicao, conclusao e cancelamento de carrinho. |
| **Total** | **67** | **52** | **15** | Resultado da execucao registrada na documentacao. |

## 8. Rastreabilidade

A rastreabilidade esta consolidada na planilha formal e no documento `05-matriz-de-rastreabilidade.md`.

| Indicador | Quantidade |
| --- | ---: |
| Requisitos/regras rastreados | 25 |
| Requisitos cobertos | 11 |
| Requisitos cobertos com falha | 14 |
| Requisitos sem cobertura | 0 |

Um requisito pode estar relacionado a varios casos de teste. Por isso, a matriz de rastreabilidade nao possui uma linha por caso, e sim uma linha por requisito ou regra funcional relevante.

## 9. Criterios de entrada

Antes da execucao, os seguintes itens devem estar prontos:

- API ServeRest disponivel no ambiente definido.
- Arquivo `jmeter/ServeRest.jmx` atualizado com os cenarios planejados.
- Arquivo `config/bzt-functional.yml` configurado para executar a suite JMeter.
- JMeter 5.6.3 disponivel no ambiente de execucao.
- Java 21 configurado no pipeline.
- Node.js 24 configurado para iniciar a API ServeRest.
- Dependencias Python instaladas a partir de `requirements.txt`.
- GitHub Actions configurado para executar a suite.
- GitHub Pages configurado como destino do relatorio.

## 10. Criterios de saida

A execucao sera considerada concluida quando:

- Todos os 67 casos cadastrados forem executados.
- O arquivo `.jtl` de resultados for gerado.
- O relatorio HTML funcional for criado.
- O relatorio for publicado no GitHub Pages.
- As falhas forem analisadas e registradas na documentacao.
- A planilha de gestao e a matriz de rastreabilidade estiverem atualizadas.

## 11. Criterios de aceite

Para considerar a suite aprovada em uma entrega final:

- Todos os testes smoke criticos devem passar.
- Falhas conhecidas devem estar documentadas e justificadas.
- Os requisitos criticos devem estar cobertos.
- O relatorio HTML deve estar acessivel pelo GitHub Pages.
- A documentacao deve refletir a execucao mais recente.

Na execucao registrada atualmente, a automacao executou corretamente, mas existem falhas funcionais a revisar antes de considerar a cobertura totalmente aprovada.

## 12. Riscos e mitigacoes

| Risco | Impacto | Mitigacao |
| --- | --- | --- |
| API indisponivel | Execucao bloqueada ou falhas falsas | Validar disponibilidade antes da execucao |
| Mudanca no comportamento da API | Asserts podem falhar | Revisar requisitos e resultados esperados |
| Massa de dados inconsistente | Falsos negativos | Isolar dados por execucao quando possivel |
| Diferenca entre execucao local e CI | Resultado divergente | Usar Java 21 e pipeline padronizado |
| Falha esperada representar regra real da API | Registro incorreto de bug | Confirmar comportamento esperado antes de classificar defeito |

## 13. Responsaveis

| Papel | Responsavel |
| --- | --- |
| Criacao dos testes | Pedro Carvalho |
| Execucao dos testes | Pedro Carvalho |
| Analise do relatorio | Pedro Carvalho |
| Revisao da documentacao | Pedro Carvalho |
| Aprovacao | Pedro Carvalho |
