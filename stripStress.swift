#!/usr/bin/swift
//: dict stress remover
/// usage: `swift stripStress.swift`
/// Author: Antoine Cœur

import Foundation

let origin = "cmudict.dict"
let destination = "cmudict-en-us.dict"

/// https://stackoverflow.com/a/46046008/1033581
class MutableOrderedDictionary: NSDictionary {
    let _values: NSMutableArray = []
    let _keys: NSMutableOrderedSet = []
    
    override var count: Int {
        return _keys.count
    }
    override func keyEnumerator() -> NSEnumerator {
        return _keys.objectEnumerator()
    }
    override func object(forKey aKey: Any) -> Any? {
        let index = _keys.index(of: aKey)
        if index != NSNotFound {
            return _values[index]
        }
        return nil
    }
    func setObject(_ anObject: Any, forKey aKey: String) {
        let index = _keys.index(of: aKey)
        if index != NSNotFound {
            _values[index] = anObject
        } else {
            _keys.add(aKey)
            _values.add(anObject)
        }
    }
}

let stripStress: Void = {
    let content = try! String(contentsOf: URL(fileURLWithPath: origin), encoding: .utf8)
    let dict = MutableOrderedDictionary()
    let regexp = try! NSRegularExpression(pattern: "^([^ \\(]+)[^ ]* (.*)$", options: .anchorsMatchLines)
    regexp.enumerateMatches(in: content, options: [], range: NSRange(location: 0, length: content.count), using: { (result, _, _) in
        let match1 = String(content[Range(result!.range(at: 1), in: content)!])
        let match2 = String(content[Range(result!.range(at: 2), in: content)!]).filter { !"012".contains($0) }
        if let prunounciations = dict[match1] as? NSMutableOrderedSet {
            prunounciations.add(match2)
        } else {
            dict.setObject(NSMutableOrderedSet(object: match2), forKey: match1)
        }
    })
    var result = ""
    for (word, phonesList) in dict {
        let (word, phonesList) = (word as! String, phonesList as! NSMutableOrderedSet)
        for (i, phones) in phonesList.enumerated() {
            let phones = phones as! String
            result.append(word + (i == 0 ? "" : "(\(i + 1))") + " " + phones + "\n")
        }
    }
    try! result.write(to: URL(fileURLWithPath: destination), atomically: true, encoding: .utf8)
}()
