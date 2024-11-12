import SwiftUI

struct ForgetPasswordScreen: View {
    var body: some View {
        NavigationStack {
            ForgotPasswordContentView()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ForgotPasswordContentView: View {
    @State private var email = ""
    @State private var isOTPViewActive = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background similar to ContentView
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "lock.shield")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                    
                    Text("Forgot Password")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Please enter your email address to receive a new OTP")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 40)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        isOTPViewActive = true
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    HStack {
                        Text("Remember password?").foregroundColor(.white.opacity(0.7))
                        NavigationLink("Sign In", value: "SignIn")
                            .foregroundColor(.white)
                    }
                    .font(.footnote)
                    .padding(.bottom, 20)
                }
                .navigationDestination(isPresented: $isOTPViewActive) {
                    VerificationView()
                }
                .navigationDestination(for: String.self) { value in
                    if value == "SignIn" {
                        ContentView()
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct VerificationView: View {
    @State private var otp = ""
    @State private var isOTPValid = false
    @State private var isOTPEntryViewActive = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "envelope.open")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                Text("Verification")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("We have sent OTP to your email, please type the code here")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .foregroundColor(.white.opacity(0.8))
                
                HStack(spacing: 30) {
                    ForEach(0..<4) { index in
                        TextField("", text: Binding(
                            get: { String(self.otp.prefix(index + 1).last ?? " ") },
                            set: { newValue in
                                if newValue.count <= 1 {
                                    self.otp = self.otp.prefix(index) + newValue + self.otp.dropFirst(index + 1)
                                }
                            }
                        ))
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .border(Color.white.opacity(0.4), width: 1)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.numberPad)
                        .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    if otp.count == 4 {
                        isOTPValid = true
                        isOTPEntryViewActive = true
                    }
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                HStack {
                    Text("Didn’t get OTP?").foregroundColor(.white.opacity(0.7))
                    Button("Resend OTP") {
                        // Action for resending OTP
                    }
                    .foregroundColor(.white)
                }
                .font(.footnote)
                .padding(.bottom, 20)
                .navigationDestination(isPresented: $isOTPEntryViewActive) {
                    OTPEntryView()
                }
            }
            .navigationBarHidden(true)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct OTPEntryView: View {
    @State private var otp = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Enter OTP")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Please type the verification code here")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(.white.opacity(0.8))
            
            HStack(spacing: 15) {
                ForEach(Array(otp), id: \.self) { character in
                    Text(String(character))
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            
            Button(action: {
                // Action to verify entered OTP
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .navigationBarHidden(true)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .edgesIgnoringSafeArea(.all)
    }
}
