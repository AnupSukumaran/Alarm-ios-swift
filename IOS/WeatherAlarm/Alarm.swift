//
//  Alarm.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-2-28.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import MediaPlayer

class Alarm: NSObject {
    
   
    var title: String
    var timeStr: String
    var date: NSDate
    var enabled: Bool
    //var region:CLCircularRegion
    var media:MPMediaItem?
    
    init( title: String, timestr: String, date: NSDate, enabled: Bool, media: MPMediaItem?) {
        self.title = title
       // self.region = region
        
        self.timeStr = timestr
        self.date = date
        self.enabled = enabled
        self.media = media
     
    }
}
