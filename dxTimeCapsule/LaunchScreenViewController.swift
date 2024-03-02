//
//  LaunchScreenViewController.swift
//  dxTimeCapsule
//
//  Created by Lee HyeKyung on 2024/02/24.
//

import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let logoImageView = UIImageView(image: UIImage(named: "AdobeBox_Open")) // 로고 이미지 뷰 생성
        logoImageView.contentMode = .scaleAspectFit // 이미지 사이즈를 뷰에 맞춤

        view.addSubview(logoImageView) // 로고 이미지 뷰를 뷰에 추가

        // SnapKit을 사용하여 로고 이미지 뷰 위치와 크기 설정
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(220)
        }
    }
}

#if DEBUG

import SwiftUI

//UIViewControllerRepresentable는 SwiftUI내에서 UIViewController를 사용할 수 있게 해줌
struct LaunchScreenViewControllerPresentable : UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        LaunchScreenViewController()
    }
}

// 미리보기 제공
struct LaunchScreenViewControllerPresentable_PreviewProvider : PreviewProvider {
    static var previews: some View{
        LaunchScreenViewControllerPresentable()
    }
}
#endif
