//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

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

    func playWithStackLabels() {
        let firstName = UILabel( text: "Ramires", color: .blue)
        let lastName = UILabel( text: "Moreira")
        lastName.intrinsicContentSize
        let button = UIButton(backgroundColor: .systemBlue)
        button.setTitle("My toggle Button", for: .normal)
        button.addTarget(self, action: #selector(toggleAxis), for: .touchUpInside)
        verticalStack.addArrangedSubviewList(views: firstName, lastName, button)
    }

    func playWithStack() {
        verticalStack.alignment = UIStackView.Alignment.center
        let blueView = UIView(backgroundColor: .blue).width(50).height(50)
        let redView = UIView(backgroundColor: .red).width(50).height(80)
        let purpleView = UIView(backgroundColor: .purple).width(50).height(100)
        verticalStack.addArrangedSubviewList(views: blueView, redView, purpleView)
    }

    @objc
    func toggleAxis() {
        UIView.animate(withDuration: 0.3) {
            self.verticalStack.axis.toggle()
        }
    }
}


extension NSLayoutConstraint.Axis {

    mutating func toggle() {
        if self == .vertical {
            self = .horizontal
        }else {
            self = .vertical
        }
    }
}


extension UIStackView {
    func addArrangedSubviewList(views: UIView ...)  {
        views.forEach({addArrangedSubview($0)})
    }
}

public class VStack: UIStackView {

    public init(spacing: CGFloat = 16 , distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }

    public required init(coder: NSCoder) {
        fatalError()
    }
}

public class HStack: VStack {

    public override init(spacing: CGFloat = 16, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill) {
        super.init(spacing: spacing, distribution: distribution, alignment: alignment)
        axis = .horizontal
    }

    public required init(coder: NSCoder) {
        fatalError()
    }
}

extension UIStackView {

    convenience init(name: String) {
        self.init(frame: .zero)
    }
}

public extension UILabel {
    convenience init(text: String, color: UIColor = .black, backgroundColor: UIColor = .white) {
        self.init(frame: .zero)
        textColor = color
        self.backgroundColor = backgroundColor
        self.text = text
    }
}

public extension UIView {

    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }

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

    static func spacer(color: UIColor = .white ) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
}

PlaygroundPage.current.liveView = ViewController()
