import Foundation
import AVFoundation

class MetronomeEngine: ObservableObject {
    private var engine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?
    private var timer: Timer?
    
    var bpm: Double = 120
    var isPlaying = false
    
    init() {
        // 1. "다른 앱 소리랑 내 소리를 합쳐줘!" 설정
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try? session.setActive(true)
        
        // 2. '딱' 소리 파일 불러오기
        if let url = Bundle.main.url(forResource: "click", withExtension: "wav") {
            audioFile = try? AVAudioFile(forReading: url)
            engine.attach(playerNode)
            engine.connect(playerNode, to: engine.mainMixerNode, format: audioFile?.processingFormat)
            try? engine.start()
        }
    }
    
    func start() {
        isPlaying = true
        nextTick()
    }
    
    func stop() {
        isPlaying = false
        timer?.invalidate()
        playerNode.stop()
    }
    
    private func nextTick() {
        guard isPlaying, let file = audioFile else { return }
        playerNode.scheduleFile(file, at: nil, completionHandler: nil)
        if !playerNode.isPlaying { playerNode.play() }
        
        let speed = 60.0 / bpm
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: false) { _ in
            self.nextTick()
        }
    }
}