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
    var isVideoPlaying = true
    var isMuteSound = false
    var enterUrl = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
    // url: http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 8/255, green: 21/255, blue: 35/255, alpha: 1)

        self.setAutoLayout()
        self.setupPlayerView(url: enterUrl)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        playerLayer?.frame = self.view.bounds

    }

    func setupPlayerView(url: String) {
        if let url = URL(string: url) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspect

            if let playerLayer = playerLayer {

                self.view.layer.addSublayer(playerLayer)
                player?.play()
            }
        }
    }

    func setAutoLayout() {
        urlBarView.addSubview(urlTextField)
        barView.addSubview(playButton)
        barView.addSubview(muteButton)
        self.view.addSubview(urlBarView)
        self.view.addSubview(barView)

        var constraints = [NSLayoutConstraint]()

        constraints.append(urlBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor))
        constraints.append(urlBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(urlBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(urlBarView.heightAnchor.constraint(equalToConstant: 60))

        constraints.append(urlTextField.centerYAnchor.constraint(equalTo: urlBarView.centerYAnchor))
        constraints.append(urlTextField.leadingAnchor.constraint(equalTo: urlBarView.leadingAnchor, constant: 8))
        constraints.append(urlTextField.trailingAnchor.constraint(equalTo: urlBarView.trailingAnchor, constant: -8))
        constraints.append(urlTextField.heightAnchor.constraint(equalToConstant: 30))

        constraints.append(barView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(barView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(barView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(barView.heightAnchor.constraint(equalToConstant: 60))

        constraints.append(playButton.centerYAnchor.constraint(equalTo: barView.centerYAnchor))
        constraints.append(playButton.leadingAnchor.constraint(equalTo: barView.leadingAnchor, constant: 20))

        constraints.append(muteButton.centerYAnchor.constraint(equalTo: barView.centerYAnchor))
        constraints.append(muteButton.trailingAnchor.constraint(equalTo: barView.trailingAnchor, constant: -20))

        NSLayoutConstraint.activate(constraints)
    }

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
        if let text = textField.text {
             self.enterUrl = text
        }
    }
}
