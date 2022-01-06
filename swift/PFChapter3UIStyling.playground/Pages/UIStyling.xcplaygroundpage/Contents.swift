import PlaygroundSupport
import UIKit

public func <> <A: AnyObject>(_ f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
    return { a in
        f(a)
        g(a)
    }
}

// MARK: Styling Functions
let viewRoundedStyle: (UIView) -> Void = {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 4
    $0.layer.cornerCurve = .continuous
}

func viewBorderStyle(color: UIColor, width: CGFloat) -> (UIView) -> Void {
    return {
        $0.layer.borderColor = color.cgColor
        $0.layer.borderWidth = width
    }
}

let textFieldBaseStyle: (UITextField) -> Void =
viewRoundedStyle
<> viewBorderStyle(color: UIColor(white: 0.75, alpha: 1), width: 1)
<> { (textField: UITextField) in
    textField.borderStyle = .roundedRect
    textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
}

func baseButtonStyle(_ button: UIButton) {
  button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
  button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
}

let roundedButtonStyle = baseButtonStyle <> viewRoundedStyle

let filledButtonStyle = roundedButtonStyle <> {
    $0.backgroundColor = .black
    $0.tintColor = .white
}

let borderButtonStyle =
    roundedButtonStyle
<> viewBorderStyle(color: .black, width: 2)

// MARK: Styling View Controller
final class StylingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let gradientView = GradientView()
        gradientView.fromColor = UIColor(red: 0.5, green: 0.85, blue: 1, alpha: 0.85)
        gradientView.toColor = .white
        gradientView.translatesAutoresizingMaskIntoConstraints = false
            
        let baseButton = UIButton()
        baseButtonStyle(baseButton)
        baseButton.setTitle("Base Button", for: .normal)
        
        let filledButton = UIButton()
        filledButtonStyle(filledButton)
        filledButton.setTitle("Filled Button", for: .normal)
        
        let borderedButton = UIButton()
        borderButtonStyle(borderedButton)
        borderedButton.setTitle("Rounded Button", for: .normal)
        
        let emailField = UITextField()
        textFieldBaseStyle(emailField)
        emailField.placeholder = "yourEmail@gmail.com"
        emailField.keyboardType = .emailAddress
        
        let rootContainer = UIStackView(
            arrangedSubviews: [
                baseButton,
                filledButton,
                borderedButton,
                emailField
            ]
        )
        
        rootContainer.axis = .vertical
        rootContainer.isLayoutMarginsRelativeArrangement = true
        rootContainer.layoutMargins = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        rootContainer.spacing = 16
        rootContainer.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(gradientView)
        self.view.addSubview(rootContainer)

        NSLayoutConstraint.activate([
          gradientView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
          gradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
          gradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
          gradientView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor),

          rootContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
          rootContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
          rootContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

// MARK: Live View
PlaygroundPage.current.liveView = StylingViewController()
