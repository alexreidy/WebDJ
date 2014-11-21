//
//  Main.swift
//  WebDJ
//
//  Created by Alex Reidy on 11/20/14.
//  Copyright (c) 2014 Alex Reidy. All rights reserved.
//

import Foundation
import MediaPlayer

let ID = getRandomString(7), WEB_ID = ID + "_W"

var player = MPMusicPlayerController()
var songs  = MPMediaQuery.songsQuery().items

var songsToPlay: [MPMediaItem] = []

var running = false

var command: [String: String] = [
    "play"  : "_____PLAY_____",
    "pause" : "_____PAUSE_____",
    "next-song" : "_____NEXT_____",
    "prev-song" : "_____PREV_____"
]

func getSongsWithTitleContaining(str: String, songs: [MPMediaItem]) -> [MPMediaItem] {
    var matches: [MPMediaItem] = []
    
    for song in songs {
        if song.title == nil { break }
        let title = lowercase(song.title!)
        
        if contains(title, lowercase(str)) {
            matches.append(song as MPMediaItem)
        }
    }
    
    return matches
}

func run() {
    running = true
    
    while (running) {
        sleep(1)
        println("Waiting for command")
        
        if var message = get("http://192.168.1.5/WebDJ/backend/app.php?name=\(ID)&action=gm") {
            println("message = " + message)
            if message == "" { continue }
            
            if message.hasPrefix(command["play"]!) {
                if message == command["play"] {
                    player.play()
                    continue
                }
                
                songsToPlay = []
                let songQuery = message.substringFromIndex(
                    message.rangeOfString(command["play"]!)!.endIndex)
                
                println("Looking for \(songQuery)")
                player.setQueueWithItemCollection(MPMediaItemCollection(items:
                    getSongsWithTitleContaining(songQuery, songs as [MPMediaItem])))
                
                // function -> local procedure so we can play the first match immediately.
                
                player.play()
                continue
            }
            
            if message == command["pause"]! {
                player.pause()
            }
            
            if message == command["next-song"]! {
                player.skipToNextItem()
            }
            
            if message == command["prev-song"]! {
                player.skipToPreviousItem()
            }
            
        }
        
    }
}

func begin() {
    if running {return}
    runAsync({
        run()
    })
}