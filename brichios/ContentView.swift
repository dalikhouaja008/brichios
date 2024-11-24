import SwiftUI

import SwiftUI

struct ContentView: View {
    // Utilisation de AppStorage pour suivre le premier lancement
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @StateObject private var auth = Auth.shared
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            if auth.loggedIn {
                NavigationView{
                    HomeBrich()
                    .environmentObject(auth)
                }
            }
            else if isFirstLaunch {
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



