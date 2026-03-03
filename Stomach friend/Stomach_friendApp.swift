//
//  Stomach_friendApp.swift
//  Stomach friend
//
//  Created by applelab03 on 2/10/26.
//

import SwiftUI
import Firebase
@main
struct Stomach_friendApp: App {
    @EnvironmentObject var auth: AuthViewModel
    init() {
            FirebaseApp.configure()
            }

            var body: some Scene {
                WindowGroup {
                    ContentView5()
                        .environmentObject(auth)
                }
            }
    
}
