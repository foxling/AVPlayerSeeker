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
        if CMTimeCompare(player.currentTime(), newChaseTime) != 0 {
            chaseTime = newChaseTime
            if !isSeekInProgress {
                trySeekToChaseTime()
            }
        }
    }
    
    fileprivate func trySeekToChaseTime() {
        guard let player = player else {
            return
        }
        if player.status == .readyToPlay {
            actuallySeekToTime()
        }
    }
    
    fileprivate func actuallySeekToTime() {
        guard let player = player else {
            return
        }
        isSeekInProgress = true
        let seekTimeInProgress = chaseTime
        player.seek(to: seekTimeInProgress, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { isFinished in
            if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                self.isSeekInProgress = false
            } else {
                self.trySeekToChaseTime()
            }
        })
    }
}

