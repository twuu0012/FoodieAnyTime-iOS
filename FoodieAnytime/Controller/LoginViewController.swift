//
//  LoginViewController.swift
//  FoodieAnytime
//
//  Created by Tony Wu on 7/5/18.
//  Copyright © 2018 Tony Wu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwdField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        
        if emailField.text == nil && passwdField.text == nil {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            Auth.auth().signIn(withEmail: emailField.text!, password: passwdField.text!) { (user, error) in
                
                if error == nil {
                    print("Login Successfully!")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigation")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
        }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
