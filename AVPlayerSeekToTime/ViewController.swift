//
//  ViewController.swift
//  AVPlayerSeekToTime
//
//  Created by LINGYE on 16/8/2.
//  Copyright © 2016年 lingye.me. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var slider: UISlider!

    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let URL = NSBundle.mainBundle().URLForResource("MAH01438", withExtension: "MP4")!
        let item = AVPlayerItem(asset: AVURLAsset(URL: URL), automaticallyLoadedAssetKeys: ["duration"])
        player = AVPlayer(playerItem: item)
        playerView.layer.addSublayer(AVPlayerLayer(player: player))
        player.play()
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        if let duration = player.currentItem?.duration {
            let seconds = CMTimeGetSeconds(duration)
            let time = CMTime(seconds: Float64(sender.value) * seconds, preferredTimescale: duration.timescale)
            player.fl_seekSmoothlyToTime(time)
        }
    }
}

class PlayerView: UIView {
    
    override func layoutSubviews() {
        if let layers = layer.sublayers {
            for layer in layers {
                layer.frame = bounds
            }
        }
    }
}


