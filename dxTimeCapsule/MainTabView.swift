import UIKit

class MainTabView: UIViewController {

    let label = UILabel()
    var viewModel: MainTabViewModel

    init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
}


//MARK: - Style & Layouts
extension MainTabView {

    private func setup() {
        // 초기 셋업할 코드들
    }

    private func style() {
        view.backgroundColor = .systemBackground

        // [Label]
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.text = viewModel.welcomeMessage // ViewModel에서 메시지 가져오기
        view.addSubview(label)
    }

    private func layout() {

        // [label] 기본 중앙 배치
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Preview
import SwiftUI

struct MainViewControllerPreview: PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: MainTabViewModel())
            .toPreview()
    }
}

#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
