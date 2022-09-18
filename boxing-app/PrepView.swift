//
//  PrepView.swift
//  boxing-app
//
//  Created by Flack, Edward (E.) on 30/08/2022.
//

import SwiftUI
import Toaster

struct PrepView: View {
    
    var roundLengthSeconds: Int
    var roundLengthMinutes: Int
    var restTimeSeconds: Int
    var restTimeMinutes: Int
    var totalDurationInSeconds: Int
    var rounds: Int
    
    @State var prepTimeSeconds: Int = 30
    @State var prepTimeMinutes: Int = 0
    
    @State var toast: Toast = Toast(text: "initial")
    
    let minus: some View = Image(uiImage: UIImage(named: "minus")!).resizable()
        .aspectRatio(
            contentMode: .fit).frame(minWidth: 0, maxHeight: 64)
//        .padding(.leading, 30)
    let plus: some View = Image(uiImage: UIImage(named: "plus")!)
        .resizable(
        capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
    )
        .aspectRatio(contentMode: .fit).multilineTextAlignment(.leading).frame(
        minWidth: 0, maxHeight: 64)
        .padding(.trailing, 15)
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Enter Preparation Time")
                    .fontWeight(.heavy)
                    .foregroundColor(Color.red)
                    .font(.system(size: 35))
                    .padding(.bottom, 50)
            }
            HStack {
                Text(String(format: "%d:%02d", prepTimeMinutes, prepTimeSeconds))
                    .fontWeight(.heavy)
                    .font(.system(size: 35))
                    .padding(.bottom, 50)
            }
            HStack {
                Button(action: {
                    prepTimeSeconds -= 5
                    if (prepTimeSeconds < 0 && prepTimeMinutes != 0) {
                        prepTimeSeconds = 55
                        prepTimeMinutes -= 1
                    } else if (prepTimeSeconds < 5 && prepTimeMinutes == 0) {
                        prepTimeSeconds = 5
                        if self.toast.isExecuting {
                            self.toast.cancel()
                        }
                        self.toast = Toast(text: "5 Seconds Minimum", duration: Delay.short)
                        self.toast.show()
                    }
                }){
                minus
                }
                Button(action: {
                    prepTimeSeconds += 5
                    if (prepTimeSeconds == 60) {
                        prepTimeSeconds = 0
                        prepTimeMinutes += 1
                    }
                    if (prepTimeMinutes >= 30 && prepTimeSeconds > 0) {
                        prepTimeMinutes = 30
                        prepTimeSeconds = 0
                        if self.toast.isExecuting {
                            self.toast.cancel()
                        }
                        self.toast = Toast(text: "30 Minutes Maximum", duration: Delay.short)
                        self.toast.show()
                    }
                }){
                plus
                }
            }.padding(.bottom, 50)
            HStack {
                NavigationLink(destination: BoxView(roundLengthSeconds: self.roundLengthSeconds, roundLengthMinutes: self.roundLengthMinutes, restTimeSeconds: self.restTimeSeconds, restTimeMinutes: self.restTimeMinutes, totalDurationInSeconds: self.totalDurationInSeconds, rounds: self.rounds, prepTimeSeconds: self.prepTimeSeconds, prepTimeMinutes: self.prepTimeMinutes)) {
                    Image(uiImage: UIImage(named: "play")!).resizable(
                        capInsets: EdgeInsets(
                            top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
                    ).aspectRatio(contentMode: .fit).multilineTextAlignment(.leading).frame(
                        minWidth: 0, maxHeight: 75
                    ).padding(.leading, 5)
                }
            }
        }
    }
}

struct PrepView_Previews: PreviewProvider {
    static var previews: some View {
        PrepView(roundLengthSeconds: 0, roundLengthMinutes: 0, restTimeSeconds: 0, restTimeMinutes: 0, totalDurationInSeconds: 0, rounds: 0)
            .padding()
            .previewInterfaceOrientation(.portrait)
    }
}
