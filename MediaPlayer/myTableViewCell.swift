//
//  myTableViewCell.swift
//  MediaPlayer
//
//  Created by jingjing qu on 5/25/15.
//  Copyright (c) 2015 TYX. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {
    
    var picture: UIImageView!
    var musicName: UILabel!
    var line: UILabel!
    var musicArtist: UILabel!
    var musicAlbum: UILabel!
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.picture = UIImageView(frame: CGRectMake(20.0, 8.0, 64.0, 64.0))
        self.picture.backgroundColor = UIColor.clearColor()
        addSubview(self.picture)
        
        self.musicName = UILabel(frame: CGRectMake(100.0, 10.0, 250.0, 35.0))
        self.musicName.backgroundColor = UIColor.clearColor()
        self.musicName.font = UIFont.boldSystemFontOfSize(22.0)
        addSubview(self.musicName)
        
        self.line = UILabel(frame: CGRectMake(0.0, 79.0, self.screenWidth, 0.5))
        self.line.backgroundColor = UIColor.grayColor()
        addSubview(self.line)
        
        self.musicArtist = UILabel(frame: CGRectMake(100.0, 50.0, 100.0, 30.0))
        self.musicArtist.backgroundColor = UIColor.clearColor()
        addSubview(self.musicArtist)
        
        self.musicAlbum = UILabel(frame: CGRectMake(200.0, 50.0, 200.0, 30.0))
        self.musicAlbum.textColor = UIColor.grayColor()
        self.musicAlbum.backgroundColor = UIColor.clearColor()
        addSubview(self.musicAlbum)
        
    }
    
    
}
