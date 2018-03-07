//
//  ViewController.swift
//  CleanYourMakeUp
//
//  Created by Jakub Hutny on 24.09.2016.
//  Copyright © 2016 Jakub Hutny. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    // PRIVATE FIELDS
    private var languageModel: LanguageProtocol = EnglishLanguageModel()
    private var pickerViewModel = PickerViewModel()
    private var hours = [String]()
    private var minutes = [String]()
    private let pickerDataSize = 100000
    private var hourValue = 0
    private var minuteValue = 0
    private var foregroundNotification: NSObjectProtocol!
    private var notificationScheduler: NotificationScheduler
    
    // OUTLETS
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var remindMeButton: UIButton!
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var minutePickerView: UIPickerView!
    @IBOutlet weak var currentStateLabel: UILabel!
    
    
    // INITIALIZERS 
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        self.notificationScheduler = NotificationScheduler(language: languageModel)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        self.notificationScheduler = NotificationScheduler(language: languageModel)
        
        super.init(coder: aDecoder)!
        NotificationCenter.default.addObserver(self, selector:#selector(ViewController.hideCurrentStateLabel), name: NSNotification.Name(rawValue: "NotificationFiredNotification"), object: nil)
    }
    
    init() {
        self.notificationScheduler = NotificationScheduler(language: languageModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelText()
        setButtonText()
        setButtonProperties(button: remindMeButton)
        setCurrentStateLabelText()
        loadDataToPickerViews()
        enterForeground()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // PUBLIC METHODS
    
    @IBAction func clickRemindMeButton(_ sender: UIButton) {
        notificationScheduler.scheduleNotification(hour: hourValue, minute: minuteValue)
        createAlertController()
    }
    
    // PICKERVIEW METHODS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSize
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row % 10)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPickerView {
            hourValue = Int(hours[pickerView.selectedRow(inComponent: 0) % hours.count])!
        }
        else {
            minuteValue = Int(minutes[pickerView.selectedRow(inComponent: 0) % minutes.count])!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerData: [String]
        
        if pickerView == hourPickerView {
            pickerData = hours
        }
        else {
            pickerData = minutes
        }
        
        var pickerLabel = view as! UILabel!
        let shadow = createShadow()
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
        }
        let titleData = pickerData[row % pickerData.count]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 42.0),NSForegroundColorAttributeName:UIColor(red: 255/255.0, green: 182/255.0, blue: 194/255.0, alpha: 1.0), NSShadowAttributeName: shadow])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .center
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 42.0
    }
    
    
    // PRIVATE METHODS
    
    private func enterForeground() {
        foregroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) {
            [unowned self] notification in
            if !self.notificationScheduler.hasAnyPendingNotifications() {
                EntityManager.disableAllEntities()
                self.setCurrentStateLabelText()
            }
        }
    }
    
    private func loadDataToPickerViews() {
        let hourData = pickerViewModel.Hours
        let minuteData = pickerViewModel.Minutes
        
        for hour in hourData {
            hours.append(hour)
        }
        for minute in minuteData {
            minutes.append(minute)
        }
        
        hourPickerView.dataSource = self
        hourPickerView.delegate = self
        minutePickerView.dataSource = self
        minutePickerView.delegate = self
    }
    
    // UI CHANGING METHODS
    
    func createShadow() -> NSShadow {
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor(red: 255/255.0, green: 182/255.0, blue: 194/255.0, alpha: 1.0)
        
        return myShadow
    }
    
    func setButtonProperties(button: UIButton) -> Void {
        let buttonColor = UIColor(red: 255/255.0, green: 182/255.0, blue: 194/255.0, alpha: 1.0)
        button.layer.cornerRadius = 12.0
        button.clipsToBounds = true
        button.layer.borderWidth = 2.0
        button.layer.borderColor = buttonColor.cgColor
        button.setTitleColor(buttonColor, for: .normal)
    }
    
    func setButtonText() {
        remindMeButton.setTitle(languageModel.ButtonText, for: .normal)
    }
    
    func setLabelText() {
        label.text = languageModel.LabelText
    }
    
    func setCurrentStateLabelText() {
        let predicate = NSPredicate(format: "isSetUp == %@", NSNumber(booleanLiteral: true))
        var setup = SetupService.get(withPredicate: predicate)
        if setup.isEmpty {
            hideCurrentStateLabel()
        }
        else {
            showCurrentStateLabel()
            let currentHour = getStringValueOfHourAndMinute(integer: Int(setup[0].hour))
            let currentMinute = getStringValueOfHourAndMinute(integer: Int(setup[0].minute))
            currentStateLabel.text = languageModel.currentstateLabel(hour: currentHour, minute: currentMinute)
        }
    }
    
    func createAlertController() {
        var hourString: String
        var minuteString: String
        
        hourString = getStringValueOfHourAndMinute(integer: hourValue)
        minuteString = getStringValueOfHourAndMinute(integer: minuteValue)
        
        let alertController = UIAlertController(title: languageModel.AlertTitle, message:
            languageModel.getAlertBody(hour: hourString, minute: minuteString), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in self.setCurrentStateLabelText() }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getStringValueOfHourAndMinute(integer: Int) -> String {
        var resultString: String
        if integer < 10 {
            resultString = "0" + String(integer)
        }
        else {
            resultString = String(integer)
        }
        
        return resultString
    }
    
    func showCurrentStateLabel() {
        currentStateLabel.isHidden = false
    }
    
    func hideCurrentStateLabel() {
        currentStateLabel.isHidden = true
    }
}
