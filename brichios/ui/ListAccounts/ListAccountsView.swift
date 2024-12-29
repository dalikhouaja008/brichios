// ListAccountsView.swift
import SwiftUI

struct ListAccountsView: View {
    @StateObject private var viewModel = ListAccountsViewModel()
    @State private var currentDotIndex = 0
    @State private var showingAddAccount = false

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                headerSection
                
                Divider()
                
                accountsScrollView
                
                if !viewModel.accounts.isEmpty {
                    dotIndicators
                }
                
                if let selectedAccount = viewModel.selectedAccount {
                    accountDetailsSection(selectedAccount)
                }
                
                Spacer()
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingAddAccount, onDismiss: { viewModel.refreshAccounts() }) {
            AddAccountView { newAccount in
                viewModel.addAccount(newAccount)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        HStack {
            Text("Your Accounts")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.primary)
            
            Spacer()
            
            addAccountButton
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
                .frame(height: 130)
                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 3)
        )
        .padding(.horizontal)
        .offset(y: -40)
    }
    
    private var addAccountButton: some View {
        Button(action: { showingAddAccount = true }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                Text("Account")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
    
    private var accountsScrollView: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.accounts) { account in
                        AccountCardView(
                            account: account,
                            isSelected: viewModel.selectedAccount?.rib == account.rib
                        )
                        .onTapGesture {
                            withAnimation(.spring()) {
                                viewModel.selectedAccount = account
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .background(scrollPositionDetector(geometry: geometry))
            }
        }
        .frame(height: 180)
    }
    
    private func scrollPositionDetector(geometry: GeometryProxy) -> some View {
        GeometryReader { proxy in
            Color.clear.onChange(of: proxy.frame(in: .global).minX) { newValue in
                let totalWidth = geometry.size.width
                let scrollPosition = -newValue
                let sectionWidth = totalWidth / 3
                currentDotIndex = min(2, max(0, Int(scrollPosition / sectionWidth)))
            }
        }
    }
    
    private var dotIndicators: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(index == currentDotIndex ? Color.blue : Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: currentDotIndex)
            }
        }
        .padding(.top, 8)
    }
    
    private func accountDetailsSection(_ account: Account) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account Details")
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("RIB")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(account.rib)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Nickname")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(account.nickname ?? "No nickname")
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

// MARK: - AccountCardView
struct AccountCardView: View {
    let account: Account
    let isSelected: Bool
    
    private let colorOptions: [Color] = [
        .blue, .gray, .cyan, .mint, Color(red: 0.75, green: 0.75, blue: 0.75)
    ]
    
    private func getRandomGradientColors() -> [Color] {
        let color1 = colorOptions.randomElement() ?? .blue
        let color2 = colorOptions.randomElement() ?? .purple
        return [color1, color2]
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 8) {
                Text(account.nickname ?? "Account")
                    .font(.headline)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 20)
                    .frame(width: 180, height: 120)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: isSelected ? [Color.blue, Color.purple] : getRandomGradientColors()),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: isSelected ? Color.purple.opacity(0.5) : Color.clear, radius: 12, x: 0, y: 8)
                
                if isSelected {
                    Text(account.rib)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }
            .padding(.vertical, 8)
            .animation(.spring(), value: isSelected)
            
            Image(systemName: "building.columns")
                .font(.title3)
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.leading, 10)
        }
    }
}
