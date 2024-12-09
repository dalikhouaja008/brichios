import SwiftUI

struct AddAccountView: View {
    @StateObject private var viewModel = AddAccountViewModel()
    @FocusState private var focusedIndex: Int? // Tracks the currently focused index

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 40) {
                        ForEach(1...viewModel.totalSteps, id: \.self) { step in
                            StepView(
                                isCurrentStep: viewModel.currentStep == step,
                                stepNumber: step,
                                title: stepTitle(for: step),
                                content: {
                                    stepContent(for: step)
                                },
                                onStepTapped: {
                                    withAnimation { viewModel.currentStep = step }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                }
                Spacer()

                // Next Button
                Button(action: {
                    if viewModel.currentStep < viewModel.totalSteps {
                        withAnimation {
                            viewModel.moveToNextStep()
                        }
                    } else {
                        viewModel.saveAccount()
                    }
                }) {
                    Text(viewModel.currentStep < viewModel.totalSteps ? "Next" : "Finish")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(
                    Group {
                        if viewModel.isStepValid() {
                            LinearGradient(
                                gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        } else {
                            Color.gray
                        }
                    }
                    .cornerRadius(10)
                )
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .disabled(!viewModel.isStepValid()) // Disable button if step is invalid
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color("Color1").opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Add Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func stepTitle(for step: Int) -> String {
        switch step {
        case 1: return "Account RIB"
        case 2: return "Account Nickname"
        case 3: return "Enter OTP"
        default: return ""
        }
    }

    @ViewBuilder
    private func stepContent(for step: Int) -> some View {
        switch step {
        case 1:
            TextField("Enter Account RIB", text: $viewModel.rib)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 10)
                .onTapGesture {
                    withAnimation { viewModel.currentStep = 1 }
                }

        case 2:
            TextField("Enter Account Nickname", text: $viewModel.nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 10)
                .onTapGesture {
                    withAnimation { viewModel.currentStep = 2 }
                }

        case 3:
            VStack(alignment: .center, spacing: 10) {
                Text("Enter the 6-digit OTP sent to your phone")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack(spacing: 10) {
                    ForEach(0..<6, id: \.self) { index in
                        OTPDigitField(
                            digit: $viewModel.otp[index],
                            index: index,
                            focusedIndex: $focusedIndex  // Pass FocusState binding
                        )
                    }
                }
            }

        default:
            EmptyView()
        }
    }
}

struct StepView<Content: View>: View {
    let isCurrentStep: Bool
    let stepNumber: Int
    let title: String
    let content: Content
    let onStepTapped: () -> Void

    init(isCurrentStep: Bool, stepNumber: Int, title: String, @ViewBuilder content: () -> Content, onStepTapped: @escaping () -> Void) {
        self.isCurrentStep = isCurrentStep
        self.stepNumber = stepNumber
        self.title = title
        self.content = content()
        self.onStepTapped = onStepTapped
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 15) {
                VStack {
                    Text("\(stepNumber)")
                        .font(.title3.bold())
                        .foregroundColor(isCurrentStep ? .white : .gray)
                        .frame(width: 40, height: 40)
                        .background(isCurrentStep ? Color("Color2") : Color.gray.opacity(0.3))
                        .clipShape(Circle())
                    if !isCurrentStep {
                        Spacer()
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(isCurrentStep ? .title2.bold() : .headline)
                        .foregroundColor(isCurrentStep ? .primary : .gray)

                    if isCurrentStep {
                        content
                    }
                }

                Spacer()
            }
            .onTapGesture {
                onStepTapped()
            }
        }
        .padding()
        .background(isCurrentStep ? Color("Color1").opacity(0.3) : Color.clear)
        .cornerRadius(12)
        .shadow(color: isCurrentStep ? Color("Color2").opacity(0.3) : .clear, radius: 6, x: 0, y: 4)
        .animation(.easeInOut, value: isCurrentStep)
    }
}

struct OTPDigitField: View {
    @Binding var digit: String
    let index: Int
    var focusedIndex: FocusState<Int?>.Binding  // FocusState binding to manage focus

    var body: some View {
        TextField("", text: $digit)
            .keyboardType(.numberPad)
            .frame(width: 30, height: 40)
            .multilineTextAlignment(.center)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green, lineWidth: 1)
            )
            .focused(focusedIndex, equals: index)
            .onChange(of: digit) { newValue in
                if newValue.count > 1 {
                    digit = String(newValue.prefix(1))
                }

                if newValue.isEmpty {
                    focusedIndex.wrappedValue = index > 0 ? index - 1 : nil // Move back when empty
                } else {
                    focusedIndex.wrappedValue = index < 5 ? index + 1 : nil // Move forward
                }
            }
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView()
    }
}
