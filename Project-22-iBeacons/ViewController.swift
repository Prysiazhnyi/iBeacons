//
//  ViewController.swift
//  Project-22-iBeacons
//
//  Created by Serhii Prysiazhnyi on 21.11.2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var distanceReading: UILabel!
    
    var locationManager: CLLocationManager?
    var isAlertPresented = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            print("Разрешено всегда \(manager.authorizationStatus)")
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        
        // Мониторинг региона маяков (если это требуется)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint, identifier: "MyBeacon")
        locationManager?.startMonitoring(for: beaconRegion)
        
        // Начало ранжирования маяков
        locationManager?.startRangingBeacons(satisfying: beaconConstraint)
    }
    
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            alertBeacon(alertTitle: "Найден маячок", alertMessage: beacon.uuid.uuidString)
        } else {
            update(distance: .unknown)
            isAlertPresented = true
        }
    }
    
    func alertBeacon(alertTitle: String, alertMessage: String) {
        
        // Проверяем, активно ли уже сообщение
        if isAlertPresented {
            return
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            // Сбрасываем флаг, когда сообщение закрыто
            self.isAlertPresented = false
        })
        
        present(alert, animated: true)
       // isAlertPresented = true
        
        print("animated  -  \(isAlertPresented)")
    }
}

