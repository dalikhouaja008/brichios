import SwiftUI

struct ListAccountsView: View {
    @StateObject private var viewModel = ListAccountsViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) { // Reduced spacing between sections
                // Top Section
                VStack(spacing: 8) { // Reduced spacing between elements in the top section
                    HStack {
                        Text("Your Accounts")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.primary)
                        
                        Spacer()
                        
                        // Add Account Button
                        NavigationLink(destination: AddAccountView()) {
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
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.systemGray6))
                            .frame(height: 130) // Increased height for the rectangular background
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 3)
                    )
                    .padding(.horizontal)
                    .offset(y: -40)
                    
                    Divider()
                    
                    // Horizontal Scrollable List of Accounts
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) { // Reduced spacing between account cards
                            ForEach(viewModel.accounts) { account in
                                AccountCardView(
                                    account: account,
                                    isSelected: viewModel.selectedAccount?.id == account.id
                                )
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        viewModel.selectedAccount = account
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 180)
                    
                    // Horizontal Scroll Indicator
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(index == 0 ? Color.blue : Color.gray.opacity(0.5)) // Highlight first dot
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 8)
                    
                    // Mid Section
                    VStack(spacing: 12) { // Reduced spacing between mid-section components
                        Divider()
                        
                        // Account Details Section
                        if let selectedAccount = viewModel.selectedAccount {
                            VStack(alignment: .leading, spacing: 12) { // Reduced spacing within details
                                Text("Account Details")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                // Balance Display
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Balance")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("\(selectedAccount.balance, specifier: "%.2f") TND")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.green)
                                }
                                
                                // Default Account Toggle
                                HStack {
                                    Text("Default Account")
                                        .font(.subheadline)
                                    Spacer()
                                    Toggle("", isOn: Binding(
                                        get: { selectedAccount.isDefault },
                                        set: { _ in
                                            viewModel.toggleDefault(for: selectedAccount)
                                        }
                                    ))
                                    .labelsHidden()
                                }
                                
                                // Top-Up Wallet Button
                                Button(action: {
                                    print("Top-Up Wallet for \(selectedAccount.name)")
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                        Text("Top-Up Wallet")
                                            .fontWeight(.bold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        } else {
                            Text("No account selected")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Bottom Section
                    Spacer()
                }
                .background(Color(.systemGray6).ignoresSafeArea())
                //.navigationTitle("Accounts")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    // Account Card View
    struct AccountCardView: View {
        let account: CustomAccount
        let isSelected: Bool
        
        var body: some View {
            VStack(spacing: 8) {
                Text(account.name)
                    .font(.headline)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 20)
                    .frame(width: 150, height: 100)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: isSelected ? [Color.blue, Color.purple] : [Color.gray.opacity(0.2), Color.gray.opacity(0.3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: isSelected ? Color.purple.opacity(0.5) : Color.clear, radius: 10, x: 0, y: 5)
                
                if isSelected {
                    Text("\(account.balance, specifier: "%.2f") TND")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }
            .padding(.vertical, 8)
            .animation(.spring(), value: isSelected)
        }
    }
}
