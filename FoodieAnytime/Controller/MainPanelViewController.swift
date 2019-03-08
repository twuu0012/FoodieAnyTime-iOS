//
//  MainPanelViewController.swift
//  FoodieAnytime
//
//  Created by Tony Wu on 7/5/18.
//  Copyright © 2018 Tony Wu. All rights reserved.
//

import UIKit
import Firebase


class MainPanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var guideList = ["All Recipes", "Shops", "My Favourites", "User"]
    var userName: String?
    var currentUid: String?
    private let SECTION_COUNT = 1
    private let SECTION_RECIPES = 0
    
    var myRec = [Recipe]()
    var othersRec = [Recipe]()
    var dbRef: DatabaseReference!
    var recipe1: Recipe?
    var recipe2: Recipe?
    var favourite: Array<String>?
    var dbRef2: DatabaseReference!
    
    @IBOutlet weak var myRecipes: UITableView!
    @IBOutlet weak var otherRecipes: UITableView!
    @IBOutlet weak var guide: UICollectionView!
    
    
    @IBOutlet weak var helloUser: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRecipes.delegate = self
        myRecipes.dataSource = self
        otherRecipes.delegate = self
        otherRecipes.dataSource = self
        
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        self.guide.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        dbRef = Database.database().reference().child("recipe")
        dbRef2 = Database.database().reference().child("favourite")
        startObserveDB()
        startObserveFavourite()
//        if self.favourite == nil {
//            initFavourites()
//        }
        
        }
        // Do any additional setup after loading the view.
//        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
//        view.addSubview(activityView)
//        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout))
//        self.navigationItem.rightBarButtonItem = logoutButton


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentUid = (Auth.auth().currentUser?.uid)!
        Database.database().reference().child("user").child(currentUid!).observeSingleEvent(of: .value, with: {(DataSnapshot) in
            let values = DataSnapshot.value as? NSDictionary
            self.userName = values!["username"] as? String
            self.helloUser.text = "Welcome \(self.userName!)!"

            self.startObserveDB()
            self.startObserveFavourite()
            if self.favourite == nil {
                self.initFavourites()
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
    
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseIn, animations: {
                self.helloUser.alpha = 1}, completion: nil)
            
        
        
    }
    
    
    func startObserveDB() {
        dbRef.observe(.value, with: { (snapshot: DataSnapshot) in
            var newMyRec = [Recipe]()
            var newOtherRec = [Recipe]()
            
            for recipe in snapshot.children {
                let recObject = Recipe(snapshot: recipe as! DataSnapshot)
                if recObject.hostId == self.currentUid{
                    newMyRec.append(recObject)
                }
                newOtherRec.append(recObject)
            }
            
            self.myRec = newMyRec
            self.othersRec = newOtherRec
            self.myRecipes.reloadData()
            self.otherRecipes.reloadData()
            
        }) { (error:Error) in
            print(error.localizedDescription)
        }
    }

    func startObserveFavourite() {
        dbRef2.observe(.value, with: {(snapshot: DataSnapshot) in
            
            for favourite in snapshot.children {
                let favObject = Favourite(snapshot: favourite as! DataSnapshot)

                if favObject.hostId == self.currentUid {
                    self.favourite = favObject.favouriteList
                }
            }
            
        })
    }
    
    func initFavourites() {
        var list = [String]()
        let newFav = Favourite(hostId: self.currentUid!, favouriteList: list)
        self.dbRef2.childByAutoId().setValue(newFav.toAnyObject())
    }

    @IBAction func logoutt(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu")
            self.present(vc!, animated: true, completion: nil)
            print("Logout Successfully")
        }
        catch{
            print(error)
        }        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadRecipe" {
            let destination = segue.destination as? UploadRecipeViewController
            destination?.currentUid = self.currentUid
            destination?.userName = self.userName
        }
        if segue.identifier == "showMyRecipe" {
            
            let destination = segue.destination as? MyRecViewController
            destination?.currentRec = self.recipe1!
        }
        if segue.identifier == "showOtherRecipe" {
            
            let destination = segue.destination as? OtherRecViewController
            destination?.currentRec = self.recipe2!
            
        }
        if segue.identifier == "myFavourites" {
            let destination = segue.destination as? FavouriteTableViewController
            destination?.currentList = self.favourite!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if tableView == self.myRecipes {
            count = myRec.count
        }
        if tableView == self.otherRecipes {
            count = othersRec.count
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if tableView == self.myRecipes {
            cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            
            let recipe = myRec[indexPath.row]
            cell!.textLabel?.text = recipe.name
            cell!.detailTextLabel?.text = "Created in \(recipe.createDate!)"
        }
        if tableView == self.otherRecipes {
            cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath)
            
            let recipe = othersRec[indexPath.row]
            cell!.textLabel?.text = recipe.name
            cell!.detailTextLabel?.text = "Created by \(recipe.addByUser!)"
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView == self.myRecipes {
            return UITableViewCellEditingStyle.delete
        }else{
            return UITableViewCellEditingStyle.none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == self.myRecipes {
            if editingStyle == .delete {
                
                let recipe = myRec[indexPath.row]
                recipe.itemRef?.removeValue()
                myRecipes.reloadData()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.myRecipes {
            
            let recipe = myRec[indexPath.row]
            self.recipe1 = recipe
            print("Load View Successfully!")
            performSegue(withIdentifier: "showMyRecipe", sender: self)
            
        }
        if tableView == self.otherRecipes
        {
            
            let recipe = othersRec[indexPath.row]
            self.recipe2 = recipe
            print("Load View Successfully!")
            performSegue(withIdentifier: "showOtherRecipe", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.guideList.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = guide.dequeueReusableCell(withReuseIdentifier: "guideCell", for: indexPath) as! GuideCollectionViewCell
        
        cell.guideLabel.text = self.guideList[indexPath.item]
        
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Do \(guideList[indexPath.item])")
        if indexPath.item == 0 {
           
            performSegue(withIdentifier: "allRecipes", sender: self)
        }
        if indexPath.item == 1 {
          
            performSegue(withIdentifier: "shopSegue", sender: self)
        }
        if indexPath.item == 2 {
        
            performSegue(withIdentifier: "myFavourites", sender: self)
        }
        if indexPath.item == 3 {
            performSegue(withIdentifier: "userSegue", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GuideCollectionViewCell
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GuideCollectionViewCell
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.8)
    }
    
}
