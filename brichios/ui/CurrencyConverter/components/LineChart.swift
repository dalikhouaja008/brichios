
import SwiftUI
import Charts

struct LineChartComponent: View {
    @ObservedObject var viewModel: CurrencyConverterViewModel
    @Binding var toCurrency: String
    
    // MARK: - Properties
    private let gradientColors = [
        Color(red: 0.2, green: 0.4, blue: 0.8),
        Color(red: 0.3, green: 0.5, blue: 0.9)
    ]
    
    // MARK: - Helper Functions
    private func calculateYAxisStride(for data: [PredictionData]) -> Double {
        guard let minValue = data.map({ $0.value }).min(),
              let maxValue = data.map({ $0.value }).max() else {
            return 0.1
        }
        
        let range = maxValue - minValue
        
        if range < 0.1 {
            return 0.01 // Très petites variations
        } else if range < 0.5 {
            return 0.05 // Petites variations
        } else if range < 1 {
            return 0.1 // Variations moyennes
        } else {
            return 0.2 // Grandes variations
        }
    }
    
    private func getYAxisRange(for data: [PredictionData]) -> ClosedRange<Double> {
        guard let minValue = data.map({ $0.value }).min(),
              let maxValue = data.map({ $0.value }).max() else {
            return 0...1
        }
        
        let padding = (maxValue - minValue) * 0.1
        return (minValue - padding)...(maxValue + padding)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
    
    private func getTrendDescription(for data: [PredictionData]) -> (text: String, color: Color, icon: String) {
        guard data.count > 1,
              let firstValue = data.first?.value,
              let lastValue = data.last?.value else {
            return ("No trend data", .gray, "minus.circle.fill")
        }
        
        let change = ((lastValue - firstValue) / firstValue) * 100
        let formattedChange = String(format: "%.2f%%", abs(change))
        
        if change > 0 {
            return ("Up \(formattedChange)", .green, "arrow.up.right.circle.fill")
        } else if change < 0 {
            return ("Down \(formattedChange)", .red, "arrow.down.right.circle.fill")
        } else {
            return ("Stable", .blue, "equal.circle.fill")
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(toCurrency) Trend Analysis")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Live indicator
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                        Text("LIVE")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
                
                if let currencyData = viewModel.predictions[toCurrency],
                   !currencyData.isEmpty {
                    let trend = getTrendDescription(for: currencyData)
                    HStack {
                        Image(systemName: trend.icon)
                            .foregroundColor(trend.color)
                        Text(trend.text)
                            .font(.subheadline)
                            .foregroundColor(trend.color)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(trend.color.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            // Chart
            ZStack {
                if viewModel.isLoadingPredictions {
                    LoadingView()
                } else if let currencyData = viewModel.predictions[toCurrency],
                          !currencyData.isEmpty {
                    let yAxisStride = calculateYAxisStride(for: currencyData)
                    let yAxisRange = getYAxisRange(for: currencyData)
                    
                    Chart(currencyData) { prediction in
                        // Area
                        AreaMark(
                            x: .value("Date", prediction.date),
                            y: .value("Value", prediction.value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    gradientColors[0].opacity(0.3),
                                    gradientColors[1].opacity(0.05)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        
                        // Line
                        LineMark(
                            x: .value("Date", prediction.date),
                            y: .value("Value", prediction.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                        
                        // Points
                        PointMark(
                            x: .value("Date", prediction.date),
                            y: .value("Value", prediction.value)
                        )
                        .symbolSize(30)
                        .foregroundStyle(gradientColors[1])
                    }
                    .chartYScale(domain: yAxisRange)
                    .chartYAxis {
                        AxisMarks(position: .leading, values: .stride(by: yAxisStride)) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4, 4]))
                                .foregroundStyle(Color.gray.opacity(0.2))
                            AxisValueLabel {
                                if let doubleValue = value.as(Double.self) {
                                    Text(String(format: "%.3f", doubleValue))
                                        .font(.system(.caption2, design: .rounded))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4, 4]))
                                .foregroundStyle(Color.gray.opacity(0.2))
                            AxisValueLabel {
                                if let date = value.as(Date.self) {
                                    Text(formatDate(date))
                                        .font(.system(.caption2, design: .rounded))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .frame(height: 280)
                } else {
                    EmptyStateView()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        .linearGradient(
                            colors: [.white, Color(white: 0.98)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 15,
                        x: 0,
                        y: 5
                    )
            )
        }
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
        viewModel.loadPredictions(
            date: dateFormatter.string(from: currentDate),
            currencies: [toCurrency]
        )
    }
}

// MARK: - Supporting Views
private struct LoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.blue)
            Text("Loading chart data...")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(height: 280)
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.downtrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("No data available")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(height: 280)
    }
}
