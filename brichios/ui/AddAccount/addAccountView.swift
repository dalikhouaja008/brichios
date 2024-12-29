import SwiftUI

struct AddAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddAccountViewModel
    @Namespace private var animation
    
    
    var onAccountAdded: ((Account) -> Void)?
    

    init(onAccountAdded: ((Account) -> Void)? = nil) {
        let viewModel = AddAccountViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onAccountAdded = onAccountAdded
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    
                    EnhancedProgressBar(
                        currentStep: viewModel.currentStep,
                        totalSteps: viewModel.totalSteps
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            ForEach(1...viewModel.totalSteps, id: \.self) { step in
                                StepContent(
                                    isCurrentStep: viewModel.currentStep == step,
                                    stepNumber: step,
                                    title: stepTitle(for: step),
                                    subtitle: stepSubtitle(for: step),
                                    stepContent: stepContent(for: step) ,
                                    onStepTapped: {
                                        withAnimation(.spring()) {
                                            viewModel.currentStep = step
                                        }
                                    }
                                )
                                .matchedGeometryEffect(id: "step\(step)", in: animation)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 25)
                    }
                    .disabled(viewModel.isLoading)
                    
                    BottomActionButton(
                        action: handleNextButtonTap,
                        isEnabled: viewModel.isStepValid(),
                        isLoading: viewModel.isLoading,
                        title: viewModel.currentStep < viewModel.totalSteps ? "Suivant" : "Terminer",
                        gradientColors: [Color("Color"), Color("Color1"), Color("Color2")]
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
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
                actions: { Button("OK", role: .cancel) {} },
                message: { Text(viewModel.error ?? "Une erreur inattendue s'est produite") }
            )
        }
        .onAppear {
            // Set up the callback in viewModel
            viewModel.onAccountAdded = { account in
                onAccountAdded?(account)
            }
        }
    }
    
    private func handleNextButtonTap() {
        if viewModel.currentStep < viewModel.totalSteps {
            viewModel.moveToNextStep()
            generateHapticFeedback()
        } else {
            if viewModel.saveAccount() {
                generateSuccessFeedback()
                dismiss() // This will dismiss the sheet and return to ListAccount
            }
        }
    }
    
    private func stepTitle(for step: Int) -> String {
        switch step {
        case 1: return "Numéro RIB"
        case 2: return "Nom du compte"
        default: return ""
        }
    }
    
    private func stepSubtitle(for step: Int) -> String {
        switch step {
        case 1: return "Entrez votre identifiant bancaire"
        case 2: return "Personnalisez votre compte"
        default: return ""
        }
    }
    // Replace your current stepContent function with this:
    
    private func stepContent(for step: Int) -> AnyView {
        return switch step {
            case 1:
                AnyView(
                    CustomTextField(
                        text: $viewModel.rib,
                        placeholder: "Entrez votre RIB",
                        keyboardType: .numberPad
                    )
                    .disabled(viewModel.isLoading)
                )
                
            case 2:
                AnyView(
                    CustomTextField(
                        text: $viewModel.nickname,
                        placeholder: "Choisissez un nom pour ce compte"
                    )
                    .disabled(viewModel.isLoading)
                )
                
            default:
                AnyView(EmptyView())
        }
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func generateSuccessFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - Supporting Views
struct StepContent: View {
    let isCurrentStep: Bool
    let stepNumber: Int
    let title: String
    let subtitle: String
    let stepContent: AnyView  // Already AnyView type
    let onStepTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 15) {
                Text("\(stepNumber)")
                    .font(.headline.bold())
                    .foregroundColor(isCurrentStep ? .white : .gray)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(isCurrentStep ? Color("Color2") : Color.gray.opacity(0.3))
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(isCurrentStep ? .primary : .gray)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if isCurrentStep {
                        stepContent  // Use directly, already AnyView
                            .transition(.opacity)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isCurrentStep ? Color("Color1").opacity(0.1) : Color.clear)
        )
        .onTapGesture(perform: onStepTapped)
    }
}

struct BackgroundView: View {
    var body: some View {
        Color("Background")
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color("Color2").opacity(0.1), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .ignoresSafeArea()
    }
}

struct EnhancedProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 6)
                
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color("Color"), Color("Color2")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: geometry.size.width * CGFloat(currentStep) / CGFloat(totalSteps),
                        height: 6
                    )
                    .animation(.spring(), value: currentStep)
            }
        }
        .frame(height: 6)
    }
}

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

struct BottomActionButton: View {
    let action: () -> Void
    let isEnabled: Bool
    let isLoading: Bool
    let title: String
    let gradientColors: [Color]
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .fontWeight(.semibold)
                
                if !isLoading {
                    Image(systemName: "arrow.right")
                        .font(.body.bold())
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                Group {
                    if isEnabled {
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        LinearGradient(
                            colors: [Color.gray.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                }
            )
            .foregroundColor(isEnabled ? .white : .gray)
            .cornerRadius(16)
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
            )
        }
        .disabled(!isEnabled || isLoading)
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView()
    }
}
