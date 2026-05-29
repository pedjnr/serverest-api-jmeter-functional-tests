# Relatorio de execucao dos testes

Este documento registra a execucao funcional usada como evidencia inicial da suite automatizada.

## 1. Identificacao

| Campo | Valor |
| --- | --- |
| Projeto | Testes Funcionais ServeRest |
| Data da execucao | 28/05/2026 |
| Responsavel | Pedro Carvalho |
| Ambiente | Local |
| Link do relatorio HTML | https://pedjnr.github.io/serverest-api-jmeter-functional-tests/ |

## 2. Evidencia visual

![Resumo do relatorio funcional](../assets/evidencias/relatorio-funcional-resumo.png)

## 3. Resumo da execucao

| Metrica | Valor |
| --- | ---: |
| Total de testes | 67 |
| Testes aprovados | 52 |
| Testes reprovados | 15 |
| Taxa de sucesso | 77.61% |
| Tempo medio | 2.9 ms |
| Maior tempo | 10 ms |
| Gerado em | 28/05/2026 05:19:05 |

## 4. Resultado por suite

| Suite | Total | Aprovados | Reprovados | Observacoes |
| --- | ---: | ---: | ---: | --- |
| Login | 4 | 2 | 2 | Falhas concentradas em cenarios negativos de body vazio e campos em branco. |
| Usuarios | 21 | 15 | 6 | Revisar cenarios negativos que retornaram sucesso quando era esperado erro. |
| Produtos | 29 | 25 | 4 | Revisar regras de validacao e comportamento esperado nos asserts. |
| Carrinhos | 13 | 10 | 3 | Revisar cenarios de edicao e usuario sem carrinho. |

## 5. Falhas encontradas

| ID | Suite | Cenario | Resultado observado | Resultado esperado | Classificacao |
| --- | --- | --- | --- | --- | --- |
| F-001 | Login | Campos em branco/body ausente | API retornou erro diferente do esperado nos asserts. | Comportamento esperado conforme caso de teste documentado. | Revisar regra/assert |
| F-002 | Usuarios | Validacoes negativas de cadastro/exclusao | Alguns cenarios retornaram sucesso quando era esperado erro. | API deve bloquear dados invalidos ou operacoes inconsistentes. | Possivel bug ou ajuste de regra |
| F-003 | Produtos | Validacoes negativas e edicao | Alguns cenarios retornaram `200`/`201` quando era esperado bloqueio. | API deve retornar erro conforme regra do caso. | Possivel bug ou ajuste de regra |
| F-004 | Carrinhos | Edicao/cancelamento/conclusao sem carrinho | Alguns cenarios retornaram resposta diferente da esperada. | API deve seguir o comportamento documentado para usuario sem carrinho. | Revisar regra/assert |

## 6. Analise

A execucao validou 67 casos funcionais da API ServeRest, com 52 casos aprovados e 15 reprovados. A taxa de sucesso registrada foi de 77.61%.

As falhas aparecem principalmente em cenarios negativos, onde a API respondeu com sucesso ou com codigo diferente do esperado pela documentacao dos testes. Esses resultados devem ser revisados para separar defeitos reais da API, comportamento esperado da ServeRest e possiveis ajustes nos asserts.

## 7. Conclusao

A suite foi executada com sucesso do ponto de vista de automacao: o JMeter executou os testes, o Taurus gerou os resultados e o relatorio HTML funcional foi criado corretamente.

Do ponto de vista funcional, a execucao ainda possui falhas a revisar antes de considerar a cobertura como totalmente aprovada.

## 8. Status da execucao

| Item | Status |
| --- | --- |
| Suite executada | Concluida |
| Relatorio HTML | Gerado |
| Evidencia visual | Registrada |
| Resultado funcional | 52 aprovados e 15 reprovados |
| Publicacao prevista | GitHub Pages |
