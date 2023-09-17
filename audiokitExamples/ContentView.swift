//
//  ContentView.swift
//  MyAudioPlayerApp
//
//  Created by test on 4/18/23.
//

import SwiftUI
import AudioKit
import AVFoundation

class Drum:ObservableObject
{
    let engine = AudioEngine()
    var instrument = AppleSampler()
    var audioFile: AVAudioFile?
    let instrument1 = DrumInstrument( name:"kick", filename: "kick.wav")
    
    init()
    {
        engine.output = instrument
        guard let url = Bundle.main.resourceURL?.appendingPathComponent("kick.wav")
        else {
            return
        }
        
        do {
            audioFile = try AVAudioFile(forReading: url)
        }
        catch  {
            Log("Could not load: \(instrument1.filename)")
        }

    
        try? instrument.loadAudioFile(audioFile!)
        
        try! engine.start()
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let darkGray = Color(red: 125 / 255, green: 125 / 255, blue: 135 / 255)
}

struct DrumInstrument {
    let name:String
    let filename:String
}
    

struct PressedButtonStyle: ButtonStyle
{
    let touchDown: () -> Void
    func makeBody(configuration: Self.Configuration) -> some View {
       
    configuration.label
        
        .frame(width: 80, height: 80)
        .background(
            Group {
                if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 10)
                        //.fixedSize()
                        .fill(Color.offWhite)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                        .shadow(color: Color.white.opacity(0.6), radius: 2, x: -1, y: -1)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        //.fixedSize()
                        .fill(Color.offWhite)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 3, y: 3)
                        .shadow(color: Color.white.opacity(0.6), radius: 5, x: -3, y: -3)
                }
            }
        )
        .foregroundColor(.darkGray)
        .fontWeight(.bold)
        .font(.system(size: 12))
        .onChange(of: configuration.isPressed) {
            if $0 {
                touchDown()
            }
        }
    }
}

struct ContentView: View
{
    var conductor = Drum()
    
    var body: some View
    {
        ZStack {
            Color.offWhite
            HStack{
                ForEach (0..<4)
                { x in
                    Button(action:{}){
                        Text("Kick")
                    }.buttonStyle(PressedButtonStyle{ conductor.instrument.play() })
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
