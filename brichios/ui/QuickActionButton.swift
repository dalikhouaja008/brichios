//
//  QuickActionButton.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/11/2024.
//

import SwiftUI

struct QuickActionButton: View {
    var icon: String
    var label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(Circle())
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(width: 80, height: 100)
    }
}
