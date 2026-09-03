# Especificação: pedidos recebidos (lado do prestador)

Segundo ecrã da pista do prestador. Continua sem backend: dados falsos e
acções simuladas. Aplicam-se todas as regras gerais e o tema definidos em
`ESPECIFICACAO-CADASTRO.md`, secções 1 a 4; este documento não os repete.

---

## 1. O que este ecrã faz

Mostra ao prestador os pedidos abertos que correspondem à categoria e às zonas
dele, deixa-o manifestar interesse, e acompanha o que acontece a seguir.

O prestador **não aceita** um pedido: manifesta interesse. Quem escolhe é o
cliente, de entre os interessados, comparando os preços de cada perfil. Isto
tem duas consequências que atravessam todo o ecrã:

- O contacto do cliente só aparece depois de o cliente o ter escolhido.
- Há dois estados a acompanhar, e nunca se devem misturar: o **estado do
  pedido** e o **estado do interesse deste prestador nesse pedido**.

## 2. Estados

**Pedido** (partilhado com a pista do cliente; não alterar sem combinar):

| Estado | Significado |
|---|---|
| `aberto` | à espera que o cliente escolha alguém |
| `aceite` | o cliente escolheu um prestador |
| `concluido` | trabalho dado como feito |
| `cancelado` | o cliente desistiu |

**Interesse** (só existe do lado do prestador):

| Estado | Significado |
|---|---|
| `enviado` | manifestou interesse, o cliente ainda não decidiu |
| `escolhido` | foi o escolhido; o contacto fica visível |
| `nao_escolhido` | o cliente escolheu outro |

Regra: quando um pedido passa a `aceite`, todos os interesses que não são o
escolhido passam a `nao_escolhido`. Nenhum contacto é revelado nesses casos.

## 3. Estrutura de ficheiros a acrescentar

```
lib/funcionalidades/pedidos/
├── dados/pedidos_falsos.dart
└── apresentacao/
    ├── controladores/
    │   ├── pedidos_estado.dart
    │   └── pedidos_controlador.dart
    ├── ecras/
    │   ├── pedidos_recebidos_ecra.dart
    │   └── detalhe_pedido_ecra.dart
    └── widgets/
        ├── cartao_pedido.dart
        ├── etiqueta_urgencia.dart
        └── filtro_pedidos.dart
```

`EtiquetaEstado` (usada para o estado do interesse) vai para
`lib/comum/widgets/etiqueta_estado.dart`, porque a pista do cliente também vai
precisar dela.

## 4. Modelo

`Pedido`: `id`, `servicoId`, `descricao`, `fotoUrl` (opcional), `bairro`,
`urgencia`, `estado`, `criadoEm`, `clienteNome`, `clienteTelefone`.

**O `clienteTelefone` nunca é mostrado enquanto o interesse não estiver
`escolhido`.** Nesta fase é uma regra da interface; quando o Supabase entrar,
passa a política RLS e o campo deixa de sequer vir na consulta.

`Interesse`: `pedidoId`, `estado`, `enviadoEm`.

`enum Urgencia { hoje, estaSemana, semPressa }` com rótulos
`Hoje`, `Esta semana`, `Sem pressa`.

## 5. Ecrã de pedidos recebidos

`AppBar` com título `Pedidos`. Duas abas (`TabBar` simples, sem ícones):

- **Disponíveis**: pedidos `aberto` da categoria e zonas do prestador, onde
  ainda não manifestou interesse. Mais recentes primeiro.
- **Os meus**: pedidos onde já manifestou interesse, ordenados por estado do
  interesse (`escolhido` no topo, depois `enviado`, depois `nao_escolhido`).

### Cartão do pedido (`CartaoPedido`)

Uma linha de topo com o nome do serviço em `titleMedium` e a etiqueta de
urgência à direita. Por baixo, a descrição do cliente em `bodyMedium`, no
máximo duas linhas com elipse. No rodapé, bairro e há quanto tempo foi criado
(`há 2 h`, `ontem`), em `bodySmall`. Miniatura quadrada de 56px à esquerda
quando há foto, com raio pequeno.

Na aba "Os meus", acrescenta a `EtiquetaEstado` do interesse no rodapé.

Contorno de 1px e raio médio, sem sombra, tal como o resto da app. Toque abre o
detalhe.

### Etiqueta de urgência

Texto curto com fundo suave e raio pequeno. `Hoje` usa a cor de erro sobre
`errorContainer`; `Esta semana` e `Sem pressa` usam `primaryContainer` e a
superfície alternativa, respectivamente. Nunca só cor a distinguir: o texto
diz sempre qual é.

### Estados do ecrã

Os três têm de existir, e a lista vazia é o caso normal no arranque, não uma
excepção:

- **A carregar**: três cartões em esqueleto, não um indicador ao centro.
- **Vazio, aba Disponíveis**: `Ainda não há pedidos nas suas zonas.` com apoio
  `Assim que entrar um pedido de canalização em Matola A ou Machava, aparece
  aqui.` (usar as zonas reais do prestador).
- **Vazio, aba Os meus**: `Ainda não mostrou interesse em nenhum pedido.`
- **Erro**: `Não foi possível carregar os pedidos.` com botão `Tentar de novo`.

Sem "puxar para actualizar" nesta fase; um botão de actualizar na `AppBar`
chega e é mais fácil de descobrir.

## 6. Detalhe do pedido

Ecrã próprio, não folha inferior: tem conteúdo que chega e o utilizador precisa
de o ler com calma.

De cima para baixo: foto do problema a toda a largura com raio médio (quando
existe), nome do serviço em `headlineSmall`, etiqueta de urgência, descrição
completa, e uma caixa com contorno contendo bairro e data do pedido.

O bloco do contacto muda conforme o estado do interesse:

- **Sem interesse ainda**: nada de contacto. Barra de fundo com
  `Tenho interesse`.
- **`enviado`**: caixa com fundo alternativo e texto
  `O cliente está a comparar os interessados. Avisamos assim que decidir.`
  Barra de fundo com botão de texto `Retirar interesse`.
- **`escolhido`**: nome do cliente e número, com dois botões: `Ligar` e
  `Abrir no WhatsApp`. Ambos com `TODO` para `url_launcher`.
- **`nao_escolhido`**: `O cliente escolheu outro prestador.` sem contacto e sem
  acção.

Depois de manifestar interesse, mostrar um `SnackBar`: `Interesse enviado.`

### Confirmação

`Retirar interesse` pede confirmação num diálogo: título
`Retirar o interesse?`, texto `O cliente deixa de o ver na lista deste
pedido.`, acções `Retirar` e `Manter`. `Tenho interesse` não pede confirmação,
porque é reversível.

## 7. Filtros

Uma linha de chips acima da lista, na aba Disponíveis: `Todas as zonas` mais um
chip por zona do prestador, e um chip `Hoje` para urgência. Selecção múltipla
nas zonas, e `Todas as zonas` limpa as outras.

Não há filtro por categoria: o prestador só tem uma.

## 8. Controlador

`pedidosControladorProvider`, um `Notifier` com:

- estado: lista de pedidos, mapa de interesses por `pedidoId`, aba activa,
  filtros escolhidos, `aCarregar`, `erro`.
- `carregar()`: simula 800 ms e devolve os dados falsos.
- `manifestarInteresse(pedidoId)` e `retirarInteresse(pedidoId)`: alteram o
  estado local, com `TODO` para o repositório.
- getters `disponiveis` e `osMeus` que aplicam filtros e ordenação.

Nenhuma filtragem nem ordenação dentro dos widgets.

## 9. Dados falsos

Oito pedidos, todos de canalização, espalhados por Matola A, Machava, Zimpeto e
Alto Maé. Descrições realistas e curtas, escritas como um cliente escreveria:
`Torneira da cozinha a pingar há dois dias`, `Autoclismo não enche`,
`Cano rebentado atrás da casa, já fechei a água`. Urgências misturadas. Dois
deles já com interesse: um `enviado` e um `escolhido`, para se poder ver o
bloco do contacto sem ter de clicar em nada.

## 10. Fora de âmbito

Notificações push, chat, orçamento dentro da app, negociação de preço,
avaliação (é da pista do cliente), e qualquer coisa relacionada com assinatura.
A regra de visibilidade entra no sprint da assinatura, não aqui.

## 11. Aceitação

`flutter analyze` limpo, e no aparelho:

1. As duas abas trocam e mantêm o scroll de cada uma.
2. Um pedido sem interesse não mostra número de telefone em lado nenhum.
3. `Tenho interesse` move o pedido da aba Disponíveis para Os meus.
4. `Retirar interesse` pede confirmação e devolve o pedido a Disponíveis.
5. O pedido com interesse `escolhido` mostra o contacto; o `nao_escolhido` não.
6. Filtrar por uma zona reduz a lista; `Todas as zonas` repõe.
7. A lista vazia mostra a mensagem própria de cada aba, não um ecrã em branco.
8. Em modo escuro as etiquetas de urgência continuam legíveis.
