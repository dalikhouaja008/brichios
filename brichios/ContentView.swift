import SwiftUI

import SwiftUI

struct ContentView: View {
    // Utilisation de AppStorage pour suivre le premier lancement
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            if isFirstLaunch {
                // Afficher la vue d'onboarding pour le premier lancement
                OnboardingView(isFirstLaunch: $isFirstLaunch)
            } else {
                // Afficher la vue principale après l'onboarding
                if UIScreen.main.bounds.height > 800 {
                    Home(viewModel: SigninViewModel(userRepository: UserRepository()))
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        Home(viewModel: SigninViewModel(userRepository: UserRepository()))
                    }
                }
            }
        }
        .onAppear {
            UserDefaults.standard.removeObject(forKey: "isFirstLaunch") // seulement pour phase dev  à enlever ce bout de code dans le déploiement
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct Home: View {
    @ObservedObject var viewModel: SigninViewModel
    @State private var index = 0
    @State private var showForgotPasswordSheet = false

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
                    self.showForgotPasswordSheet.toggle()
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
                .sheet(isPresented: $showForgotPasswordSheet) {
                    ForgotPasswordView()
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


