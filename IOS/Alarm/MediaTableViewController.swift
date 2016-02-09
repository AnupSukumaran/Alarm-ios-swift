//
//  MusicTableViewController.swift
//  Alarm-ios8-swift
//
//  Created by longyutao on 16/2/3.
//  Copyright (c) 2016年 LongGames. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaTableViewController: UITableViewController, MPMediaPickerControllerDelegate  {
    
    private let musicIdentifier = "musicIdentifier"
    private let numberOfRingtones = 2
    var mediaItem: MPMediaItem?
    static func mediaText() -> String
    {
        
        return Global.mediaLabel
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0
        {
            return 1
        }
        
        else if section == 1
        {
            return 2
        }
        else
        {
            return numberOfRingtones
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return nil
        }
        else if section == 1
        {
            return "SONGS"
        }
        else
        {
            return "RINGTONS"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84.0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(
            musicIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(
                style: UITableViewCellStyle.Default, reuseIdentifier: musicIdentifier)
        }
        if indexPath.section == 0
        {
            
            if indexPath.row == 0
            {
                cell!.textLabel!.text = "Buy More Tones"
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 1
            {
                cell!.textLabel!.text = "Pick a song"
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                cell!.textLabel!.text = "bell"
            }
            else if indexPath.row == 1
            {
                cell!.textLabel!.text = "tickle"
            }
            if cell!.textLabel!.text == Global.mediaLabel
            {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mediaPicker = MPMediaPickerController(mediaTypes: MPMediaType.AnyAudio)
        mediaPicker.delegate = self
        mediaPicker.prompt = "Select any song!"
        mediaPicker.allowsPickingMultipleItems = false
        if indexPath.section == 1
        {
            if indexPath.row == 1
            {
                
                self.presentViewController(mediaPicker, animated: true, completion: nil)
            }
        }
        
        var c = tableView.cellForRowAtIndexPath(indexPath)
        var cells = tableView.visibleCells() as! [UITableViewCell]
        for cell in cells
        {
            var indexP = tableView.indexPathForCell(cell)
            if indexP?.section == 2
            {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        if indexPath.section == 2
        {
            c?.accessoryType = UITableViewCellAccessoryType.Checkmark
            Global.mediaLabel = c!.textLabel!.text!
        }
    }
    
    
    /*
    MPMediaPickerControllerDelegate
    */
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems  mediaItemCollection:MPMediaItemCollection) -> Void
    {
        if !mediaItemCollection.items.isEmpty
        {
            var aMediaItem = mediaItemCollection.items[0] as? MPMediaItem
        
//        if aMediaItem?.artwork != nil {
//        mediaImageView.image = aMediaItem.artwork.imageWithSize(mediaCell.contentView.bounds.size);
//        mediaImageView.hidden = false
//        }
        
        self.mediaItem = aMediaItem
        Alarms.sharedInstance[Global.indexOfCell].mediaID = (self.mediaItem?.valueForProperty(MPMediaItemPropertyPersistentID)) as! String
        //fillData(aMediaItem);
        self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
