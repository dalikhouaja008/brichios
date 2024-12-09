
import SwiftUI
import Charts

struct LineChartComponent: View {
    @ObservedObject var viewModel: CurrencyConverterViewModel
    @Binding var toCurrency: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header with trend analysis
            HStack {
                VStack(alignment: .leading) {
                    Text("7-Day \(toCurrency) Forecast")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    if let currencyData = viewModel.predictions[toCurrency], !currencyData.isEmpty {
                        Text(trendDescription(for: currencyData))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
            .padding(.horizontal)
            
            // Chart or Loading/Error State
            if viewModel.isLoadingPredictions {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
            } else if let currencyData = viewModel.predictions[toCurrency], !currencyData.isEmpty {
                Chart(currencyData) { prediction in
                    // Filled area below line
                    AreaMark(
                        x: .value("Date", prediction.date),
                        y: .value("Value", prediction.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.3), .blue.opacity(0.1)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Main line
                    LineMark(
                        x: .value("Date", prediction.date),
                        y: .value("Value", prediction.value)
                    )
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(.blue)
                    
                    // Data points
                    PointMark(
                        x: .value("Date", prediction.date),
                        y: .value("Value", prediction.value)
                    )
                    .symbolSize(100)
                    .foregroundStyle(.blue)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisValueLabel()
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic) { _ in
                        AxisGridLine(stroke: StrokeStyle(dash: [2, 2]))
                            .foregroundStyle(.gray.opacity(0.3))
                        AxisValueLabel()
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .frame(height: 250)
            } else {
                Text("No predictions available for \(toCurrency)")
                    .foregroundColor(.red)
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.white, .blue.opacity(0.05)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
        .onAppear { loadPredictions() }
        .onChange(of: toCurrency) { _ in loadPredictions() }
    }
    
    private func trendDescription(for data: [PredictionData]) -> String {
        guard data.count > 1 else { return "Insufficient data" }
        
        let firstValue = data.first!.value
        let lastValue = data.last!.value
        let percentChange = ((lastValue - firstValue) / firstValue) * 100
        
        if percentChange > 1 {
            return "Trending ↑ \(String(format: "%.2f", percentChange))%"
        } else if percentChange < -1 {
            return "Trending ↓ \(String(format: "%.2f", abs(percentChange)))%"
        } else {
            return "Stable trend"
        }
    }
    
    private func loadPredictions() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        viewModel.loadPredictions(date: dateFormatter.string(from: currentDate), currencies: [toCurrency])
    }
}

