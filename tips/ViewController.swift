//
//  ViewController.swift
//  tips
//
//  Created by Zachary Matthews on 2/6/16.
//  Copyright © 2016 Zachary Matthews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    let defaultAmountLabelText: String = "$0.00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipLabel.text = defaultAmountLabelText
        totalLabel.text = defaultAmountLabelText
        buildTipControl(tipControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buildTipControl(tipControl)
        setTipControlSelectedIndex(tipControl)
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
        let tipPercentages = SettingsViewController().getDefaultTipPercentages()
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let billAmount = NSString(string: billField.text!).doubleValue
        let tipAmount = billAmount * tipPercentage
        let totalAmount = billAmount + tipAmount
        
        tipLabel.text = String(format: "$%.2f", tipAmount)
        totalLabel.text = String(format: "$%.2f", totalAmount)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
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

