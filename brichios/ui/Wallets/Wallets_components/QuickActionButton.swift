//
//  QuickActionButton.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
import SwiftUI
struct QuickActionButton: View {
    var icon: String
    var label: String
    var backgroundColor: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white) // Make icons white
            Text(label)
                .font(.caption)
                .foregroundColor(.white) // Make text white
        }
        .frame(width: 80, height: 80)
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
