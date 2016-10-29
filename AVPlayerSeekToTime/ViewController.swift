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
        
        let URL = Bundle.main.url(forResource: "MAH01438", withExtension: "MP4")!
        let item = AVPlayerItem(asset: AVURLAsset(url: URL), automaticallyLoadedAssetKeys: ["duration"])
        player = AVPlayer(playerItem: item)
        playerView.layer.addSublayer(AVPlayerLayer(player: player))
        player.play()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if let duration = player.currentItem?.duration {
            let seconds = CMTimeGetSeconds(duration)
            let time = CMTime(seconds: Float64(sender.value) * seconds, preferredTimescale: duration.timescale)
            player.pause()
            player.fl_seekSmoothly(to: time)
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


