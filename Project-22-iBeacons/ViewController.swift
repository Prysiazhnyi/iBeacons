//
//  ViewController.swift
//  Project-22-iBeacons
//
//  Created by Serhii Prysiazhnyi on 21.11.2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var isAlertPresented = true

    @IBOutlet var distanceReading: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        startScanning() // запускаем поиск маяков
        
    }
    
    func startScanning() {
        // Маяк 1
        let uuid1 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconConstraint1 = CLBeaconIdentityConstraint(uuid: uuid1, major: 123, minor: 456)
        let beaconRegion1 = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint1, identifier: "Beacon1")
        locationManager?.startMonitoring(for: beaconRegion1)
        locationManager?.startRangingBeacons(satisfying: beaconConstraint1)
        
        // Маяк 2
        let uuid2 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E6")!
        let beaconConstraint2 = CLBeaconIdentityConstraint(uuid: uuid2, major: 789, minor: 101)
        let beaconRegion2 = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint2, identifier: "Beacon2")
        locationManager?.startMonitoring(for: beaconRegion2)
        locationManager?.startRangingBeacons(satisfying: beaconConstraint2)
        
        // Маяк 3
        let uuid3 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E7")!
        let beaconConstraint3 = CLBeaconIdentityConstraint(uuid: uuid3, major: 112, minor: 113)
        let beaconRegion3 = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint3, identifier: "Beacon3")
        locationManager?.startMonitoring(for: beaconRegion3)
        locationManager?.startRangingBeacons(satisfying: beaconConstraint3)
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
            alertBeacon(alertTitle: "Найден маячок \(region.identifier)", alertMessage: beacon.uuid.uuidString)
        } else {
            update(distance: .unknown)
        }
    }
    
    func alertBeacon(alertTitle: String, alertMessage: String) {
        if isAlertPresented {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                self.isAlertPresented = false
            })
            
            present(alert, animated: true)
        }
    }
}
