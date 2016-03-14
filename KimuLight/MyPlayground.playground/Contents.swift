//: Playground - noun: a place where people can play

import RxCocoa
import RxSwift

"hello"

//let s = (0..<10).toObservable()
//    .map { e -> Int in
//        print("0: \(e)")
//        return e
//}.shareReplay(1)

let s = Observable<Int>.interval(1, scheduler: MainScheduler.instance)

s.subscribeNext { e in
    print("1: \(e)")
}

//s.subscribeNext { e in
//    print("2: \(e)")
//}
