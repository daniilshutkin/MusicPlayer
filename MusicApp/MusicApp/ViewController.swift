//
//  ViewController.swift
//  MusicApp
//
//  Created by Daniil Shutkin on 12.07.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    public var position: Int = 0
    public var songs = ["One", "Two"]
    
    let forwardButton = UIButton()
    let backwardButton = UIButton()
    let playButton = UIButton()
    var trackSlider = UISlider()
    var volumeSlider = UISlider()
    var player = AVAudioPlayer()
    var timePlayback = 0.0
    private var shouldPlay: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.volumeSlider.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
        self.trackSlider.addTarget(self, action: #selector(chengeSlider), for: .valueChanged)
        
        songPlay()
        configureButton()
        addButtonConstraints()
    }
    
    @objc func chengeSlider(sender:UISlider) {
            self.player.currentTime = TimeInterval(sender.value)
    }
    
    func cucleSong() {
        
    }
    
    func songPlay() {
        do {
            if let audioPath = Bundle.main.path(forResource: songs[position], ofType: "mp3"){
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            }
        } catch {
            print("Error")
        }
    }
    
    func addButtonAndSlider(){
        view.addSubview(forwardButton)
        view.addSubview(backwardButton)
        view.addSubview(playButton)
        view.addSubview(trackSlider)
        view.addSubview(volumeSlider)
    }
    
    func configureButton() {
        addButtonAndSlider()
        volumeSlider.value = 0.5
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
        volumeSlider.addTarget(self, action: #selector(sliderAction(sender:)), for: .valueChanged)
        volumeSlider.isContinuous = false//change when the button is released
        volumeSlider.minimumTrackTintColor = .systemBlue
        volumeSlider.maximumTrackTintColor = .lightGray
        volumeSlider.thumbTintColor = .systemGray3
        
        trackSlider.minimumValue = 0
        trackSlider.maximumValue = 10
        trackSlider.addTarget(self, action: #selector(sliderAction(sender:)), for: .valueChanged)
        trackSlider.isContinuous = false//change when the button is released
        trackSlider.minimumTrackTintColor = .systemBlue
        trackSlider.maximumTrackTintColor = .lightGray
        trackSlider.thumbTintColor = .systemGray3
        
        forwardButton.setTitle(">", for: .normal)
        forwardButton.backgroundColor = .lightGray
        forwardButton.setTitleColor(.systemBlue, for: .normal)
        forwardButton.layer.cornerRadius = 5
        forwardButton.addTarget(self, action: #selector(forward), for: .touchUpInside)
        
        backwardButton.setTitle("<", for: .normal)
        backwardButton.backgroundColor = .lightGray
        backwardButton.setTitleColor(.systemBlue, for: .normal)
        backwardButton.layer.cornerRadius = 5
        backwardButton.addTarget(self, action: #selector(backward), for: .touchUpInside)
        
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = .lightGray
        playButton.setTitleColor(.systemBlue, for: .normal)
        playButton.layer.cornerRadius = 5
        playButton.addTarget(self, action: #selector(playback), for: .touchUpInside)
    }
    
    @objc func sliderAction(sender: UISlider) {
        self.trackSlider.maximumValue = Float(player.duration)
        playButton.addTarget(self, action: #selector(playback), for: .touchUpInside)
//        player.seek(to: CMTime(seconds: Double(trackSlider.value), preferredTimescale: 1000))
        timePlayback = Double(self.trackSlider.value)
        playButton.setTitle("Stop", for: .normal)
    }
    
    @objc func playback(sender: UIButton) {
        shouldPlay = !shouldPlay
        if shouldPlay {
            playButton.setTitle("Stop", for: .normal)
            self.player.play()
            forwardButton.isEnabled = true
            backwardButton.isEnabled = true
        } else {
            playButton.setTitle("Play", for: .normal)
            self.player.stop()
        }
    }
    
    @objc func backward(sender: UIButton) {
        if position > 0 {
            position = position - 1
            songPlay()
        } else {
            songPlay()
        }
    }
    
    @objc func forward(sender: UIButton) {
        if songs.count > position + 1{
            position = position + 1
            songPlay()
        } else {
            songPlay()
        }
    }
    
    @objc func volumeChanged(sender: UISlider) {
        player.volume = volumeSlider.value
    }
    
    func addButtonConstraints() {
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        trackSlider.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70),
            trackSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70),
            
            volumeSlider.topAnchor.constraint(equalTo: trackSlider.topAnchor, constant: -50),
            volumeSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70),
            volumeSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70),
            
            backwardButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70),
            backwardButton.topAnchor.constraint(equalTo: trackSlider.topAnchor, constant: 40),
            backwardButton.widthAnchor.constraint(equalToConstant: 40),
            backwardButton.heightAnchor.constraint(equalToConstant: 40),
            
            forwardButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70),
            forwardButton.topAnchor.constraint(equalTo: trackSlider.topAnchor, constant: 40),
            forwardButton.widthAnchor.constraint(equalToConstant: 40),
            forwardButton.heightAnchor.constraint(equalToConstant: 40),
            
            playButton.leftAnchor.constraint(equalTo: backwardButton.leftAnchor, constant: 45),
            playButton.rightAnchor.constraint(equalTo: forwardButton.rightAnchor, constant: -45),
            playButton.topAnchor.constraint(equalTo: trackSlider.topAnchor, constant: 40),
            playButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
    }
}

