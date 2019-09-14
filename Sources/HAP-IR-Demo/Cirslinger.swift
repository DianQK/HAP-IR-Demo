import Clibpigpio

public func irSlingRaw(outPin: UInt32, frequency: UInt32, dutyCycle: Double, codes: [UInt32]) {
    #if os(macOS)
        print("send")
        return
    #endif
    var pulses: [gpioPulse_t] = [gpioPulse_t(gpioOn: 1, gpioOff: 1, usDelay: 1)]
    
    func addPulse(onPins: UInt32, offPins: UInt32, duration: UInt32) -> gpioPulse_t {
        return gpioPulse_t(gpioOn: onPins, gpioOff: offPins, usDelay: duration)
    }
    
    func carrierFrequency(outPin: UInt32, frequency: UInt32, dutyCycle: Double, duration: Double) -> [gpioPulse_t] {
        let oneCycleTime: Double = 1000000.0 / Double(frequency) // 1000000 microseconds in a second
        let onDuration = UInt32(round(oneCycleTime * dutyCycle))
        let offDuration = UInt32(round(oneCycleTime * (1.0 - dutyCycle)))
        
        let totalCycles = Int32(round(duration / oneCycleTime))
        let totalPulses = Int32(totalCycles * 2)
        
        var pulses: [gpioPulse_t] = []
        
        for i in (0...totalPulses) {
            if (i % 2 == 0) {
                pulses.append(addPulse(onPins: 1 << outPin, offPins: 0, duration: onDuration))
            } else {
                pulses.append(addPulse(onPins: 0, offPins: 1 << outPin, duration: offDuration))
            }
        }
        
        return pulses
    }
    
    func gap(outPin: UInt32, duration: Double) -> [gpioPulse_t] {
        return [addPulse(onPins: 0, offPins: 0, duration: UInt32(duration))]
    }
    
    for (index, value) in codes.enumerated() {
        if (index % 2 == 0) {
            pulses.append(contentsOf: carrierFrequency(outPin: outPin, frequency: frequency, dutyCycle: dutyCycle, duration: Double(value)))
        } else {
            pulses.append(contentsOf: gap(outPin: outPin, duration: Double(value)))
        }
    }
    
    let pulsesCount = UInt32(pulses.count)
    
    // Init pigpio
    if (gpioInitialise() < 0)
    {
        // Initialization failed
        print("GPIO Initialization failed\n")
        return
    }
    
    // Setup the GPIO pin as an output pin
    gpioSetMode(outPin, UInt32(PI_OUTPUT))
    
    // Start a new wave
    gpioWaveClear()
    
    gpioWaveAddGeneric(pulsesCount, &pulses)
    
    let waveID = gpioWaveCreate()
    
    if (waveID >= 0) {
        let result = gpioWaveTxSend(UInt32(waveID), UInt32(PI_WAVE_MODE_ONE_SHOT))
        print("Result: \(result)\n")
    } else {
        print("Wave creation failure!\n \(waveID)")
    }
    
    // Wait for the wave to finish transmitting
    while (gpioWaveTxBusy() > 0)
    {
        time_sleep(0.1);
    }
    
    // Delete the wave if it exists
    if (waveID >= 0)
    {
        gpioWaveDelete(UInt32(waveID))
    }
    
    gpioTerminate()

}
