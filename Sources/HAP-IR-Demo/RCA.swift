//
//  RCA.swift
//  Cirslinger
//
//  Created by DianQK on 2019/9/8.
//

import Foundation

public struct RCA {
    
    public let pin: UInt32
    public let address: String // 4 位
    public let command: String // 8 位

    public let codes: [UInt32]
    
    public let frequency: UInt32 = 38000
    public let dutyCycle: Double = 0.5
    
    
    public init(pin: UInt32, address: String, command: String) {
        self.pin = pin
        self.address = address
        self.command = command
        let leadingPulseDuration: UInt32 = 4000
        let leadingGapDuration: UInt32 = 4000
        
        let addressCodes = self.address.compactMap { $0 == "1" }
        let commandCodes = self.command.compactMap { $0 == "1" }
        
        let convertToPulses = { (isPulse: Bool) -> [UInt32] in
            return isPulse ? [500, 2000] : [500, 1000]
        }

        var codes: [UInt32] = [leadingPulseDuration, leadingGapDuration]
        codes.append(contentsOf: addressCodes.flatMap(convertToPulses))
        codes.append(contentsOf: commandCodes.flatMap(convertToPulses))
        codes.append(contentsOf: addressCodes.map { !$0 }.flatMap(convertToPulses))
        codes.append(contentsOf: commandCodes.map { !$0 }.flatMap(convertToPulses))
        codes.append(500)

        self.codes = codes
    }
    
    public func send() {
        irSlingRaw(outPin: pin, frequency: frequency, dutyCycle: dutyCycle, codes: codes)
    }
    
}
