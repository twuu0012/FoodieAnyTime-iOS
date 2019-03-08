//
//  OtherRecViewController.swift
//  FoodieAnytime
//
//  Created by Tony Wu on 9/5/18.
//  Copyright © 2018 Tony Wu. All rights reserved.
//

import UIKit

class OtherRecViewController: UIViewController {

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
