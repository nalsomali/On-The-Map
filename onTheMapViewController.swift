//
//  onTheMapViewController.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation

import MapKit
import UIKit

class OnTheMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var detailItem : [MKPointAnnotation] = []
    
    // MARK: - UI Components
    
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target:self, action: #selector(addButtonTapped)), UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logOut))
        navigationItem.title = "On the Map"
        mapView.delegate = self
        getStudents()
    }
    
    // MARK: - Helpers
    
    @objc func addButtonTapped () {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "InfoPosting") as? InformationPostingViewController {
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
    @objc private func logOut(){
        onTheMapClient.deleteSession() { sessionResponse, error in
            DispatchQueue.main.async {
                if error != nil {
                    self.showErrorAlert(message: "something went wrong!")
                    return
                }
                if sessionResponse != nil {
                    BaseClient.userKey = ""
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    private func getStudents() {
        studentClient.getStudentLocation(params: ["limit": "100", "order":"-updatedAt"]) { result, error in
            if error != nil {
                self.showErrorAlert(message: "something went wrong!")
                return
            }
            if !result.isEmpty {
                for item in result {
                    let lat = CLLocationDegrees(item.latitude)
                    let long = CLLocationDegrees(item.longitude)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let first = item.firstName
                    let last = item.lastName
                    let mediaURL = item.mediaURL
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    self.detailItem.append(annotation)
                }
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(self.detailItem)
                }
            }
        }
    }
    @objc func refresh(){
        mapView.removeAnnotations(detailItem)
        detailItem.removeAll()
        getStudents()
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "Pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = btn
        }else {
            pinView?.annotation = annotation
        }
        pinView?.pinTintColor = .purple
        pinView?.tintColor = .purple
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURLString = view.annotation?.subtitle, let urlStr = mediaURLString, let url = URL(string: urlStr) {
                UIApplication.shared.open(url)
            }
        }
    }
}
