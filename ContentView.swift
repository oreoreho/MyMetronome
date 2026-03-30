import SwiftUI

struct ContentView: View {
    @StateObject var metronome = MetronomeEngine()
    @State var bpm: Double = 120
    
    var body: some View {
        VStack(spacing: 50) {
            Text("나만의 메트로놈").font(.largeTitle)
            Text("\(Int(bpm)) BPM").font(.system(size: 60))
            
            Slider(value: $bpm, in: 60...200, step: 1)
                .padding()
            
            Button(action: {
                metronome.bpm = bpm
                metronome.isPlaying ? metronome.stop() : metronome.start()
            }) {
                Text(metronome.isPlaying ? "멈춤" : "시작")
                    .font(.title).padding().background(Color.blue).foregroundColor(.white).cornerRadius(20)
            }
        }
    }
}