import UIKit

extension UIButton {
//    static let gradientColor1 = UIColor(red: 0.831, green: 0.2, blue: 0.412, alpha: 1.0)
//    static let gradientColor2 = UIColor(red: 0.796, green: 0.678, blue: 0.427, alpha: 1.0)
    
    // 버튼 그라데이션 적용 확장
    func applyGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}


