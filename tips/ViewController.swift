//
//  ViewController.swift
//  tips
//
//  Created by Zachary Matthews on 2/6/16.
//  Copyright © 2016 Zachary Matthews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let defaultAmountLabelText: String = "$0.00"
    let keyBillLatestString = "last_bill_string"
    let keyBillLatestEditTime = "bill_last_edit_time"
    let billAmountPersistSeconds = 60
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var (billString, editTime) = getLatestBillStringAndEditTime()
        let secondsSinceLastEdit = Int(NSDate().timeIntervalSince1970) - editTime
        if secondsSinceLastEdit > billAmountPersistSeconds {
            billString = ""
        }
        billField.text = billString
        setLabelAmounts(getAmountFromBillString(billField.text!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buildTipControl(tipControl)
        setTipControlSelectedIndex(tipControl)
        setLabelAmounts(getAmountFromBillString(billField.text!))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        let billString = billField.text!
        let billAmount = getAmountFromBillString(billString)
        setLabelAmounts(billAmount)
        storeLatestBillStringAndEditTime(billString)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func getAmountFromBillString(billString: String) -> (Double) {
        return NSString(string: billField.text!).doubleValue
    }
    
    func setLabelAmounts(billAmount: Double) {
        let tipPercentages = SettingsViewController().getDefaultTipPercentages()
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let tipAmount = billAmount * tipPercentage
        let totalAmount = billAmount + tipAmount
        tipLabel.text = String(format: "$%.2f", tipAmount)
        totalLabel.text = String(format: "$%.2f", totalAmount)
    }
    
    func storeLatestBillStringAndEditTime(billString: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let nowSeconds = Int(NSDate().timeIntervalSince1970)
        defaults.setInteger(nowSeconds, forKey: keyBillLatestEditTime)
        defaults.setObject(billString, forKey: keyBillLatestString)
    }
    
    func getLatestBillStringAndEditTime() -> (billString: String, editTime: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let editTime = defaults.integerForKey(keyBillLatestEditTime)
        var billString = ""
        if defaults.objectForKey(keyBillLatestString) != nil {
            billString = defaults.objectForKey(keyBillLatestString)! as! String
        }
        return (billString, editTime)
    }
    
    func buildTipControl(controller: UISegmentedControl, shouldSetSelected: Bool = true) {
        controller.removeAllSegments()
        var index = 0
        for tipPercentage in SettingsViewController().getDefaultTipPercentages() {
            controller.insertSegmentWithTitle(
                String(format: "%.0f%%", tipPercentage * 100),
                atIndex: index,
                animated:false
            )
            index++
        }
        if shouldSetSelected {
            setTipControlSelectedIndex(controller)    
        }
        
    }
    
    func setTipControlSelectedIndex(controller: UISegmentedControl) {
        controller.selectedSegmentIndex = SettingsViewController().getDefaultTipPercentageIndex()
    }
}

