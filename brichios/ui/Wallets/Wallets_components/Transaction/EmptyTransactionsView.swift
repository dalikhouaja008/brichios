//
//  EmptyTransactionsView.swift
//  brichios
//
//  Created by Mac Mini 2 on 18/12/2024.
//

import Foundation
import SwiftUI

struct EmptyTransactionsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Transactions Found")
                .font(.headline)
            
            Text("Try adjusting your filters or search terms")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
