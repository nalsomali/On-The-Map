//
//  ViewController.swift
//  On the Map
//
//  Created by Nada  on 21/08/2021.
//

import UIKit

class LoginViewController: UIViewController {

        @IBOutlet var imageView: UIImageView!
        @IBOutlet var emailTextfield: UITextField!
        @IBOutlet var passwordTextfield: UITextField!
        @IBOutlet var loginButton: UIButton!
        @IBOutlet var label: UILabel!
        @IBOutlet var signUpButton: UIButton!
        
        // MARK: - Helpers
        private func login(){
            if ((emailTextfield.text?.isEmpty) == true) || ((passwordTextfield.text?.isEmpty) == true) {
                self.showErrorAlert(message: "please fill the blanks!")
            }
          onTheMapClient.postSession(username: emailTextfield.text ?? "", password: passwordTextfield.text ?? "") { sessionResponse, error in
                DispatchQueue.main.async {
                    if error != nil {
                        self.showErrorAlert(message: error?.localizedDescription ?? "")
                    }
                    if let response = sessionResponse, response.account.registered {
                        BaseClient.userKey = response.account.key
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController {
                            vc.modalPresentationStyle = .fullScreen
                            self.emailTextfield.text = ""
                            self.passwordTextfield.text = ""
                            self.present(vc, animated: true)
                        } else {
                            self.showErrorAlert(message: "Incorret password, username! Please try again.")
                        }
                    }
                }
            }
        }
        @IBAction func loginButtonTapped(_ sender: UIButton) {
            login()
        }
        @IBAction func signUpButtonTapped(_ sender: Any) {
            if let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com") {
                UIApplication.shared.open(url)
            }
        }
    }

