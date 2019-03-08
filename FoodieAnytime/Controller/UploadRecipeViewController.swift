//
//  UploadRecipeViewController.swift
//  FoodieAnytime
//
//  Created by Tony Wu on 7/5/18.
//  Copyright © 2018 Tony Wu. All rights reserved.
//

import UIKit
import Firebase

class UploadRecipeViewController: UIViewController {

    var dbRef: DatabaseReference!
    var currentUid: String?
    var userName: String?
    
    @IBOutlet weak var materialField: UITextField!
    @IBOutlet weak var processField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("recipe")
    }
    
    @IBAction func saveRecipe(_ sender: Any) {
        if titleField.text == "" && processField.text == "" && materialField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "You need to enter title, process and material!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }else{
                let title = titleField.text!
                let material = materialField.text!
                let process = processField.text!
//                print(currentUid)
                let recipe = Recipe(name: title, process: process, material: material, addByUser: self.userName!, hostId: self.currentUid!)
                dbRef.childByAutoId().setValue(recipe.toAnyObject())
                print("Upload successfully")
            
                let alertController = UIAlertController(title: "Congrats", message: "Your recipe has been uploaded successfully!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
            })
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
