//
//  API.swift
//  FNActivists
//
//  Created by Jeet Patel on 11/7/15.
//
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
var NotificationCenter = NSNotificationCenter.defaultCenter()
var APIErrorOccured = "APIErrorOccured"


class User:NSObject {
    static var currentUser:User?
    
    var token:String
    
    init(tok:String) {
        token = tok
    }
    
    func addNewTag(tag:String) {
        if let _ = User.currentUser {
            Alamofire.request(.POST, "http://jayravaliya.com:5000/tags/add", parameters: ["token":User.currentUser!.token, "tag":tag], encoding: .JSON, headers: nil).responseJSON(completionHandler: {(response) in
                if(response.response!.statusCode == 200) {
                    
                } else {
                    if response.result.error != nil {
                        NotificationCenter.postNotification(NSNotification(name: APIErrorOccured, object: nil, userInfo: ["error":response.result.error!]))
                    } else {
                        NotificationCenter.postNotification(NSNotification(name: APIErrorOccured, object: nil, userInfo: nil))
                    }
                }
            })
        }
    }
    func removeTag(tag:String) {
        if let _ = User.currentUser {
            Alamofire.request(.POST, "http://jayravaliya.com:5000/tags/remove", parameters: ["token":User.currentUser!.token, "tag":tag], encoding: .JSON, headers: nil).responseJSON(completionHandler: {(response) in
                if(response.response!.statusCode == 200) {
                    
                } else {
                    if response.result.error != nil {
                        NotificationCenter.postNotification(NSNotification(name: APIErrorOccured, object: nil, userInfo: ["error":response.result.error!]))
                    } else {
                        NotificationCenter.postNotification(NSNotification(name: APIErrorOccured, object: nil, userInfo: nil))
                    }
                }
            })
        }
    }
    func getTags(completion:(([String]?)->Void)) {
        if let _ = User.currentUser {
            Alamofire.request(.POST, "http://jayravaliya.com:5000/tags", parameters: ["token":User.currentUser!.token], encoding: .JSON, headers: nil).responseJSON(completionHandler: {(response) in
                if(response.response?.statusCode == 200) {
                    var jsonData = JSON(response.result.value!)
                    print(response.result.value!)
                    print(jsonData["Success"].arrayObject)
                    completion(jsonData["Success"].arrayObject as? [String])
                } else {
                    if response.result.error != nil {
                        NotificationCenter.postNotification(NSNotification(name: APIErrorOccured, object: nil, userInfo: ["error":response.result.error!]))
                    } else {
                        NotificationCenter.postNotification(NSNotification(name: APIErrorOccured, object: nil, userInfo: nil))
                    }
                }
            })
        }
    }
    func queryBills(tag:String,completion:(([String:[Bills]]?)->Void)) {
        Alamofire.request(.POST, "http://jayravaliya.com:5000/bills/get", parameters: ["token":User.currentUser!.token, "tag":tag], encoding: .JSON, headers: nil).responseData(/*).responseJSON(*/{(response) in
            if(response.response?.statusCode == 200) {
                let data = response.result.value!
                //print(NSString(data: data, encoding: NSUTF8StringEncoding))
                var billDict:[String:[Bills]] = [:]
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    let swifty = JSON(json)
                    print(json)
                    let dictionary = swifty["Success"].array!
                    print(dictionary.count)
                    for tagDict in dictionary {
                        for (tag,bills) in tagDict.dictionary! {
                            for bill in bills.array! {
                                print((bill.dictionary!))
                                var dict = bill.dictionary!
                                let title = (dict["title"]?.string != nil ? (dict["title"]!.string!):"")
                                //print(dict["prefloor_probability"])
                                let prefloor = dict["prefloor_probability"]?.string != nil ? (dict["prefloor_probability"]?.string):""
                                let postfloor = dict["postfloor_probability"]?.string != nil ? (dict["postfloor_probability"]?.string):""
                                let current = dict["current_prediction"]?.string != nil ? (dict["current_prediction"]?.string):""
                                
                                
                                let id = dict["id"]!.string!
                                let newBill = Bills(title: title, id: id, tag: tag, preFloor:  prefloor! == "" ? -1: NSString(string: prefloor!).doubleValue, postFloor: postfloor! == "" ? -1: NSString(string: postfloor!).doubleValue, current: NSString(string: current!).doubleValue)
                                
                                if(billDict[tag] == nil) {
                                    billDict[tag] = []
                                }
                                billDict[tag]!.append(newBill)
                            }
                        }
                    }
                    
//                    for(tag) in swifty["Success"].array! {
//                    for (x,_) in tag.dictionary! {
//                        for bill in tag.dictionary![x]!.array! {
//                            print((bill.dictionary!))
//                            var dict = bill.dictionary!
//                            let title = (dict["title"] != nil ? (dict["title"]!.string!):"")
//                            //print(dict["prefloor_probability"])
//                            let prefloor = "0"//dict["prefloor_probability"] != nil ? (dict["prefloor_probability"]?.string!):""
//                            let postfloor = "0" //dict["postfloor_probability"] != nil ? (dict["postfloor_probability"]?.string!):""
//                            let id = dict["id"]!.string!
//                            let newBill = Bills(title: title, id: id, tag: tag, preFloor:  prefloor == "" ? -1: NSString(string: prefloor).doubleValue, postFloor: postfloor == "" ? -1: NSString(string: postfloor).doubleValue)
//                            
//                            if(billDict[tag] == nil) {
//                                billDict[tag] = []
//                            }
//                            billDict[tag]!.append(newBill)
//                        }
//                    }
//                    }
                }catch {
                
                }
                completion(billDict);
            } else {
                
                if response.result.error != nil {
                    print(response.result.error)
                    NotificationCenter.postNotification(NSNotification(name: APIErrorOccured, object: nil, userInfo: ["error":response.result.error!]))
                } else {
                    NotificationCenter.postNotification(NSNotification(name: APIErrorOccured, object: nil, userInfo: nil))
                }
                completion(nil)
            }
        })
    }
}

class Bills:NSObject {
    var title:String
    var id:String
    var tag:String?
    var cosponsors:[String] = []
    var postFloorProbability:Double?
    var preFloorProbability:Double?
    var current_prediction:Double?
    init(title:String, id:String, tag:String?, preFloor:Double?,postFloor:Double?, current:Double?) {
        self.title = title
        self.id = id
        self.tag = tag
        self.preFloorProbability = preFloor
        self.postFloorProbability = postFloor
    }
}