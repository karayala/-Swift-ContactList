//
//  AddVC.swift
//  ContactList
//      The purpose of this is to provide a way to control the input that the user may give to form new contacts.
//  Created by Kartik Ayala on 3/2/16.
//  Copyright © 2016 Kartik Ayala. All rights reserved.
//

import UIKit
import CoreData

class AddVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    //var item is an object that was passed on by the main view controller. This will act as our key to the Core Data
    var item : Contact? = nil
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    

    //Outlets
    @IBOutlet weak var descriptionBox: UITextField!
    @IBOutlet var companyBox: UITextField!
    @IBOutlet var mobilePhoneBox: UITextField!
    @IBOutlet var homePhoneBox: UITextField!
    @IBOutlet var workPhoneBox: UITextField!
    
    
    
    //checkItem simply checks to see if a contact is already listed.
    //This uses the name, and phone numbers to do the matching
    func checkItem(name : String, hphone : String, mphone : String, wphone : String) -> Bool{
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        do {
            let fetchedEntities = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            // Do something with fetchedEntities
            let count = fetchedEntities.count
            for(var i = 0; i < count ; i++){
                let item1 = fetchedEntities[i].name as String!
                let phonem = fetchedEntities[i].phonemobile as String!
                let phoneh = fetchedEntities[i].phonehome as String!
                let phonew = fetchedEntities[i].phonework as String!
                if(item1  == nil || phonem == nil || phoneh == nil || phonew == nil){
                    return true
                }else{
                    if(item1 == name && (phonem == mphone || phoneh == hphone || phonew == wphone)){
                        return false
                    }
                }
            }
        } catch {
            print("Error in checkItem--AddVC")
        }
        return true
    }
    
    //Systematic
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func dismissViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //When the user taps on the "Save" button, it's supposed to create and save the data and dismiss the viewController
    @IBAction func saveButton(sender: AnyObject) {
        createTask()
        dismissViewController()
    }
    
    //the Cancel button is supposed to simply dismiss the view controller (bring back to the last page)
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewController()
    }
    
    //Here's the process for creating and initiating a task along with saving it.
    func createTask() {
        //1. Check if the contact already exists
        if(checkItem(descriptionBox.text!, hphone: homePhoneBox.text!, mphone: mobilePhoneBox.text!, wphone: workPhoneBox.text!)){
            
            //2. Set up Core Data tools needed
            let entityDescription = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedObjectContext)
            let task = Contact(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
            
            
            //3. Update data
            task.name = descriptionBox.text
            task.phonehome = homePhoneBox.text
            task.phonemobile = mobilePhoneBox.text
            task.phonework = workPhoneBox.text
            task.company = companyBox.text
            task.onfavorite = false
            task.isjson = false
            
            //4. Save it
            do{
                try(managedObjectContext.save())
            }catch{
                print("Error in task creation process")
            }
        }else{
            let alert = UIAlertController(title: "Uh Oh!", message: "That contact already exists", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
    
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
    }
    
    func editItem(){
        item?.name = descriptionBox.text
        
        //Save it
        do{
            try(managedObjectContext.save())
        }catch{
            print("hi")
        }
        print("Task Created")
    }
    
    

}
