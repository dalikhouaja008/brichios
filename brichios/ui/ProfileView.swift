//
//  ProfileView.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/11/2024.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("User Profile")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Welcome to your profile page!")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
