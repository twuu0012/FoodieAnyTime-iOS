//
//  UpdateRecViewController.swift
//  FoodieAnytime
//
//  Created by Tony Wu on 9/5/18.
//  Copyright © 2018 Tony Wu. All rights reserved.
//

import UIKit
import Firebase

class UpdateRecViewController: UIViewController {

    var currentRec: Recipe?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var processField: UITextField!
    @IBOutlet weak var materialField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.text = currentRec!.name
        processField.text = currentRec!.process
        materialField.text = currentRec!.material
        
        // Do any additional setup after loading the view.
    }
    @IBAction func updateRecipe(_ sender: Any) {
        var messageString: String = "All fields need to be filled in!"
        if titleField.text != "" && processField.text != "" && materialField.text != "" {
            
            let title = titleField.text!
            let process = processField.text!
            let material = materialField.text!
            let modifiedDate = getDate()
            
                currentRec!.itemRef?.updateChildValues(["name" : title, "process" : process, "material" : material,
                                                        "createdate" : modifiedDate])
               messageString = "This recipe has been updated!"
            print("update successfully!")
            
        }
        
        let alertController = UIAlertController(title:"Message", message:messageString, preferredStyle: UIAlertControllerStyle.alert)
        let destinationVC = navigationController!.viewControllers.filter({$0 is MainPanelViewController}).first
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.navigationController?.popToViewController(destinationVC!, animated: true)
        })
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func getDate() -> String {
        let dateString = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let currentTime = formatter.string(from: dateString)
        return currentTime as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
