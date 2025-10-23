/*
 Public Swift view mounted by the Fabric `StreamsView` Objective-C++ wrapper.
 Minimal TPStreamsSDK-backed player: stores props, creates TPAVPlayer and
 TPStreamPlayerViewController, and mounts the player view.
*/
import UIKit
import TPStreamsSDK
import React

@objc(StreamsSwiftView)
public class StreamsSwiftView: UIView {
    private(set) var assetId: String?
    private(set) var accessToken: String?
    private var player: TPAVPlayer?
    private var playerViewController: TPStreamPlayerViewController?
    
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
        playerVC.config = TPStreamPlayerConfigurationBuilder()
                                .setPreferredForwardDuration(15)
                                .setPreferredRewindDuration(5)
                                .setprogressBarThumbColor(.systemRed)
                                .setwatchedProgressTrackColor(.systemRed)
                                .showDownloadOption()
                                .build()

        addSubview(playerVC.view)
        playerVC.view.frame = bounds
        playerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        player.play()
        playerViewController = playerVC
    }


    private func cleanupPlayer() {
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
