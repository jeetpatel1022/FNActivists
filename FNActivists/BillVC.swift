
//       var data = PieChartDataSet(yVals: [ChartDataEntry(value: 0.5, xIndex: 1),ChartDataEntry(value: 0.5, xIndex: 2)], label: "Election")
//        data.colors = ChartColorTemplates.colorful()
//        newsFeed.data = PieChartData(xVals: [1,2], dataSet: data)
//        newsFeed.rotationEnabled=false
//        newsFeed.descriptionText=""
//        newsFeed.centerAttributedText = NSAttributedString(string: "")
//        newsFeed.animate(xAxisDuration: 1)
////
//  BillVC.swift
//  FNActivists
//
//  Created by Jeet Patel on 11/8/15.
//
//

import Foundation
import UIKit
import Charts
class BillVC:UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var descriptionTable: UITableView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var cosponsorView: UICollectionView!
    var cosponsorDel:CosponsorView?
    @IBOutlet var chart1: PieChartView!
    @IBOutlet var chart2: PieChartView!
    @IBOutlet var chart3: PieChartView!
    var del1:ChartDel?
    var del2:ChartDel?
    var del3:ChartDel?
    
    var bill:Bills? //= Bills(title: "", id: "", tag: "", preFloor: 0.5, postFloor: 0.5)
    override func viewDidLoad() {
        webView.backgroundColor = .blueColor()
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://google.com")!))
        webView.scrollView
        descriptionTable.delegate=self
        descriptionTable.dataSource=self

       // chart1.layer.shadowColor = UIColor.lightGrayColor().CGColor
        //chart1.layer.shadowOffset = CGSize(width: 0, height: -5)
        //chart1.layer.shadowOpacity = 1
        //chart1.layer.shadowRadius = 2
    }
    override func viewDidAppear(animated: Bool) {
        //del1 = ChartDel(chart: chart1, prob: 0.2)
        //del2 = ChartDel(chart: chart2, prob: 0.35)
        //del3 = ChartDel(chart: chart3, prob: 0.87)
        self.titleLabel.text = bill!.title
        del2 = ChartDel(chart: chart2, prob: bill!.preFloorProbability!)
        del3 = ChartDel(chart: chart3, prob: bill!.postFloorProbability!)
        if bill!.preFloorProbability == -1 {
            chart1.centerAttributedText = NSAttributedString(string: "N/A")
        }
        if bill!.preFloorProbability == -1 {
            chart2.centerAttributedText = NSAttributedString(string: "N/A")
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("description")!
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

class ChartDel:ChartViewDelegate {
    init(chart:PieChartView, prob:Double) {
        chart.delegate=self
        var data = PieChartDataSet(yVals: [ChartDataEntry(value: prob, xIndex: 1),ChartDataEntry(value: 1-prob, xIndex: 2)], label: "")
        data.colors = ChartColorTemplates.vordiplom()
        data.drawValuesEnabled=false
        chart.data = PieChartData(xVals: [1,2], dataSet: data)
        chart.rotationEnabled=false
        chart.drawSliceTextEnabled=false
        chart.legend.enabled=false
        chart.descriptionText="Prediction"
        chart.centerAttributedText = NSAttributedString(string: "\(Int(prob*100))%")
        chart.animate(xAxisDuration: 1)
    }
}

class CosponsorView: NSObject, UICollectionViewDelegate,UICollectionViewDataSource {
    var bill:Bills
    init(collectionView:UICollectionView, bill:Bills) {
        self.bill=bill
        super.init()
        collectionView.delegate=self
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("sponsor", forIndexPath: indexPath)
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bill.cosponsors.count
    }
}