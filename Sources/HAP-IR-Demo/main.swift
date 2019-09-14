import SwiftyGPIO
import Foundation
#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)
let gp = gpios[.pin18]!
gp.direction = .input
gp.onChange { (gpio) in
    print(gpio.value)
}

RunLoop.main.run()
