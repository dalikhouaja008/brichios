//
//  TransactionListView.swift
//  brichios
//
//  Created by Mac Mini 2 on 18/12/2024.
//

import Foundation
import SwiftUI

struct TransactionsListView: View {
    @Environment(\.dismiss) var dismiss
    let transactions: [SolanaTransaction]
    @State private var searchText = ""
    @State private var selectedFilter = TransactionFilter.all
    
    enum TransactionFilter: String, CaseIterable {
        case all = "All"
        case sent = "Sent"
        case received = "Received"
        
        func filter(_ transaction: SolanaTransaction) -> Bool {
            switch self {
            case .all:
                return true
            case .sent:
                return transaction.amount < 0
            case .received:
                return transaction.amount >= 0
            }
        }
    }
    
    var filteredTransactions: [SolanaTransaction] {
        transactions
            .filter { selectedFilter.filter($0) }
            .filter {
                searchText.isEmpty ||
                $0.id.localizedCaseInsensitiveContains(searchText) ||
                $0.type.localizedCaseInsensitiveContains(searchText)
            }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Filter Picker
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(TransactionFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                List(filteredTransactions) { transaction in
                    TransactionRow(transaction: transaction)
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 4)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("All Transactions")
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

