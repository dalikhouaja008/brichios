//
//  Home.swift
//  brichios
//
//  Created by Mac Mini 2 on 24/11/2024.
//

import Foundation
import SwiftUI

struct Home: View {
    @ObservedObject var viewModel: SigninViewModel
    @State private var index = 0
    @State private var showForgetPasswordSheet = false

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 200, height: 180)

            HStack {
                Button(action: {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)) {
                        self.index = 0
                    }
                }) {
                    Text("Sign In")
                        .foregroundColor(self.index == 0 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                }
                .background(self.index == 0 ? Color.white : Color.clear)
                .clipShape(Capsule())

                Button(action: {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)) {
                        self.index = 1
                    }
                }) {
                    Text("Sign Up")
                        .foregroundColor(self.index == 1 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                }
                .background(self.index == 1 ? Color.white : Color.clear)
                .clipShape(Capsule())
            }
            .background(Color.black.opacity(0.1))
            .clipShape(Capsule())
            .padding(.top, 25)

            if self.index == 0 {
                Login(viewModel: viewModel)
            } else {
                SignUp(viewModel:SignupViewModel(userRepository: UserRepository()))
            }

            if self.index == 0 {
                Button(action: {
                    self.showForgetPasswordSheet.toggle()
                }) {
                    Text("Forget Password?")
                        .foregroundColor(self.index == 0 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                }
                .background(Color.white)
                .clipShape(Capsule())
                .padding(.top, 20)
                .sheet(isPresented: $showForgetPasswordSheet) {
                    ForgetPasswordView()
                }
            }

            HStack(spacing: 15) {
                Color.white.opacity(0.7)
                    .frame(width: 35, height: 1)

                Text("Or")
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Color.white.opacity(0.7)
                    .frame(width: 35, height: 1)
            }
            .padding(.top, 10)

            HStack {
                Button(action: {
                    // Facebook login action
                }) {
                    Image("fb")
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                .background(Color.white)
                .clipShape(Circle())

                Button(action: {
                    // Google login action
                }) {
                    Image("google")
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                .background(Color.white)
                .clipShape(Circle())
                .padding(.leading, 25)
            }
            .padding(.top, 10)
        }
        .padding()
    }
}
