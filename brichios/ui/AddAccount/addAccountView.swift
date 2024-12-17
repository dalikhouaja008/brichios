import SwiftUI

struct AddAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddAccountViewModel()
    @FocusState private var focusedIndex: Int?

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color("Background") // Add this color to your assets
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress Bar
                    ProgressBar(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    // Main Content
                    ScrollView {
                        VStack(spacing: 25) {
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
                        .padding(.vertical, 25)
                    }
                    .disabled(viewModel.isLoading)
                    
                    // Bottom Button
                    VStack {
                        Button(action: handleNextButtonTap) {
                            HStack {
                                Text(viewModel.currentStep < viewModel.totalSteps ? "Suivant" : "Terminer")
                                    .fontWeight(.semibold)
                                
                                if !viewModel.isLoading {
                                    Image(systemName: "arrow.right")
                                        .font(.body.bold())
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                Group {
                                    if viewModel.isStepValid() {
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    } else {
                                        Color.gray.opacity(0.3)
                                    }
                                }
                            )
                            .foregroundColor(viewModel.isStepValid() ? .white : .gray)
                            .cornerRadius(12)
                            .overlay(
                                Group {
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .tint(.white)
                                    }
                                }
                            )
                        }
                        .disabled(!viewModel.isStepValid() || viewModel.isLoading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    .background(Color("Background"))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Ajouter un compte")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: dismiss.callAsFunction) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .alert(
                "Erreur",
                isPresented: $viewModel.showAlert,
                actions: {
                    Button("OK", role: .cancel) {}
                },
                message: {
                    Text(viewModel.error ?? "Une erreur inattendue s'est produite")
                }
            )
        }
    }
    
    private func handleNextButtonTap() {
        if viewModel.currentStep < viewModel.totalSteps {
            withAnimation {
                viewModel.moveToNextStep()
            }
        } else {
            viewModel.saveAccount()
            dismiss()
        }
    }

    private func stepTitle(for step: Int) -> String {
        switch step {
        case 1: return "Numéro RIB"
        case 2: return "Nom du compte"
        case 3: return "Code OTP"
        default: return ""
        }
    }

    @ViewBuilder
    private func stepContent(for step: Int) -> some View {
        switch step {
        case 1:
            CustomTextField(
                text: $viewModel.rib,
                placeholder: "Entrez votre RIB",
                keyboardType: .numberPad
            )
            .disabled(viewModel.isLoading)

        case 2:
            CustomTextField(
                text: $viewModel.nickname,
                placeholder: "Choisissez un nom pour ce compte"
            )
            .disabled(viewModel.isLoading)

        case 3:
            OTPInputView(
                otp: $viewModel.otp,
                focusedIndex: $focusedIndex,
                isLoading: viewModel.isLoading
            )
        default:
            EmptyView()
        }
    }
}

// Custom TextField View
struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.vertical, 8)
    }
}

// Progress Bar View
struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.2))
                    .frame(height: 4)
                
                Rectangle()
                    .foregroundColor(Color("Color2"))
                    .frame(width: geometry.size.width * CGFloat(currentStep) / CGFloat(totalSteps), height: 4)
                    .animation(.easeInOut, value: currentStep)
            }
            .cornerRadius(2)
        }
        .frame(height: 4)
    }
}

// OTP Input View
struct OTPInputView: View {
    @Binding var otp: [String]
    var focusedIndex: FocusState<Int?>.Binding
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Entrez le code OTP reçu par SMS")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    OTPDigitField(
                        digit: $otp[index],
                        index: index,
                        focusedIndex: focusedIndex
                    )
                }
            }
        }
        .disabled(isLoading)
    }
}

struct LoadingProgressView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
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
