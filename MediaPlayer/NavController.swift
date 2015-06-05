//
//  NavController.swift
//  MediaPlayer
//
//  Created by jingjing qu on 5/25/15.
//  Copyright (c) 2015 TYX. All rights reserved.
//

import UIKit

class NavController: UINavigationController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar上title的颜色在navController里修改
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor()]

        self.navigationBar.barTintColor = UIColor(red: 0.267, green: 0.808, blue: 0.965, alpha: 1.0)
        //self.navigationBar.backgroundColor = UIColor.yellowColor()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
       //每次新界面弹出来把status bar变浅色
       // UIApplication.sharedApplication().statusBarStyle = .LightContent
        
    }
    
    }
