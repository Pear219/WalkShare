//
//  MapViewRepresentable.swift
//  WalkShare
//
//  Created by Kokona Kato on 2024/06/18.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var pinLocation: IdentifiableCoordinate?
    @Binding var distanceFromCurrentLocation: CLLocationDistance?
    
    @ObservedObject var locationManager: LocationManager

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable

        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.region = mapView.region
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? MKPointAnnotation {
                let pinLocation = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                parent.pinLocation = IdentifiableCoordinate(coordinate: pinLocation)
            }
        }

        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let mapView = gestureRecognizer.view as! MKMapView
            let locationInView = gestureRecognizer.location(in: mapView)
            let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            parent.pinLocation = IdentifiableCoordinate(coordinate: tappedCoordinate)
            
            if let currentLocation = parent.locationManager.location {
                let pinLocationCLLocation = CLLocation(latitude: tappedCoordinate.latitude, longitude: tappedCoordinate.longitude)
                let currentLocationCLLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                let distance = currentLocationCLLocation.distance(from: pinLocationCLLocation)
                parent.distanceFromCurrentLocation = distance
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.setRegion(region, animated: true)
        
        if let pinLocation = pinLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pinLocation.coordinate
            view.removeAnnotations(view.annotations)
            view.addAnnotation(annotation)
        }
    }
}
