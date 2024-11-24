import SwiftUI

struct OTPView: View {
    @StateObject private var viewModel = OTPViewModel()
    @FocusState private var focusedIndex: Int? // Tracks the currently focused OTP field
    
    var body: some View {
        VStack {
            
            // Title and Subtitle
            Text("Enter CODE")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 90)
            
            Text("Please enter the 6-digit sent to your Mail.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 10)

            // OTP Input Fields
            HStack(spacing: 8) { // Adjust spacing between the fields
                ForEach(0..<viewModel.otp.count, id: \.self) { index in
                    OTPTextField(otp: $viewModel.otp[index], isActive: focusedIndex == index)
                        .focused($focusedIndex, equals: index) // Bind each field to its index
                        .onChange(of: viewModel.otp[index]) { newValue in
                            if newValue.count == 1 { // Automatically move to the next field
                                focusedIndex = index + 1
                            }
                        }
                }
            }
            .padding(.top, 100)

            // Error message if OTP is not complete
            if !viewModel.isComplete {
                Text("Please fill in all OTP fields.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 20)
            }

            // Submit Button
            Button(action: {
                viewModel.submitOTP()
            }) {
                Text("Submit")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
            }
            .background(viewModel.isComplete ? Color.blue : Color.gray)
            .clipShape(Capsule())
            .disabled(!viewModel.isComplete)
            .padding(.top, 290)
            .shadow(radius: 5)

            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .onAppear {
            focusedIndex = 0 // Automatically focus on the first field
        }
    }
}

// OTP Text Field Custom View
struct OTPTextField: View {
    @Binding var otp: String
    var isActive: Bool

    var body: some View {
        TextField("", text: $otp)
            .frame(width: 45, height: 45) // Adjust size of the text fields
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isActive ? Color.blue : Color.gray, lineWidth: 2)
            )
            .cornerRadius(10)
            .onReceive(otp.publisher.collect()) { value in
                if value.count > 1 {
                    otp = String(value.prefix(1)) // Keep only the first character entered
                }
            }
            .disableAutocorrection(true)
            .padding(.horizontal, 5)
            .background(Color.white)
    }
}

// Preview Struct
struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView()
    }
}
