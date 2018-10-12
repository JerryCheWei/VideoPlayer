//
//  ViewController.swift
//  VideoPlayer
//
//  Created by chang-che-wei on 2018/10/9.
//  Copyright © 2018 chang-che-wei. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {

    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isVideoPlaying = false
    var isMuteSound = false
    var enterUrl = ""
    // url: http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 8/255, green: 21/255, blue: 35/255, alpha: 1)

        urlTextField.delegate = self
        self.setAutoLayout()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        playerLayer?.frame = self.playerView.bounds

    }

    func setupPlayerView(url: String) {
        if let url = URL(string: url) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspect

            if let playerLayer = playerLayer {

                self.playerView.layer.addSublayer(playerLayer)
                player?.play()
                player?.addObserver(self, forKeyPath: "playerIsPlaying", options: [.initial], context: nil)
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "playerIsPlaying" {
            playButton.setTitle("Pause", for: .normal)
            isVideoPlaying = true
        }
        if keyPath == "enterUrl" {
            self.setupPlayerView(url: enterUrl)
        }
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.rotated()
    }

    func rotated() {
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            topAnchor?.constant = 0

            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {

                self.view.layoutIfNeeded()

            }, completion: nil)
        }

        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            topAnchor?.constant -= 80

            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {

                self.view.layoutIfNeeded()

            }, completion: nil)
        }
    }

    var topAnchor: NSLayoutConstraint?

    func setAutoLayout() {
        urlBarView.addSubview(urlTextField)
        barView.addSubview(playButton)
        barView.addSubview(muteButton)
        self.view.addSubview(urlBarView)
        self.view.addSubview(barView)
        self.view.addSubview(playerView)

        topAnchor = urlBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        topAnchor?.isActive = true
        urlBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        urlBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        urlBarView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        urlTextField.centerYAnchor.constraint(equalTo: urlBarView.centerYAnchor).isActive = true
        urlTextField.leadingAnchor.constraint(equalTo: urlBarView.leadingAnchor, constant: 8).isActive = true
        urlTextField.trailingAnchor.constraint(equalTo: urlBarView.trailingAnchor, constant: -8).isActive = true
        urlTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true

        barView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        barView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        barView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        barView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        playButton.centerYAnchor.constraint(equalTo: barView.centerYAnchor).isActive = true
        playButton.leadingAnchor.constraint(equalTo: barView.leadingAnchor, constant: 20).isActive = true

        muteButton.centerYAnchor.constraint(equalTo: barView.centerYAnchor).isActive = true
        muteButton.trailingAnchor.constraint(equalTo: barView.trailingAnchor, constant: -20).isActive = true

        playerView.topAnchor.constraint(equalTo: urlBarView.bottomAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: barView.topAnchor).isActive = true

    }

    let playerView: UIView = {
        var playerView = UIView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()

    let urlBarView: UIView = {

        var urlBarView = UIView()

        urlBarView.translatesAutoresizingMaskIntoConstraints = false
        urlBarView.backgroundColor = UIColor.init(red: 8/255, green: 21/255, blue: 35/255, alpha: 1)

        return urlBarView
    }()

    let urlTextField: UITextField = {

        var urlTextField = UITextField()

        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        urlTextField.backgroundColor = .white
        urlTextField.layer.cornerRadius = 5
        urlTextField.placeholder = "Enter URL of video"
        urlTextField.textAlignment = .center
        urlTextField.clearButtonMode = .whileEditing
        return urlTextField
    }()

    let barView: UIView = {

        var barView = UIView()

        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        return barView
    }()

    let playButton: UIButton = {
        var playButton = UIButton()

        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Play", for: .normal)
        playButton.tintColor = .white
        playButton.isEnabled = true
        playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        return playButton
    }()

    let muteButton: UIButton = {
        var muteButton = UIButton()

        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.setTitle("Mute", for: .normal)
        muteButton.tintColor = .white
        muteButton.isEnabled = true
        muteButton.addTarget(self, action: #selector(muteAction), for: .touchUpInside)
        return muteButton
    }()

    @objc func playAction(sender: UIButton) {

        if isVideoPlaying {
            player?.pause()
            sender.setTitle("Play", for: .normal)
            isVideoPlaying = false
        }
        else {
            player?.play()
            sender.setTitle("Pause", for: .normal)
            isVideoPlaying = true
            print("Play")
        }
    }
    @objc func muteAction(sender: UIButton) {

        if isMuteSound {
            player?.isMuted = false
            isMuteSound = false
            sender.setTitle("Mute", for: .normal)
        }
        else {
            player?.isMuted = true
            isMuteSound = true
            sender.setTitle("UnMute", for: .normal)
            print("Mute")
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = urlTextField.text {
            self.enterUrl = text
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.addObserver(self, forKeyPath: "enterUrl", options: [.initial], context: nil)
        return true
    }
}
