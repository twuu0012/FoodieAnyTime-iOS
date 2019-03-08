//
//  MyRecViewController.swift
//  FoodieAnytime
//
//  Created by Tony Wu on 9/5/18.
//  Copyright © 2018 Tony Wu. All rights reserved.
//

import UIKit

class MyRecViewController: UIViewController {

    var currentRec: Recipe?
    
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var processField: UILabel!
    @IBOutlet weak var materialField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.text = currentRec!.name
        processField.text = currentRec!.process
        materialField.text = currentRec!.material
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateRecipe" {
            
            let destination = segue.destination as? UpdateRecViewController
            destination?.currentRec = self.currentRec
        
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
