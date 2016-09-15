//
//  AddTagVC.swift
//  FNActivists
//
//  Created by Jeet Patel on 11/7/15.
//
//

import Foundation
import UIKit

class AddTagVC:UIViewController {
    @IBOutlet var textField: UITextField!
    @IBAction func cancel(sender: AnyObject) {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    @IBAction func addTag(sender: AnyObject) {
        User.currentUser?.addNewTag(textField.text!)
        self.view.removeFromSuperview()
        User.currentUser?.getTags({(tags) in
            if let tag = tags {
                (((self.parentViewController as! UINavigationController).viewControllers[((self.parentViewController as! UINavigationController).viewControllers.count-2)] as! SecondViewController)).tags = tag
                (((self.parentViewController as! UINavigationController).viewControllers[((self.parentViewController as! UINavigationController).viewControllers.count-2)] as! SecondViewController)).tagTable.reloadData()
                self.removeFromParentViewController()

            }
        })

    }
    override func viewDidLoad() {
    }
    override func viewDidAppear(animated: Bool) {
    }
    override func viewDidDisappear(animated: Bool) {
        textField.resignFirstResponder()
    }
}