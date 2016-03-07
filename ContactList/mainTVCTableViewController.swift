//
//  mainTVCTableViewController.swift
//  ContactList
//      mainTVCTableViewController serves as the root class in this program. This is where most of the deciisions are made.
//  Created by Kartik Ayala on 03/02/16.
//  Copyright © 2015 Kartik Ayala. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class mainTVCTableViewController: UIViewController, NSFetchedResultsControllerDelegate {
    //Tableview connections
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Obtaining resources needed for Core Data implementation
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        
        do{
            try(fetchedResultController.performFetch())
        }catch{
            print("error on view did load of addVC")
            return
        }
        
        //parses the JSON and stores it into core data right away
        parseJSON()
        
        //configure view information
        if (self.restorationIdentifier == "contactsViewStoryBoard"){
            self.tableView.rowHeight = 60
            self.tableView.reloadData()
        }else{
            self.favoritesTableView.rowHeight = 60
            self.favoritesTableView.reloadData()
        }
    }
    
    
    
    //GOAL OF FUNCTION - Parse JSON files with the use of Swifty JSON and store directly into core data.
    func parseJSON(){
        let URL : NSURL = NSURL(string: "https://solstice.applauncher.com/external/contacts.json")!
        let jsonData = NSData(contentsOfURL: URL)
        let readableJSON = JSON(data: jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        for(var i = 0; i < readableJSON.count; i++){
            let name = readableJSON[i]["name"].string as String!
            var home_Phone = readableJSON[i]["phone"]["home"].string as String!
            if(readableJSON[i]["phone"]["home"].string as String! == nil){
                home_Phone = ""
            }
            var mobile_Phone = readableJSON[i]["phone"]["mobile"].string as String!
            if(readableJSON[i]["phone"]["mobile"].string as String! == nil){
                mobile_Phone = ""
            }
            var work_Phone = readableJSON[i]["phone"]["work"].string as String!
            if(readableJSON[i]["phone"]["work"].string as String! == nil){
                work_Phone = ""
            }
            var employee_id = readableJSON[i]["employeeId"].int32 as Int32!
            if(employee_id == nil){
                employee_id = 0
            }
            var company = readableJSON[i]["company"].string as String!
            if(company == nil){
                company = ""
            }
            var details_URL = readableJSON[i]["detailsURL"].string as String!
            if(details_URL == nil){
                details_URL = ""
            }
            var birthdate = readableJSON[i]["birthdate"].string as String!
            if(birthdate == nil){
                birthdate = ""
            }
            var small_Image_URL = readableJSON[i]["smallImageURL"].string as String!
            if(small_Image_URL == nil){
                small_Image_URL = ""
            }

            if(checkItem(name, homePhone: home_Phone, mobilePhone: mobile_Phone, workPhone: work_Phone)){
                addItem(name, homeP: home_Phone, mobileP: mobile_Phone, workP: work_Phone, employeeID : employee_id, company : company, smallURL : small_Image_URL, detailURL : details_URL)
            }
        }
    }
    
    //This function allows to check if a contact has already been created.
    func checkItem(name : String, homePhone : String, mobilePhone : String, workPhone : String) -> Bool{
        // Assuming type has a reference to managed object context
        do {
            //Fetch the core data information
            let fetchRequest = NSFetchRequest(entityName: "Contact")
            let fetchedEntities = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            let count = fetchedEntities.count
            
            //This iterates through and compares the given name and number with the existing ones
            for(var i = 0; i < count ; i++){
                
                let tempName = fetchedEntities[i].name as String!
                let tempHNumber = fetchedEntities[i].phonehome as String!
                let tempMNumber = fetchedEntities[i].phonemobile as String!
                let tempWNumber = fetchedEntities[i].phonework as String!
                if(tempName == nil || tempHNumber == nil || tempMNumber == nil || tempWNumber == nil){
                    return true
                }else{
                    if(tempName == name && (tempHNumber == homePhone || tempMNumber == mobilePhone || tempWNumber == workPhone)){
                        return false
                    }
                }

            }
        } catch {
            // Do something in response to error condition
        }
        return true
    }
    
    
    //This function goes through the process of adding a contact.
    func addItem(name : String, homeP : String, mobileP : String, workP : String, employeeID : Int32, company : String, smallURL : String, detailURL : String) {
        //ENtity descriptor is needed
        
        //Get core data set up
        let entityDescription = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedObjectContext)
        let task = Contact(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        //Set its description
        task.name = name
        task.isjson = true
        task.onfavorite = false
        task.phonehome = homeP
        task.phonemobile = mobileP
        task.phonework = workP
        let empID = NSInteger(employeeID) as NSInteger!
        task.employeeid = empID
        task.company = company
        task.smallimageurl = smallURL
        task.detailsurl = detailURL
        
        //Save it
        do{
            try(managedObjectContext.save())
        }catch{
            print("error")
        }
    }
    
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if (self.restorationIdentifier == "contactsViewStoryBoard"){
            tableView.reloadData()
        }else{
            favoritesTableView.reloadData()
        }
    }
    
    //************************************CORE DATA SETUP**********************************//
    //[CD]1. Defines a variable in order to store the Managed Object Context
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    //[CD]2. Fetched Result Controller is the gateway to fetch data.
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    //[CD]3. Populating the fetchedResultController:
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    //[CD]4. Task Fetched Request:
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        let namesortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        //Depending on if we're at the favorite's screen or on the home screen, 
        //we can obtain different results using the core data. Here, we just query it using predicates
        //and sort descriptors.
        if (self.restorationIdentifier == "contactsViewStoryBoard"){
            fetchRequest.sortDescriptors = [namesortDescriptor]
        }else{
            //fetchRequest.sortDescriptors = [favoriteSortDescriptor]
            let temp = NSPredicate(format: "onfavorite == %@", NSNumber(bool: true))
            fetchRequest.predicate = temp
            fetchRequest.sortDescriptors = [namesortDescriptor]
        }
        return fetchRequest
    }
    //************************************CORE DATA SETUP**********************************//
    

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //

    //************************************TABLE VIEW SETUP**********************************//
    //[TV]1 Initialize the number of sections.
      func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }

    //[TV]2. Initialize number of rows In each section.
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    //[TV]3. initialize each height
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }

    
    //[tv4]initialize the actual cell and its contents
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if (self.restorationIdentifier == "contactsViewStoryBoard"){
            let cell = tableView.dequeueReusableCellWithIdentifier("fancyCell") as! ContactTableViewCell
            let item = fetchedResultController.objectAtIndexPath(indexPath) as! Contact
            cell.nameBox.text = item.name
            cell.phoneBox.text = item.phonemobile
            
            if(item.isjson == true){
                let imageName = item.smallimageurl
                let url = NSURL(string: imageName!)
                let data = NSData(contentsOfURL: url!)
                cell.imageBox.image = UIImage(data: data!)
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            let item = fetchedResultController.objectAtIndexPath(indexPath) as! Contact
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.phonehome 
            if(item.isjson == true){
                let imageName = item.smallimageurl
                
                let url = NSURL(string: imageName!)
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                cell.imageView?.image = UIImage(data: data!)
            }
           return cell
        }

    }
     //[TV5]. Support deleting of the cells
     func tableView(tableView: UITableView, commitEditingStyle editingStyle:    UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject : NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath as NSIndexPath!) as! NSManagedObject
        managedObjectContext.deleteObject(managedObject)
        do{
            try(managedObjectContext.save())
        }catch{
            print("error on view did load of addVC")
            return
        }
    }
//************************************TABLE VIEW SETUP^**********************************//
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //1. Check the identifier:
        if segue.identifier == "edit"{
            let cell = sender as! UITableViewCell
            if (self.restorationIdentifier == "contactsViewStoryBoard"){
                let indexPath = tableView.indexPathForCell(cell)
                let itemController : ContactDisplayViewController = segue.destinationViewController as! ContactDisplayViewController
                let item : Contact = fetchedResultController.objectAtIndexPath(indexPath!) as! Contact
                itemController.item = item
            }else{
                let indexPath = favoritesTableView.indexPathForCell(cell)
                let itemController : ContactDisplayViewController = segue.destinationViewController as! ContactDisplayViewController
                let item : Contact = fetchedResultController.objectAtIndexPath(indexPath!) as! Contact
                itemController.item = item
            }
        }
        
    }
    

}
