//
//  FirstViewController.swift
//  FNActivists
//
//  Created by Jeet Patel on 11/7/15.
//
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts
//0e9b1e6b7fa6ad49aa8b99af32679336

class FirstViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var newsFeed: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsFeed.delegate=self
        newsFeed.dataSource=self

    }
    override func viewDidAppear(animated: Bool) {
        User.currentUser?.queryBills("", completion: {(bills) in
            if bills != nil {
                self.tableDict = bills!;
                self.newsFeed.reloadData()
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var tableDict:[String:[Bills]] = [:]
    var tableArray:[Bills] = []
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Bills")!
        var contentView = cell.viewWithTag(1)!
        var textView = cell.viewWithTag(3)! as! UILabel
        (cell.viewWithTag(14) as! UILabel).text = tableArray[indexPath.row].tag != nil  ? "#\(tableArray[indexPath.row].tag!)": ""
        if (cell.viewWithTag(14) as! UILabel).text == "" {
            cell.viewWithTag(14)?.hidden=true
        } else {
            cell.viewWithTag(14)?.hidden=false
        }
        textView.text = tableArray[indexPath.row].title
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BillVC") as! BillVC
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        vc.bill = tableArray[indexPath.row]
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableArray=[]
        var tmp = Array<Array<Bills>>(tableDict.values)
        for tmparr in tmp {
            tableArray+=tmparr
        }
        print(tableArray.count)
        return tableArray.count
    }
}


