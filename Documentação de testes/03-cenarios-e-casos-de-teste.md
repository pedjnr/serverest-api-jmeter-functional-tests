# Cenários e casos de teste

Documento consolidado a partir da planilha formal de gestão de testes.

Fonte: `Documentação de testes/Formal/Matriz de Gestao de Testes - ServeRest.xlsx`, aba `Casos de Teste`.

## Resumo

- Total de casos documentados: `67`
- Suítes cobertas: `4`
- Status dos casos: `Falhou`: 15, `Passou`: 52
- Tipos de teste: `Negativo`: 43, `Positivo`: 24
- Prioridades: `Alta`: 48, `Baixa`: 5, `Média`: 14
- Smoke: `Não`: 44, `Sim`: 23
- Regressão: `Não`: 32, `Sim`: 35

## Suíte: [API LOGIN]

- Total de casos: `4`
- Status: `Falhou`: 2, `Passou`: 2
- Tipos: `Negativo`: 3, `Positivo`: 1
- Smoke: `Não`: 3, `Sim`: 1
- Regressão: `Não`: 1, `Sim`: 3

| ID | Cenário | Caso de teste | Tipo | Prioridade | Smoke | Regressão | Pré-condição | Dados | Resultado esperado | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CT-LOGIN-001 | POST | Deve realizar login com sucesso | Positivo | Alta | Sim | Sim | Usuário válido cadastrado | email/senha válidos | Retornar status code 200 | `Passou` |
| CT-LOGIN-002 | POST | Não deve realizar login com E-mail/senha Inválida | Negativo | Alta | Não | Não | Usuário válido cadastrado | senha inválida | Retornar status code 401 | `Passou` |
| CT-LOGIN-003 | POST | Não deve realizar login com E-mail/Senha em Branco | Negativo | Alta | Não | Sim | Não aplicável | Não aplicável | Retornar status code 401 | `Falhou` |
| CT-LOGIN-004 | POST | Não deve logar sem enviar nenhum body | Negativo | Alta | Não | Sim | Não aplicável | Não aplicável | Retornar status code 401 | `Falhou` |

## Suíte: [API USUÁRIOS]

- Total de casos: `21`
- Status: `Falhou`: 6, `Passou`: 15
- Tipos: `Negativo`: 14, `Positivo`: 7
- Smoke: `Não`: 15, `Sim`: 6
- Regressão: `Não`: 10, `Sim`: 11

| ID | Cenário | Caso de teste | Tipo | Prioridade | Smoke | Regressão | Pré-condição | Dados | Resultado esperado | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CT-USR-001 | GET | Deve listar todos os usuários | Positivo | Baixa | Sim | Sim | Não aplicável | Não aplicável | Retornar status code 200 | `Passou` |
| CT-USR-002 | GET | Deve encontrar usuário com sucesso | Positivo | Média | Sim | Sim | Usuário válido cadastrado | ID de usuário cadastrado | Retornar status code 200 | `Passou` |
| CT-USR-003 | GET | Não deve encontrar usuário com ID falso | Negativo | Baixa | Não | Não | Não aplicável | ID inexistente | Retornar status code 400 | `Passou` |
| CT-USR-004 | GET | Não deve encontrar usuário com ID tamanho errado | Negativo | Baixa | Não | Não | Não aplicável | ID com menos de 16 caracteres ou mais de 16 caracteres | Retornar status code 400 | `Passou` |
| CT-USR-005 | POST | Deve cadastrar usuário com sucesso | Positivo | Alta | Sim | Sim | E-mail ainda não cadastrado | Nome, E-mail, Senha, Admin (boolean) | Retornar status code 201 | `Passou` |
| CT-USR-006 | POST | Não deve cadastrar com e-mail em formato incorreto | Positivo | Média | Não | Não | Não aplicável | Nome, E-mail com formato incorreto, Senha, Admin (boolean) | Deve retornar mensagem avisando sobre o formato errado do e-mail | `Passou` |
| CT-USR-007 | POST | Não deve cadastrar com Nome, E-mail e Senha em branco | Negativo | Média | Não | Não | Não aplicável | Não aplicável | Deve retornar mensagem avisando o que ficou em branco | `Passou` |
| CT-USR-008 | POST | Não deve cadastrar com dado em formato inválido | Negativo | Média | Não | Não | Não aplicável | Nome, E-mail, Senha, Admin (não boolean) | Deve retornar mensagem avisando " administrador deve ser 'true' ou 'false' " | `Passou` |
| CT-USR-009 | POST | Não deve cadastrar com Hotmail | Negativo | Alta | Não | Sim | Não aplicável | Nome, E-mail hotmail, Senha, Admin (boolean) | Deve retornar status code diferente de 201 | `Falhou` |
| CT-USR-010 | POST | Não deve cadastrar com Gmail | Negativo | Alta | Não | Sim | Não aplicável | Nome, E-mail gmail, Senha, Admin (boolean) | Deve retornar status code diferente de 201 | `Falhou` |
| CT-USR-011 | POST | Senha não pode ter mais que dez caracteres | Negativo | Alta | Não | Sim | Não aplicável | Nome, E-mail, Senha com mais de 10 caracteres, Admin (boolean) | Deve retornar status code diferente de 201 | `Falhou` |
| CT-USR-012 | POST | Senha não pode ter menos de cinco caracteres | Negativo | Alta | Não | Sim | Não aplicável | Nome, E-mail, Senha com menos de 5 caracteres, Admin (boolean) | Deve retornar status code diferente de 201 | `Falhou` |
| CT-USR-013 | POST | Não deve cadastrar com E-mail repetido | Negativo | Alta | Não | Não | E-mail já cadastrado | Nome, E-mail, Senha, Admin (boolean) | Deve retornar status code 400 e mensagem "Este email já está sendo usado" | `Passou` |
| CT-USR-014 | PUT | Deve editar usuário com sucesso | Positivo | Alta | Sim | Sim | Usuário válido cadastrado | Nome, E-mail, Senha, Admin (boolean) | Deve retornar status code 200 | `Passou` |
| CT-USR-015 | PUT | Não deve editar com informações em branco | Negativo | Média | Não | Não | Usuário válido cadastrado | Não aplicável | Deve retornar status code 200 e mensagem "não pode ficar em branco" | `Passou` |
| CT-USR-016 | PUT | Não deve cadastrar com E-mail repetido | Positivo | Média | Não | Não | Usuário válido cadastrado | Nome, E-mail, Senha, Admin (boolean) | Deve retornar status code 400 e mensagem "Este email já está sendo usado" | `Passou` |
| CT-USR-017 | PUT | Não deve cadastrar usuário com sucesso | Negativo | Alta | Sim | Sim | Não aplicável | Nome, E-mail, Senha, Admin (boolean) | Deve retornar status code diferente de 201 | `Falhou` |
| CT-USR-018 | DELETE | Deve deletar usuário com sucesso | Positivo | Alta | Sim | Sim | Usuário válido cadastrado | ID de usuário cadastrado | Deve retornar status code 200 e mensagem "Registro excluído com sucesso" | `Passou` |
| CT-USR-019 | DELETE | Não deve deletar usuário com ID inválido | Negativo | Alta | Não | Sim | Não aplicável | Não aplicável | Deve retornar status code 200 e mensagem "Nenhum registro excluído" | `Falhou` |
| CT-USR-020 | DELETE | Não deve excluir sem informar ID | Negativo | Alta | Não | Não | Não aplicável | Não aplicável | Deve retornar status code 200 | `Passou` |
| CT-USR-021 | DELETE | Não deve excluir usuário com carrinho cadastrado | Negativo | Alta | Não | Não | Usuário válido cadastrado com carrinho | ID de usuário cadastrado | Deve retornar status code 200 | `Passou` |

## Suíte: [API PRODUTOS]

- Total de casos: `29`
- Status: `Falhou`: 4, `Passou`: 25
- Tipos: `Negativo`: 20, `Positivo`: 9
- Smoke: `Não`: 20, `Sim`: 9
- Regressão: `Não`: 17, `Sim`: 12

| ID | Cenário | Caso de teste | Tipo | Prioridade | Smoke | Regressão | Pré-condição | Dados | Resultado esperado | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CT-PROD-001 | GET | Deve listar todos os produtos | Positivo | Alta | Sim | Sim | Não aplicável | Não aplicável | Listar produtos cadastrados e retornar status code 200 | `Passou` |
| CT-PROD-002 | GET | Deve encontrar produto específico | Positivo | Alta | Sim | Sim | Produto válido cadastrado | ID de produto cadastrado | Mostrar produto específico e retornar status code 200 | `Passou` |
| CT-PROD-003 | GET | Não deve encontrar produto com ID falso | Negativo | Baixa | Não | Não | Não aplicável | Não aplicável | Retornar status code 400 | `Passou` |
| CT-PROD-004 | GET | Não deve encontrar produto com ID em tamanho incorreto | Negativo | Baixa | Não | Não | Não aplicável | Não aplicável | Não deve retornar status code 200 | `Passou` |
| CT-PROD-005 | POST | Deve cadastrar com sucesso | Positivo | Alta | Sim | Sim | Usuário com acesso administrativo | Nome, Preço, Descrição e Quantidade | Deve retornar status code 201 | `Passou` |
| CT-PROD-006 | POST | Deve cadastrar produto com preço decimal | Positivo | Alta | Sim | Sim | Usuário com acesso administrativo | Nome, Preço com valor decimal, Descrição e Quantidade | Retornar status code 201 | `Falhou` |
| CT-PROD-007 | POST | Deve retornar mensagem de erro com preço muito alto | Positivo | Alta | Não | Não | Usuário com acesso administrativo | Nome, Preço com valor de '10000000000000000', Descrição e Quantidade | Retornar mensagem de erro sobre o preço | `Passou` |
| CT-PROD-008 | POST | Deve retornar mensagem de erro com quantidade muito alta | Positivo | Alta | Não | Não | Usuário com acesso administrativo | Nome, Preço, Descrição e Quantidade com valor de '10000000000000000' | Retornar mensagem de erro sobre a quantidade | `Passou` |
| CT-PROD-009 | POST | Não deve cadastrar produto com quantidade zero | Negativo | Alta | Sim | Sim | Usuário com acesso administrativo | Nome, Preço, Descrição e Quantidade com valor zero | Deve retornar status code diferente de 201 | `Falhou` |
| CT-PROD-010 | POST | Não deve cadastrar produto com preço zero | Negativo | Alta | Não | Sim | Usuário com acesso administrativo | Nome, Preço com valor zero, Descrição e Quantidade | Não deve cadastrar e não deve retornar status code 201 | `Passou` |
| CT-PROD-011 | POST | Não deve cadastrar produto com nome repetido | Negativo | Média | Não | Não | Usuário com acesso administrativo e produto já cadastrado | Nome de produto já cadastrado, Preço, Descrição e Quantidade | Não deve cadastrar e nem retornar status code 201 | `Passou` |
| CT-PROD-012 | POST | Não deve cadastrar produto sem token de acesso | Negativo | Média | Não | Não | Não aplicável | Nome, Preço, Descrição e Quantidade | Deve retornar status code 401 | `Passou` |
| CT-PROD-013 | POST | Não deve cadastrar produto com token de acesso inválido | Negativo | Média | Não | Não | Token de acesso inválido | Nome, Preço, Descrição e Quantidade | Deve retornar status code 401 | `Passou` |
| CT-PROD-014 | POST | Não deve cadastrar produto com usuário sem permissão | Negativo | Alta | Não | Sim | Usuário sem acesso administrativo | Nome, Preço, Descrição e Quantidade | Deve retornar status code 403 | `Passou` |
| CT-PROD-015 | PUT | Deve editar produto com sucesso | Positivo | Alta | Não | Não | Usuário com acesso administrativo e produto já cadastrado | Id de produto, Nome, Preço, Descrição e Quantidade | Deve editar com sucesso e retornar status code 200 | `Passou` |
| CT-PROD-016 | PUT | Não deve editar/criar produto com ID curto | Negativo | Média | Não | Não | Usuário com acesso administrativo | Id de produto curto, Nome, Preço, Descrição e Quantidade | Deve retornar status code diferente de 200 | `Passou` |
| CT-PROD-017 | PUT | Não deve cadastrar produto com sucesso através do PUT | Negativo | Alta | Sim | Sim | Usuário com acesso administrativo | Id falso de produto, Nome, Preço, Descrição e Quantidade | Deve retornar status code diferente de 201 | `Falhou` |
| CT-PROD-018 | PUT | Não deve cadastrar produto com o mesmo nome | Negativo | Média | Não | Não | Usuário com acesso administrativo e produto já cadastrado | Id falso de produto, Nome de produto já cadastrado, Preço, Descrição e Quantidade | Deve retornar status code 400 | `Passou` |
| CT-PROD-019 | PUT | Deve permitir editar mudando apenas um valor | Positivo | Média | Não | Não | Usuário com acesso administrativo e produto já cadastrado | Id de produto, Nome, Preço, Descrição e Quantidade | Deve editar com sucesso e retornar status code 200 | `Passou` |
| CT-PROD-020 | PUT | Não deve editar sem acesso administrativo | Negativo | Alta | Não | Sim | Usuário com acesso administrativo e produto já cadastrado | Id de produto, Nome, Preço, Descrição e Quantidade | Deve retornar mensagem de erro e status code 403 | `Passou` |
| CT-PROD-021 | PUT | Não deve editar com token de acesso inválido | Negativo | Alta | Não | Não | Token de acesso inválido | Id de produto já cadastrado, Nome, Preço, Descrição e Quantidade | Deve retornar status code 401 | `Passou` |
| CT-PROD-022 | PUT | Não deve editar sem token de acesso | Negativo | Alta | Não | Não | Não aplicável | Id de produto, Nome, Preço, Descrição e Quantidade | Deve retornar status code 401 | `Passou` |
| CT-PROD-023 | PUT | Não deve editar produto que pertence a carrinho | Negativo | Alta | Sim | Sim | Usuário com acesso administrativo e produto já cadastrado | Id de produto já cadastrado, Nome, Preço, Descrição e Quantidade | Deve retornar status code diferente de 200 | `Falhou` |
| CT-PROD-024 | DELETE | Deve deletar produto com sucesso | Positivo | Alta | Sim | Sim | Usuário com acesso administrativo e produto já cadastrado | Id de produto | Deve deletar e retornar status code 200 | `Passou` |
| CT-PROD-025 | DELETE | Não deve deletar sem informar ID | Negativo | Alta | Não | Não | Usuário com acesso administrativo | Não aplicável | Não deve retornar status code 200 | `Passou` |
| CT-PROD-026 | DELETE | Não deve excluir produto com carrinho cadastrado | Negativo | Alta | Não | Não | Usuário com acesso administrativo | Id de produto pertencente a um carrinho | Deve retornar status code 400 | `Passou` |
| CT-PROD-027 | DELETE | Não deve deletar sem token de acesso | Negativo | Alta | Não | Não | Não aplicável | Id de produto | Deve retornar status code 401 | `Passou` |
| CT-PROD-028 | DELETE | Não deve deletar com token de acesso inválido | Negativo | Alta | Não | Não | Token de acesso inválido | Id de produto | Deve retornar status code 401 | `Passou` |
| CT-PROD-029 | DELETE | Não deve deletar sem ser usuário administrativo | Negativo | Alta | Sim | Sim | Usuário sem acesso administrativo | Id de produto | Deve retornar status code 403 | `Passou` |

## Suíte: [API CARRINHOS]

- Total de casos: `13`
- Status: `Falhou`: 3, `Passou`: 10
- Tipos: `Negativo`: 6, `Positivo`: 7
- Smoke: `Não`: 6, `Sim`: 7
- Regressão: `Não`: 4, `Sim`: 9

| ID | Cenário | Caso de teste | Tipo | Prioridade | Smoke | Regressão | Pré-condição | Dados | Resultado esperado | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CT-CART-001 | GET | Deve listar todos os carrinhos | Positivo | Alta | Sim | Sim | Carrinho cadastrado no sistema | Não aplicável | Deve retornar lista de carrinhos e status code 200 | `Passou` |
| CT-CART-002 | GET | Deve listar carrinho por ID | Positivo | Alta | Sim | Sim | Carrinho cadastrado no sistema | ID de carrinho | Deve retornar carrinho específico e status code 200 | `Passou` |
| CT-CART-003 | POST | Deve cadastrar carrinho com usuário administrativo | Positivo | Alta | Sim | Sim | Produto válido cadastrado para cadastrar no carrinho e token de acesso válido | idProduto e quantidade | Deve cadastrar carrinho e retornar status code 200 | `Passou` |
| CT-CART-004 | POST | Não deve cadastrar um segundo carrinho pro mesmo usuário | Negativo | Alta | Não | Não | Carrinho cadastrado no sistema, Produto válido cadastrado para cadastrar no carrinho e token de acesso válido | idProduto e quantidade | Deve retornar status code 400 | `Passou` |
| CT-CART-005 | POST | Não deve cadastrar carrinho com produto que não existe | Negativo | Alta | Não | Não | Produto inexistente para cadastrar no carrinho e token de acesso válido | idProduto inexistente e quantidade | Deve retornar status code 400 | `Passou` |
| CT-CART-006 | POST | Não deve cadastrar carrinho com produtos a mais do que tem no estoque | Negativo | Média | Não | Não | Produto válido cadastrado para cadastrar no carrinho e token de acesso válido | idProduto e quantidade maior do que no estoque | Deve retornar status code 400 | `Passou` |
| CT-CART-007 | POST | Deve cadastrar carrinho com usuário comum | Positivo | Alta | Sim | Sim | Carrinho cadastrado no sistema | idProduto e quantidade | Deve retornar status code 201 | `Passou` |
| CT-CART-008 | POST | Não deve cadastrar carrinho sem autenticação | Negativo | Média | Não | Não | Produto válido cadastrado para cadastrar no carrinho | idProduto e quantidade | Deve retornar status code 401 | `Passou` |
| CT-CART-009 | PUT | Deve editar carrinho com sucesso | Positivo | Alta | Sim | Sim | Carrinho cadastrado no sistema e produto válido cadastrado | idProduto e quantidade | Deve retornar status code 200 e editar carrinho já cadastrado | `Falhou` |
| CT-CART-010 | DELETE | Deve cancelar compra de carrinho com sucesso | Positivo | Alta | Sim | Sim | Carrinho cadastrado e token de acesso válido | Não aplicável | Deve retornar status code 200 | `Passou` |
| CT-CART-011 | DELETE | Não deve cancelar compra de usuário sem carrinho | Negativo | Alta | Não | Sim | Token de acesso válido de usuário sem carrinho | Não aplicável | Deve retornar status code 200 | `Falhou` |
| CT-CART-012 | DELETE | Deve concluir compra de carrinho com sucesso | Positivo | Alta | Sim | Sim | Carrinho cadastrado e token de acesso válido | Não aplicável | Deve retornar status code 200 | `Passou` |
| CT-CART-013 | DELETE | Não deve concluir compra de usuário sem carrinho | Negativo | Alta | Não | Sim | Token de acesso válido de usuário sem carrinho | Não aplicável | Deve retornar status code 200 | `Falhou` |
