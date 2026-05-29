# Massa de dados

## 1. Estratégia

A massa de dados é criada, consultada e reutilizada durante a execução dos testes automatizados. Os cenários usam dados válidos e inválidos para validar regras funcionais da API ServeRest, incluindo autenticação, permissões, duplicidade, formato, limites de campos e relacionamento entre usuários, produtos e carrinhos.

Os dados são organizados por fluxo para reduzir dependência manual e permitir execução em pipeline.

## 2. Usuários

| Dado | Uso | Observação |
| --- | --- | --- |
| Usuário administrador | Login, cadastro/edição/exclusão de produtos e fluxos com permissão elevada | Necessário para validar endpoints protegidos |
| Usuário comum | Login, cadastro de carrinho e validações de permissão | Usado para diferenciar comportamento de admin e não admin |
| E-mail válido | Cadastro e login com sucesso | Deve ser único quando o cenário cria novo usuário |
| E-mail repetido | Validação de duplicidade | Usado para confirmar bloqueio de e-mail já cadastrado |
| E-mail Gmail | Regra específica de bloqueio | Relacionado ao requisito `REQ-007` |
| E-mail Hotmail | Regra específica de bloqueio | Relacionado ao requisito `REQ-006` |
| Senha com mais de 10 caracteres | Regra específica de tamanho máximo | Relacionado ao requisito `REQ-008` |
| Senha com menos de 5 caracteres | Regra específica de tamanho mínimo | Relacionado ao requisito `REQ-009` |

## 3. Produtos

| Dado | Uso | Observação |
| --- | --- | --- |
| Produto válido | Cadastro, consulta, edição, exclusão e carrinho | Base para fluxos positivos |
| Produto inexistente | Validação de consulta/carrinho inválido | Usado em cenários negativos |
| Produto com nome repetido | Validação de duplicidade | Confirma regra de nome único quando aplicável |
| Preço decimal | Regra específica de cadastro | Relacionado ao requisito `REQ-014` |
| Preço zero | Validação de limite | Usado em regra negativa de produto |
| Quantidade zero | Regra específica de cadastro | Relacionado ao requisito `REQ-016` |
| Produto vinculado a carrinho | Validação de edição/exclusão bloqueada | Relacionado aos requisitos de carrinho e produto |

## 4. Carrinhos

| Dado | Uso | Observação |
| --- | --- | --- |
| Carrinho válido | Consulta, edição, conclusão e cancelamento | Criado com produto existente e usuário autenticado |
| Carrinho duplicado | Validação de segundo carrinho para o mesmo usuário | Garante regra de unicidade por usuário |
| Quantidade acima do estoque | Validação de estoque | Cobre regra de quantidade indisponível |
| Usuário sem carrinho | Cancelamento/conclusão sem carrinho | Cobre comportamento esperado para ausência de carrinho |
| Produto inexistente no carrinho | Validação de produto inválido | Cobre regra de consistência do carrinho |

## 5. Dados técnicos reutilizados

| Variável/Dado | Origem | Uso |
| --- | --- | --- |
| Token de acesso | Resposta do login | Autorização em produtos e carrinhos |
| ID de usuário | Cadastro ou consulta de usuários | Consulta, edição, exclusão e relacionamento com carrinho |
| ID de produto | Cadastro ou consulta de produtos | Consulta, edição, exclusão e criação de carrinho |
| ID de carrinho | Cadastro ou consulta de carrinhos | Consulta, edição, conclusão e cancelamento |

## 6. Cuidados de execução

- Cenários que criam usuários ou produtos devem evitar conflito de dados entre execuções.
- Cenários negativos devem manter os dados inválidos controlados para que a falha represente a regra testada.
- Tokens e IDs capturados em etapas anteriores devem ser reutilizados apenas nos fluxos relacionados.
- Massa compartilhada entre usuário, produto e carrinho deve preservar a ordem lógica da execução.
