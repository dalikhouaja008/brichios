import Foundation
import SwiftUI

struct CurrencyConverterView: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()

    var body: some View {
            ScrollView {
                VStack(spacing: 5) {
                    // Currency Conversion Card
                    VStack(spacing: 16) {
                        // Currency Selection
                        HStack(spacing: 12) {
                            CurrencyDropdown(
                                title: "From",
                                selection: $viewModel.uiStateCurrency.fromCurrency,
                                currencies: viewModel.uiStateCurrency.availableCurrencies
                            )
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                            
                            Button(action: {
                                
                                //print("Avant swap - From: \(viewModel.uiStateCurrency.fromCurrency) To: \(viewModel.uiStateCurrency.toCurrency)")
                                viewModel.swapCurrencies()
                                //print("Après swap - From: \(viewModel.uiStateCurrency.fromCurrency) To: \(viewModel.uiStateCurrency.toCurrency)")
                                viewModel.uiStateCurrency.isTNDtoOtherCurrency = !viewModel.uiStateCurrency.isTNDtoOtherCurrency
                                
                                // print( viewModel.uiStateCurrency.isTNDtoOtherCurrency)
                                
                            }) {
                                Image(systemName: "arrow.left.arrow.right")
                                    .foregroundColor(.black.opacity(0.6))
                                    .padding()
                            }
                            
                            CurrencyDropdown(
                                title: "To",
                                selection: $viewModel.uiStateCurrency.toCurrency,
                                currencies: viewModel.uiStateCurrency.availableCurrencies
                            )
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                        }
                        
                        // Amount Input
                        TextField("Enter Amount", text: $viewModel.uiStateCurrency.amount)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(12)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal)
                        
                        // Convert Button
                        Button(action: {
                            let amount = viewModel.uiStateCurrency.amount
                            if viewModel.uiStateCurrency.isTNDtoOtherCurrency {
                                viewModel.calculateSellingRate(
                                    currency: viewModel.uiStateCurrency.toCurrency,
                                    amount: amount
                                )
                            } else {
                                viewModel.calculateBuyingRate(
                                    currency: viewModel.uiStateCurrency.fromCurrency,
                                    amount: amount
                                )
                            }
                        }) {
                            if (viewModel.uiStateCurrency.isLoading) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Convert")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.2, green: 0.4, blue: 0.8),
                                    Color(red: 0.3, green: 0.5, blue: 0.9)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(viewModel.uiStateCurrency.isLoading)
                        .padding(.horizontal)
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        
                        // Result
                        VStack(spacing: 8) {
                            if viewModel.uiStateCurrency.errorMessage != nil {
                                Text("Un problème est survenu.Merci de réessayer plus tard ")
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            } else {
                                Text("Converted Amount: \(viewModel.formatConvertedAmount(viewModel.uiStateCurrency.convertedAmount))")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    
                    
                    LineChartComponent(
                        viewModel: viewModel,
                        toCurrency: $viewModel.uiStateCurrency.toCurrency
                    )
                }
                .padding(.vertical)
            }
            .padding(.top, -55)
            .navigationTitle("B-Rich")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }


