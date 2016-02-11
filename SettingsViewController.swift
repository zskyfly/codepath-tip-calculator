//
//  SettingsViewController.swift
//  tips
//
//  Created by Zachary Matthews on 2/7/16.
//  Copyright © 2016 Zachary Matthews. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let defaultTipPercentages = [0.15, 0.18, 0.20, 0.45, 0.12, 0.32]
    let keyTipPercentageIndex = "tip_percentage_index"
    let keyTipPercentages = "tip_percentages"
    
    @IBOutlet weak var tipRemovalControl: UISegmentedControl!
    @IBOutlet weak var tipDefaultControl: UISegmentedControl!
    @IBOutlet weak var restoreSettingsButton: UIButton!
    @IBOutlet weak var addTipButton: UIButton!
    @IBOutlet weak var addTipLabel: UILabel!
    @IBOutlet weak var addTipSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buildSettingsViewTipControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditDefaultValue(sender: AnyObject) {
        setDefaultTipPercentageIndex(tipDefaultControl.selectedSegmentIndex)
    }

    @IBAction func onEditRemoveValue(sender: AnyObject) {
        let indexToRemove = tipRemovalControl.selectedSegmentIndex
        removeDefaultTipPercentage(indexToRemove)
    }
    
    @IBAction func onClickRestore(sender: AnyObject) {
        setDefaultTipPercentages(defaultTipPercentages)
        setDefaultTipPercentageIndex(0)
        buildSettingsViewTipControllers()
    }
    
    @IBAction func onEditAddTipSlider(sender: AnyObject) {
        let currentSliderValue = Int(addTipSlider.value)
        updateAddTipControls(currentSliderValue)
    }
    
    @IBAction func onClickAddTipButton(sender: AnyObject) {
        let currentSliderValue = Int(addTipSlider.value)
        let tipPercentageToAdd = Double(currentSliderValue) / 100.0
        addDefaultTipPercentage(tipPercentageToAdd)
    }
    
    func initAddTipControls() {
        let allTipPercentages = getDefaultTipPercentages()
        let highestTipPercentage = allTipPercentages.last!
        var suggestedTipPercentage = highestTipPercentage
        while allTipPercentages.contains(suggestedTipPercentage) {
            if suggestedTipPercentage < 1.0 {
                suggestedTipPercentage += 0.01
                print("incrementing to \(suggestedTipPercentage)")
            } else {
                suggestedTipPercentage -= 0.01
                print("decrementing to \(suggestedTipPercentage)")
            }
        }
        suggestedTipPercentage = suggestedTipPercentage * 100.0
        addTipSlider.value = Float32(suggestedTipPercentage)
        let currentSliderValue = Int(suggestedTipPercentage)
        updateAddTipControls(currentSliderValue)
    }
    
    func updateAddTipControls(currentSliderValue: Int) {
        addTipLabel.text = "\(currentSliderValue)%"
        let currentTipPercentage = Double(currentSliderValue) / 100.0
        if getDefaultTipPercentages().contains(currentTipPercentage) {
            addTipButton.enabled = false
        } else {
            addTipButton.enabled = true
        }
    }
    
    func getDefaultTipPercentages() -> [Double] {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.arrayForKey(keyTipPercentages) == nil {
            setDefaultTipPercentages(defaultTipPercentages)
        }
        let tipPercentages = defaults.objectForKey(keyTipPercentages)! as! [Double]
        return tipPercentages.sort()
    }
    
    func setDefaultTipPercentages(tipPercentages: [Double]) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tipPercentages, forKey: keyTipPercentages)
        defaults.synchronize()
    }
    
    func removeDefaultTipPercentage(index: Int) {
        let oldDefaultPercentage = getDefaultTipPercentageValue()
        var allTipPercentages = getDefaultTipPercentages()
        allTipPercentages.removeAtIndex(index)
        setDefaultTipPercentages(allTipPercentages)
        resetDefaultTipPercentageIndex(oldDefaultPercentage)
        buildSettingsViewTipControllers()
    }
    
    func resetDefaultTipPercentageIndex(oldDefaultTipPercentage: Double) {
        let allTipPercentages = getDefaultTipPercentages()
        var newTipPercentageIndex = 0
        if allTipPercentages.contains(oldDefaultTipPercentage) {
            newTipPercentageIndex = allTipPercentages.indexOf(oldDefaultTipPercentage)!
        }
        setDefaultTipPercentageIndex(newTipPercentageIndex)
    }

    func addDefaultTipPercentage(tipPercentage: Double) {
        let oldDefaultPercentage = getDefaultTipPercentageValue()
        var allTipPercentages = getDefaultTipPercentages()
        allTipPercentages.append(tipPercentage)
        setDefaultTipPercentages(allTipPercentages)
        resetDefaultTipPercentageIndex(oldDefaultPercentage)
        buildSettingsViewTipControllers()
    }
    
    func getDefaultTipPercentageIndex() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultIndex = defaults.integerForKey(keyTipPercentageIndex)
        if defaultIndex > getDefaultTipPercentages().count - 1 {
            return 0
        }
        return defaults.integerForKey(keyTipPercentageIndex)
    }
    
    func getDefaultTipPercentageValue() -> Double {
        return getDefaultTipPercentages()[getDefaultTipPercentageIndex()]
    }
    
    func setDefaultTipPercentageIndex(index: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(index, forKey: keyTipPercentageIndex)
        defaults.synchronize()
    }
    
    func buildSettingsViewTipControllers() {
        ViewController().buildTipControl(tipDefaultControl)
        ViewController().buildTipControl(tipRemovalControl, shouldSetSelected: false)
        if getDefaultTipPercentages().count == 1 {
            tipRemovalControl.setEnabled(false, forSegmentAtIndex: 0)
        }
        initAddTipControls()
    }
}
