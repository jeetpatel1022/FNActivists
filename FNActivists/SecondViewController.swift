//
//  SecondViewController.swift
//  FNActivists
//
//  Created by Jeet Patel on 11/7/15.
//
//

import UIKit
import Alamofire

class SecondViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBAction func addTag(sender: AnyObject) {
        var vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddTag") as! AddTagVC
        self.navigationController?.addChildViewController(vc)
        self.navigationController?.view.addSubview(vc.view)
        vc.textField.becomeFirstResponder()
        vc.view.frame = UIScreen.mainScreen().bounds
    }
    @IBOutlet var tagTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tagTable.delegate=self
        tagTable.dataSource=self
        User.currentUser?.getTags({(tags) in
            if let tag = tags {
                self.tags = tag
                self.tagTable.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var tags:[String] = []
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tag")!
        let label = cell.viewWithTag(1) as! UILabel
        
        label.text = tags[indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let text = (tableView.cellForRowAtIndexPath(indexPath)!.viewWithTag(1) as! UILabel).text!
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BillsByTagVC")
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        User.currentUser?.queryBills(text, completion: {(bills) in
        })

    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            User.currentUser?.removeTag(tags[indexPath.row])
            tags.removeAtIndex(indexPath.row)
            self.tagTable.reloadData()
            User.currentUser?.getTags({(tags) in
                if let tag = tags {
                    self.tags = tag
                    self.tagTable.reloadData()
                }
            })
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }


}



