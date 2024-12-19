//
//  ErrorWalletsView.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/12/2024.
//

import Foundation
import SwiftUI

struct ErrorWalletsView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
