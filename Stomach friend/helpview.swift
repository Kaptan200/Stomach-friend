//
//  helpview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var problemText: String = ""
    
    var body: some View {
      NavigationStack {
          ZStack {
              Color(.systemGray6)
                  .ignoresSafeArea()
              
              VStack {
                  

                  
                  Spacer()
                  
      
                  ZStack(alignment: .top) {
                      

                      
                      VStack(alignment: .leading) {
                          
      
                          HStack{
                              Button(action: {dismiss()}) {
                                  Image(systemName: "chevron.left")
                                      
                              }.foregroundStyle(.primary)
                              // Heading
                              Text("Help & Support")
                                  .font(.custom("Snell Roundhand", size: 34))
                                  .frame(maxWidth: .infinity, alignment: .center)
                                  .padding(.vertical, 10)
                          }
                          
                          Spacer()
                          
                          // Text Area
                          ZStack(alignment: .center) {
                              
                              RoundedRectangle(cornerRadius: 5)
                                  .stroke(Color.gray.opacity(0.7), lineWidth: 1.5)
                                  .frame(height: 180)
                              
                              if problemText.isEmpty {
                                  Text("Type your Problem")
                                      .foregroundColor(.gray.opacity(0.6))
                              }
                              
                              TextEditor(text: $problemText)
                                  .padding(8)
                                  .frame(height: 180)
                                  .background(Color.clear)
                          }
                          .padding(.horizontal, 40)
                          
                          Spacer()
                          
                          // Report Button
                          Button(action: {
                              print("Problem Reported")
                          }) {
                              Text("Report")
                                  .foregroundColor(.blue)
                                  .font(.system(size: 18, weight: .medium))
                          }
                          .frame(maxWidth: .infinity)
                          
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

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}

