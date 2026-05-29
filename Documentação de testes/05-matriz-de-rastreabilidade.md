# Matriz de rastreabilidade

Este documento liga requisitos funcionais e regras de negocio aos casos de teste automatizados da suite JMeter.

Fonte principal: `Documentação de testes/Formal/Matriz de Gestao de Testes - ServeRest.xlsx`, aba `Rastreabilidade`.

## 1. Objetivo

Garantir que os requisitos relevantes da API ServeRest estejam cobertos por casos de teste automatizados, sem criar uma linha artificial para cada teste individual.

## 2. Resumo da cobertura

- Total de requisitos/regras rastreados: `25`
- Cobertos: `11`
- Cobertos com falha: `14`
- Sem cobertura: `0`

## 3. Matriz

| ID | Requisito/Regra | Suite | Casos relacionados | Cobertura | Observacoes |
| --- | --- | --- | --- | --- | --- |
| REQ-001 | Deve poder logar com credenciais validas. | [API LOGIN] | CT-LOGIN-001 | Coberto | Fluxo basico da ServeRest. |
| REQ-002 | Nao deve permitir login com credenciais invalidas, campos em branco ou body ausente. | [API LOGIN] | CT-LOGIN-002, CT-LOGIN-003, CT-LOGIN-004 | Coberto com falha | Cobre validacoes negativas de login. |
| REQ-003 | Deve poder listar e consultar usuarios. | [API USUÁRIOS] | CT-USR-001, CT-USR-002, CT-USR-003, CT-USR-004 | Coberto | Funcionalidade basica de usuarios. |
| REQ-004 | Deve poder criar usuario com dados validos. | [API USUÁRIOS] | CT-USR-005 | Coberto | Funcionalidade basica de usuarios. |
| REQ-005 | Cadastro de usuario deve validar e-mail, campos obrigatorios, tipo do campo admin e e-mail repetido. | [API USUÁRIOS] | CT-USR-006, CT-USR-007, CT-USR-008, CT-USR-013 | Coberto | Agrupa validacoes gerais de cadastro. |
| REQ-006 | Nao pode deixar cadastrar com email Hotmail. | [API USUÁRIOS] | CT-USR-009 | Coberto com falha | Requisito especifico informado. |
| REQ-007 | Nao pode deixar cadastrar com email Gmail. | [API USUÁRIOS] | CT-USR-010 | Coberto com falha | Requisito especifico informado. |
| REQ-008 | Nao pode ter senha com mais de 10 caracteres. | [API USUÁRIOS] | CT-USR-011 | Coberto com falha | Requisito especifico informado. |
| REQ-009 | Nao pode ter senha com menos de 5 caracteres. | [API USUÁRIOS] | CT-USR-012 | Coberto com falha | Requisito especifico informado. |
| REQ-010 | Nao deve cadastrar usuario atraves do PUT. | [API USUÁRIOS] | CT-USR-017 | Coberto com falha | Requisito especifico informado. |
| REQ-011 | Deve poder editar e excluir usuarios conforme regras da API. | [API USUÁRIOS] | CT-USR-014, CT-USR-015, CT-USR-016, CT-USR-018, CT-USR-019, CT-USR-020, CT-USR-021 | Coberto com falha | Funcionalidade basica de usuarios. |
| REQ-012 | Deve poder listar e consultar produtos. | [API PRODUTOS] | CT-PROD-001, CT-PROD-002, CT-PROD-003, CT-PROD-004 | Coberto | Funcionalidade basica de produtos. |
| REQ-013 | Deve poder criar produto com usuario administrador. | [API PRODUTOS] | CT-PROD-005 | Coberto | Funcionalidade basica de produtos. |
| REQ-014 | Deve poder cadastrar produto com preco decimal. | [API PRODUTOS] | CT-PROD-006 | Coberto com falha | Requisito especifico informado. |
| REQ-015 | Cadastro de produto deve validar limites, duplicidade, autenticacao e permissao. | [API PRODUTOS] | CT-PROD-007, CT-PROD-008, CT-PROD-010, CT-PROD-011, CT-PROD-012, CT-PROD-013, CT-PROD-014 | Coberto | Agrupa validacoes gerais de cadastro de produto. |
| REQ-016 | Nao deve realizar cadastro de produto com quantidade zero. | [API PRODUTOS] | CT-PROD-009 | Coberto com falha | Requisito especifico informado. |
| REQ-017 | Nao deve cadastrar produto atraves do PUT. | [API PRODUTOS] | CT-PROD-017 | Coberto com falha | Requisito especifico informado. |
| REQ-018 | Nao deve permitir editar produto que ja pertence a um carrinho. | [API PRODUTOS] | CT-PROD-023 | Coberto com falha | Requisito especifico informado. |
| REQ-019 | Deve poder editar e excluir produtos conforme autenticacao, permissao e vinculo com carrinho. | [API PRODUTOS] | CT-PROD-015, CT-PROD-016, CT-PROD-018, CT-PROD-019, CT-PROD-020, CT-PROD-021, CT-PROD-022, CT-PROD-024, CT-PROD-025, CT-PROD-026, CT-PROD-027, CT-PROD-028, CT-PROD-029 | Coberto | Funcionalidade basica de produtos. |
| REQ-020 | Deve poder listar e consultar carrinhos. | [API CARRINHOS] | CT-CART-001, CT-CART-002 | Coberto | Funcionalidade basica de carrinhos. |
| REQ-021 | Deve poder cadastrar carrinho com produto valido e usuario autenticado. | [API CARRINHOS] | CT-CART-003, CT-CART-007 | Coberto | Funcionalidade basica de carrinhos. |
| REQ-022 | Cadastro de carrinho deve validar carrinho duplicado, produto inexistente, estoque e autenticacao. | [API CARRINHOS] | CT-CART-004, CT-CART-005, CT-CART-006, CT-CART-008 | Coberto | Agrupa validacoes gerais de cadastro de carrinho. |
| REQ-023 | Deve permitir adicionar mais produtos ao carrinho atraves do PUT. | [API CARRINHOS] | CT-CART-009 | Coberto com falha | Requisito especifico informado. |
| REQ-024 | Deve poder cancelar compra de carrinho. | [API CARRINHOS] | CT-CART-010, CT-CART-011 | Coberto com falha | Funcionalidade basica de carrinhos. |
| REQ-025 | Deve poder concluir compra de carrinho. | [API CARRINHOS] | CT-CART-012, CT-CART-013 | Coberto com falha | Funcionalidade basica de carrinhos. |

## 4. Observacoes

- Um requisito pode ser coberto por varios casos de teste.
- `Coberto com falha` significa que existe teste automatizado para o requisito, mas pelo menos um caso relacionado falhou na execucao registrada.
