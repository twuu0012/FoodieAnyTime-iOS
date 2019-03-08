//
//  SignUpViewController.swift
//  FoodieAnytime
//
//  Created by Tony Wu on 7/5/18.
//  Copyright © 2018 Tony Wu. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwdField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createUser(_ sender: Any) {
        if emailField.text == "" && userNameField.text == "" && passwdField.text == "" && countryField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "All Fields Need To Be Filled In!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }else{
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwdField.text!, completion: { (user, error) in
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    print("creating user...")
                    
                    guard let uid = user?.uid else { return }
                    
                    let value = ["email": self.emailField.text!, "username": self.userNameField.text!, "country": self.countryField.text!] as [String : Any]
                    
                    self.registerIntoDatabase(uid, value: value
                    )
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigation")
                    self.present(vc!, animated: true, completion: nil)
                }
            })
        }
    }
    
    private func registerIntoDatabase(_ uid: String, value: [String : Any]) {
        
        let ref = Database.database().reference()
        let userReference = ref.child("user").child(uid)
        
        userReference.updateChildValues(value, withCompletionBlock: {(ref, error) in
            if error != nil{
                let alertController = UIAlertController(title: "Error", message: error.description(), preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                print("Sign up successfully")
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
