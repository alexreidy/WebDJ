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
var songs: [MPMediaItem] = MPMediaQuery.songsQuery().items as [MPMediaItem]

var songsToPlay: [MPMediaItem] = []

var running = false

var command: [String: String] = [
    "play"  : "_____PLAY_____",
    "pause" : "_____PAUSE_____",
    "next-song" : "_____NEXT_____",
    "prev-song" : "_____PREV_____"
]

var onSongChanged: ()->() = {}

func play() {
    player.play()
    onSongChanged()
}

func run() {
    running = true
    
    while (running) {
        sleep(1)
        println("Waiting for command")
        
        if var message = get("http://alexreidy.me/software/WebDJ/backend/app.php?name=\(ID)&action=gm") {
            if message == "" { continue }
            
            if message.hasPrefix(command["play"]!) {
                if message == command["play"] {
                    play()
                    continue
                }
                
                let songQuery = message.substringFromIndex(
                    message.rangeOfString(command["play"]!)!.endIndex)
                
                println("Looking for \(songQuery)")
                
                songsToPlay = []
                
                for song in songs {
                    if var title = song.title {
                        title = lowercase(title)
                        
                        if title.hasPrefix(songQuery) {
                            if songsToPlay.count == 0 {
                                // Play 1st match immediately
                                player.setQueueWithItemCollection(
                                    MPMediaItemCollection(items: [song]))
                                play()
                            }
                            songsToPlay.append(song)
                        }
                        
                    }
                }
                
                if songsToPlay.count > 0 {
                    player.setQueueWithItemCollection(
                        MPMediaItemCollection(items: songsToPlay))
                }
                
                continue
            }
            
            if message == command["pause"]! {
                player.pause()
            }
            
            if message == command["next-song"]! {
                player.skipToNextItem()
                if player.indexOfNowPlayingItem.predecessor() < 0 {
                    if songsToPlay.count > 1 {
                        player.nowPlayingItem = songsToPlay[1]
                    }
                }
                play()
            }
            
            if message == command["prev-song"]! {
                player.skipToPreviousItem()
                play()
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