//
//  MasterViewController.swift
//  HWSproject7b
//
//  Created by Jamaal Sedayao on 5/20/16.
//  Copyright © 2016 Jamaal Sedayao. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()

    let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"

    override func viewDidLoad() {
   
        makeAPIRequest(urlString)
        
    }
    
    func makeAPIRequest(inputString:String) {
        
        if let url = NSURL(string: inputString){
            if let data = try? NSData(contentsOfURL: url, options: []){
                let json = JSON(data:data)
                
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    parseJSON(json)
                    print(json)
                }
            }
            
        }
    }
    
    func parseJSON(json: JSON) {
            for result in json["results"].arrayValue{
                let title = result["title"].stringValue
                let body = result["body"].stringValue
                let sigs = result["signatureCount"].stringValue
                let obj = ["title": title, "body":body, "sigs":sigs]
                objects.append(obj)
            }
            tableView.reloadData()
            //print(objects)
    }
    

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object as? String
        return cell
    }


}

