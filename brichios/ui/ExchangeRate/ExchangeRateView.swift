

import Foundation
import SwiftUI

struct ExchangeRateView: View {
    @StateObject private var viewModel = ExchangeRateViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) { 
                // News Carousel
                Text("Latest News")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 10) // Reduced from 20
                    .multilineTextAlignment(.leading)
                VStack {
                    switch viewModel.newsState {
                    case .loading:
                        ProgressView()
                    case .error(let message):
                        Text("News Error: \(message)")
                            .foregroundColor(.red)
                    case .success(let news):
                        TabView {
                            ForEach(news) { item in
                                NewsItemView(newsItem: item)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        .frame(height: 150)
                        .padding(.all, 10)
                    }
                }
                
                VStack(spacing: 20) {
                    Text("Currency Rate")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 10) // Reduced from 20
                        .multilineTextAlignment(.leading)
                    
                    // Exchange Rates List
                    VStack {
                        if viewModel.uiState.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(1.5)
                                .padding()
                        } else if let errorMessage = viewModel.uiState.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding()
                        } else if let rates = viewModel.uiState.exchangeRates {
                            ForEach(rates, id: \.code) { rate in
                                ExchangeRateRow(rate: rate)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                }
                .padding(.vertical, 5) // Reduced from default
            }
            .padding(.top, -50) // Reduced from -55
            .onAppear {
                viewModel.fetchExchangeRates()
                viewModel.fetchNews()
            }
        }
    }
}
