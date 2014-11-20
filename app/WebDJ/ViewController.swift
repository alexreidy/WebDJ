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
    
    var player = MPMusicPlayerController()
    var songs  = MPMediaQuery.songsQuery().items
    
    var running = false
    
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
    
    func run() { ////////////// nnnneeeeeedddd to use POST because some song names are retaaaaaaded
        running = true
        
        while (running) {
            sleep(1)
            println("Waiting for command")
            
            if var message = get("http://192.168.1.5/WebDJ/backend/app.php?name=\(ID)&action=gm") {
                if message == "" { continue }
                
                if message == "SEND_SONG_LIST" {
                    for song in songs {
                        get("http://192.168.1.5/WebDJ/backend/app.php?name=\(WEB_ID)&action=sm&message=_____SONG_____\(replaceSpacesForURL(song.title!!))")
                    }
                    
                    continue
                }
                
                let songQuery = message
                println("Looking for \(songQuery)")
                for song in songs {
                    let title = lowercase(song.title!!)
                    if contains(title, lowercase(songQuery)) {
                        player.setQueueWithItemCollection(MPMediaItemCollection(items: [song]))
                        player.play()
                        println("Playing \(title)")
                        break
                    }
                }
                
            }
            
        }
    }
    
    func begin() {
        if self.running {return}
        runAsync({
            self.run()
        })
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