//
//  main.swift
//  urlcodec
//
//  Created by larryhou on 31/7/2015.
//  Copyright © 2015 larryhou. All rights reserved.
//

import Foundation

var decodeMode = true, verbose = false

var arguments = Process.arguments
arguments = Array(arguments[1..<arguments.count])

let manager = ArgumentsManager(name: "encodeURIComponent")
manager.insertOption("--encode-mode", abbr: "-e", help: "Use url encode mode to process", hasValue: false) { decodeMode = false }
manager.insertOption("--decode-mode", abbr: "-d", help: "Use url decode mode to process", hasValue: false) { decodeMode = true }
manager.insertOption("--verbose", abbr: "-v", help: "Enable verbose printing", hasValue: false) { verbose = true }
manager.insertOption("--help", abbr: "-h", help: "Show help message", hasValue: false)
{
    manager.showHelpMessage()
    exit(0)
}

while arguments.count > 0
{
    let text = arguments[0]
    if manager.recognizeOption(text, triggerWhenMatch: true)
    {
        arguments.removeAtIndex(0)
        if let hasValue = manager.getOption(text)?.hasValue where hasValue
        {
            //TODO: parsing argument value
        }
    }
    else
    {
        break
    }
}

if verbose
{
    print(Process.arguments)
}

func expandUnicodeString(range:String) -> String
{
    let from = range.unicodeScalars.startIndex
    let to = from.successor().successor()
    
    var result = ""
    for i in range.unicodeScalars[from].value...range.unicodeScalars[to].value
    {
        result.append(UnicodeScalar(i))
    }
    
    return result
}

var charactersInString = expandUnicodeString("a-z") + expandUnicodeString("A-Z") + expandUnicodeString("0-9") + "-_.!~*'()"
let encodeURICharacterSet = NSCharacterSet(charactersInString: charactersInString)

if arguments.count > 0
{
    while arguments.count > 0
    {
        var text = arguments.removeAtIndex(0)
        if decodeMode
        {
            text = text.stringByRemovingPercentEncoding!
        }
        else
        {
            text = text.stringByAddingPercentEncodingWithAllowedCharacters(encodeURICharacterSet)!
        }
        
        print(text)
    }
}
else
{
    manager.showHelpMessage(stderr)
    exit(1)
}


