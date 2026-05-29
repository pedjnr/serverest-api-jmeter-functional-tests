# Estratégia de testes

## 1. Abordagem

A suíte foi estruturada por domínio funcional da API ServeRest. Cada suite agrupa cenários positivos e negativos, validando status code, mensagens de resposta, regras de negócio, autenticação, autorização e reutilização de dados entre fluxos.

O foco desta etapa é funcional. A análise de desempenho da API será tratada em uma suíte separada, sem misturar indicadores de performance com a evidência de comportamento funcional.

## 2. Organização das suites

| Suite | Objetivo | Quantidade |
| --- | --- | ---: |
| `[API LOGIN]` | Validar autenticação e falhas de credenciais/requisição | 4 |
| `[API USUÁRIOS]` | Validar cadastro, consulta, edição, exclusão e regras específicas de usuários | 21 |
| `[API PRODUTOS]` | Validar consulta, criação, edição, exclusão, permissão e regras de produto | 29 |
| `[API CARRINHOS]` | Validar consulta, criação, edição, conclusão e cancelamento de carrinhos | 13 |

## 3. Nomenclatura adotada

Os samplers do JMeter seguem um prefixo por domínio funcional, permitindo que o relatório HTML agrupe os resultados automaticamente.

| Domínio | Prefixo |
| --- | --- |
| Login | `[API LOGIN]` |
| Usuários | `[API USUÁRIOS]` |
| Produtos | `[API PRODUTOS]` |
| Carrinhos | `[API CARRINHOS]` |

## 4. Validações

As validações cobrem:

- status code retornado pela API;
- mensagens de sucesso e erro;
- regras de campos obrigatórios;
- formato e duplicidade de dados;
- autenticação por token;
- autorização de usuários administradores e comuns;
- vínculo entre produto, usuário e carrinho;
- cenários de criação, consulta, edição, exclusão, conclusão e cancelamento.

## 5. Classificação dos casos

| Classificação | Quantidade |
| --- | ---: |
| Casos positivos | 24 |
| Casos negativos | 43 |
| Prioridade alta | 48 |
| Prioridade média | 14 |
| Prioridade baixa | 5 |
| Smoke | 23 |
| Regressão | 35 |

## 6. Execução automatizada

A execução é orquestrada pelo Taurus com o arquivo `config/bzt-functional.yml`. No GitHub Actions, a API ServeRest é iniciada localmente via NPM antes da execução dos testes. Em seguida, o JMeter executa o plano `jmeter/ServeRest.jmx` e gera o arquivo de resultados `.jtl`.

Após a execução, o script `scripts/gerar-relatorio-funcional.ps1` processa os resultados e cria um relatório HTML funcional com:

- indicadores de total, aprovados, reprovados e taxa de sucesso;
- gráfico de proporção entre testes aprovados e reprovados;
- agrupamento por suite;
- tabela de cenários com status, código HTTP, tempo e mensagem;
- referência ao arquivo bruto de resultados.

## 7. Análise de falhas

As falhas são classificadas a partir do comportamento observado no relatório e da regra documentada na matriz de rastreabilidade.

| Origem possível | Critério de análise |
| --- | --- |
| Defeito real da API | A API retorna sucesso quando deveria bloquear, ou retorna erro incompatível com a regra definida |
| Ajuste de assert | O teste espera um resultado diferente do comportamento aceito para a API |
| Massa de dados | O dado usado no teste interfere no resultado esperado |
| Ambiente | A API ou o pipeline indisponível compromete a execução |

Na execução registrada, as falhas estão concentradas em cenários negativos e regras específicas de usuários, produtos e carrinhos.
