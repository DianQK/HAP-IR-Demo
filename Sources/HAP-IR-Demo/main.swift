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
var preTime: UInt64 = 0
var times: [UInt64] = []
gp.onChange { (gpio) in
    if (preTime == 0 && !gpio.value) { // 首个信号为脉冲，即 value 从 false 变 true 开始计算
        preTime = DispatchTime.now().uptimeNanoseconds
        print("收到信号，1s 后打印结果")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            print(times)
            preTime = 0
            times = []
        })
    } else if (preTime > 0) {
        let now = DispatchTime.now().uptimeNanoseconds
        times.append((now - preTime) / 1000)
        preTime = now
    }
}
RunLoop.main.run()
