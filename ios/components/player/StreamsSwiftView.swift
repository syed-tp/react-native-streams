/*
 Public Swift view mounted by the Fabric `StreamsView` Objective-C++ wrapper.
 Minimal TPStreamsSDK-backed player: stores props, creates TPAVPlayer and
 TPStreamPlayerViewController, and mounts the player view.
*/
import UIKit
import AVFoundation
import TPStreamsSDK
import React

@objc(StreamsSwiftView)
public class StreamsSwiftView: UIView {
    private static let maxOfflineLicenseDuration: TimeInterval = 15 * 24 * 60 * 60
    
    private(set) var assetId: String?
    private(set) var accessToken: String?
    private(set) var startAt: Double = 0.0
    private(set) var shouldAutoPlay: Bool = true
    private(set) var showDefaultCaptions: Bool = false
    private(set) var enableDownload: Bool = false
    private(set) var offlineLicenseExpireTime: TimeInterval = StreamsSwiftView.maxOfflineLicenseDuration
    private var player: TPAVPlayer?
    private var playerViewController: TPStreamPlayerViewController?
    private var playerStatusObserver: NSKeyValueObservation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates native view with new props from React. Missing keys are ignored.
    @objc public func updateProps(_ props: [String: Any]) {
        guard let assetId = props["assetId"] as? String,
              let accessToken = props["accessToken"] as? String else { return }

        self.assetId = assetId
        self.accessToken = accessToken
        
        if let startAt = props["startAt"] as? NSNumber {
            self.startAt = startAt.doubleValue
        }
        
        if let shouldAutoPlay = props["shouldAutoPlay"] as? Bool {
            self.shouldAutoPlay = shouldAutoPlay
        }
        
        if let showDefaultCaptions = props["showDefaultCaptions"] as? Bool {
            self.showDefaultCaptions = showDefaultCaptions
        }
        
        if let enableDownload = props["enableDownload"] as? Bool {
            self.enableDownload = enableDownload
        }
        
        if let providedDuration = props["offlineLicenseExpireTime"] as? NSNumber {
            let duration = providedDuration.doubleValue
            if duration > 0 && duration < StreamsSwiftView.maxOfflineLicenseDuration {
                self.offlineLicenseExpireTime = duration
            }
        }
        
        setupPlayer()
    }

    private func setupPlayer() {
        cleanupPlayer()
        
        guard let assetId = assetId else { return }
        player = TPStreamsDownloadManager.shared.isAssetDownloaded(assetID: assetId)
            ? createOfflinePlayer()
            : createOnlinePlayer()
        
        guard player != nil else {
            print("Failed to create player - invalid assetId or accessToken")
            return
        }
        configurePlayerView()
    }

    private func createOfflinePlayer() -> TPAVPlayer? {
        guard let assetId = assetId else { return nil }
        return TPAVPlayer(offlineAssetId: assetId) { error in
            if let error = error { print("Offline setup error: \(error.localizedDescription)") }
        }
    }

    private func createOnlinePlayer() -> TPAVPlayer? {
        guard let assetId = assetId, let accessToken = accessToken else { return nil }
        return TPAVPlayer(assetID: assetId, accessToken: accessToken) { error in
            if let error = error { print("Online setup error: \(error.localizedDescription)") }
        }
    }

    private func configurePlayerView() {
        guard let player = player else { return }

        let playerVC = TPStreamPlayerViewController()
        playerVC.player = player
        playerVC.config = createPlayerConfigBuilder().build()

        addSubview(playerVC.view)
        playerVC.view.frame = bounds
        playerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        playerViewController = playerVC
        
        setupSeekObserver()
        
        if shouldAutoPlay {
            player.play()
        }
    }
    
    private func setupSeekObserver() {
        guard let player = player, startAt > 0 else { return }
        
        if player.status == .readyToPlay {
            performSeek(to: startAt)
            return
        }
        
        playerStatusObserver = player.observe(\.status, options: [.new]) { [weak self] player, _ in
            guard let self = self, player.status == .readyToPlay else { return }
            self.performSeek(to: self.startAt)
            self.playerStatusObserver?.invalidate()
            self.playerStatusObserver = nil
        }
    }
    
    private func performSeek(to position: Double) {
        guard let player = player else { return }
        
        let startTime = CMTime(seconds: position, preferredTimescale: 600)
        player.seek(to: startTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    private func createPlayerConfigBuilder() -> TPStreamPlayerConfigurationBuilder {
            let configBuilder = TPStreamPlayerConfigurationBuilder()
            .setPreferredForwardDuration(15)
            .setPreferredRewindDuration(5)
            .setprogressBarThumbColor(.systemBlue)
            .setwatchedProgressTrackColor(.systemBlue)
            .setLicenseDurationSeconds(offlineLicenseExpireTime)
        
        if enableDownload {
            configBuilder.showDownloadOption()
        }
        
        return configBuilder
    }


    private func cleanupPlayer() {
        playerStatusObserver?.invalidate()
        playerStatusObserver = nil
        playerViewController?.view.removeFromSuperview()
        playerViewController?.removeFromParent()
        playerViewController = nil
        player?.pause()
        player = nil
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        playerViewController?.view.frame = bounds
    }
}
