//
//  TableViewController.swift
//  WordList
//
//  Created by Ege Sucu on 12.12.2018.
//  Copyright © 2018 Ege Sucu. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class TableViewController: UITableViewController {
    
    var words : Results<Word>!
    let realm = try! Realm()
    var engWord = ""
    var germWord = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAccess()
        words = realm.objects(Word.self)
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func refresh()
    {
        // Updating your data here...
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       words = realm.objects(Word.self)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return words.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        
        let word = words[indexPath.row]
        
        cell.textLabel?.text = word.germanWord
        cell.detailTextLabel?.text = word.englishWord
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            if let item = words?[indexPath.row] {
                try! realm.write {
                    realm.delete(item)
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
        }
    }
    
    
 
    @IBAction func addWord(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add", message: "Add a new Word", preferredStyle: .alert)
        alert.addTextField { (germanTextField) in
            germanTextField.placeholder = "German Word"
        }
        alert.addTextField { (englishTextField) in
            englishTextField.placeholder = "English Word"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let germanWord = alert?.textFields![0].text
            let englishWord = alert?.textFields![1].text
            let word = Word()
            word.germanWord = germanWord ?? "Error"
            word.englishWord = englishWord ?? "Error AGAİN"
            
            try! self.realm.write {
                self.realm.add(word)
            }
            do{
                self.tableView.reloadData()
            }
            
        }))
       self.present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        germWord = words[indexPath.row].germanWord
        engWord = words[indexPath.row].englishWord
        self.performSegue(withIdentifier: "view", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "view" {
            let destinationVC = segue.destination as! PreviewViewController
            destinationVC.germanText = germWord
            destinationVC.englishText = engWord
        }
    }
    
    func getAccess (){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (didAllow, error) in
            if error != nil {
                print("Bildirim yaratılamadı.")
            }
            else {
                self.sendNotifications()
            }
        }
    }
    
    
    func sendNotifications(){
        let content = UNMutableNotificationContent()
        content.title = "Add new Words to your Vocab"
        content.body = "Add new german words into your vocabulary to remember them."
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "studyVocab", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        let anotherContent = UNMutableNotificationContent()
        anotherContent.title = "Study Some Words"
        anotherContent.body = "You need to study some words you have written to memorize them."
        anotherContent.sound = UNNotificationSound.default
        
        var anotherComponents = DateComponents()
        anotherComponents.hour = 20
        anotherComponents.minute = 00
        anotherComponents.weekday = 1
        
        let anotherTrigger = UNCalendarNotificationTrigger(dateMatching: anotherComponents, repeats: true)
        let anotherRequest = UNNotificationRequest(identifier: "studyWeekly", content: anotherContent, trigger: anotherTrigger)
        UNUserNotificationCenter.current().add(anotherRequest, withCompletionHandler: nil)
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
                self.navigationController!.popToRootViewController(animated: true)
            })
        }
        else {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
    
}
