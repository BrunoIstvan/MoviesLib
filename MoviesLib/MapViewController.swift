//
//  MapViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 26/06/18.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var currentElement: String = ""
    var theater: Theater!
    var theaters: [Theater] = []
    lazy var locationManager = CLLocationManager()
    var poiAnnotations: [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = .standard
        searchBar.delegate = self
        loadXML()
        requestUserLocationAuthorization()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? URLViewController {
            vc.url = sender as! String
        }
    }
    
    func requestUserLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.pausesLocationUpdatesAutomatically = true
            
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Usuário já autorizou!")
            case .denied:
                print("Usuário negou")
            case .restricted:
                print("Sifu!")
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }

    func loadXML() {
        guard let xmlURL = Bundle.main.url(forResource: "theaters", withExtension: "xml") else {return}
        guard let xmlParser = XMLParser(contentsOf: xmlURL) else {return}
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func addTheaters() {
        for theater in theaters {
            let coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
            let annotation = TheaterAnnotation(coordinate: coordinate, title: theater.name, subtitle: theater.url)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func getRoute(destination: CLLocationCoordinate2D) {
        let request = MKDirectionsRequest()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        guard let source = locationManager.location?.coordinate else {return}
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        //request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error == nil {
                
                guard let response = response else {return}
                let routes = response.routes.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime})
                guard let route = routes.first else {return}
                print("Nome da rota:", route.name)
                print("Distância:", route.distance)
                print("Duração:", route.expectedTravelTime)
                print("Tipo de transporte:", route.transportType)
                for step in route.steps {
                    print("Em \(step.distance) metros, \(step.instructions)")
                }
                
                self.mapView.removeOverlays(self.mapView.overlays)
                self.mapView.add(route.polyline, level: .aboveRoads)
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                
                
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
}

extension MapViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if elementName == "Theater" {
            theater = Theater()
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !content.isEmpty {
            switch currentElement {
            case "name":
                theater.name = content
            case "address":
                theater.address = content
            case "latitude":
                theater.latitude = Double(content)!
            case "longitude":
                theater.longitude = Double(content)!
            case "url":
                theater.url = content
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "Theater" {
            theaters.append(theater)
        }
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        addTheaters()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let camera = MKMapCamera()
        camera.altitude = 100
        camera.pitch = 80
        camera.centerCoordinate = view.annotation!.coordinate
        mapView.setCamera(camera, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 8.0
            renderer.strokeColor = #colorLiteral(red: 0.1065191296, green: 1, blue: 0.9202408439, alpha: 1)
            return renderer
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.leftCalloutAccessoryView {
            guard let coordinate = view.annotation?.coordinate else {return}
            getRoute(destination: coordinate)
        } else {
            guard let url = view.annotation?.subtitle else {return}
            performSegue(withIdentifier: "segue", sender: url)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKAnnotationView!
        
        if annotation is TheaterAnnotation {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Theater")
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Theater")
                annotationView.image = UIImage(named: "theaterIcon")
                annotationView.canShowCallout = true
                
                let btLeft = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                btLeft.setImage(UIImage(named: "car"), for: .normal)
                annotationView.leftCalloutAccessoryView = btLeft
                
                let btRight = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btRight
            } else {
                annotationView.annotation = annotation
            }
            
        }
        
        return annotationView
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        print("Velocidade:", userLocation.location?.speed ?? 0.0)
//
//        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
//        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loading.startAnimating()
        self.view.endEditing(true)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text!
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            self.loading.stopAnimating()
            
            if error == nil {
                guard let response = response else {return}
                self.mapView.removeAnnotations(self.poiAnnotations)
                self.poiAnnotations.removeAll()
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    self.poiAnnotations.append(annotation)
                }
                self.mapView.addAnnotations(self.poiAnnotations)
            }
        }
    }
}
















