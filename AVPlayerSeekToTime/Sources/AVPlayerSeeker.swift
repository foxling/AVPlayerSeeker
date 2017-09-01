//
//  Created by Foxling on 16/8/2.
//

import UIKit
import AVFoundation

private var seekerKey = ""

public extension AVPlayer {
    
    public func fl_seekSmoothly(to newChaseTime: CMTime) {
        var seeker = objc_getAssociatedObject(self, &seekerKey) as? AVPlayerSeeker
        if seeker == nil {
            seeker = AVPlayerSeeker(player: self)
            objc_setAssociatedObject(self, &seekerKey, seeker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        seeker?.seekSmoothly(to: newChaseTime)
    }
    
}

open class AVPlayerSeeker {
    
    open weak var player: AVPlayer?
    fileprivate var isSeekInProgress = false
    fileprivate var chaseTime = kCMTimeZero
    
    public init(player: AVPlayer) {
        self.player = player
    }
    
    open func seekSmoothly(to newChaseTime: CMTime) {
        guard let player = player else {
            return
        }
        if (player.currentItem == nil) {
            return
        }
//        print("seekSmoothly: \(newChaseTime), isSeekInProgress: \(isSeekInProgress), currentTime: \(player.currentTime())")
        if CMTimeCompare(player.currentTime(), newChaseTime) != 0 {
            chaseTime = newChaseTime
            if !isSeekInProgress {
                trySeekToChaseTime()
            }
        }
    }
    
    fileprivate var readyObservable: ReadyObservable?
    fileprivate func trySeekToChaseTime() {
        guard let player = player else {
            return
        }
        readyObservable?.cancel()
//        print("player.status before: \(player.status.rawValue)")
        if player.status == .readyToPlay {
            actuallySeekToTime()
        } else {
            readyObservable = ReadyObservable(player, { [weak self] in
                guard let s = self else { return }
                s.actuallySeekToTime()
            })
        }
    }
    
    fileprivate func actuallySeekToTime() {
        guard let player = player else {
            return
        }
        isSeekInProgress = true
//        print("actuallySeekToTime: \(chaseTime)")
        player.seek(to: chaseTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { [weak self] isFinished in
            guard let s = self, let player = s.player else { return }
//            print("seek done: \(player.currentTime()), chaseTime: \(s.chaseTime)")
            if abs(CMTimeSubtract(player.currentTime(), s.chaseTime).seconds) < 0.1 {
                s.isSeekInProgress = false
            } else {
                s.trySeekToChaseTime()
            }
        })
    }
    
}

private class ReadyObservable: NSObject {
    fileprivate var block: (() -> Void)
    fileprivate var player: AVPlayer
    fileprivate var isCancel: Bool = false
    init(_ player: AVPlayer, _ block: @escaping (() -> Void)) {
        self.block = block
        self.player = player
        super.init()
        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("ReadyObservable: isCancel-\(isCancel), status-\(player.status.rawValue)")
        if isCancel {
            return
        }
        if keyPath == "status" {
            if player.status == .readyToPlay {
                block()
            }
        }
    }
    func cancel() {
        if isCancel {
            return
        }
        isCancel = true
    }
    deinit {
        player.removeObserver(self, forKeyPath: "status")
    }
}
