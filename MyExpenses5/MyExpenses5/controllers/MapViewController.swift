//
//  MapViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 1/18/26.
//  Copyright © 2026 Home Office. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    private var hasZoomed = false   // Prevents repeated auto-zoom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Maps"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        setupMapView()
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.layer.borderColor = UIColor.black.cgColor
        self.mapView.layer.borderWidth = 0.5
    }
    
    //MARK: - mapping functions
    
    private func setupMapView() {
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = .follow
        self.mapView.delegate = self
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}


extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, !hasZoomed else { return }

        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 500,   // Zoom level (in meters), change from 1000 to 500
            longitudinalMeters: 1000
        )

        self.mapView.setRegion(region, animated: true)
        hasZoomed = true
        
        //-- Add user location pin (once)
        if self.mapView.annotations.filter({ $0 is CustomAnnotation }).isEmpty {
            let userPin = CustomAnnotation(
                title: "You are here",
                subtitle: nil,
                coordinate: location.coordinate
            )
            self.mapView.addAnnotation(userPin)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error)
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //-- Keep default user blue dot
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "CustomPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView?.canShowCallout = true
            pinView?.markerTintColor = .systemOrange
            pinView?.glyphImage = UIImage(systemName: "mappin")
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
}
