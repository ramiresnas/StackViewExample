# UIStackView

Created: Jun 06, 2020 11:36 AM
Last Updated: Jun 06, 2020 3:55 PM
Tags: ios, stackview, swift, uikit

## O Problema

Quando você quer posicionar algum elemento na tela de um aplicativo iOS, é muito comum começar a escrever suas constraints. E isso não é ruim, eu gosto de como as constraints foram pensadas, e da forma como elas funcionam. Mas quando você está em projetos grandes e estes projetos têm diversos elementos em uma mesma tela,  nos deparamos com muitas linhas de código para posicionar um elemento na tela. Não é incomum ter extensões no seu código que tentem facilitar a leitura de contrainsts, por exemplo:

```swift
extension UIView {

    @discardableResult
    func enableAutolayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    @discardableResult
    func centerX(in view: UIView) -> Self {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return self
    }

    @discardableResult
    func centerY(in view: UIView) -> Self {
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return self
    }

    @discardableResult
    func width( _ anchor: NSLayoutDimension , multiplier: CGFloat = 1 ) -> Self {
        widthAnchor.constraint(equalTo: anchor, multiplier: multiplier).isActive = true
        return self
    }

    @discardableResult
    func height( _ anchor: NSLayoutDimension , multiplier: CGFloat = 1 ) -> Self {
        heightAnchor.constraint(equalTo: anchor, multiplier: multiplier).isActive = true
        return self
    }

    @discardableResult
    func width( _ value: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: value).isActive = true
        return self
    }

    @discardableResult
    func height( _ value: CGFloat ) -> Self {
        heightAnchor.constraint(equalToConstant: value).isActive = true
        return self
    }
}
```

Não é a toa que a comunidade tem criado algumas alternativas, como: [SnapKit](https://github.com/SnapKit/SnapKit), [TinyContraints](https://github.com/roberthein/TinyConstraints), [Cartograph](https://github.com/robb/Cartography)y, [EasyPeas](https://github.com/nakiostudio/EasyPeasy)y, [Stevia](https://github.com/freshOS/Stevia). Mas o fato é que o problema ainda estará lá, ainda teremos algumas linhas de código dedicadas para posicionar elementos na tela. Quando temos poucos elementos isso não é um problema. Mas quando temos muitos elementos na tela isso é complicado de gerenciar, principalmente quando estes elementos possuem condições para serem ou não adicionados.

Em resumo os problemas que queremos resolver é:

- Não precisar criar constraints para todos os elementos, principalmente quando temos diversos elementos em uma tela.
- Tornar o controle de estados mais simples, por exemplo:

    ```swift
    if user.isAdmin {
    	// shown all admin views
    } else {
    	// shown only user views
    }

    // É comum tbm em validação de fomulários, com combo box.

    if isStateSelected {
    	// shown cities views
    } else {
    	// hidde cities views
    }
    ```

- Tornar mudanças mais simples de se fazer, como trocar a posição de elementos.

Esses são alguns problemas que geralmente tornam o uso de constraints muito complicado e verboso. Existem ainda outros problemas tais como, mudar a direção de alguns elementos quando o App estiver sendo usado por algum usuário de um país oriental (já que lá não a leitura não é da esquerda pra direita).  Mas vamos deixar isso para uma outra oportunidade.  

Você conseguiu se identificar com um ou mais destes problemas? Então vamos ver como podemos resolver isso de forma muito simples.

## StackView

Todos os problemas citados na seção anterior são resolvidos de forma bastante simples utilizando StackView. Ao adicionar views a uma StackView ela admite algumas convenções e espera que você esteja ciente disso. É lógico que você pode configurar alguns comportamentos, o que tornam as coisas menos engessadas. Então antes de partir para o código, é importante você entender como uma stack funciona, eu listei alguns pontos principais:

- Não é neccessário  definir altura nem largura;
- Não é possível definir um `backgroundColor` diretamente (dá pra fazer isso de outra forma, te conto depois);
- É auto dimensionada baseando-se nas views que foram adicionadas;
- Apesar de possuir o método `func addSubview(_ view: UIView)` você deve usar o método `func addArrangedSubview(_ view: UIView)` para obter o comportamento esperado por uma StackView;
- As contraints das  `arrangedSubviews` são limitadas em altura e largura, ou seja qualquer tentativa de posicionar `views`utilizando as conhecidas constraints, irão falhar. Pois a stackView irá sobrescrever com base em suas configurações.

O posicionamento de uma `view` dentro de uma `StackView`  é defino através das propriedades, `axis`, `distribution`, `alignment` e `spacing`.

![https://docs-assets.developer.apple.com/published/82128953f6/uistack_hero_2x_04e50947-5aa0-4403-825b-26ba4c1662bd.png](https://docs-assets.developer.apple.com/published/82128953f6/uistack_hero_2x_04e50947-5aa0-4403-825b-26ba4c1662bd.png)

A propriedade `axis` define se a `StackView` será `horizontal` ou `vertical`.  Para facilitar a leitura e uso, podemos criar duas subclasses de `UIStackView` uma que será `vertical` e outra que será `horizontal` que iremos chamar de `VStack` e `HStack`, respectivamente.  

Poderíamos criar só uma `extension` se o objetivo fosse unicamente criar um inicializador diferente, mas a intenção aqui é tornar explicito que determinada stack será vertical ou horizontal.

```swift
class VStack: UIStackView {

    init(spacing: CGFloat = 16, distribution: UIStackView.Distribution = .fill,
								alignment: UIStackView.Alignment = .fill) {

        super.init(frame: .zero)
        self.axis = .vertical
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
}

class HStack: VStack {

		override init(spacing: CGFloat = 16,
						      distribution: UIStackView.Distribution = .fill,
		              alignment: UIStackView.Alignment = .fill) {

        super.init(spacing: spacing, distribution: distribution,
										alignment: alignment)
        axis = .horizontal
    }
}

extension UIStackView {
    func addArrangedSubviewList(views: UIView ...)  {
        views.forEach({addArrangedSubview($0)})
    }
}
```

## Mãos na massa

O código abaixo é um exemplo simples, onde estou usando as extensões que foram colocadas logo a cima. A intenção é reduzir linhas de código que não irão acrescentar em nada no nosso exemplo.  

```swift
class ViewController : UIViewController {

    private var verticalStack = HStack()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(verticalStack)

        verticalStack
            .enableAutolayout()
            .centerX(in: view)
            .centerY(in: view)

        playWithStack()
    }

		func playWithStack() {
        let firstName = UILabel( text: "Ramires", color: .blue)
        let lastName = UILabel( text: "Moreira")
        lastName.intrinsicContentSize
        let button = UIButton(backgroundColor: .systemBlue)
        button.setTitle("My toggle Button", for: .normal)
        button.addTarget(self, action: #selector(toggleAxis), for: .touchUpInside)
        verticalStack.addArrangedSubviewList(views: firstName, lastName, button)
    }

    @objc
    func toggleAxis() {
        UIView.animate(withDuration: 0.3) {
            self.verticalStack.axis.toggle()
        }
    }
}
```

![UIStackView%20f17d4fb4c8d34c28b87a81346aecea8e/2020-06-06_13.33.55.gif](UIStackView%20f17d4fb4c8d34c28b87a81346aecea8e/2020-06-06_13.33.55.gif)

Note como é simples. Nesse caso não foi necessário configurar altura nem largura das nossas `labels` e `button`. Pois  `UILabel` e `UIButton` possuem um tamanho intrínseco `intrinsicContentSize` e a `StackView` usa esses valores. Mas isso não é verdade quando se trata de uma `UIView` pura. Vejamos um exemplo:

```swift
func playWithStack() {
	let blueView = UIView(backgroundColor: .blue)
	let redView = UIView(backgroundColor: .red)
	let purpleView = UIView(backgroundColor: .purple)
	verticalStack.addArrangedSubviewList(views: blueView, redView, purpleView)
}
```

Ao compilar o código acima não irá aparecer nada na tela, isso porque nossas views não possuem altura nem largura definidas. Vamos fazer isso.

```swift
func playWithStack() {
    let blueView = UIView(backgroundColor: .blue).width(50).height(50)
    let redView = UIView(backgroundColor: .red).width(50).height(80)
    let purpleView = UIView(backgroundColor: .purple).width(50).height(100)
    verticalStack.addArrangedSubviewList(views: blueView, redView, purpleView)
}
```

O código acima produz um resultado inesperado (imagem à esquerda). Note que nesta imagem todas as `views` são apresentadas com alturas iguais, porém o código está configurado com alturas de  `50`, `80` e `10`, respectivamente. Isso acontece porque definimos que o alinhamento padrão será `UIStackView.Alignment.fil`. Para corrigir isso podemos configurar um outro alinhamento.

```swift
verticalStack.alignment = .center
```

Perceba que agora as `views` estão com a altura correta (imagem à direita).

![UIStackView%20f17d4fb4c8d34c28b87a81346aecea8e/Captura_de_Tela_2020-06-06_as_13.47.47.png](UIStackView%20f17d4fb4c8d34c28b87a81346aecea8e/simulador.png)

Comportamentos como esses são comuns de acontecer, como foi dito no início deste post, a `StackView` sobrescreve as constraints dependendo de sua configuração.

As configurações mostradas aqui não são as únicas, você pode fazer diversas combinações de `axis`, `distribution`, `alignment` e `spacing`. O post ficaria muito extenso para mostrar todas as combinações possíveis. Mas para que você possa exercitar isso, eu deixei o código fonte deste exemplo no github [neste link](https://github.com/ramiresnas/StackViewExample).

## Conclusão

Então você acha que isso consegue resolver os problemas citados no início? Ou é só mais uma forma  complicada de fazer a mesma coisa? Todos os feedbacks são bem vindos. Eu espero que isso lhe ajude a criar interfaces de forma mais simples e que facilite a leitura do seu código.
Eu pensei em fazer um paralelo com um código escrito usando constraints, mas desisti, afinal você já sabe o quanto iria escrever se estivesse usando constraints.
