//
//  pageView.swift
//  brichios
//
//  Created by Mac Mini 2 on 17/11/2024.
//

import Foundation
import SwiftUI

struct PageView: View {
    var imageName: String
    var title: String
    var description: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .padding()

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
                .multilineTextAlignment(.center)

            Text(description)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.top, 10)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
        }
    }
}

