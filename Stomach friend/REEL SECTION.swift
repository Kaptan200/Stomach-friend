//import SwiftUI
//import AVKit
//import Combine
//// MARK: - MODEL
//struct Reel: Identifiable {
//    let id = UUID()
//    let videoURL: String
//    let username: String
//    let caption: String
//}
//
//// MARK: - VIEWMODEL
//class ReelViewModel: ObservableObject {
//    @Published var reels: [Reel] = [
//        Reel(
//            videoURL: "https://samplelib.com/lib/preview/mp4/sample-5s.mp4",
//            username: "user1",
//            caption: "Making pasta"
//        ),
//        Reel(
//            videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
//            username: "user2",
//            caption: "Enjoy Healthy Food"
//        ),
//        Reel(
//            videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
//            username: "user3",
//            caption: "Food love 🍔"
//        )
//    ]
//}
//
///////////////////////////////////////////////////////////////
//
//// MARK: - REEL CELL (Single Video)
//struct ReelCell: View {
//    
//    let reel: Reel
//    
//    @State private var player = AVPlayer()
//    @State private var isPlaying = false
//    @State private var isMuted = false
//    @State private var showHeart = false
//    
//    var body: some View {
//        ZStack {
//            
//            VideoPlayer(player: player)
//                .ignoresSafeArea()
//                .onAppear {
//                    setupPlayer()
//                }
//                .onDisappear {
//                    player.pause()
//                }
//                .onTapGesture(count: 2) {
//                    likeAnimation()
//                }
//            
//            // ❤️ Double Tap Animation
//            if showHeart {
//                Image(systemName: "heart.fill")
//                    .font(.system(size: 90))
//                    .foregroundColor(.white)
//                    .scaleEffect(showHeart ? 1 : 0.5)
//                    .animation(.easeInOut, value: showHeart)
//            }
//            
//            VStack {
//                Spacer()
//                
//                HStack(alignment: .bottom) {
//                    
//                    // LEFT SIDE
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("@\(reel.username)")
//                            .foregroundColor(.white)
//                            .bold()
//                        
//                        Text(reel.caption)
//                            .foregroundColor(.white)
//                    }
//                    
//                    Spacer()
//                    
//                    // RIGHT ACTIONS
//                    VStack(spacing: 20) {
//                        
//                        Image(systemName: "heart")
//                        Image(systemName: "message")
//                        Image(systemName: "paperplane")
//                        
//                        Button {
//                            toggleMute()
//                        } label: {
//                            Image(systemName: isMuted ? "speaker.slash" : "speaker.wave.2")
//                        }
//                    }
//                    .font(.title)
//                    .foregroundColor(.white)
//                }
//                .padding()
//            }
//        }
//    }
//    
//    // MARK: - FUNCTIONS
//    
//    func setupPlayer() {
//        guard let url = URL(string: reel.videoURL) else { return }
//        
//        let item = AVPlayerItem(url: url)
//        player.replaceCurrentItem(with: item)
//        player.isMuted = isMuted
//        player.play()
//        
//        // LOOP VIDEO
//        NotificationCenter.default.addObserver(
//            forName: .AVPlayerItemDidPlayToEndTime,
//            object: item,
//            queue: .main
//        ) { _ in
//            player.seek(to: .zero)
//            player.play()
//        }
//    }
//    
//    func toggleMute() {
//        isMuted.toggle()
//        player.isMuted = isMuted
//    }
//    
//    func likeAnimation() {
//        showHeart = true
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//            showHeart = false
//        }
//    }
//}
//
///////////////////////////////////////////////////////////////
//
//// MARK: - MAIN REELS VIEW (VERTICAL SCROLL)
//struct ReelsView: View {
//    
//    @StateObject var vm = ReelViewModel()
//    
//    var body: some View {
//        TabView {
//            ForEach(vm.reels) { reel in
//                ReelCell(reel: reel)
//            }
//        }
//        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//        .ignoresSafeArea()
//    }
//}
//
///////////////////////////////////////////////////////////////
//
//// MARK: - APP ENTRY (ONLY ONE @main!)
//#Preview {
//    ReelsView()
//}
import SwiftUI
import Combine
import AVKit
import PhotosUI

// MARK: - MODEL
struct Reel: Identifiable {
    let id = UUID()
    let videoName: String
    let username: String
    let caption: String
    var likes: Int
}

// MARK: - VIEWMODEL
class ReelViewModel: ObservableObject {
    
    @Published var reels: [Reel] = [
        Reel(videoName: "burger", username: "Burger King", caption: "Food 🍔", likes: 25),
        Reel(videoName: "timer", username: "user1", caption: "Cooking 🔥", likes: 10),
        Reel(videoName: "dosa", username: "South Indian", caption: "Eating🔥", likes: 25)
    ]
    
    func addReel(videoName: String) {
        let newReel = Reel(videoName: videoName, username: "You", caption: "New Reel 🎥", likes: 0)
        reels.insert(newReel, at: 0)
    }
}

// MARK: - REEL CELL
struct ReelCell: View {
    
    let reel: Reel
    @Binding var reels: [Reel]
    
    @State private var player = AVPlayer()
    @State private var isMuted = false
    @State private var showHeart = false
    @State private var showComments = false
    
    var body: some View {
        ZStack {
            
            VideoPlayer(player: player)
                .ignoresSafeArea()
                .onAppear { setupPlayer() }
                .onDisappear {
                    player.pause()
                    NotificationCenter.default.removeObserver(self)
                }
                .onTapGesture(count: 2) {
                    like()
                }
            
            // ❤️ Animation
            if showHeart {
                Image(systemName: "heart.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .transition(.scale)
            }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    
                    // LEFT
                    VStack(alignment: .leading) {
                        Text("@\(reel.username)")
                            .foregroundColor(.white)
                            .bold()
                        Text(reel.caption)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // RIGHT ACTIONS
                    VStack(spacing: 20) {
                        
                        // ❤️ LIKE
                        Button {
                            like()
                        } label: {
                            VStack {
                                Image(systemName: "heart.fill")
                                Text("\(reel.likes)")
                            }
                        }
                        
                        // 💬 COMMENTS
                        Button {
                            showComments = true
                        } label: {
                            Image(systemName: "message")
                        }
                        .sheet(isPresented: $showComments) {
                            CommentsView()
                        }
                        
                        // 🔗 SHARE
                        Button {
                            share()
                        } label: {
                            Image(systemName: "paperplane")
                        }
                        
                        // 🔇 MUTE
                        Button {
                            isMuted.toggle()
                            player.isMuted = isMuted
                        } label: {
                            Image(systemName: isMuted ? "speaker.slash" : "speaker.wave.2")
                        }
                    }
                    .foregroundColor(.white)
                    .font(.title)
                }
                .padding()
            }
        }
    }
    
    // MARK: - FUNCTIONS
    
    func setupPlayer() {
        guard let path = Bundle.main.path(forResource: reel.videoName, ofType: "mp4") else { return }
        let url = URL(fileURLWithPath: path)
        let item = AVPlayerItem(url: url)
        
        player.replaceCurrentItem(with: item)
        player.isMuted = isMuted
        player.play()
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
    
    func like() {
        showHeart = true
        
        if let index = reels.firstIndex(where: { $0.id == reel.id }) {
            reels[index].likes += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showHeart = false
        }
    }
    
    func share() {
        let activity = UIActivityViewController(
            activityItems: ["Check out this reel!"],
            applicationActivities: nil
        )
        
        UIApplication.shared.windows.first?.rootViewController?
            .present(activity, animated: true)
    }
}

// MARK: - COMMENTS VIEW
struct CommentsView: View {
    
    @State private var comment = ""
    @State private var comments: [String] = ["Nice 🔥", "Awesome 👏"]
    
    var body: some View {
        VStack {
            
            List(comments, id: \.self) {
                Text($0)
                    .foregroundColor(Color.black)
            }
            
            HStack {
                TextField("Add comment...", text: $comment)
                    .foregroundColor(Color.black)
                
                Button("Send") {
                    if !comment.isEmpty {
                        comments.append(comment)
                        comment = ""
                    }
                }  .foregroundColor(Color.blue)
            }
            .padding()
        }
    }
}

// MARK: - REELS VIEW
struct ReelsView: View {
    
    @StateObject var vm = ReelViewModel()
    @State private var showPicker = false
    
    var body: some View {
        ZStack {
            
            TabView {
                ForEach(vm.reels) { reel in
                    ReelCell(reel: reel, reels: $vm.reels)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            
//            // ➕ UPLOAD BUTTON
//            VStack {
//                Spacer()
//                
//                HStack {
//                    Spacer()
//                    
//                    Button {
//                        showPicker = true
//                    } label: {
//                        Image(systemName: "plus.circle.fill")
//                            .font(.largeTitle)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                }
//            }
        }
        .sheet(isPresented: $showPicker) {
            VideoPicker { name in
                vm.addReel(videoName: name)
            }
        }
    }
}

// MARK: - VIDEO PICKER (SIMPLIFIED)
struct VideoPicker: View {
    
    var onPick: (String) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Select Demo Video")
            
            Button("Add reel1.mp4") {
                onPick("reel1")
            }
            
            Button("Add reel2.mp4") {
                onPick("reel2")
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ReelsView()
}
