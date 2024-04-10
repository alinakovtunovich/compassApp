//
//  ViewController.swift
//  Compass
//
//  Created by Alina Kovtunovich on 4/10/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let compasView = CompasView()
    
    // этот объект управляет получением данных о местоположении устройства
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        
        self.view.backgroundColor = .lightGray
        
        // отрисовка квадрата, в котором будут находиться все части компаса
        compasView.frame.size = CGSize(width: view.bounds.width, height: view.bounds.width) // height?
        compasView.center = view.center
        compasView.backgroundColor = .clear
        view.addSubview(compasView)
        
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        UIView.animate(withDuration: 0.5) {
            self.compasView.transform = CGAffineTransform(rotationAngle: CGFloat(-1 * newHeading.trueHeading * . pi / 180))
        }
        
    }
}

