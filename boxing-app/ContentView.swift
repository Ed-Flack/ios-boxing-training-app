//
//  ContentView.swift
//  boxing-app
//
//  Created by Flack, Edward (E.) on 12/03/2022.
//

import SwiftUI
import Toaster

struct ContentView: View {
    @State var roundLengthMinutes: Int
    @State var roundLengthSeconds: Int
    @State var restTimeMinutes: Int
    @State var restTimeSeconds: Int
    @State var rounds: Int
    
    @State var totalRoundLengthInSeconds: Int
    @State var totalRestTimeInSeconds: Int
    @State var totalDurationInSeconds: Int
    @State var durationMinutes: Int
    @State var durationSeconds: Int
    
    @State var toast: Toast = Toast(text: "initial")
    
    let minus: some View = Image(uiImage: UIImage(named: "minus")!).resizable().aspectRatio(
        contentMode: .fit)

    let plus: some View = Image(uiImage: UIImage(named: "plus")!).resizable(
        capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
    ).aspectRatio(contentMode: .fit).multilineTextAlignment(.leading).frame(
        minWidth: 0, maxHeight: 64
    ).padding(.trailing, 30)
    
    init() {
        _roundLengthMinutes = State(initialValue: 3)
        _roundLengthSeconds = State(initialValue: 0)
        _restTimeMinutes = State(initialValue: 1)
        _restTimeSeconds = State(initialValue: 0)
        _rounds = State(initialValue: 5)
        _totalRoundLengthInSeconds = State(initialValue: 3 * 60 + 0) // roundLengthMinutes * 60 + roundLengthSeconds
        _totalRestTimeInSeconds = State(initialValue: 1 * 60 + 0) // restTimeMinutes * 60 + restTimeSeconds
        _totalDurationInSeconds = State(initialValue: (3 * 60 + 0) * 5 + (1 * 60 + 0) * (5 - 1)) // totalRoundLengthInSeconds * rounds + totalRestTimeInSeconds * (rounds - 1)
        _durationMinutes = State(initialValue: (((3 * 60 + 0) * 5 + (1 * 60 + 0) * (5 - 1)) / 60)) // totalDurationInSeconds / 60
        _durationSeconds = State(initialValue: (((3 * 60 + 0) * 5 + (1 * 60 + 0) * (5 - 1)) % 60)) // totalDurationInSeconds % 60
    }
    
    func calculateTotalTime() {
        totalRoundLengthInSeconds = roundLengthMinutes * 60 + roundLengthSeconds
        totalRestTimeInSeconds = restTimeMinutes * 60 + restTimeSeconds
        totalDurationInSeconds = totalRoundLengthInSeconds * rounds + totalRestTimeInSeconds * (rounds - 1)
        durationMinutes = totalDurationInSeconds / 60
        durationSeconds = totalDurationInSeconds % 60
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top) {
                    Text("Flacky's Boxing App")
                        .fontWeight(.heavy)
                        //                    .multilineTextAlignment(.center)
                        //                    .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(Color.red)
                        .font(.system(size: 40))
                        .padding(.bottom, 100)

                }
                .frame(minWidth: 0, maxHeight: 1)
                HStack {
                    Text("Round Length")
                        .fontWeight(.heavy)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(Color.red)
                        .font(.system(size: 15))
                }.padding(.trailing, 290)
                HStack {
                    Image(uiImage: UIImage(named: "gloves")!).resizable(
                        capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
                    )
                    .aspectRatio(contentMode: .fit)
                    .multilineTextAlignment(.leading).frame(
                        minWidth: 0, maxHeight: .infinity)
                    Text(
                        String(format: "%d:%02d", self.roundLengthMinutes, self.roundLengthSeconds)
                    )
                    .fontWeight(.heavy)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                    Button(action: {
                        self.roundLengthSeconds -= 5
                        if self.roundLengthSeconds - 5 < 0 && self.roundLengthMinutes != 0 {
                            self.roundLengthSeconds = 55
                            self.roundLengthMinutes -= 1
                        } else if self.roundLengthSeconds < 5 && self.roundLengthMinutes == 0 {
                            self.roundLengthSeconds = 5
                            if self.toast.isExecuting {
                                self.toast.cancel()
                            }
                            self.toast = Toast(text: "5 Seconds Minimum", duration: Delay.short)
                            self.toast.show()
                        }
                        calculateTotalTime()
                    }) {
                        minus
                    }
                    Button(action: {
                        self.roundLengthSeconds += 5
                        if self.roundLengthSeconds == 60 {
                            self.roundLengthSeconds = 0
                            self.roundLengthMinutes += 1
                        }
                        if self.roundLengthMinutes >= 30 && roundLengthSeconds > 0 {
                            roundLengthMinutes = 30
                            roundLengthSeconds = 0
                            if self.toast.isExecuting {
                                self.toast.cancel()
                            }
                            self.toast = Toast(text: "30 Minutes Maximum", duration: Delay.short)
                            self.toast.show()
                        }
                        calculateTotalTime()
                    }) {
                        plus
                    }
                }.padding(.bottom, 80.0)
                HStack {
                    Text("Rest Time")
                        .fontWeight(.heavy)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(Color.red)
                        .font(.system(size: 15))
                }.padding(.trailing, 290)
                HStack {
                    Image(uiImage: UIImage(named: "time")!).resizable(
                        capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
                    ).aspectRatio(contentMode: .fit).multilineTextAlignment(.leading).frame(
                        minWidth: 0, maxHeight: 100)
                    Text(String(format: "%d:%02d", self.restTimeMinutes, self.restTimeSeconds))
                        .fontWeight(.heavy)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                    Button(action: {
                        self.restTimeSeconds -= 5
                        if self.restTimeSeconds < 0 && self.restTimeMinutes != 0 {
                            self.restTimeSeconds = 55
                            self.restTimeMinutes -= 1
                        } else if self.restTimeSeconds < 5 && self.restTimeMinutes == 0 {
                            self.restTimeSeconds = 5
                            if self.toast.isExecuting {
                                self.toast.cancel()
                            }
                            self.toast = Toast(text: "5 Seconds Minimum", duration: Delay.short)
                            self.toast.show()
                        }
                        calculateTotalTime()
                    }) {
                        minus
                    }
                    Button(action: {
                        self.restTimeSeconds += 5
                        if self.restTimeSeconds == 60 {
                            self.restTimeSeconds = 0
                            self.restTimeMinutes += 1
                        }
                        if self.restTimeMinutes >= 30 && self.restTimeSeconds > 0 {
                            self.restTimeMinutes = 30
                            self.restTimeSeconds = 0
                            if self.toast.isExecuting {
                                self.toast.cancel()
                            }
                            self.toast = Toast(text: "30 Minutes Maximum", duration: Delay.short)
                            self.toast.show()
                        }
                        calculateTotalTime()
                    }) {
                        plus
                    }
                }.padding(.bottom, 80)

                HStack {
                    Text("Rounds")
                        .fontWeight(.heavy)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(Color.red)
                        .font(.system(size: 15))
                }.padding(.trailing, 290)
                HStack {
                    Image(uiImage: UIImage(named: "round")!).resizable(
                        capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
                    ).aspectRatio(contentMode: .fit).multilineTextAlignment(.leading).frame(
                        minWidth: 0, maxHeight: 150
                    ).padding(.leading, 5)
                    Text(String(rounds))
                        .fontWeight(.heavy)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                    Button(action: {
                        self.rounds -= 1
                        if self.rounds < 1 {
                            self.rounds = 1
                            if self.toast.isExecuting {
                                self.toast.cancel()
                            }
                            self.toast = Toast(text: "1 Round Minimum", duration: Delay.short)
                            self.toast.show()
                        }
                        calculateTotalTime()
                    }) {
                        minus
                    }
                    Button(action: {
                        self.rounds += 1
                        if self.rounds > 100 {
                            self.rounds = 100
                            if self.toast.isExecuting {
                                self.toast.cancel()
                            }
                            self.toast = Toast(text: "100 Rounds Maximum", duration: Delay.short)
                            self.toast.show()
                        }
                        calculateTotalTime()
                    }) {
                        plus
                    }
                }
                HStack {
                    NavigationLink(destination: PrepView(roundLengthSeconds: self.roundLengthSeconds, roundLengthMinutes: self.roundLengthMinutes, restTimeSeconds: self.restTimeSeconds, restTimeMinutes: self.restTimeMinutes, totalDurationInSeconds: self.totalDurationInSeconds, rounds: self.rounds)) {
                        Image(uiImage: UIImage(named: "play")!).resizable(
                            capInsets: EdgeInsets(
                                top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
                        ).aspectRatio(contentMode: .fit).multilineTextAlignment(.leading).frame(
                            minWidth: 0, maxHeight: 75
                        ).padding(.leading, 5)
                    }
                    Text(String(format: "Total Time: %d:%02d", durationMinutes, durationSeconds))
                        .fontWeight(.heavy)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(Color.red)
                        .font(.system(size: 20)).padding(.leading, 124)
                }.padding(.top, 40)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .padding()
            .previewInterfaceOrientation(.portrait)
    }
}
