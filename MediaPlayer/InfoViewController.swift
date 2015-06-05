//
//  InfoViewController.swift
//  MediaPlayer
//
//  Created by jingjing qu on 5/25/15.
//  Copyright (c) 2015 TYX. All rights reserved.
//

import UIKit
import MediaPlayer

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var table: UITableView!
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    var data = ["a", "b", "c", "d"]
    var identifier = "cell"
    var nav: NavController!
    lazy var musicViewController = MusicViewController()
    
    private let musicItems = MPMediaItemCollection(items: MPMediaQuery.songsQuery().items)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation controller
        //每一个view的title要在这个view里单独加
        self.navigationItem.title = "Media Player"
        
        //table view
        //top bar 20.0, navigation bar 44.0
        self.table = UITableView(frame: CGRectMake(0.0, 0.0, self.screenWidth, self.screenHeight), style: UITableViewStyle.Plain)
        self.table.rowHeight = 80.0
        self.table.separatorStyle = .None
        self.table.delegate = self
        self.table.dataSource = self
        //the bottom cell in the table
        //self.table.tableFooterView = UIView()
        self.table.registerClass(myTableViewCell.classForCoder(), forCellReuseIdentifier: self.identifier)
        self.view.addSubview(self.table)
        
        self.musicViewController.musicItems = self.musicItems

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier(self.identifier, forIndexPath: indexPath) as! myTableViewCell
        
        if indexPath.row == self.musicViewController.musicIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        
        let mediaItem = self.musicItems.items[indexPath.row] as! MPMediaItem
        
        if let mediaArkwork = mediaItem.valueForProperty(MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
            cell.picture.image = mediaArkwork.imageWithSize(CGSizeMake(65.0, 65.0))
        } else {
            cell.picture.image = nil
        }
        
        cell.musicName.text = mediaItem.valueForProperty(MPMediaItemPropertyTitle) as? String
        
        
    
        
        
//        var basicString1 = ""
//        var basicString2 = ""
//        if let name = mediaItem.valueForProperty(MPMediaItemPropertyArtist) as? String {
//            basicString1 = name
//        }
//        if let name = mediaItem.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String {
//            basicString2 = name
//        }
//        
//        let colorString = NSMutableAttributedString(string: basicString1 + " " + basicString2, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12.0)])
//        colorString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: count(basicString1)))
//        colorString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSRange(location: count(basicString1) + 1 , length:count(basicString1) + count(basicString2) + 1))
//        cell.musicArtist.attributedText = colorString
        
        cell.musicArtist.text = mediaItem.valueForProperty(MPMediaItemPropertyArtist) as? String
        
        cell.musicAlbum.text = mediaItem.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String

        cell.musicName.frame.size.width = CGFloat(count(cell.musicName.text!.utf16)) * 30.0
        cell.musicAlbum.frame.size.width = CGFloat(count(cell.musicAlbum.text!.utf16)) * 30.0
        cell.musicArtist.frame.size.width = CGFloat(count(cell.musicArtist.text!.utf16)) * 30.0
        
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = self.table.indexPathForSelectedRow() {
          self.table.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if self.musicViewController.musicIndex != -1 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "toMusicViewController:")
        }
        
    }
    
    func toMusicViewController(sender: AnyObject) {
        self.musicViewController.musicHasChanged = false
        self.navigationController!.pushViewController(self.musicViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let mediaItem = self.musicItems.items[indexPath.row] as! MPMediaItem

            self.musicViewController.navigationItem.title = mediaItem.valueForProperty(MPMediaItemPropertyTitle) as? String
        
        
        if self.musicViewController.musicIndex != indexPath.row {
            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! myTableViewCell
            
            currentCell.accessoryType = .Checkmark
            
            if self.musicViewController.musicIndex != -1 {
             
                if let previousCell = self.table.cellForRowAtIndexPath(NSIndexPath(forRow: self.musicViewController.musicIndex, inSection: 0)) as? myTableViewCell {
                    previousCell.accessoryType = .None
                }
                
            }
            
            self.musicViewController.musicIndex = indexPath.row
            self.musicViewController.musicHasChanged = true
            
        } else {
            self.musicViewController.musicHasChanged = false
        }
        
        
            self.navigationController!.pushViewController(self.musicViewController, animated: true)
    }
    



}
