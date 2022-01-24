//
//  TableViewController.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation

import UIKit
import MapKit
class TableViewController: UITableViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var detailItem : [MKAnnotation] = []
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target:self, action: #selector(addButtonTapped)), UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logOut))
        navigationItem.title = "On the Map"
        
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
                    self.tableView.reloadData()
                }
            }
        }
    }
    @objc func refresh(){
        detailItem.removeAll()
        tableView.reloadData()
        getStudents()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItem.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let studentInformation = detailItem[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = studentInformation.title ?? ""
        cell.detailTextLabel?.text = studentInformation.subtitle ?? ""
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mediaURLString = detailItem[indexPath.row].subtitle, let urlStr = mediaURLString, let url = URL(string: urlStr) {
            UIApplication.shared.open(url)
        }
    }
}
