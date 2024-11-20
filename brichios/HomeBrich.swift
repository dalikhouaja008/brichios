//
//  HomeBrich.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/11/2024.
//
import SwiftUI


import SwiftUI

struct HomeBrich: View {
    var body: some View {
        TabView {
            // Wallet View
            NavigationView {
                WalletView()
                    .navigationTitle("Your wallets")
            }
            .tabItem {
                Image(systemName: "wallet.pass")
                Text("Wallet")
            }
            .tint(.blue)
            .shadow(color: .gray.opacity(0.5), radius: 2, x: 0, y: 2)
            
            // Exchange Rate View
            NavigationView {
                ExchangeRateView()
                    .navigationTitle("Exchange Rates")
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tint(.green)
            .shadow(color: .gray.opacity(0.5), radius: 2, x: 0, y: 2)
            
            // Bank Accounts View
            NavigationView {
                ListAccountsView()
                    .navigationTitle("Your Bank Accounts")
            }
            .tabItem {
                Image(systemName: "banknote.fill")
                Text("Bank Accounts")
            }
            .tint(.purple)
            .shadow(color: .gray.opacity(0.5), radius: 2, x: 0, y: 2)
            
            // Profile View (New Tab)
            NavigationView {
                ProfileView()
                    .navigationTitle("Profile")
            }
            .tabItem {
                Image(systemName: "person.circle.fill")
                Text("Profile")
            }
            .tint(.red)
            .shadow(color: .gray.opacity(0.5), radius: 2, x: 0, y: 2)
        }
        .accentColor(.blue) // Customize tab bar item color
    }
}
