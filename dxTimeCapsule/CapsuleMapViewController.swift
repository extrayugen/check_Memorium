//
//  CapsuleMapViewController.swift
//  dxTimeCapsule
//
//  Created by YeongHo Ha on 2/24/24.
//

import UIKit
import NMapsMap
import CoreLocation


class CapsuleMapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let mapView = NMFMapView(frame: view.bounds)
        view.addSubview(mapView)
        
    }
}
