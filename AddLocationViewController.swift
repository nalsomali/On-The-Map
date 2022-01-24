//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var userData: PostUserInformation?
    var detailItem : MKPointAnnotation?
    
    // MARK: - UI Components
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var finishButton: UIButton!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Location"
        mapView.delegate = self
        DispatchQueue.main.async {
            self.mapView.addAnnotation(self.detailItem!)
            let latitude:CLLocationDegrees = self.userData?.latitude ?? 0
            let longitude:CLLocationDegrees = self.userData?.longitude ?? 0
            let latDelta:CLLocationDegrees = 0.05
            let lonDelta:CLLocationDegrees = 0.05
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapView.setRegion(region, animated: false)
        }
        
    }
    // MARK: - Helpers
    private func setupCancelButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }
    
    @objc func cancelTapped(){
        if (storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController) != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    private func postMyData() {
        
        guard let userData = userData else { return }
        
        studentClient.postStudentLocation(student: userData) { isPosted, error in
            DispatchQueue.main.async {
                if isPosted {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showErrorAlert(message: "something went wrong!")
                }
            }
        }
    }
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        postMyData()
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
}
