import SwiftUI
import AVKit
import Combine
// MARK: - MODEL
struct Reel: Identifiable {
    let id = UUID()
    let videoURL: String
    let username: String
    let caption: String
}

// MARK: - VIEWMODEL
class ReelViewModel: ObservableObject {
    @Published var reels: [Reel] = [
        Reel(
            videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            username: "user1",
            caption: "Making pasta"
        ),
        Reel(
            videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
            username: "user2",
            caption: "Enjoy Healthy Food"
        ),
        Reel(
            videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
            username: "user3",
            caption: "Food love 🍔"
        )
    ]
}

/////////////////////////////////////////////////////////////

// MARK: - REEL CELL (Single Video)
struct ReelCell: View {
    
    let reel: Reel
    
    @State private var player = AVPlayer()
    @State private var isPlaying = false
    @State private var isMuted = false
    @State private var showHeart = false
    
    var body: some View {
        ZStack {
            
            VideoPlayer(player: player)
                .ignoresSafeArea()
                .onAppear {
                    setupPlayer()
                }
                .onDisappear {
                    player.pause()
                }
                .onTapGesture(count: 2) {
                    likeAnimation()
                }
            
            // ❤️ Double Tap Animation
            if showHeart {
                Image(systemName: "heart.fill")
                    .font(.system(size: 90))
                    .foregroundColor(.white)
                    .scaleEffect(showHeart ? 1 : 0.5)
                    .animation(.easeInOut, value: showHeart)
            }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    
                    // LEFT SIDE
                    VStack(alignment: .leading, spacing: 8) {
                        Text("@\(reel.username)")
                            .foregroundColor(.white)
                            .bold()
                        
                        Text(reel.caption)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // RIGHT ACTIONS
                    VStack(spacing: 20) {
                        
                        Image(systemName: "heart")
                        Image(systemName: "message")
                        Image(systemName: "paperplane")
                        
                        Button {
                            toggleMute()
                        } label: {
                            Image(systemName: isMuted ? "speaker.slash" : "speaker.wave.2")
                        }
                    }
                    .font(.title)
                    .foregroundColor(.white)
                }
                .padding()
            }
        }
    }
    
    // MARK: - FUNCTIONS
    
    func setupPlayer() {
        guard let url = URL(string: reel.videoURL) else { return }
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.isMuted = isMuted
        player.play()
        
        // LOOP VIDEO
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
    
    func toggleMute() {
        isMuted.toggle()
        player.isMuted = isMuted
    }
    
    func likeAnimation() {
        showHeart = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showHeart = false
        }
    }
}

/////////////////////////////////////////////////////////////

// MARK: - MAIN REELS VIEW (VERTICAL SCROLL)
struct ReelsView: View {
    
    @StateObject var vm = ReelViewModel()
    
    var body: some View {
        TabView {
            ForEach(vm.reels) { reel in
                ReelCell(reel: reel)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}

/////////////////////////////////////////////////////////////

// MARK: - APP ENTRY (ONLY ONE @main!)
#Preview {
    ReelsView()
}
