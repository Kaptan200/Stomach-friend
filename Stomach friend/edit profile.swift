//
//  edit profile.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var fullName: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var bio: String = ""
    @State private var cuisine: String = ""
    @State private var location: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack{
                        
                        Button(action: {dismiss()}){
                            Image(systemName: "chevron.left")
                        }.foregroundStyle(.primary)
                        Spacer()
                         Text("Edit profile")
                           .font(Font.largeTitle.bold())
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                    }.padding()
                    // MARK: - Profile Image
                    VStack {
                       
                      
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.circle.fill") // Add your image in Assets
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                            
                            Button {
                                print("Change photo tapped")
                            } label: {
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.orange)
                                    .clipShape(Circle())
                            }
                        }
                        
                        Button("Change Photo") {
                            print("Change photo tapped")
                        }
                        .foregroundColor(.orange)
                        .padding(.top, 8)
                    }
                    .padding(.top)
                    
                    
                    // MARK: - Form Fields
                    VStack(spacing: 16) {
                        CustomTextField(title: "Full Name", text: $fullName)
                        CustomTextField(title: "Username", text: $username)
                        CustomTextField(title: "Email", text: $email)
                        CustomTextField(title: "Phone Number", text: $phone)
                        
                        VStack(alignment: .leading) {
                            Text("Bio")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $bio)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        
                        CustomTextField(title: "Food liked", text: $cuisine)
                        CustomTextField(title: "Location", text: $location)
                    }
                    .padding(.horizontal)
                    
                    
                    // MARK: - Save Button
                    Button(action: {
                        print("Save Changes")
                    }) {
                        Text("Save Changes")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    
                    // MARK: - Delete Account
                  
                }
                .padding(.bottom, 30)
            }
          
        }.toolbar(.hidden)
    }
}

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("Enter \(title)", text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
}

#Preview {
    EditProfileView()
}
