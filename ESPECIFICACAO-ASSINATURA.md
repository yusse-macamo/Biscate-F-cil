# Especificação: assinatura (lado do prestador)

Terceiro ecrã da pista do prestador. Sem backend: dados falsos, pagamento
simulado. Aplicam-se as regras gerais e o tema de
`ESPECIFICACAO-CADASTRO.md`, secções 1 a 4.

---

## 1. O que este ecrã faz

O prestador paga para ser visível aos clientes. Este ecrã mostra-lhe em que
situação está, quanto tempo lhe falta, e como pagar.

**A cobrança fica atrás de uma flag desligada** (`cobrancaActiva = false` em
`nucleo/constantes/`). Com a flag desligada, todos os prestadores contam como
activos e o ecrã mostra o estado gratuito. Toda a lógica é construída agora e
ligada depois do piloto.

## 2. Planos

Os valores são decididos pelos administradores e **nunca são constantes no
código**. Nesta fase vivem em `planos_falsos.dart`, um único ficheiro que
depois se troca por leitura da tabela `planos`.

| Plano | Preço actual | Ciclo | Quando se paga |
|---|---|---|---|
| Quinzenal | 100 MT | 14 dias | no fim do ciclo |
| Mensal | 150 MT | 30 dias | antes do ciclo começar |

Período gratuito: **14 dias**, a contar da **aprovação** do cadastro, não do
registo. Se o prestador esperou dois dias pela verificação, esses dias não lhe
saem do gratuito.

### Regras de janela

**Quinzenal** (pago no fim): a janela de pagamento abre 3 dias antes do fim do
ciclo. Tolerância de 2 dias depois do fim. Passada a tolerância sem pagamento,
a visibilidade cai.

**Mensal** (pago à cabeça): a janela de renovação abre 5 dias antes do fim.
Não há tolerância: no dia seguinte ao fim do ciclo, sem pagamento, a
visibilidade cai. Isto é intencional e diferente do quinzenal.

### Regra do preço congelado

Quando um administrador altera o preço de um plano, quem tem assinatura activa
mantém o valor acordado até ao fim do ciclo em curso. O novo valor só se aplica
na renovação seguinte. A `Assinatura` guarda, por isso, o **preço no momento da
adesão**, e não lê o preço actual do plano.

## 3. Estados da assinatura

| Estado | Significado | Visível aos clientes |
|---|---|---|
| `gratuito` | dentro dos 14 dias após aprovação | sim |
| `activa` | ciclo pago e a decorrer | sim |
| `em_tolerancia` | quinzenal, ciclo terminou, dentro dos 2 dias | sim |
| `expirada` | sem pagamento válido | **não** |

Calcular o estado na leitura, a partir das datas, em vez de depender de tarefa
agendada. Menos peças a falhar.

## 4. Estrutura de ficheiros

```
lib/funcionalidades/assinatura/
├── dados/planos_falsos.dart
└── apresentacao/
    ├── controladores/
    │   ├── assinatura_estado.dart
    │   └── assinatura_controlador.dart
    ├── ecras/
    │   ├── assinatura_ecra.dart
    │   └── pagamento_ecra.dart
    └── widgets/
        ├── cartao_estado_assinatura.dart
        ├── cartao_plano.dart
        └── linha_pagamento.dart
```

## 5. Modelo

`Plano`: `id`, `nome`, `preco`, `diasCiclo`, `pagamentoAntecipado` (bool),
`diasJanela`, `diasTolerancia`.

`Assinatura`: `planoId`, `precoAcordado`, `inicio`, `fim`, `estado`.

`Pagamento`: `id`, `valor`, `data`, `referencia`, `confirmado`.

Getters no estado: `diasRestantes`, `podePagar` (dentro da janela),
`estaVisivel`.

## 6. Ecrã de assinatura

`AppBar` com título `Assinatura`.

### Cartão de estado, no topo

É o elemento mais importante do ecrã e ocupa o topo inteiro. Contorno, sem
sombra. Muda conforme o estado:

- **`gratuito`**: `Período gratuito` em `labelSmall`, `Faltam 9 dias` em
  `headlineSmall`, e apoio `Depois disso precisa de um plano para continuar a
  receber pedidos.`
- **`activa`**: `Plano mensal` / `Faltam 12 dias` / `Renova a 24 de Março.`
- **`em_tolerancia`**: usa `errorContainer`. `Pagamento em atraso` /
  `Restam 2 dias` / `Sem pagamento, deixa de aparecer nas procuras.`
- **`expirada`**: `errorContainer`. `Não está visível` /
  `Os clientes não o encontram` / `Pague para voltar a receber pedidos.`

Nunca usar só a cor para distinguir: o texto diz sempre o que se passa.

### Escolha de plano

Título `Planos` em `titleSmall` e dois `CartaoPlano`, um por plano. Cada um com
nome, preço em destaque (`headlineSmall`), ciclo (`Cada 14 dias`) e uma linha
de regra: `Paga no fim do período` ou `Paga antes de começar`. O plano actual
leva a marca `O seu plano` e contorno primário.

Uma linha por baixo, em `bodySmall`: `Os preços podem mudar. Se mudarem, o seu
valor mantém-se até ao fim do período em curso.`

Não ordenar por preço nem marcar nenhum como "recomendado". Mostrar os dois com
o mesmo peso e deixar escolher.

### Histórico

Título `Pagamentos` e uma lista de `LinhaPagamento`: data à esquerda, valor à
direita, e uma marca de confirmado. Vazio: `Ainda não fez pagamentos.`

### Barra de fundo

Botão principal, com rótulo conforme o estado: `Escolher plano` (gratuito),
`Pagar agora` (dentro da janela ou em atraso), ou ausente quando a assinatura
está activa e fora da janela. Nesse caso a barra não aparece de todo, em vez de
mostrar um botão desactivado.

## 7. Ecrã de pagamento

Aberto a partir do botão. Mostra, por ordem: plano escolhido, valor a pagar, e
as instruções de pagamento por e-Mola em passos numerados (aqui a numeração faz
sentido, é uma sequência real).

Instruções com o número de destino em destaque e um botão `Copiar número`.
Abaixo, um aviso: `Use o número de telefone com que se registou. É assim que
identificamos o seu pagamento.` Isto é essencial: sem correspondência de
número, a confirmação automática por SMS não funciona.

No fundo, `Já paguei`, que nesta fase simula a confirmação após 1500 ms e
devolve ao ecrã anterior com o estado actualizado e um `SnackBar`
`Pagamento confirmado.`

`TODO`: substituir pela leitura do SMS do e-Mola e conta corrente, portadas do
RideLink. O prestador nunca escreve no estado da assinatura; quando o backend
entrar, isso passa a Edge Function.

## 8. Controlador

`assinaturaControladorProvider`, um `Notifier`:

- `carregar()`, `escolherPlano(planoId)`, `simularPagamento()`.
- Calcula o estado a partir das datas em cada leitura.
- Nenhum cálculo de datas ou de estado dentro dos widgets.

## 9. Dados falsos

Os dois planos com os valores acima. Uma assinatura de exemplo no estado
`gratuito` com 9 dias restantes, e dois pagamentos no histórico. Deixar
comentado, no ficheiro, um exemplo de cada um dos outros três estados, para se
poder trocar à mão e ver o ecrã em cada situação sem alterar código.

## 10. Fora de âmbito

Confirmação real de pagamento, M-Pesa (só e-Mola na primeira fase), facturas,
reembolsos, mudança de plano a meio do ciclo, e a regra de visibilidade em si,
que é a sessão conjunta com a outra pista.

## 11. Aceitação

`flutter analyze` limpo, e no aparelho:

1. Cada um dos quatro estados mostra o cartão certo (trocando os dados falsos).
2. Com assinatura activa fora da janela, a barra de fundo não aparece.
3. Em `expirada`, o texto diz claramente que os clientes não o encontram.
4. `Já paguei` actualiza o estado e mostra o histórico com o novo pagamento.
5. O plano actual está marcado e o outro continua escolhível.
6. Com `cobrancaActiva = false`, o ecrã mostra sempre o estado gratuito.
7. Em modo escuro, os estados de atraso e expirado continuam legíveis.
