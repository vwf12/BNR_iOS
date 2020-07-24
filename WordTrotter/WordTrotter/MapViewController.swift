//
//  MapViewController.swift
//  WordTrotter
//
//  Created by FARIT GATIATULLIN on 13/06/2020.
//  Copyright © 2020 vwf. All rights reserved.
//

//import UIKit
//import MapKit
//
//class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
//
//    var mapView: MKMapView!
//    var locationManager: CLLocationManager?
//
//
//    override func loadView() {
////        Create a map view
//        mapView = MKMapView()
//
////        Set it as *the* new view of this view controller
//        view = mapView
//
//        mapView.delegate = self
//        mapView.isZoomEnabled = true
//        mapView.showsUserLocation = true
//
//
//
//        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
//
//        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//        segmentedControl.selectedSegmentIndex = 0
//
//        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
//
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(segmentedControl)
//
//        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
//        let margins = view.layoutMarginsGuide
//        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
//        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
//
//        topConstraint.isActive = true
//        leadingConstraint.isActive = true
//        trailingConstraint.isActive = true
//
//        initLocalizationButton(segmentedControl)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("MapViewController loaded its view.")
//    }
//
//    @objc func mapTypeChanged(_ segControl:UISegmentedControl) {
//        switch segControl.selectedSegmentIndex {
//        case 0:
//            mapView.mapType = .standard
//        case 1:
//            mapView.mapType = .hybrid
//        case 2:
//            mapView.mapType = .satellite
//        default:
//            break
//        }
//    }
//
//    func initLocalizationButton(_ anyView: UIView!){
//        let localizationButton = UIButton.init(type: .system)
//        localizationButton.setTitle("Localization", for: .normal)
//        localizationButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(localizationButton)
//
//        //Constraints
//
//        let topConstraint = localizationButton.topAnchor.constraint(equalTo:anyView
//            .topAnchor, constant: 32 )
//        let leadingConstraint = localizationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
//        let trailingConstraint = localizationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
//
//        topConstraint.isActive = true
//        leadingConstraint.isActive = true
//        trailingConstraint.isActive = true
//
//        localizationButton.addTarget(self, action: #selector(MapViewController.showLocalization(sender:)), for: .touchUpInside)
//    }
//
//    @objc func showLocalization(sender: UIButton!){
//        locationManager?.requestWhenInUseAuthorization()//se agrega permiso en info.plist
//        mapView.showsUserLocation = true //fire up the method mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
//
//
//    }
//
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        let latitude = userLocation.coordinate.latitude
//        let longitude = userLocation.coordinate.longitude
//        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        let region = MKCoordinateRegion(center: center, span: span)
//
//        mapView.setRegion(region, animated: true)
//    }
//}

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var pinIndex: Int = 0
    var annotationList: [MKPointAnnotation]!
    //var locationManager: CLLocationManager?
    
    var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        return manager
    }()
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Set it as *the* view of this view controller
        view = mapView
        
        let p1 = MKPointAnnotation()
        p1.title = "Alghero"
        p1.coordinate = CLLocationCoordinate2D(latitude: 40.579693, longitude: 8.318887)
        let p2 = MKPointAnnotation()
        p2.title = "München"
        p2.coordinate = CLLocationCoordinate2D(latitude: 48.1367, longitude: 11.58862)
        let p3 = MKPointAnnotation()
        p3.title = "Moraine Lake"
        p3.coordinate = CLLocationCoordinate2D(latitude: 51.327847, longitude: -116.182474)
        annotationList = [p1, p2, p3]
        
        let randomLocationButton = UIButton()
        randomLocationButton.setTitle("Random Location", for: .normal)
        randomLocationButton.addTarget(self,
                                       action: #selector(getRandomLocation(_:)),
                                       for: .touchUpInside)
        randomLocationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        randomLocationButton.setTitleColor(UIColor.black, for: .normal)
        randomLocationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(randomLocationButton)
        
        let topRandomLocationButtonConstraint =
            randomLocationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        let leadingRandomLocationButtonConstraint =
            randomLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingRandomLocationButtonConstraint =
            randomLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        topRandomLocationButtonConstraint.isActive = true
        leadingRandomLocationButtonConstraint.isActive = true
        trailingRandomLocationButtonConstraint.isActive = true
        
        //let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        initLocalizationButton(segmentedControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
        setupUserTrackingButtonAndScaleView()
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func initLocalizationButton(_ anyView: UIView!){
        let localizationButton = UIButton.init(type: .system)
        localizationButton.setTitle("Localization", for: .normal)
        localizationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(localizationButton)
        
        //Constraints
        let topConstraint = localizationButton.topAnchor.constraint(equalTo:anyView
            .topAnchor, constant: 32 )
        let leadingConstraint = localizationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingConstraint = localizationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        localizationButton.addTarget(self, action: #selector(MapViewController.showLocalization(sender:)), for: .touchUpInside)
    }
    
    @objc func showLocalization(sender: UIButton!){
        locationManager.requestWhenInUseAuthorization()//se agrega permiso en info.plist
        mapView.showsUserLocation = true //fire up the method mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
        mapView.userTrackingMode = .follow
    }
    
    //    func showLocalization(sender: UIButton!) {
    //        locationManager?.requestWhenInUseAuthorization()
    //        self.mapView(mapView, didUpdate: location)
    //    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //This is a method from MKMapViewDelegate, fires up when the user`s location changes
        let zoomedInCurrentLocation = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?  {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "") as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotationList[pinIndex], reuseIdentifier: "")
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinTintColor = MKPinAnnotationView.purplePinColor()
        } else {
            pinView?.annotation = annotationList[pinIndex]
        }
        return pinView
    }
    
    func setupUserTrackingButtonAndScaleView() {
        mapView.showsUserLocation = true
        
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)
        
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                                     scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
                                     scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)])
    }
    
    @objc func getRandomLocation(_ sender: UIButton) {
        let region = MKCoordinateRegion(center: annotationList[pinIndex].coordinate, latitudinalMeters: 700, longitudinalMeters: 700)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotationList[pinIndex])
        pinIndex += 1
        pinIndex = pinIndex % 3
    }
}
