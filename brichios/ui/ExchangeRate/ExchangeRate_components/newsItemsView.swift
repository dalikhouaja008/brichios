//
//  newsItemsView.swift
//  brichios
//
//  Created by Mac Mini 2 on 5/12/2024.
//

import Foundation
import SwiftUI

struct NewsItemView: View {
    let newsItem: NewsItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
          
            Text(newsItem.title)
                .font(.headline)
                .lineLimit(2)
            
            Text(newsItem.content)
                .font(.subheadline)
                .lineLimit(3)
                .foregroundColor(.secondary)
            
            Text(formattedDate)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        // Convert string to date
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: newsItem.date) {
            return dateFormatter.string(from: date)
        }
        
        // Fallback to original string if conversion fails
        return newsItem.date
    }
}
