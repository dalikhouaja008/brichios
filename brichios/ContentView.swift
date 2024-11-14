import SwiftUI

struct ContentView: View {
    @State private var isSignUpActive = false // Track whether we show Login or Sign Up view

    var body: some View {
        NavigationView {
            VStack {
                // Button to toggle between Sign Up and Login view
                HStack {
                    Button(action: {
                        withAnimation {
                            isSignUpActive = false // Show Login view
                        }
                    }) {
                        Text("Login")
                            .font(.title2)
                            .foregroundColor(isSignUpActive ? .gray : .white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                Group {
                                    if !isSignUpActive {
                                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    } else {
                                        Color.clear
                                    }
                                }
                            )
                            .cornerRadius(40)
                            .shadow(radius: 8)
                    }

                    Button(action: {
                        withAnimation {
                            isSignUpActive = true // Show Sign Up view
                        }
                    }) {
                        Text("Sign Up")
                            .font(.title2)
                            .foregroundColor(isSignUpActive ? .white : .gray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                Group {
                                    if isSignUpActive {
                                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    } else {
                                        Color.clear
                                    }
                                }
                            )
                            .cornerRadius(40)
                            .shadow(radius: 8)
                    }
                }
                .padding(.top, 50)

                Spacer()

                // Toggle between LoginView and SignUpView
                ZStack {
                    if isSignUpActive {
                        SignUpView()
                            .transition(.move(edge: .trailing)) // Transition for sign up
                    } else {
                        LoginView()
                            .transition(.move(edge: .leading)) // Transition for login
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Optional: for better handling on iPads
    }
}
