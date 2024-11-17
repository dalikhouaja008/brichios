import SwiftUI

struct OnboardingView: View {
    @Binding var isFirstLaunch: Bool // Binding pour modifier l'état dans ContentView
    @State private var currentPage = 0
    private let onboardingTexts = [
        "Welcome to the App!",
        "Discover Amazing Features",
        "Get Started and Have Fun!"
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingTexts.count, id: \.self) { index in
                    VStack {
                        Text(onboardingTexts[index])
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                    }
                    .background(LinearGradient(gradient: .init(colors: [Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(20)
                    .padding()
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            Button(action: {
                // Quand l'utilisateur clique sur "Get Started", on passe à l'écran de connexion
                isFirstLaunch = false
            }) {
                Text("Get Started")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: .init(colors: [Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            // On réinitialise la page actuelle si c'est le premier lancement
            if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                // Si l'app a déjà été lancée, on saute les écrans d'onboarding
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isFirstLaunch: .constant(true))
    }
}
