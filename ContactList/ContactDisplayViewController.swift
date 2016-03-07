//
//  ContactDisplayViewController.swift
//  ContactList
//
//      The goal of this class is to serve as the vuew controller for the contact display. This is where the               information will be displayed and rendered
//
//  Created by Kartik Ayala on 3/2/16.
//  Copyright © 2016 Kartik Ayala. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class ContactDisplayViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    //COnnections//
    @IBOutlet weak var saveFav: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    //JSON FILE VARIABLES
    var favorite = false
    var largeImageURL = ""
    var email = ""
    var website = ""
    var address = [String]()
    var coords = [Float]()
    //JSON FILE VARIABLES
    
    
    var item : Contact? = nil
    
    //The parsing of the extra data will be done in this function
    override func viewDidLoad() {
        //JSON parsing setup
        super.viewDidLoad()
        if(item?.isjson == true && item?.detailsurl != nil){
            let URL : NSURL = NSURL(string: (item?.detailsurl)!)!
            let jsonData = NSData(contentsOfURL: URL)
            let readableJSON = JSON(data: jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            
            //Thoroughly checks for any possible defects

            if(readableJSON["favorite"].bool != nil){
                favorite = readableJSON["favorite"].bool!
            }else{
                favorite = false
            }
            
            if(readableJSON["largeImageURL"].string != nil){
                largeImageURL = readableJSON["largeImageURL"].string!
            }else{
                largeImageURL = ""
            }
            
            if(readableJSON["email"].string != nil){
                email = readableJSON["email"].string!
            }else{
                email = ""
            }
            
            if(readableJSON["website"].string != nil){
                website = readableJSON["website"].string!
            }else{
                website = ""
            }
            
            if(readableJSON["address"]["street"].string != nil){
                address.append(readableJSON["address"]["street"].string!)
            }else{
                address.append("")
            }
            
            if(readableJSON["address"]["city"].string != nil){
                address.append(readableJSON["address"]["city"].string!)
            }else{
                address.append("")
            }
            
            if(readableJSON["address"]["state"].string != nil){
                address.append(readableJSON["address"]["state"].string!)
            }else{
                address.append("")
            }
            
            if(readableJSON["address"]["country"].string != nil){
                address.append(readableJSON["address"]["country"].string!)
            }else{
                address.append("")
            }
            
            if( readableJSON["address"]["zip"].string != nil){
                address.append(readableJSON["address"]["zip"].string!)
            }else{
                address.append("")
            }
            if(readableJSON["address"]["latitude"].float != nil){
                coords.append(readableJSON["address"]["latitude"].float!)
            }else{
                coords.append(0.0)
            }
            
            if(readableJSON["address"]["longitude"].float != nil){
                coords.append(readableJSON["address"]["longitude"].float!)
            }else{
                coords.append(0.0)
            }
        }
        
        if(item?.onfavorite == true){
            saveFav.image = UIImage(named: "fullHeart")
        }else{
            saveFav.image = UIImage(named: "emptyHeart")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//TODO::::::
    
     //Individual heights have been set per row.
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(item?.isjson == true){
            if indexPath.section==0{
                return 200.0
            }else if indexPath.section==1{
                return 100
            }else if indexPath.section==2{
                return 50
            }else if indexPath.section == 3 || indexPath.section == 4{
                return 50
            }else{
                return 50
            }
        }else{
            if indexPath.section==0{
                return 200.0
            }else{
                return 50
            }
        }
    }
    
    //This function will be displaying the corresponding header views
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        //The main heading has been chosen here
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.whiteColor()
        header.textLabel?.textColor = UIColor.blueColor()
        header.textLabel?.font = UIFont(name: "Arial", size: 25)
        
        //The main titles and colors will be set here
        if section == 0{
            header.textLabel?.text = item?.name
            header.textLabel?.textColor = UIColor.orangeColor()
            header.textLabel?.font = UIFont(name: "Arial", size: 35)
            return
        }
        if(item?.isjson == true){
            if section == 1{
                header.textLabel?.text = "Address:"
            }else if section == 2{
                header.textLabel?.text = "Phone:"
            }else if section == 3{
                header.textLabel?.text = "Email:"
            }else if section == 4{
                header.textLabel?.text = "Website:"
            }else if section == 5{
                header.textLabel?.text = "Birthday:"
            }else{
                header.textLabel?.text = ""
            }
        }else{
            if(section == 1){
                header.textLabel?.text = "Phone: "
            }
        }
    }
    
    //TODO: Heading only shows up when this function is in place... why?
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "hi"
    }
    
    //The number of sections in total are set here. For the JSON contects, there will be 6, whereas; there will only be 2 for local contacts
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(item?.isjson == true){
            return 6
        }else{
            return 2
        }
    }
    
    //The amount of rows per section are set here.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(item?.isjson == true){
            if section == 1{
                return 1
            }else if section == 2{
                return 3
            }else if section == 3{
                return 1
            }else if section == 4{
                return 1
            }else if section == 5{
                return 1
            }else{
                return 1
            }
        }else{
            if(section == 0){
                return 1
            }else{
                return 3
            }
        }
    }
    
    
    //Here we fill in all the sections and rows of the Contact Information Table.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //We seperate the procedure for JSON contacts and local contacts, as both would differ.
        if(item?.isjson == true){
            
            //The procedure is sorted by section number, as each section corresponds to a different type of information.
            //Here, we display the main header information
            if(indexPath.section == 0){
                let cell = tableView.dequeueReusableCellWithIdentifier("nameCell") as! TableViewCell
                cell.companyLabel.text = item?.company
                let imageName = largeImageURL
                let url = NSURL(string: imageName)
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                cell.displayLabel.image = UIImage(data: data!)
                return cell
            }
            
            //Here we display the addresses
            if(indexPath.section == 1){
                let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
                cell.textLabel?.numberOfLines = 3
                cell.textLabel?.text = "\(address[0])\n\(address[1]), \(address[2]) \(address[4])\n\(address[3])"
                cell.detailTextLabel?.text = ""
                return cell
            
            //Here, we display the phone numbers in 3 seperate rows
            }else if(indexPath.section == 2){
                let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
                let index = indexPath.row
                if(index == 0){
                    cell.textLabel?.text = item?.phonemobile
                    cell.detailTextLabel?.text = "Mobile"
                }else if(index == 1){
                    cell.textLabel?.text = item?.phonehome
                    cell.detailTextLabel?.text = "Home"
                }else{
                    cell.textLabel?.text = item?.phonework
                    cell.detailTextLabel?.text = "Work"
                }
                return cell
                
            //Here, we display the e-mail.
            }else if(indexPath.section == 3){
                let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
                cell.textLabel?.text = email
                cell.detailTextLabel?.text = ""
                return cell
            //Here, we display the webstie
            }else if(indexPath.section == 4){
                let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
                cell.textLabel?.text = website
                cell.detailTextLabel?.text = ""
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
                return cell
            }
        }else{
            //Here, the information on non-JSON contacts is displayed
            
            //First, the header
            if(indexPath.section == 0){
                let cell = tableView.dequeueReusableCellWithIdentifier("nameCell") as! TableViewCell
                //  cell.displayPicture?.image = self.bigImage
                cell.companyLabel.text = item?.company
                return cell
            }
            //Next, the phone numbers get displayed
            if(indexPath.section == 1){
                let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
                let index = indexPath.row
                if(index == 0){
                    cell.textLabel?.text = item?.phonemobile
                    cell.detailTextLabel?.text = "Mobile"
                }else if(index == 1){
                    cell.textLabel?.text = item?.phonehome
                    cell.detailTextLabel?.text = "Home"
                }else{
                    cell.textLabel?.text = item?.phonework
                    cell.detailTextLabel?.text = "Work"
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
                return cell
            }

        }
    }
    
    //allows functionality that makes it possible for user to actually call phone numbers.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2{
            if(indexPath.row == 0){
                let number = item?.phonemobile
                let newString = number!.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let url : NSURL = NSURL(string: "tel://" + newString)!
                UIApplication.sharedApplication().openURL(url)
            }else if(indexPath.row == 1){
                let number = item?.phonehome
                let newString = number!.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let url : NSURL = NSURL(string: "tel://" + newString)!
                UIApplication.sharedApplication().openURL(url)
            }else if(indexPath.row == 0){
                let number = item?.phonework
                let newString = number!.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let url : NSURL = NSURL(string: "tel://" + newString)!
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    //Handles when user taps the favorite button
    //Changes the image and adds the user to the favorites
    @IBAction func favoriteTapped(sender: AnyObject) {
        if(item?.onfavorite == false){
            saveFav.image = UIImage(named: "fullHeart")
            addToFavorite(1)
        }else{
            saveFav.image = UIImage(named: "emptyHeart")
            addToFavorite(0)
        }
    }

    
    //Allows user to be added to the favorites list
    func addToFavorite(cond : integer_t){
        if(cond == 0){
            item?.onfavorite = false
            do{
                try(managedObjectContext.save())
            }catch{
                print("Error in removing from favorite")
            }
        }else{
            item?.onfavorite = true
            do{
                try(managedObjectContext.save())
            }catch{
                print("Error in adding to favorite")
            }
        }
    }
    

}
