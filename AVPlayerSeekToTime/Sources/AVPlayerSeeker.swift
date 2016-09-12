//
//  Created by Foxling on 16/8/2.
//

import UIKit
import AVFoundation

private var seekerKey = ""

public extension AVPlayer {
    
    public func fl_seekSmoothlyToTime(newChaseTime: CMTime) {
        var seeker = objc_getAssociatedObject(self, &seekerKey) as? AVPlayerSeeker
        if seeker == nil {
            seeker = AVPlayerSeeker(player: self)
            objc_setAssociatedObject(self, &seekerKey, seeker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        seeker?.seekSmoothlyToTime(newChaseTime)
    }
}

public class AVPlayerSeeker {
    
    public let player: AVPlayer
    private var isSeekInProgress = false
    private var chaseTime = kCMTimeZero
    
    public init(player: AVPlayer) {
        self.player = player
    }
    
    public func seekSmoothlyToTime(newChaseTime: CMTime) {
        if CMTimeCompare(newChaseTime, chaseTime) != 0 {
            chaseTime = newChaseTime
            if !isSeekInProgress {
                trySeekToChaseTime()
            }
        }
    }
    
    private func trySeekToChaseTime() {
        if player.status == .ReadyToPlay {
            actuallySeekToTime()
        }
    }
    
    private func actuallySeekToTime() {
        isSeekInProgress = true
        let seekTimeInProgress = chaseTime
        player.seekToTime(seekTimeInProgress, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { isFinished in
            if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                self.isSeekInProgress = false
            } else {
                self.trySeekToChaseTime()
            }
        })
    }
}

