//
//  AllTransactionsView.swift
//  brichios
//
//  Created by Mac Mini 2 on 18/12/2024.
//

import Foundation
import SwiftUI
struct AllTransactionsView: View {
    @Environment(\.dismiss) private var dismiss
    let transactions: [SolanaTransaction]
    
    // State variables
    @State private var searchText = ""
    @State private var selectedPeriod: TimePeriod = .all
    @State private var selectedType: TransactionType = .all
    
    // Enums for filtering
    enum TimePeriod: String, CaseIterable {
        case day = "24h"
        case week = "7d"
        case month = "30d"
        case all = "All"
    }
    
    enum TransactionType: String, CaseIterable {
        case all = "All"
        case sent = "Sent"
        case received = "Received"
    }
    
    // Filtered transactions
    private var filteredTransactions: [SolanaTransaction] {
        transactions.filter { transaction in
            let matchesSearch = searchText.isEmpty ||
                transaction.type.localizedCaseInsensitiveContains(searchText) ||
                transaction.id.localizedCaseInsensitiveContains(searchText)
            
            let matchesType: Bool = {
                switch selectedType {
                case .all: return true
                case .sent: return transaction.amount < 0
                case .received: return transaction.amount > 0
                }
            }()
            
            let matchesPeriod: Bool = {
                let now = Date()
                switch selectedPeriod {
                case .day:
                    return transaction.timestamp >= now.addingTimeInterval(-86400)
                case .week:
                    return transaction.timestamp >= now.addingTimeInterval(-604800)
                case .month:
                    return transaction.timestamp >= now.addingTimeInterval(-2592000)
                case .all:
                    return true
                }
            }()
            
            return matchesSearch && matchesType && matchesPeriod
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Stats
                TransactionStatsHeader(transactions: filteredTransactions)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                
                // Filters
                VStack(spacing: 12) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search transactions", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Filter Controls
                    HStack {
                        // Time Period Picker
                        Picker("Period", selection: $selectedPeriod) {
                            ForEach(TimePeriod.allCases, id: \.self) { period in
                                Text(period.rawValue).tag(period)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Divider()
                            .frame(height: 20)
                        
                        // Transaction Type Picker
                        Picker("Type", selection: $selectedType) {
                            ForEach(TransactionType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, y: 5)
                
                // Transactions List
                if filteredTransactions.isEmpty {
                    EmptyTransactionsView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTransactions) { transaction in
                                TransactionRow(transaction: transaction)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}
