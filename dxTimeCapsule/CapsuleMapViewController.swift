//
//  CapsuleMapViewController.swift
//  dxTimeCapsule
//
//  Created by YeongHo Ha on 2/24/24.
//

import UIKit
import NMapsMap
import CoreLocation
import SnapKit

class CapsuleMapViewController: UIViewController {
    private lazy var nvBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    private lazy var capsuleMap: NMFMapView = {
        let map = NMFMapView(frame: view.frame)
        
        return map
    }()
    // 콜렉션 뷰(등록된 타임캡슐의 간략한 정보)
    private var capsuleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBlue
        collection.layer.cornerRadius = 30
        collection.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collection.layer.masksToBounds = true
        return collection
    }()
    private let dragBar: UIButton = { // 컬렉셔 뷰 상단 바
        let bar = UIButton()
        bar.backgroundColor = .black
        bar.layer.cornerRadius = 3
        return bar
    }()
    private var pageControl: UIPageControl = { // 컬렉션 뷰 페이지
        let page = UIPageControl()
        page.currentPage = 0
        page.numberOfPages = 4 // 임시
        page.currentPageIndicatorTintColor = .black
        page.pageIndicatorTintColor = .white
        return page
    }()
    // 콜렉션 뷰 원래 높이
    private var collectionHeight: CGFloat?
    // 콜렉션 뷰 드래그 할 떄, 마지막 y좌표 저장 변수
    private var lastY: CGFloat = 0
    private var flowLayout: UICollectionViewFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        autoLayouts()
        configCV()
        // 제스처 인식기로 드래그바 버튼 설정
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        dragBar.addGestureRecognizer(panGestureRecognizer)
        //pageCotrol.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
    }
    
    private func configCV() {
        capsuleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        capsuleCollectionView.delegate = self
        capsuleCollectionView.dataSource = self
        capsuleCollectionView.register(LockedCapsuleCell.self, forCellWithReuseIdentifier: LockedCapsuleCell.identifier)
        capsuleCollectionView.isPagingEnabled = true
        capsuleCollectionView.showsHorizontalScrollIndicator = false
        capsuleCollectionView.decelerationRate = .fast
        
        if let layout = capsuleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal // 스크롤 방향(가로)
            layout.sectionInset = UIEdgeInsets(top: 48, left: 24, bottom: 60, right: 24)
            layout.itemSize = CGSize(width: view.frame.width - 48, height: 110)
            layout.minimumLineSpacing = 48 // 최소 줄간격
            //layout.minimumInteritemSpacing = 0
            self.flowLayout = layout
        }
    }
    
    
}
// MARK: - UICollectionView Delegate, DataSource
extension CapsuleMapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8 // 임시 설정.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LockedCapsuleCell", for: indexPath) as? LockedCapsuleCell else {fatalError("Unable to dequeue CapsuleCollectionViewCell")}
        
        return cell
    }
    
}

extension CapsuleMapViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 클래스 프로퍼티를 사용
        if let layout = self.flowLayout {
            let width = scrollView.frame.width - (layout.sectionInset.left + layout.sectionInset.right)
            let index = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
            pageControl.currentPage = max(0, min(pageControl.numberOfPages - 1, index))
        }
       
    }
}

// MARK: - UI AutoLayout
extension CapsuleMapViewController {
    private func addSubViews() {
        self.view.addSubview(nvBar)
        self.view.addSubview(capsuleMap)
        self.view.addSubview(capsuleCollectionView)
        self.view.addSubview(dragBar)
        self.view.addSubview(pageControl)
    }
    
    private func autoLayouts() {
        nvBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        capsuleMap.snp.makeConstraints { make in
            make.top.equalTo(nvBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(capsuleCollectionView.snp.top).offset(30)
        }
        capsuleCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(capsuleMap.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(350)
        }
        dragBar.snp.makeConstraints { make in
            make.centerX.equalTo(capsuleCollectionView.snp.centerX)
            make.top.equalTo(capsuleCollectionView.snp.top).offset(12)
            make.width.equalTo(60)
            make.height.equalTo(5)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
}


// MARK: - Button
extension CapsuleMapViewController {
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        capsuleCollectionView.scrollToItem(at: IndexPath(item: current, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handleDrag(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.view)
        let velocity = gestureRecognizer.velocity(in: self.view)
        
        //let collapsedPosition: CGFloat = 500 // Adjust this value
        let midPosition: CGFloat = 300 // Adjust this value
        let fullPosition: CGFloat = 100 // Adjust this value
        
        // 제스처 인식기 상태
        switch gestureRecognizer.state {
        case .began: // 시작
            // 컬렉션 뷰 원래 높이 저장
            collectionHeight = capsuleCollectionView.frame.height
            
            print("Drag began")
        case .changed: // 변경
            // 드래그에 위치 계산
            let newPosition = max(min(collectionHeight! + translation.y, collectionHeight!), fullPosition)
            capsuleCollectionView.frame.origin.y = newPosition
            print("드래그 위치: \(newPosition)")
            
        case .ended: // 끝
            let finalPosition: CGFloat
            if velocity.y < 0 {
                finalPosition = (capsuleCollectionView.frame.origin.y <= (midPosition + fullPosition) / 2) ? fullPosition : midPosition
            } else {
                finalPosition = collectionHeight!
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.capsuleCollectionView.frame.origin.y = finalPosition
            }) { _ in
                print("애니메이션 기능 완료: \(finalPosition)")
            }
        default:
            break
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: view)
    }
}


// MARK: - Preview
import SwiftUI

struct PreView: PreviewProvider {
    static var previews: some View {
        CapsuleMapViewController().toPreview()
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

