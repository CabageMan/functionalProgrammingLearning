import UIKit

public final class GradientView: UIView {
    public var fromColor: UIColor =  .clear {
        didSet { updateGradient() }
    }
    public var toColor: UIColor = .clear {
        didSet { updateGradient() }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    public override init(frame: CGRect = .zero) {
      super.init(frame: frame)

      self.gradientLayer.locations = [0, 1]
      self.layer.insertSublayer(self.gradientLayer, at: 0)
    }

    public required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
      self.gradientLayer.frame = self.bounds
    }
    
    private func updateGradient() {
      self.gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
    }
}
