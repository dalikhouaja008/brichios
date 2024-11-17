import SwiftUI

struct SignUp : View {
    @State var username = ""
    @State var mail = ""
    @State var pass = ""
    @State var repass = ""
    @State var passwordError = ""
    @State var usernameError = ""
    @State var mailerror = ""
    @State private var showPassword: Bool = false
    
    var body : some View{
        
        VStack{
            
            VStack{
                HStack(spacing: 13){
                    
                    Image(systemName:"person.crop.circle.fill")
                        .foregroundColor(.black)
                    
                    TextField("Enter your name", text: self.$mail)
                    
                }.padding(.vertical, 13)
                Divider()
                HStack(spacing: 15){
                    
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    
                    TextField("Enter Email Address", text: self.$mail)
                    
                }.padding(.vertical, 13)
                
                Divider()
                HStack(spacing: 15){
                    
                    Image(systemName:"phone")
                        .foregroundColor(.black)
                    
                    TextField("Enter your phone number", text: self.$mail)
                    
                }.padding(.vertical, 20)
                Divider()
                HStack(spacing: 15){
                    
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    
                    if showPassword {
                        TextField("Password", text: $pass)
                           
                    } else {
                        SecureField("Password", text: $pass)
                           
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .foregroundColor(Color.gray)
                    }
                    .padding(.trailing, 16)
                    
                }.padding(.vertical, 20)
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    
                    if showPassword {
                        TextField("Confirm password", text: $repass)
                           
                    } else {
                        SecureField("Confirm password", text: $repass)
                           
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .foregroundColor(Color.gray)
                    }
                    .padding(.trailing, 16)
                    
                }.padding(.vertical, 20)
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 25)
            
            
            Button(action: {
                
            }) {
                
                Text("SIGNUP")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                
            }.background(
            
                Color.red
            )
            .cornerRadius(8)
            .offset(y: -40)
            .padding(.bottom, -40)
            .shadow(radius: 15)
        }
    }


    // Validation function for the sign-up form
    func validateSignUp() -> Bool {
        var isValid = true
        
        if username.isEmpty {
            usernameError = "Username cannot be empty."
            isValid = false
        } else {
            usernameError = ""
        }
        
        if mail.isEmpty || !mail.contains("@") {
            mailerror = "Please enter a valid email address."
            isValid = false
        } else {
            mailerror = ""
        }
        
        if pass.isEmpty || pass.count < 6 {
            passwordError = "Password must be at least 6 characters."
            isValid = false
        } else {
            passwordError = ""
        }
        
        return isValid
    }
}
