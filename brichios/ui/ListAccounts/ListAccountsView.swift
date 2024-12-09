import SwiftUI

struct ListAccountsView: View {
    @StateObject private var viewModel = ListAccountsViewModel()
    @State private var currentDotIndex = 0  // Track the current dot index based on the scroll position

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                // Top Section
                VStack(spacing: 8) {
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
                            .frame(height: 130)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 3)
                    )
                    .padding(.horizontal)
                    .offset(y: -40)
                    
                    Divider()
                    
                    // Horizontal Scrollable List of Accounts
                    GeometryReader { geometry in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.accounts) { account in
                                    AccountCardView(account: account, isSelected: viewModel.selectedAccount?.id == account.id)
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                viewModel.selectedAccount = account
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear.onChange(of: proxy.frame(in: .global).minX) { newValue in
                                        // Determine which dot should be blue based on the scroll position
                                        let totalWidth = geometry.size.width
                                        let scrollPosition = -newValue
                                        let sectionWidth = totalWidth / 3

                                        if scrollPosition < sectionWidth {
                                            currentDotIndex = 0  // First section
                                        } else if scrollPosition < 2 * sectionWidth {
                                            currentDotIndex = 1  // Middle section
                                        } else {
                                            currentDotIndex = 2  // Last section
                                        }
                                    }
                                }
                            )
                        }
                    }
                    .frame(height: 180)
                    
                    // Custom Dot Indicator (fixed size, always 3 dots)
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(index == currentDotIndex ? Color.blue : Color.gray.opacity(0.5))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentDotIndex)
                        }
                    }
                    .padding(.top, 8)
                    
                    // Mid Section (unchanged)
                    VStack(spacing: 12) {
                        Divider()
                        
                        if let selectedAccount = viewModel.selectedAccount {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Account Details")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Balance")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("\(selectedAccount.balance, specifier: "%.2f") TND")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.green)
                                }
                                
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
                    
                    Spacer()
                }
                .background(Color(.systemGray6).ignoresSafeArea())
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

// Account Card View
struct AccountCardView: View {
    let account: CustomAccount
    let isSelected: Bool
    
    // List of predefined colors
    private let colorOptions: [Color] = [
        .blue, .gray, .cyan, .mint, Color(red: 0.75, green: 0.75, blue: 0.75)
    ]
    
    // Generate random gradient colors
    private func getRandomGradientColors() -> [Color] {
        let color1 = colorOptions.randomElement() ?? .blue
        let color2 = colorOptions.randomElement() ?? .purple
        return [color1, color2]
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 8) {
                Text(account.name)
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
                    Text("\(account.balance, specifier: "%.2f") TND")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }
            .padding(.vertical, 8)
            .animation(.spring(), value: isSelected)
            
            // Bank Icon
            Image(systemName: "building.columns")
                .font(.title3)
                .foregroundColor(.white)
                .padding(.top, 20)  // Padding for top
                .padding(.leading, 10)
        }
    }
}
