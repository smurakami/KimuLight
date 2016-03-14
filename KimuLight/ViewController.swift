//
//  ViewController.swift
//  KimuLight
//
//  Created by 村上晋太郎 on 2016/03/12.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit
import CoreMotion

//
//
//func ** (left: Double, right: Double) {
//    return pow(left, right)
//}

func norm(x: Double, _ y: Double, _ z: Double) -> Double {
    return sqrt(x * x + y * y + z * z)
}

class ViewController: UIViewController {
    
    let manager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { [weak self] data, error in
            guard let accel = data?.userAcceleration else { return }
            let n = CGFloat(norm(accel.x, accel.y, accel.z))
            let h :CGFloat
            let s :CGFloat
            let b :CGFloat
            let th: CGFloat = 0.15
            if n < th {
                h = 0
                s = n / th
                b = CGFloat(1)
            } else {
                let h_ = (n - th) / (1 - th)
                h = h_ - floor(h_)
                s = CGFloat(1)
                b = CGFloat(1)
            }
            
            self?.view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b, alpha: 1)
            
            
//            guard let accel = data?.userAcceleration else { return }
//            let r = CGFloat(1 - accel.x)
//            let g = CGFloat(1 - accel.y)
//            let b = CGFloat(1 - accel.z)
//            self?.view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
            
//            self?.view.backgroundColor = UIColor(
//                red: CGFloat(accel.x),
//                green: CGFloat(accel.y),
//                blue: CGFloat(accel.z),
//                alpha: 1)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

