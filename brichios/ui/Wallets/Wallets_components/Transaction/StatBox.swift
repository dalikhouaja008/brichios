//
//  StatBox.swift
//  brichios
//
//  Created by Mac Mini 2 on 18/12/2024.
//

import Foundation
import SwiftUI
struct StatBox: View {
    let title: String
    let value: Double
    let valueColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(String(format: "%.4f", value))
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(valueColor)
            Text("SOL")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
    }
}
