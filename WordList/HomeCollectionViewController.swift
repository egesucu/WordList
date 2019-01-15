//
//  HomeCollectionViewController.swift
//  WordList
//
//  Created by Ege Sucu on 13.01.2019.
//  Copyright © 2019 Ege Sucu. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

private let reuseIdentifier = "Word"

class HomeCollectionViewController: UICollectionViewController {
    
    
    var words : Results<Word>!
    let realm = try! Realm()
    var engWord = ""
    var germWord = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAccess()
        words = realm.objects(Word.self)


        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        words = realm.objects(Word.self)
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
        anotherComponents.hour = 22
        anotherComponents.minute = 00
        anotherComponents.weekday = 1
        
        let anotherTrigger = UNCalendarNotificationTrigger(dateMatching: anotherComponents, repeats: true)
        let anotherRequest = UNNotificationRequest(identifier: "studyWeekly", content: anotherContent, trigger: anotherTrigger)
        UNUserNotificationCenter.current().add(anotherRequest, withCompletionHandler: nil)
        
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return words.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        let word = words[indexPath.row]
        
        cell.wordLabel.text = word.germanWord
        return cell
    }
    
    @IBAction func addWordIntoList(_ sender: UIBarButtonItem) {
        
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
            defer{
                     self.collectionView.reloadData()
               
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
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
    
    
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
