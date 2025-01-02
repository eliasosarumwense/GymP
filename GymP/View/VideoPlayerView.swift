//
//  VideoPlayerView.swift
//  GymP
//
//  Created by Elias Osarumwense on 14.08.24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        return VideoPlayerUIView(player: player)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view if needed
    }
}

class VideoPlayerUIView: UIView {
    private var playerLayer: AVPlayerLayer?

    init(player: AVPlayer) {
        super.init(frame: .zero)
        self.playerLayer = AVPlayerLayer(player: player)
        if let playerLayer = self.playerLayer {
            playerLayer.videoGravity = .resizeAspect
            layer.addSublayer(playerLayer)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}
