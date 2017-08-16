//
//  ViewController.swift
//  Art Book
//
//  Created by Kornet Project on 15/08/2017.
//  Copyright © 2017 Kornet Project. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var nameArray = [String]()
    var yearArray = [Int]()
    var artistArray = [String]()
    var imageArray = [UIImage]()
    var selectedPainting = ""
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.retrieveInfo), name: NSNotification.Name(rawValue:"paintingCreated"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        retrieveInfo()
    }

   
    @IBAction func addButonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateVC", sender: nil)
        self.selectedPainting = ""
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateVC"{
            let destinationVC = segue.destination as! createVC
            destinationVC.chosenPainting = selectedPainting
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPainting = nameArray[indexPath.row]
        performSegue(withIdentifier: "toCreateVC", sender: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func retrieveInfo(){
        self.nameArray.removeAll(keepingCapacity: false)
        self.yearArray.removeAll(keepingCapacity: false)
        self.artistArray.removeAll(keepingCapacity: false)
        self.imageArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "name") as? String{
                        self.nameArray.append(name)
                    }
                    if let year = result.value(forKey: "year") as? Int{
                        self.yearArray.append(year)
                    }
                    if let artist = result.value(forKey: "artist") as? String{
                        self.artistArray.append(artist)
                    }
                    if let imageData = result.value(forKey: "image") as? Data{
                        let image = UIImage(data: imageData)
                        self.imageArray.append(image!)
                    }
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("There was an error")
        }
    }
}

