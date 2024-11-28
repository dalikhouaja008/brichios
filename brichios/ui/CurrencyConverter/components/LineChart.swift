import SwiftUI
import Charts

import SwiftUI
import Charts

struct LineChartComponent: View {
    @ObservedObject var viewModel: CurrencyConverterViewModel
    @Binding var toCurrency: String
    
    var body: some View {
        VStack {
            Text("Prediction for \(toCurrency) for the next 7 days")
                .font(.headline)
                .padding(.bottom, 10)
            
            if viewModel.isLoadingPredictions {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else if let currencyData = viewModel.predictions[toCurrency], !currencyData.isEmpty {
                Chart(currencyData) { prediction in
                    LineMark(
                        x: .value("Date", prediction.date),
                        y: .value("Value", prediction.value)
                    )
                    .interpolationMethod(.cardinal)
                    
                    PointMark(
                        x: .value("Date", prediction.date),
                        y: .value("Value", prediction.value)
                    )
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        if let dateString = value.as(String.self) {
                            AxisValueLabel(dateString)
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic) { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                .frame(height: 300)
                .padding()
            } else {
                Text("No predictions available for \(toCurrency)")
                    .foregroundColor(.red)
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
        .onAppear {
            loadPredictions()
        }
        .onChange(of: toCurrency) { _ in
            loadPredictions()
        }
    }
    
    private func loadPredictions() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        viewModel.loadPredictions(date: dateFormatter.string(from: currentDate), currencies: [toCurrency])
    }
}


