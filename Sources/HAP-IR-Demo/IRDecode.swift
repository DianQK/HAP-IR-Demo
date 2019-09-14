//
//  IRDecode.swift
//  HAP-IR-Demo
//
//  Created by DianQK on 2019/9/14.
//

import SwiftyGPIO
import Foundation
#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

struct IRDecode {
    
    static func decode(times: [UInt64]) {
        let values = times[2...49].enumerated() // 后半段是循环 8000us + lead code + code
            .compactMap({ $0.offset % 2 == 1 ? $0.element : nil })
            .map { (space: UInt64) -> Int in
                let oneRange: ClosedRange<UInt64> = 1500...2200
                return oneRange.contains(space) ? 1 : 0
        }
        let result = values.map(String.init).joined()
        print(result)
    }
    
}
