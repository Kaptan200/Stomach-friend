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
   
    init() {
            FirebaseApp.configure()
            }

            var body: some Scene {
                WindowGroup {
                    ContentView5()
                      
                }
            }
    
}
