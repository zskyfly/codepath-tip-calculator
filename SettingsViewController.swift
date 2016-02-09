//
//  SettingsViewController.swift
//  tips
//
//  Created by Zachary Matthews on 2/7/16.
//  Copyright © 2016 Zachary Matthews. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let defaultTipPercentages = [0.15, 0.18, 0.20]
    let defaultKeyTipPercentageIndex = "tip_percentage_index"
    
    @IBOutlet weak var tipDefaultControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ViewController().buildTipControl(tipDefaultControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditValue(sender: AnyObject) {
        setDefaultTipPercentageIndex(tipDefaultControl.selectedSegmentIndex)
        
    }

    func getTipPercentages() -> [Double] {
        return defaultTipPercentages
    }
    
    func getDefaultTipPercentageIndex() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(defaultKeyTipPercentageIndex)
    }
    
    func setDefaultTipPercentageIndex(index: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(index, forKey: defaultKeyTipPercentageIndex)
        defaults.synchronize()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
