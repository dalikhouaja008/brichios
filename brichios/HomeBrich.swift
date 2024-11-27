//
//  HomeBrich.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/11/2024.
//
import SwiftUI


import SwiftUI

//Structure de navigation dans page principal


struct HomeBrich: View {
    @State private var tabSelected: Tab = .house
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background global
                Color.white.opacity(0.05)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    TabView(selection: $tabSelected) {
                        // Page Accueil
                        ExchangeRateView()
                            .tag(Tab.house)
                        CurrencyConverterView()
                            .tag(Tab.currencyConvert)
                        WalletView()
                           .tag(Tab.wallet)
                        
                        ProfileView()
                           .tag(Tab.person)
                        
                        ListAccountsView()
                           .tag(Tab.bank)
                        
                    }
                    
                    CustomBottomBar(selectedTab: $tabSelected)
                }
            }
        }
    }
}
struct HomeBrich_Previews: PreviewProvider {
    static var previews: some View {
        HomeBrich()
            .previewInterfaceOrientation(.portrait)
    }
}



