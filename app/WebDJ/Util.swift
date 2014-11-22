//
//  Util.swift
//  WebDJ
//
//  Created by Alex Reidy on 11/19/14.
//  Copyright (c) 2014 Alex Reidy. All rights reserved.
//

import Foundation

// Returns true if strB is substring of strA
func contains(strA: String, strB: String) -> Bool {
    if (countElements(strA) < countElements(strB)) ||
        countElements(strA) == 0 || countElements(strB) == 0 {
            return false
    }
    
    var iB = 0
    
    for var i = 0; i < countElements(strA); i++ {
        if Array(strA)[i] == Array(strB)[iB] {
            if ++iB == countElements(strB) { return true }
        } else {
            iB = 0
        }
    }
    
    return false
}

// Returns true if str starts with prefix
func startsWith(str: String, prefix: String) -> Bool {
    if countElements(prefix) > countElements(str) {
        return false
    }
    
    for var i = 0; i < countElements(prefix); i++ {
        if Array(str)[i] != Array(prefix)[i] {
            return false
        }
    }
    
    return true
}

func split(str: String, delim: Character) -> [String] {
    var components: [String] = []
    var temp: String = ""
    
    for c in str {
        if c == delim {
            components.append(temp)
            temp = ""
        } else {
            temp.append(c)
        }
    }
    
    components.append(temp)
    return components
}

func get(webAddress: String) -> String? {
    let data = NSURLConnection.sendSynchronousRequest(
        NSURLRequest(URL: NSURL(string: webAddress)!), returningResponse: nil, error: nil)
    
    if data == nil { return nil }
    
    return NSString(data: data!, encoding: NSUTF8StringEncoding)
}

func lowercase(str: String) -> String {
    return NSString(string: str).lowercaseString
}

func getRandomString(length: Int) -> String {
    let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
    var str = ""

    for var i = 0; i < length; i++ {
        str.append(alphabet[Int(arc4random_uniform(UInt32(alphabet.count)))])
    }
    
    return str
}

func runAsync(fn: () -> ()) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), fn)
}

func replaceSpacesForURL(str: String) -> String {
    var components = split(str, " ")
    var nstr = ""
    
    for component in components {
        nstr.splice(component, atIndex: nstr.endIndex)
        if component != components.last {
            nstr.splice("%20", atIndex: nstr.endIndex)
        }
    }
    
    return nstr
}

func escapeStringForURL(str: NSString) -> String {
    return CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault, str, nil,
        ":/?#[]@!$&'()*+,;=" as NSString,
        kCFStringEncodingASCII)
}

