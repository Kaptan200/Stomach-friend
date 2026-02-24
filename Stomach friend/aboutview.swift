//
//  aboutview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack{
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    
                    // iPhone Style Container
                    ZStack(alignment: .top) {
                        
                        VStack(alignment: .leading) {
                            HStack{
                                Button(action: {dismiss()}){
                                    Image(systemName: "chevron.left")
                                }.foregroundStyle(.primary)
                                // Heading
                                Text("About")
                                    .font(.custom("Snell Roundhand", size: 36))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 10)
                            }
                            
                            Spacer()
                            
                            // About Text
                            Text("""
    Findurant is your ultimate dining companion, designed to make finding the perfect restaurant effortless. Whether you're craving local favorites or exploring new culinary experiences, Findurant helps you discover the best places to eat based on your preferences, location, and dietary needs.

    With easy-to-use features like real-time reviews, menus, and reservation options, Findurant lets you explore a wide variety of dining choices, all in one place. From casual bites to fine dining, we’ve got you covered—making every meal memorable and every decision simple.
    """)
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black.opacity(0.85))
                            .padding(.horizontal, 30)
                            
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

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

