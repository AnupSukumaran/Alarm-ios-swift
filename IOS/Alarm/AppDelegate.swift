//
//  AppDelegate.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-2-28.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import AVFoundation

protocol AlarmApplicationDelegate
{
    //typealias Weekday
    func playAlarmSound()
    //something wrong with typealias, use Int instead
    func setNotificationWithDate(date: NSDate, onWeekdaysForNotify:[Int]?)
    func setupNotificationSettings()
    
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, AlarmApplicationDelegate{

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    //var alarmDelegate: AlarmApplicationDelegate?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //alarmDelegate? = self
        //alarmDelegate!.setupNotificationSettings()
        
        setupNotificationSettings()
        window?.tintColor = UIColor.redColor()
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        /*AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
            nil,
            vibrationCallback,
            nil)*/
        
        playAlarmSound()
        //if app is in foreground, show a alert
        let storageController = UIAlertController(title: "Alarm", message: nil, preferredStyle: .Alert)
        //todo, snooze
        let snoozeOption = UIAlertAction(title: "Snooze", style: .Default) {
            (action:UIAlertAction!)->Void in audioPlayer?.stop()
            
        }
        let stopOption = UIAlertAction(title: "OK", style: .Default) {
            (action:UIAlertAction!)->Void in audioPlayer?.stop()}
        storageController.addAction(snoozeOption)
        storageController.addAction(stopOption)
        window?.rootViewController!.presentViewController(storageController, animated: true, completion: nil)
  
        
    }
    
    //print out all registed NSNotification for debug
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        println(notificationSettings.types.rawValue)
    }
    
    //AlarmApplicationDelegate protocol
    func playAlarmSound() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        let url = NSURL.fileURLWithPath(
            NSBundle.mainBundle().pathForResource("bell", ofType: "mp3")!)
        
        var error: NSError?
        
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        if let err = error {
            println("audioPlayer error \(err.localizedDescription)")
        } else {
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        }
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.play()
    }
    
    func setupNotificationSettings() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        //if (notificationSettings.types == UIUserNotificationType.None){
            // Specify the notification types.
            var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
            
            
            // Specify the notification actions.
            var stopAction = UIMutableUserNotificationAction()
            stopAction.identifier = "myStop"
            stopAction.title = "OK"
            stopAction.activationMode = UIUserNotificationActivationMode.Background
            stopAction.destructive = false
            stopAction.authenticationRequired = false
            
            var snoozeAction = UIMutableUserNotificationAction()
            snoozeAction.identifier = "mySnooze"
            snoozeAction.title = "Snooze"
            snoozeAction.activationMode = UIUserNotificationActivationMode.Background
            snoozeAction.destructive = false
            snoozeAction.authenticationRequired = false
        
            
            let actionsArray = [UIUserNotificationAction](arrayLiteral: stopAction, snoozeAction)
            let actionsArrayMinimal = [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction)
            // Specify the category related to the above actions.
            var alarmCategory = UIMutableUserNotificationCategory()
            alarmCategory.identifier = "myAlarmCategory"
            alarmCategory.setActions(actionsArray, forContext: .Default)
            alarmCategory.setActions(actionsArrayMinimal, forContext: .Minimal)
            
            
            let categoriesForSettings = Set(arrayLiteral: alarmCategory)
            
            
            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings)
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        //}
    }
    
    private func correctDate(date: NSDate, onWeekdaysForNotify weekdays:[Int]?) -> [NSDate]
    {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let now = NSDate()
        var correctedDate: [NSDate] = [NSDate]()
        let flags = NSCalendarUnit.CalendarUnitEra|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitWeekdayOrdinal | NSCalendarUnit.CalendarUnitTimeZone | NSCalendarUnit.CalendarUnitWeekOfMonth | NSCalendarUnit.CalendarUnitWeekOfYear
        var dateComponents = calendar.components(flags, fromDate: date)
        var nowComponents = calendar.components(flags, fromDate: now)
        var weekday:Int!
        if date.compare(now) == NSComparisonResult.OrderedAscending
        {
            nowComponents.hour = dateComponents.hour
            nowComponents.minute = dateComponents.minute
            nowComponents.second = 0
            weekday = nowComponents.weekday
            correctedDate.append(calendar.dateFromComponents(nowComponents)!)
        }
        else
        {
            weekday = dateComponents.weekday
            correctedDate.append(calendar.dateFromComponents(dateComponents)!)
        }
        if weekdays == nil{
            return correctedDate
        }
        else
        {
            let daysInWeek = 7
            correctedDate.removeAll(keepCapacity: true)
            for wd in weekdays!
            {
                
                var wdDate: NSDate!
                if date.compare(now) == NSComparisonResult.OrderedAscending
                {
                    
                    wdDate =  calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: wd+daysInWeek-weekday, toDate: date, options:.MatchStrictly)!
                    
                }
                else
                {
                    wdDate =  calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: wd-weekday, toDate: date, options:.MatchStrictly)!
                }
                
                correctedDate.append(wdDate)
            }
            return correctedDate
        }
    }
    
    func setNotificationWithDate(date: NSDate, onWeekdaysForNotify weekdays:[Int]?) {
        let AlarmNotification: UILocalNotification = UILocalNotification()
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        AlarmNotification.alertBody = "Wake Up!"
        AlarmNotification.alertAction = "Open App"
        AlarmNotification.category = "myAlarmCategory"
        //AlarmNotification.applicationIconBadgeNumber = 0
        //AlarmNotification.repeatCalendar = calendar
        //TODO, not working
        //AlarmNotification.repeatInterval = NSCalendarUnit.CalendarUnitWeekOfYear
        AlarmNotification.soundName = "bell.mp3"
        AlarmNotification.timeZone = NSTimeZone.defaultTimeZone()
        
        let datesForNotification = correctDate(date, onWeekdaysForNotify:weekdays)
        for d in datesForNotification
        {
            AlarmNotification.fireDate = d
            UIApplication.sharedApplication().scheduleLocalNotification(AlarmNotification)
        }
        
    }
    
    
    
    
    //todo,vibration infinity
    func vibrationCallback(id:SystemSoundID, _ callback:UnsafeMutablePointer<Void>) -> Void
    {
        print("callback")
    }
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully
        flag: Bool) {
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!,
        error: NSError!) {
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer!) {
    }
    
    
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

