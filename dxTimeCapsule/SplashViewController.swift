//
//  LaunchScreenViewController.swift
//  dxTimeCapsule
//
//  Created by Lee HyeKyung on 2024/02/24.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // 첫 번째 이미지(닫힌 상태)
        let closedBoxImageView = UIImageView(image: UIImage(named: "AdobeBox_Close"))
        closedBoxImageView.contentMode = .scaleAspectFit

        // 두 번째 이미지(열린 상태)
        let openBoxImageView = UIImageView(image: UIImage(named: "AdobeBox_Open"))
        openBoxImageView.contentMode = .scaleAspectFit
        openBoxImageView.alpha = 0 // 초기에는 투명하게 설정하여 보이지 않도록 함

        view.addSubview(openBoxImageView) // 두 번째 이미지를 먼저 추가합니다.
        view.addSubview(closedBoxImageView)

        // SnapKit을 사용하여 이미지 뷰 위치와 크기 설정
        closedBoxImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(220)
        }

        openBoxImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(220)
        }

        // 두 이미지를 연속적으로 표시하기 위해 애니메이션 적용
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
            // 열린 상태의 이미지를 투명하지 않게 함 (페이드 인 효과)
            openBoxImageView.alpha = 1.0
        }, completion: { _ in
            // 애니메이션 종료 후 작업을 추가할 수 있음

        })
    }
}

#if DEBUG

import SwiftUI

//UIViewControllerRepresentable는 SwiftUI내에서 UIViewController를 사용할 수 있게 해줌
struct LaunchScreenViewControllerPresentable : UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        SplashViewController()
    }
}

// 미리보기 제공
struct LaunchScreenViewControllerPresentable_PreviewProvider : PreviewProvider {
    static var previews: some View{
        LaunchScreenViewControllerPresentable()
    }
}
#endif
