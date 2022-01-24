//
//  InfoPostingViewController.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    var userData = PostUserInformation(uniqueKey: BaseClient.userKey, firstName: "", lastName: "", mapString: "", mediaURL: "", latitude: 0, longitude: 0)
    var detailItem = MKPointAnnotation()
    lazy var geocoder = CLGeocoder()
    
    // MARK: - UI Components
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var findLocationButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.title = "Add Location"
        indicatorAndButtonSetups(activityIndicator: true, findLocation: false)
        activityIndicatorView.stopAnimating()
        self.locationTextField.delegate = self
        self.urlTextField.delegate = self
        getUserName()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Helpers
    private func getUserName() {
       onTheMapClient.getSession(userId: BaseClient.userKey) { userInfo, error in
            DispatchQueue.main.async {
                if error != nil {
                    self.showErrorAlert(message: "something went wrong!")
                    return
                }
                
                if let userInfo = userInfo {
                    self.userData.firstName = userInfo["first_name"] as! String
                    self.userData.lastName = userInfo["last_name"] as! String
                }
            }
        }
    }
    
    @objc func cancelTapped(){
        activityIndicatorView.stopAnimating()
        indicatorAndButtonSetups(activityIndicator: true, findLocation: false)
        dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if error != nil {
            indicatorAndButtonSetups(activityIndicator: true, findLocation: false)
            activityIndicatorView.stopAnimating()
            self.showErrorAlert(message: "Unable to Forward Geocode Address")
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            if let location = location {
                let coordinate = location.coordinate
                userData.latitude = coordinate.latitude
                userData.longitude = coordinate.longitude
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                self.detailItem = annotation
                if let vc = storyboard?.instantiateViewController(withIdentifier: "AddLocation") as? AddLocationViewController {
                    vc.userData = userData
                    vc.detailItem = detailItem
                    indicatorAndButtonSetups(activityIndicator: true, findLocation: false)
                    activityIndicatorView.stopAnimating()
                    navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                indicatorAndButtonSetups(activityIndicator: true, findLocation: false)
                activityIndicatorView.stopAnimating()
                self.showErrorAlert(message: "location wasn't found!")
                
            }
        }
    }
    @IBAction func findLocationAction(_ sender: UIButton) {
        
        indicatorAndButtonSetups(activityIndicator: false, findLocation: true)
        activityIndicatorView.startAnimating()
        userData.mapString = locationTextField.text ?? ""
        userData.mediaURL = urlTextField.text ?? ""
        
        geocoder.geocodeAddressString(userData.mapString) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    private func indicatorAndButtonSetups(activityIndicator: Bool, findLocation: Bool){
        activityIndicatorView.isHidden = activityIndicator
        findLocationButton.isHidden = findLocation
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if urlTextField.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keybordWillHide(_ notification:Notification) {
        if urlTextField.isFirstResponder && view.frame.origin.y != 0{
            view.frame.origin.y = 0
        }
    }
    
    @objc func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
}
