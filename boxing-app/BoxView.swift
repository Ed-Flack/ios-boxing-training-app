//
//  BoxView.swift
//  boxing-app
//
//  Created by Flack, Edward (E.) on 10/09/2022.
//

import SwiftUI
import AVFoundation

struct BoxView: View {
    
    let roundLengthSeconds: Int
    let roundLengthMinutes: Int
    let restTimeSeconds: Int
    let restTimeMinutes: Int
    
    @State var totalDurationInSeconds: Int
    @State var rounds: Int
    @State var prepTimeSeconds: Int
    @State var prepTimeMinutes: Int
    
    @State var roundLengthSecondsState: Int
    @State var roundLengthMinutesState: Int
    @State var restTimeSecondsState: Int
    @State var restTimeMinutesState: Int
    
    @State var title: String
    @State var isPrepTime: Bool
    @State var box: Bool
    @State var roundNumber: Int
    @State var timerText: String
    @State var roundUpdated: Bool
    
    @State var player: AVAudioPlayer!

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func playSound(sound: String) {
        let url = Bundle.main.url(forResource: sound, withExtension: ".mp3")
        guard url != nil else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        } catch {
            print(error)
        }
    }
    
    init(roundLengthSeconds: Int, roundLengthMinutes: Int, restTimeSeconds: Int, restTimeMinutes: Int, totalDurationInSeconds: Int, rounds: Int, prepTimeSeconds: Int, prepTimeMinutes: Int) {
        self.roundLengthSeconds = roundLengthSeconds
        self.roundLengthMinutes = roundLengthMinutes
        self.restTimeSeconds = restTimeSeconds
        self.restTimeMinutes = restTimeMinutes
        _totalDurationInSeconds = State(initialValue: totalDurationInSeconds)
        _rounds = State(initialValue: rounds)
        _prepTimeSeconds = State(initialValue: prepTimeSeconds)
        _prepTimeMinutes = State(initialValue: prepTimeMinutes)
        _roundLengthSecondsState = State(initialValue: roundLengthSeconds)
        _roundLengthMinutesState = State(initialValue: roundLengthMinutes)
        _restTimeSecondsState = State(initialValue: restTimeSeconds)
        _restTimeMinutesState = State(initialValue: restTimeMinutes)
        _title = State(initialValue: "Prepare")
        _isPrepTime = State(initialValue: true)
        _box = State(initialValue: false)
        _roundNumber = State(initialValue: 1)
        _timerText = State(initialValue: String(format: "%d:%02d", prepTimeMinutes, prepTimeSeconds))
        _roundUpdated = State(initialValue: false)
    }
    
    var body: some View {
    VStack {
            HStack(alignment: .top) {
                Text(title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.red)
                    .font(.system(size: 35))
                    .padding(.bottom, 50)
            }
        HStack(alignment: .center) {
                Text(timerText)
                    .fontWeight(.heavy)
                    .font(.system(size: 35))
                    .padding(.bottom, 50)
                    .onReceive(timer) { _ in
                        if (isPrepTime) {
                            timerText = String(format: "%d:%02d", prepTimeMinutes, prepTimeSeconds)
                            if (prepTimeMinutes <= 0 && prepTimeSeconds <= 5) {
                                playSound(sound: "beep")
                            }
                            if (prepTimeMinutes <= 0 && prepTimeSeconds <= 0) {
                                playSound(sound: "single_bell")
                                isPrepTime = false
                                box = true
                            }
                            prepTimeSeconds -= 1
                            if (prepTimeSeconds < 0) {
                                prepTimeMinutes -= 1
                                prepTimeSeconds = 59
                            }
                            if (prepTimeMinutes <= 0) {
                                prepTimeMinutes = 0
                            }
                        } else if (box) {
                            title = String(format: "Round %d", roundNumber)
                            timerText = String(format: "%d:%02d", roundLengthMinutesState, roundLengthSecondsState)
                            if (roundLengthMinutesState <= 0 && roundLengthSecondsState <= 5) {
                                playSound(sound: "beep")
                            }
                            if (roundLengthMinutesState <= 0 && roundLengthSecondsState <= 0) {
                                playSound(sound: "bell")
                                box = false
                                roundLengthSecondsState = roundLengthSeconds
                                roundLengthMinutesState = roundLengthMinutes
                                if (!roundUpdated) {
                                    rounds -= 1
                                    roundNumber += 1
                                    roundUpdated = true
                                }
                            }
                            roundLengthSecondsState -= 1
                            if (roundLengthSecondsState < 0) {
                                roundLengthMinutesState -= 1
                                roundLengthSecondsState = 59
                            }
                            if (roundLengthMinutesState <= 0) {
                                roundLengthMinutesState = 0
                            }
                        } else {
                            if (rounds > 0) {
                                title = "Rest"
                                timerText = String(format: "%d:%02d", restTimeMinutesState, restTimeSecondsState)
                                if (restTimeMinutesState <= 0 && restTimeSecondsState <= 5) {
                                    playSound(sound: "beep")
                                }
                                if (restTimeMinutesState <= 0 && restTimeSecondsState <= 0) {
                                    playSound(sound: "single_bell")
                                    box = true
                                    restTimeSecondsState = restTimeSeconds
                                    restTimeMinutesState = restTimeMinutes
                                }
                                restTimeSecondsState -= 1
                                if (restTimeSecondsState < 0) {
                                    restTimeMinutesState -= 1
                                    restTimeSecondsState = 59
                                }
                                if (restTimeMinutesState <= 0) {
                                    restTimeMinutesState = 0
                                }
                                roundUpdated = false
                            } else {
                                title = "Finished"
                                timerText = "Good Job!"
                            }
                        }
                    }
            }
        }
    }
}

struct BoxView_Previews: PreviewProvider {
    static var previews: some View {
        BoxView(roundLengthSeconds: 0, roundLengthMinutes: 0, restTimeSeconds: 0, restTimeMinutes: 0, totalDurationInSeconds: 0, rounds: 0, prepTimeSeconds: 0, prepTimeMinutes: 0)
            .padding()
            .previewInterfaceOrientation(.portrait)
    }
}
