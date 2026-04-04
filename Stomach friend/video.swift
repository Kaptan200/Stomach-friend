import SwiftUI
import Combine
import AVKit
import StoreKit
import AVFoundation

// MARK: - MODEL
struct RecipeVideo: Identifiable {
    let id = UUID()
    let title: String
    let videoName: String   // 👈 local file name (NO .mp4)
    let audioName: String?
    let isPremium: Bool
}

// MARK: - SUBSCRIPTION MANAGER
@MainActor
class SubscriptionManager: ObservableObject {
    
    @Published var isSubscribed: Bool = false
    @Published var products: [Product] = []
    
    private let productID = "com.yourapp.premium.monthly"
    
    init() {
        Task {
            await loadProducts()
            await checkSubscription()
        }
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: [productID])
        } catch {
            print("Error:", error)
        }
    }
    
    func purchase() async {
        guard let product = products.first else { return }
        
        do {
            let result = try await product.purchase()
            
            if case .success(let verification) = result {
                if case .verified(_) = verification {
                    isSubscribed = true
                }
            }
        } catch {
            print("Purchase failed")
        }
    }
    
    func checkSubscription() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == productID {
                    isSubscribed = true
                    return
                }
            }
        }
        isSubscribed = false
    }
}

// MARK: - AUDIO MANAGER (LOCAL AUDIO)
class AudioManager {
    
    static let shared = AudioManager()
    private var player: AVAudioPlayer?
    
    func playAudio(name: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("Audio error")
            }
        }
    }
    
    func stopAudio() {
        player?.stop()
    }
}

// MARK: - VIDEO PLAYER (LOCAL VIDEO)
struct VideoPlayerView: View {
    
    let videoName: String
    let audioName: String?
    
    @State private var player = AVPlayer()
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .onAppear {
                    // 🎥 Load LOCAL video
                    if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                        player = AVPlayer(url: url)
                        player.play()
                    } else {
                        print("Video not found")
                    }
                    
                    // 🎧 Play LOCAL audio
                    if let audio = audioName {
                        AudioManager.shared.playAudio(name: audio)
                    }
                }
                .onDisappear {
                    player.pause()
                    AudioManager.shared.stopAudio()
                }
        }
        .navigationTitle("Cooking Video")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - LOCKED VIEW
struct LockedView: View {
    
    var subscribeAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(systemName: "lock.fill")
                .font(.largeTitle)
            
            Text("Premium Recipe")
                .font(.title2)
                .bold()
            
            Text("Subscribe to unlock this recipe video")
                .multilineTextAlignment(.center)
            
            Button("Subscribe Now") {
                subscribeAction()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
    }
}

// MARK: - MAIN VIEW
struct RecipesView: View {
    
    @StateObject var subManager = SubscriptionManager()
    
    // 🎥 LOCAL VIDEOS
    let videos: [RecipeVideo] = [
        RecipeVideo(
            title: "Paneer Butter Masala",
            videoName: "paneer",   // 👈 paneer.mp4 in Xcode
            audioName: nil,
            isPremium: true
        ),
        RecipeVideo(
            title: "Masala Dosa",
            videoName: "dosa",     // 👈 dosa.mp4 in Xcode
            audioName: nil,
            isPremium: false
        ),
        RecipeVideo(
        title: "Pakode",
        videoName: "PAKODE",     // 👈 dosa.mp4 in Xcode
        audioName: nil,
        isPremium: false
        )
    ]
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // 🎨 FULL PAGE GRADIENT
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .pink.opacity(0.6)]),
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // 📋 YOUR LIST
                List(videos) { video in
                    
                    NavigationLink {
                        
                        if video.isPremium && !subManager.isSubscribed {
                            LockedView {
                                Task {
                                    await subManager.purchase()
                                }
                            }
                        } else {
                            VideoPlayerView(
                                videoName: video.videoName,
                                audioName: video.audioName
                            )
                        }
                        
                    } label: {
                        HStack {
                            Text(video.title)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            if video.isPremium {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
//                    .listRowBackground(Color.clear) // 🔥 make rows transparent
                }
                .scrollContentBackground(.hidden) // 🔥 remove white background
                .background(Color.clear)
                .navigationTitle("Recipes")
            }
        }
    }
    }


#Preview {
    RecipesView()
}

