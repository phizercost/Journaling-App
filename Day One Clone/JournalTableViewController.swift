//
//  JournalTableViewController.swift
//  Day One Clone
//
//  Created by Phizer Cost on 5/13/19.
//  Copyright © 2019 Phizer Cost. All rights reserved.
//

import UIKit
import RealmSwift

class JournalTableViewController: UITableViewController {

    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var whiteCameraBtn: UIButton!
    
    @IBOutlet weak var whiteAddBtn: UIButton!
    
    var entries : Results<Entry>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whiteCameraBtn.imageView?.contentMode = .scaleAspectFit
        whiteAddBtn.imageView?.contentMode = .scaleAspectFit
        
        
        topHeaderView.backgroundColor = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.00) 
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.00) // 4cc1fc
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getEntries()
    }
    
    func getEntries() {
        if let realm = try? Realm() {
            entries = realm.objects(Entry.self).sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToNew", sender: "camera")
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToNew", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNew"{
            if let text = sender as? String {
                if text == "camera"{
                    let createVC = segue.destination as?  CreateJournalViewController
                    createVC?.startWithCamera = true
                }
            }
        } else if segue.identifier == "tableToDetail" {
            if let entry = sender as? Entry {
                if let detailVC = segue.destination as? JournalDetailViewController {
                    detailVC.entry = entry
                }
            }
        }
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let entries = self.entries {
            return entries.count
        } else {
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell",for: indexPath) as? JournalCell {
            
            if let entry = entries?[indexPath.row]{
                cell.previewTextLabel.text = entry.text
                if let image = entry.pictures.first?.thumbnail() {
                    cell.imageViewWidth.constant = 100
                    cell.previewImageView.image = image
                } else {
                    cell.imageViewWidth.constant = 0
                }
                cell.monthLabel.text = entry.monthString()
                cell.dayLabel.text = entry.dayString()
                cell.yearLabel.text = entry.yearString()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let entry = entries?[indexPath.row]{
            performSegue(withIdentifier: "tableToDetail", sender: entry)
        }
    }

}

class JournalCell: UITableViewCell {
    
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var previewTextLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
}
