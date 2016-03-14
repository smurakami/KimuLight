//
//  ViewController.swift
//  KimuLight
//
//  Created by 村上晋太郎 on 2016/03/12.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit
import CoreMotion
import RxCocoa
import RxSwift

extension CMMotionManager {
    var rx_deviceMotionUpdated: Observable<CMDeviceMotion> {
        return Observable.create { observer in
            self.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { dataOrNil, errorOrNil in
                if let error = errorOrNil {
                    observer.onError(error)
                } else if let data = dataOrNil {
                    observer.onNext(data)
                } else {
                    observer.onError(NSError(domain: "Undefined Error", code: 0, userInfo: nil))
                }
            })
            return NopDisposable.instance
        }
    }
}

class ViewController: UIViewController {
    
    let manager = CMMotionManager()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // utils
        func norm3(x: Double, _ y: Double, _ z: Double) -> Double {
            return sqrt(x * x + y * y + z * z)
        }
        func norm(v: CMAcceleration) -> Double {
            return norm3(v.x, v.y, v.z)
        }
        func mod(x: CGFloat, _ n: CGFloat) -> CGFloat {
            let x_ = x / n
            return (x_ - floor(x_)) * n
        }
        // stream
        let th: CGFloat = 0.15
        let maxValue: CGFloat = 1
        let accelNorm = manager.rx_deviceMotionUpdated
            .map { $0.userAcceleration }
            .map { norm($0) }
            .map { CGFloat($0) }
            .shareReplay(1)
        let hsb_low = accelNorm
            .filter { $0 < th }
            .map { (CGFloat(0), $0 / th, CGFloat(1)) }
        let hsb_high = accelNorm
            .filter { $0 >= th }
            .map { (mod($0, maxValue), CGFloat(1), CGFloat(1)) }
        
        Observable.of(hsb_low, hsb_high)
            .merge()
            .subscribeNext { [weak self] (h, s, b) in
                self?.view.backgroundColor = UIColor(hue: h, saturation: s, brightness: b, alpha: 1)
            }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

