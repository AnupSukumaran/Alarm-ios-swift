//
//  AlarmAddViewController.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-3-2.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer


class AlarmAddEditViewController: UIViewController, MPMediaPickerControllerDelegate, UITableViewDelegate,  UITableViewDataSource{

    @IBOutlet weak var datePicker: UIDatePicker!
    var mediaItem: MPMediaItem?
    var isEditMode: Bool = false
    var indexOfCell: Int = -1
    private var label: String = "Alarm"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let mediaPicker = MPMediaPickerController(mediaTypes: .Music)
        //mediaPicker.delegate = self
       // mediaPicker.prompt = "Select any song!"
       // mediaPicker.allowsPickingMultipleItems = false
        //presentViewController(mediaPicker, animated: true, completion: nil)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveEditAlarm(sender: AnyObject) {
        let date = datePicker.date
        let timeStr = NSDateFormatter.localizedStringFromDate(date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        if isEditMode
        {
            Alarms.sharedInstance.setDate(date, AtIndex: indexOfCell)
            Alarms.sharedInstance.setTimeStr(timeStr, AtIndex: indexOfCell)
        }
        else
        {
            Alarms.sharedInstance.append( Alarm(label: "Alarm", timeStr: timeStr, date: date,            enabled: false, UUID: NSUUID().UUIDString, mediaID: "", repeatWeekdays: [Int]()))
        }
        
        //navigationController?.popViewControllerAnimated(true)
        //dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("saveEditAlarm", sender: self)
    }
    
    
    let settingIdentifier = "setting"
 
    private let settingLabel = ["Repeat","Label", "Sound", "Snooze"]
    enum AlarmInterval: String {
        case Once="Once", EveryDay="EveryDay", WeekDay="WeekDay", WeekEnd="WeekEnd"
    }
    var settingLabelDetail:AlarmInterval = .Once
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if isEditMode
        {
            return 2
        }
        else
        {
            return 1

        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 4
        }
        else
        {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(
            settingIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(
                style: UITableViewCellStyle.Value1, reuseIdentifier: settingIdentifier)
        }
        if indexPath.section == 0
        {
            
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2
            {
                
                cell!.textLabel!.text = settingLabel[indexPath.row]
                cell!.detailTextLabel!.text = settingLabelDetail.rawValue
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else if indexPath.row == 3
            {
               
                cell!.textLabel!.text = settingLabel[indexPath.row]
                let sw = UISwitch(frame: CGRect())
                sw.addTarget(self, action: "SwitchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                
                cell!.accessoryView = sw
            }
        }
        else if indexPath.section == 1{
            cell = UITableViewCell(
                style: UITableViewCellStyle.Subtitle, reuseIdentifier: settingIdentifier)
            cell!.textLabel!.text = "Delete"
        }
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        /*
        let title = NSLocalizedString("Choose a Alarm Interval", comment: "")
        //let message = NSLocalizedString("Choose Interval", comment: "")
        let onceActionTitle = NSLocalizedString(intervalArray[0], comment: "")
        let everydayActionTitle = NSLocalizedString(intervalArray[1], comment: "")
        let weekdayActionTitle = NSLocalizedString(intervalArray[2], comment: "")
        let weekendActionTitle = NSLocalizedString(intervalArray[3], comment: "")
        let cancelActionTitle = NSLocalizedString(intervalArray[4], comment: "")
        
        let storageController = UIAlertController(title: title, message: nil, preferredStyle: ./*ActionSheet*/Alert)
            
        let onceOption = UIAlertAction(title: onceActionTitle, style: .Default) {(action:UIAlertAction!)->Void in self.settingLabelDetail = .Once
            cell!.detailTextLabel!.text = self.settingLabelDetail.rawValue}
        storageController.addAction(onceOption)
            
        let everydayOption = UIAlertAction(title: everydayActionTitle, style: .Default) {(action:UIAlertAction!)->Void in self.settingLabelDetail = .EveryDay
            cell!.detailTextLabel!.text = self.settingLabelDetail.rawValue}
        storageController.addAction(everydayOption)
            
        let weekdayOption = UIAlertAction(title: weekdayActionTitle, style: .Default) {(action:UIAlertAction!)->Void in self.settingLabelDetail = .WeekDay
            cell!.detailTextLabel!.text = self.settingLabelDetail.rawValue}
        storageController.addAction(weekdayOption)
            
        let weekendOption = UIAlertAction(title: weekendActionTitle, style: .Default) {(action:UIAlertAction!)->Void in self.settingLabelDetail = .WeekEnd
            cell!.detailTextLabel!.text = self.settingLabelDetail.rawValue}
        storageController.addAction(weekendOption)
            
        let cancelOption = UIAlertAction(title: cancelActionTitle, style: .Cancel) {(action:UIAlertAction!)->Void in }
        storageController.addAction(cancelOption)
        
            
        presentViewController(storageController, animated: true, completion: nil)
        */
        switch indexPath.row{
        case 0:
            performSegueWithIdentifier("weekdaysSegue", sender: self)
            cell?.setSelected(true, animated: false)
        default:
            break
            
        }
            
    }
    
   /* override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowValue = alarms[indexPath.row].timeStr
        let message = "You selected \(rowValue)"
        let controller = UIAlertController(title: "Row Selected",
            message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Yes I Did",
            style: .Default, handler: nil)
        controller.addAction(action)
        presentViewController(controller, animated: true, completion: nil)
    }*/
    
    /*
    func numberOfComponentsInPickerView(colorPicker: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return "Interval"
    }
*/
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
    MPMediaPickerControllerDelegate
    */
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems  mediaItemCollection:MPMediaItemCollection) -> Void
    {
        var aMediaItem = mediaItemCollection.items[0] as! MPMediaItem
        /*if (( aMediaItem.artwork ) != nil) {
            mediaImageView.image = aMediaItem.artwork.imageWithSize(mediaCell.contentView.bounds.size);
            mediaImageView.hidden = false;
        }*/
        
        self.mediaItem = aMediaItem;
        //fillData(aMediaItem);
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }

}
