//
//  CreateTNDWalletView.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/12/2024.
//

import Foundation
import SwiftUI
struct CreateTNDWalletCard: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Icon and Title
            VStack(spacing: 12) {
                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                Text("Create TND Wallet")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Start managing your TND transactions")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Create Button
            Button(action: { showSheet = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Now")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
        .padding(.horizontal)
    }
}
// Date Formatter Extension
extension DateFormatter {
    static let utcFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}


