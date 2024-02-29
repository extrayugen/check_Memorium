//
//  etc.swift
//  dxTimeCapsule
//
//  Created by t2023-m0031 on 2/29/24.
//

import Foundation

// 모달 당기는 제스쳐
//@objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
//    let translation = gesture.translation(in: view)
//    let velocity = gesture.velocity(in: view)
//    
//    switch gesture.state {
//    case .changed:
//        // 드래그에 따른 뷰의 위치 변경 로직
//        if translation.y > 0 { // 위로 드래그하지 않도록
//            view.transform = CGAffineTransform(translationX: 0, y: translation.y)
//        }
//    case .ended:
//        if translation.y > 100 || velocity.y > 1000 {
//            // 드래그 거리 또는 속도가 임계값을 초과하면 모달 닫기
//            dismiss(animated: true, completion: nil)
//        } else {
//            // 애니메이션으로 원래 위치로 복귀
//            UIView.animate(withDuration: 0.3) {
//                self.view.transform = .identity
//            }
//        }
//    default:
//        break
//    }
//}
