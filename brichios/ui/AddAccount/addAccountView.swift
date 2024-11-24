import SwiftUI
import VisionKit
import Vision

struct addAccountView: View {
    // Form Fields
        @StateObject private var viewModel = AddAccountViewModel() // Bind ViewModel to the View

        @Environment(\.presentationMode) var presentationMode

        var body: some View {
            NavigationView {
                ZStack {
                    Color(.systemGray6).ignoresSafeArea() // Background
                    
                    VStack {
                        // Progress Bar
                        CustomProgressBar(currentStep: $viewModel.currentStep, totalSteps: viewModel.totalSteps)
                            .padding(.top)

                        Spacer()

                        // Current Step Content
                        Group {
                            if viewModel.currentStep == 1 {
                                StepOneView(name: $viewModel.name)
                            } else if viewModel.currentStep == 2 {
                                StepTwoView(number: $viewModel.number)
                            } else if viewModel.currentStep == 3 {
                                StepThreeView(type: $viewModel.type, accountTypes: viewModel.getAccountTypes())
                            }
                        }
                        .animation(.easeInOut, value: viewModel.currentStep)

                        Spacer()

                        // Navigation Buttons
                        HStack {
                            if viewModel.currentStep > 1 {
                                Button(action: {
                                    withAnimation { viewModel.currentStep -= 1 }
                                }) {
                                    Text("Back")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.blue)
                                        .cornerRadius(10)
                                }
                            }

                            Button(action: {
                                if viewModel.currentStep < viewModel.totalSteps {
                                    withAnimation { viewModel.currentStep += 1 }
                                } else {
                                    viewModel.saveAccount()
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                Text(viewModel.currentStep == viewModel.totalSteps ? "Finish" : "Next")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                            }
                        }
                        .padding()
                    }
                }
                .navigationBarItems(
                    leading: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }

    // Step 1: Account Name
    struct StepOneView: View {
        @Binding var name: String

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Step 1")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("Enter the Account Name")
                    .font(.title)
                    .fontWeight(.bold)

                TextField("Account Name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.vertical)
            }
            .padding()
        }
    }

    // Step 2: Account Number
    struct StepTwoView: View {
        @Binding var number: String

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Step 2")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("Enter the Account Number")
                    .font(.title)
                    .fontWeight(.bold)

                TextField("Account Number", text: $number)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.vertical)
            }
            .padding()
        }
    }

    // Step 3: Account Type
    struct StepThreeView: View {
        @Binding var type: String
        let accountTypes: [String]

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Step 3")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("Select the Account Type")
                    .font(.title)
                    .fontWeight(.bold)

                Picker("Account Type", selection: $type) {
                    ForEach(accountTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            .padding()
        }
    }

    // Custom Progress Bar
    struct CustomProgressBar: View {
        @Binding var currentStep: Int
        let totalSteps: Int

        var body: some View {
            HStack(spacing: 4) {
                ForEach(1...totalSteps, id: \.self) { step in
                    Rectangle()
                        .fill(step <= currentStep ?
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 8)
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal)
        }
    }

  

#Preview {
    addAccountView()
}
