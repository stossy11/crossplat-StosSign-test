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

func run2() async throws {
    print("Hello, world!")
    
    let anisetteData: AnisetteData
#if canImport(MacAnisette)
    let dict = AOSKit.getAnisetteData()
    
    let jsonData = try! JSONSerialization.data(withJSONObject: dict ?? [], options: [])
    
    anisetteData = try! JSONDecoder().decode(AnisetteData.self, from: jsonData)
    #else
    
    anisetteData = try await AnisetteManager.shared.getAnisetteData()
    
    #endif
    
    let account = CommandLine.arguments[1]
    let password = CommandLine.arguments[2]
    
    
    print("Attempting to Authenticate with email: \(account), password: \(password.count)")
    
    let (accountResponse, appleAPISession) = try await Authentication.authenticate(
        appleID: account,
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

Task {
    do {
        try await run2()
    } catch {
        print("\(error)")
    }
}

RunLoop.current.run()

