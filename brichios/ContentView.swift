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

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            VStack(spacing: 16) {
                TextField("Email Address", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.15)))
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                if !emailError.isEmpty {
                    Text(emailError)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.15)))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                if !passwordError.isEmpty {
                    Text(passwordError)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
            }
            
            Button(action: {
                if validateLogin() {
                    print("Logging in with email: \(email) and password: \(password)")
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(40)
                    .shadow(radius: 8)
            }
            .padding(.horizontal)
            
            NavigationLink(destination: ForgotPasswordScreen()) {
                Text("Forgot Password?")
                    .foregroundColor(Color.blue)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
    
    func validateLogin() -> Bool {
        var isValid = true
        
        if email.isEmpty || !email.contains("@") {
            emailError = "Please enter a valid email address."
            isValid = false
        } else {
            emailError = ""
        }
        
        if password.isEmpty || password.count < 6 {
            passwordError = "Password must be at least 6 characters."
            isValid = false
        } else {
            passwordError = ""
        }
        
        return isValid
    }
}

struct SignUpView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var usernameError = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            VStack(spacing: 16) {
                TextField("Username", text: $username)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.15)))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                if !usernameError.isEmpty {
                    Text(usernameError)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                
                TextField("Email Address", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.15)))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                if !emailError.isEmpty {
                    Text(emailError)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.15)))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                if !passwordError.isEmpty {
                    Text(passwordError)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
            }
            
            Button(action: {
                if validateSignUp() {
                    print("Signing up with username: \(username), email: \(email), password: \(password)")
                }
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(40)
                    .shadow(radius: 8)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
    
    func validateSignUp() -> Bool {
        var isValid = true
        
        if username.isEmpty {
            usernameError = "Username cannot be empty."
            isValid = false
        } else {
            usernameError = ""
        }
        
        if email.isEmpty || !email.contains("@") {
            emailError = "Please enter a valid email address."
            isValid = false
        } else {
            emailError = ""
        }
        
        if password.isEmpty || password.count < 6 {
            passwordError = "Password must be at least 6 characters."
            isValid = false
        } else {
            passwordError = ""
        }
        
        return isValid
    }
}

struct ForgotPasswordScreen: View {
    var body: some View {
        NavigationStack {
            ForgotPasswordContentView() // Light background to set a clean base
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ForgetPasswordContentView: View { // Renamed to avoid redeclaration
    @State private var email = ""
    @State private var isOTPViewActive = false
    
    var body: some View {
        ZStack {
            Color.purple.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .background(Color.white)
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "lock.shield")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(Color.purple.opacity(0.8))
                    .padding(.bottom, 40)
                
                Text("Forgot Password")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                
                Text("Please enter your email address to receive a new OTP")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.purple.opacity(0.8))
                    .padding(.horizontal, 40)
                
                TextField("Email", text: $email)
                    .padding()
                    .foregroundColor(.gray)
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    isOTPViewActive = true
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                HStack {
                    Text("Remember password?")
                        .foregroundColor(.gray)
                        .font(.system(size: 50))
                    
                    NavigationLink("Sign In", destination: ContentView())
                        .foregroundColor(.purple)
                        .font(.body)
                }
                .font(.footnote)
                .padding(.bottom, 10)
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
