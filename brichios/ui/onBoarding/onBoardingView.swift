

import Foundation
import SwiftUI

struct OnboardingView: View {
    @Binding var isFirstLaunch: Bool
    @State private var currentPage: Int = 0 // Variable d'état pour suivre la page actuelle
        
    var body: some View {
        VStack {
            // Contenu de l'onboarding
            TabView(selection: $currentPage) { // Lier le TabView à currentPage
                PageView(imageName: "welcome1", title: "Welcome to B-Rich", description: "Discover our amazing features to make your life easier.")
                    .tag(0) // Tag pour identifier la page
                PageView(imageName: "welcome2", title: "Your Trusted Banking Partner", description: "Secure and reliable banking solutions designed for your success." )
                    .tag(1)
                PageView(imageName: "welcome3", title:"Seamless Currency Exchange Solutions", description: "Fast, secure, and hassle-free currency exchange at competitive rates.")
                    .tag(2)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom))
            .edgesIgnoringSafeArea(.all)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Indicateurs de page
            
            Spacer()
            Button(action: {
                if currentPage < 2 { // Vérifie si la page actuelle est inférieure à 2
                    currentPage += 1 // Passe à la page suivante
                } else {
                    isFirstLaunch = false // Marque l'onboarding comme terminé
                }
            }) {
                Text(currentPage == 2 ? "Get Started" : "Next") // Change le texte du bouton selon la page
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .bottom, endPoint: .top))
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20) // Ajoute un espacement sur les côtés
            .padding(.bottom, 20)
            // Ajoute un espacement depuis le bas
        }
    }
}
