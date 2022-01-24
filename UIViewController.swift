//
//  UIViewController.swift
//  On the Map
//
//  Created by Nada  on 14/10/2021.
//

import Foundation
import UIKit

extension UIViewController  {
    func showErrorAlert(message: String){
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        DispatchQueue.main.async {
           self.present(ac , animated: true)
        }
        }
        
    }

