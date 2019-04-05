//
//  MasterViewController.swift
//  notes
//
//  Created by Isaac Raval on 4/2/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    //Singleton to make properties and methods accessible from other files
    static let sharedInstance = MasterViewController()

    var detailViewController: DetailViewController? = nil
    
    struct vals {
        static var objects = [Note]()
        static var currentCell:Int?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add edit button that toggles between edit/done
        navigationItem.leftBarButtonItem = editButtonItem

        //Initialize split view controller and create button to add cells
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        
        //Add button to add cels
        navigationItem.rightBarButtonItem = addButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.navigationItem.titleView = UIView() //Hide navigation-bar title
    }

    override func viewWillAppear(_ animated: Bool) {
        //If a child view controllers is displayed clear the selection
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        
        //Update data when arriving from another view controller
        tableView.reloadData()
        
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        
        //Get date and format it
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateTime = formatter.string(from: Date())
        
        //Add empty note to array of objects
        MasterViewController.vals.objects.insert(Note.init(noteName: "Note Created \(dateTime)", noteContents: "", date: dateTime), at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.title = "Back" //Set title of back button
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //Get appropriate Note object
                let object = MasterViewController.vals.objects[indexPath.row] as! Note
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                //Set contents of note
                controller.contentOfNote = object.noteContents as NSString
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                //Make indexPath.row value accessible from DetailViewController and other files
                MasterViewController.vals.currentCell = indexPath.row
            }
        }
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MasterViewController.vals.objects.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = MasterViewController.vals.objects[indexPath.row] as! Note
        
        //Set cell title
        cell.textLabel!.text = object.noteName
        
        //Set subtitle to truncated version of note contents if note is not empty
        let stringToSetSubtitleTo = "\(object.noteContents.prefix(90))"
        if (stringToSetSubtitleTo.isEmpty) {
            cell.detailTextLabel?.text = "Empty";
        }
        else { //If note has contents, set subtitle to truncated version
            cell.detailTextLabel?.text = stringToSetSubtitleTo;
        }
                
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MasterViewController.vals.objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

