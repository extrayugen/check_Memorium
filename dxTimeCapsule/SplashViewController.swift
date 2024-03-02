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
//        let openBoxImageView = UIImageView(image: UIImage(named: "AdobeBox_Open"))
//        openBoxImageView.contentMode = .scaleAspectFit
//        openBoxImageView.alpha = 0 // 초기에는 투명하게 설정하여 보이지 않도록 함
        
        view.addSubview(closedBoxImageView)
//        view.addSubview(openBoxImageView)
        
        // SnapKit을 사용하여 이미지 뷰 위치와 크기 설정
        closedBoxImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
//        openBoxImageView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(400)
//        }
        
        // 첫 번째 이미지 2초 후 사라짐
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 1.0, animations: {
                closedBoxImageView.alpha = 0
            }) { _ in
                // 두 번째 이미지 페이드 인
//                UIView.animate(withDuration: 1.0, animations: {
//                    openBoxImageView.alpha = 1.0
//                }) { _ in
                    // 두 번째 이미지 1초 후 사라짐 및 로그인 뷰 컨트롤러로 전환
                    UIView.animate(withDuration: 1.0, animations: {
                        closedBoxImageView.alpha = 0
                    }) { _ in
                        // 로그인 뷰 컨트롤러로 전환하는 코드
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
                        
                        UIView.transition(with: sceneDelegate.window!, duration: 1, options: .transitionCrossDissolve, animations: {
                            sceneDelegate.window?.rootViewController = LoginViewController()
                        }, completion: nil)
                    }
                }
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
