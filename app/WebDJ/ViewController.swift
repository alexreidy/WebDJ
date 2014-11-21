//
//  ViewController.swift
//  WebMusicController
//
//  Created by Alex Reidy on 11/12/14.
//  Copyright (c) 2014 Alex Reidy. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var pausePlayToggleSwitch: UISwitch!
    
    @IBAction func togglePlaying(sender: AnyObject) {
        if pausePlayToggleSwitch.on {
            player.play()
            begin()
        } else {
            running = false
            player.pause()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        idLabel.text = ID
        begin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}