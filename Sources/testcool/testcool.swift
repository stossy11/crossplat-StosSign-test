// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import StosSign_Auth
#if canImport(MacAnisette)
import MacAnisette
#endif
import SwiftCrossUI
import DefaultBackend

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    
    @State var error: String = ""
    
    @State var showAlert = false
    
    var body: some View {
        VStack {
            TextField("Email", text: $username)
            
            TextField("Password", text: $password)
            
            Button("Login") {
                Task {
                    do {
                        try await self.login()
                    } catch {
                        self.error = "\(error)"
                        self.showAlert = true
                    }
                }
            }
        }
        .alert("Error:\n \(error)", isPresented: $showAlert) {
            
            Button("OK") {
                
            }
        }
    }
    
    
    func login() async throws {
        
        let anisetteData: AnisetteData
    #if canImport(MacAnisette)
        let dict = AOSKit.getAnisetteData()
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dict ?? [], options: [])
        
        anisetteData = try! JSONDecoder().decode(AnisetteData.self, from: jsonData)
        #else
        
        anisetteData = try await AnisetteManager.shared.getAnisetteData()
        
        #endif
        
        
        print("Attempting to Authenticate with email: \(username), password: \(password.count)")
        
        let (accountResponse, appleAPISession) = try await Authentication.authenticate(
            appleID: username,
            password: password,
            anisetteData: anisetteData
        ) { verificationHandler in
            print("Enter your verification code:")
            if let code = readLine()?.trimmingCharacters(in: .whitespaces), !code.isEmpty {
                verificationHandler(code)
            } else {
                print("Invalid input")
                verificationHandler(nil)
            }
        }
        
        print("Authentication successful!")
        print("Name: \(accountResponse.firstName) \(accountResponse.lastName)")

        
        
    }
}
