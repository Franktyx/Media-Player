//
//  MusicViewController.swift
//  MediaPlayer
//
//  Created by jingjing qu on 5/25/15.
//  Copyright (c) 2015 TYX. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicViewController: UIViewController {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var musicItems: MPMediaItemCollection!
    var musicPlayer: MPMusicPlayerController!
    var infoViewController: InfoViewController!
    
    //pass the index from InfoViewController
    var musicIndex = -1
    var musicHasChanged = false
    
    var musicArtworkBackground: UIView!
    var musicArtwork: UIImageView!
    
    let imageRotate = CABasicAnimation(keyPath: "transform.rotation")
    var imageIsStoped = false
    
    var nextMusicButton: UIButton!
    var previousMusicButton: UIButton!
    var toggleButton: UIButton!
    var musicSlider: UISlider!
    var displayLink: CADisplayLink!
    var isPlaying = true
    
    var musicCurrentTime: UILabel!
    var musicTotalTime: UILabel!
    
    var musicBlurView: UIVisualEffectView!
    
    var playImage = UIImage(named: "Image-1")
    var pauseImage = UIImage(named: "Image-2")
    var nextImage = UIImage(named: "next")
    var prevImage = UIImage(named: "prev")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Image")!)
        self.musicBlurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        self.musicBlurView.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(self.musicBlurView)
        self.navigationController?.navigationBar.hidden = true
        
        
        //调用系统自带player
        self.musicPlayer = MPMusicPlayerController.systemMusicPlayer()
        //把musicItems放进player
        self.musicPlayer.setQueueWithItemCollection(self.musicItems)
        self.musicPlayer.repeatMode = .All
        
        //musicArtwork image
        self.musicArtwork = UIImageView(frame: CGRectMake(20.0, self.screenHeight / 2 - (self.screenWidth / 2 - 20.0), self.screenWidth - 40.0, self.screenWidth - 40.0))
        self.musicArtwork.backgroundColor = UIColor.grayColor()
        self.musicArtwork.layer.cornerRadius = self.screenWidth / 2 - 20.0
        

        //图片离开superview的部分不会显示
        self.musicArtwork.clipsToBounds = true
        self.musicArtwork.contentMode = .ScaleAspectFill
        self.musicBlurView.contentView.addSubview(self.musicArtwork)
        
        //once you change the song, you give this notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeMusic", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: self.musicPlayer)
        self.musicPlayer.beginGeneratingPlaybackNotifications()
        
        //next song button
        self.nextMusicButton = UIButton(frame: CGRectMake(self.screenWidth - 140.0, self.screenHeight - 90.0, 40.0, 40.0))
        self.nextMusicButton.setBackgroundImage(self.nextImage, forState: UIControlState.Normal)
        //nextMusicButton.backgroundColor = UIColor(red: 0.827, green: 0.878, blue: 0.953, alpha: 0.5)
        nextMusicButton.addTarget(self, action: "nextMusic:", forControlEvents: .TouchUpInside)
        self.musicBlurView.contentView.addSubview(self.nextMusicButton)
        
        //prev song button
        self.previousMusicButton = UIButton(frame: CGRectMake(100.0, self.screenHeight - 90.0, 40.0, 40.0))
        self.previousMusicButton.setBackgroundImage(self.prevImage, forState: UIControlState.Normal)
        //previousMusicButton.backgroundColor = UIColor(red: 0.827, green: 0.878, blue: 0.953, alpha: 0.5)

        previousMusicButton.addTarget(self, action: "prevMusic:", forControlEvents: .TouchUpInside)
        self.musicBlurView.contentView.addSubview(self.previousMusicButton)
        
        //toggle button, pause and play
        
        self.toggleButton = UIButton(frame: CGRectMake(self.screenWidth / 2 - 30.0 , self.screenHeight - 100.0 , 60.0, 60.0))
        self.toggleButton.backgroundColor = UIColor.clearColor()
        self.toggleButton.setBackgroundImage(self.pauseImage, forState: UIControlState.Normal)
        
        self.toggleButton.addTarget(self, action: "toggleMusic:", forControlEvents: .TouchUpInside)
        self.musicBlurView.contentView.addSubview(toggleButton)
        
        //UISlider
        self.musicSlider = UISlider(frame: CGRectMake(30.0, 530.0, self.screenWidth - 60.0, 30.0))
        self.musicSlider.addTarget(self, action: "pauseDisplayLink:", forControlEvents: .TouchDown)
        self.musicSlider.addTarget(self, action: "updateMusic:", forControlEvents: .TouchUpInside)
        self.musicSlider.addTarget(self, action: "updateMusic:", forControlEvents: .TouchUpOutside)
        self.musicBlurView.contentView.addSubview(self.musicSlider)
        
        //displayLink
        self.displayLink = CADisplayLink(target: self, selector: "updateMusicInterface:")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        
        let currentTimeVabEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: self.musicBlurView.effect as! UIBlurEffect))
        currentTimeVabEffectView.frame = CGRectMake(20, 500.0, 50.0, 30)
        self.musicBlurView.contentView.addSubview(currentTimeVabEffectView)
        
        self.musicCurrentTime = UILabel(frame: currentTimeVabEffectView.bounds)
        self.musicCurrentTime.textColor = UIColor.whiteColor()
        currentTimeVabEffectView.contentView.addSubview(self.musicCurrentTime)
        
        let totalTimeVabEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: self.musicBlurView.effect as! UIBlurEffect))
        totalTimeVabEffectView.frame = CGRectMake(self.screenWidth - 70.0, 500.0, 50.0, 30.0)
        self.musicBlurView.contentView.addSubview(totalTimeVabEffectView)
        
        self.musicTotalTime = UILabel(frame: totalTimeVabEffectView.bounds)
        self.musicTotalTime.textColor = UIColor.whiteColor()
        totalTimeVabEffectView.contentView.addSubview(self.musicTotalTime)
        
        //画纯色图
        //用withOptions支持retina屏幕，最后一个参数0.0表示支持retina
       //UIGraphicsBeginImageContextWithOptions(<#size: CGSize#>, <#opaque: Bool#>, <#scale: CGFloat#>)
        
        
        //add a double tap gesture on rotating artwork
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "toggleStop:")
        doubleTapGesture.numberOfTapsRequired = 2
        self.musicArtwork.addGestureRecognizer(doubleTapGesture)
        self.musicArtwork.userInteractionEnabled = true

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //give the reference of the rootViewController
        self.infoViewController = self.navigationController?.viewControllers[0] as! InfoViewController
        
        if self.musicHasChanged {
        
            self.musicPlayer.stop()
            self.musicPlayer.nowPlayingItem = self.musicItems.items[self.musicIndex] as! MPMediaItem
            self.musicPlayer.play()
            
            
        }
        
    }
    
    //next music button
    func nextMusic(sender: AnyObject) {
        self.musicPlayer.skipToNextItem()
        if self.toggleButton.titleForState(.Normal) == "Play" {
            toggleMusic(self.toggleButton)
        }
    }
    
    //previous music button
    func prevMusic(sender: AnyObject) {
        self.musicPlayer.skipToPreviousItem()
        if self.toggleButton.titleForState(.Normal) == "Play" {
            toggleMusic(self.toggleButton)
        }
    }
    
    func changeMusic() {
        self.navigationItem.title = self.musicPlayer.nowPlayingItem.valueForProperty(MPMediaItemPropertyTitle) as? String
        self.musicArtwork.layer.removeAllAnimations()
        
        (self.navigationController?.viewControllers[0] as! InfoViewController).table.reloadData()
        
        if let mediaArkwork = self.musicPlayer.nowPlayingItem.valueForProperty(MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
            self.musicArtwork.image = mediaArkwork.imageWithSize(CGSizeMake(self.screenWidth - 40.0, self.screenWidth - 40.0))
            imageRotate.fromValue = 0
            imageRotate.toValue = M_PI
            imageRotate.duration = 13.0
            imageRotate.repeatCount = Float.infinity
            imageRotate.cumulative = true
            self.musicArtwork.layer.addAnimation(imageRotate, forKey: "imageRotate")
            
        } else {
            self.musicArtwork.image = nil
        }
        
        if self.isPlaying == false {
            println("here")
            self.toggleMusic(self.toggleButton)
        }
        
        self.musicSlider.minimumValue = 0.0
        //NSTimeInterval其实是double
        self.musicSlider.maximumValue = Float(self.musicPlayer.nowPlayingItem.valueForProperty(MPMediaItemPropertyPlaybackDuration) as! NSTimeInterval)
        self.musicSlider.value = 0.0
        self.musicSlider.minimumValue = 0.0
        self.musicSlider.maximumValue = Float(self.musicPlayer.nowPlayingItem.valueForProperty(MPMediaItemPropertyPlaybackDuration) as! NSTimeInterval)

        self.musicCurrentTime.text = "00:00"
        
        let totalTime = Int(round(self.musicPlayer.nowPlayingItem.valueForProperty(MPMediaItemPropertyPlaybackDuration) as! NSTimeInterval))
        self.musicTotalTime.text = String(format:"%02d:%02d",totalTime/60,totalTime % 60)
    }
    
    //musicSlider
    func updateMusic(sender:AnyObject){
        self.musicPlayer.currentPlaybackTime = Double(self.musicSlider.value)
        self.displayLink.paused = false
        
        if self.isPlaying == false {
            self.toggleMusic(self.toggleButton)
        }
    }
    
    func pauseDisplayLink(sender:AnyObject)
    {
        self.displayLink.paused = true
    }
    
    //displayLink
    func updateMusicInterface(sender:AnyObject) {
        self.musicSlider.value = Float(self.musicPlayer.currentPlaybackTime)
        
        let currentTime = Int(round(self.musicPlayer.currentPlaybackTime))
        self.musicCurrentTime.text = String(format:"%02d:%02d",currentTime/60,currentTime % 60)
        
    }
    
    //toggle music button
    func toggleMusic(button: UIButton) {
        if self.isPlaying == true {
            self.musicPlayer.pause()
            self.isPlaying = false
            self.imageIsStoped = true
            self.toggleButton.setBackgroundImage(self.playImage, forState: UIControlState.Normal)
            //stop the rotating artwork
            let pauseTime = self.musicArtwork.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
            self.musicArtwork.layer.speed = 0.0
            self.musicArtwork.layer.timeOffset = pauseTime
        
        } else {
            self.musicPlayer.play()
            
            //stop the rotating artwork
            self.isPlaying = true
            self.imageIsStoped = false
            self.toggleButton.setBackgroundImage(self.pauseImage, forState: UIControlState.Normal)
            let pauseTime = self.musicArtwork.layer.timeOffset
            self.musicArtwork.layer.speed = 1.0
            self.musicArtwork.layer.timeOffset = 0.0
            self.musicArtwork.layer.beginTime = 0.0
            self.musicArtwork.layer.beginTime = self.musicArtwork.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pauseTime
        }
    }
    
    func toggleStop(recogizer: UITapGestureRecognizer) {
        if self.imageIsStoped == false {
            self.toggleMusic(self.toggleButton)
            self.imageIsStoped = true
        } else {
            self.toggleMusic(self.toggleButton)
            self.imageIsStoped = false
        }
    }
    
    

}
