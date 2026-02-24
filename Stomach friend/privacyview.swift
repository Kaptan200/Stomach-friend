//
//  privacyview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack{
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    
                    // iPhone Style Main Container
                    ZStack(alignment: .top) {
                        
                        VStack(alignment: .leading) {
                            
                      
                            HStack{
                                Button(action: { dismiss() }) {
                                    Image(systemName: "chevron.left")
                                        .bold()
                                 }
                                 .foregroundStyle(Color.primary)
                                // Heading
                                Text("Privacy")
                                    .font(.custom("Snell Roundhand", size: 36))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 10)
                            }
                            
                            Spacer()
                            
                            // Privacy Text
                            Text("""
    Your privacy is important to us. We collect only the necessary information to provide you with the best experience and keep your data secure. You can manage your preferences and review our full privacy policy anytime in the settings. If you have any questions, we’re here to help!
    """)
                            .font(.system(size: 20, weight: .regular))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .foregroundColor(.black.opacity(0.85))
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .frame(height: 750)
                    
                    Spacer()
                }
            }
        }.toolbar(.hidden)
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}

