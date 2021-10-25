//
//  TTLiveAgentUtils.swift
//  TTLiveAgentWidget
//
//  Created by Lukáš Boura on 21.10.2021.
//

import Foundation

class TTLiveAgentUtils {
    
    static func urlCode(from url: URL) -> String? {
        let urlString = url.absoluteString
        let urlRange = NSRange(urlString.startIndex..<urlString.endIndex, in: urlString)
        let regex = try! NSRegularExpression(pattern: #"(http|https):\/\/.*\/(?<urlcode>[\d]+)"#)

        if let match = regex.firstMatch(in: urlString, options: [], range: urlRange) {
            let urlCodeRange = match.range(at: match.numberOfRanges - 1)
            if let urlCodeStringRange = Range(urlCodeRange, in: urlString) {
                let urlCode = String(urlString[urlCodeStringRange])
                return urlCode
            }
        }
        
        return nil
    }
    
}
