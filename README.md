拖动进度条实时流畅预览视频，类似于 iOS 照片应用播放视频时的拖动效果。
解决直接调用 `seekToTime` 时的卡顿现象。

```swift
func sliderValueChanged(sender: UISlider) {
    if let duration = player.currentItem?.duration {
        let seconds = CMTimeGetSeconds(duration)
        let time = CMTime(seconds: Float64(sender.value) * seconds, preferredTimescale: duration.timescale)
        player.fl_seekSmoothlyToTime(time)
    }
}
```

## Reference
https://developer.apple.com/library/ios/qa/qa1820/_index.html