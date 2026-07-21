//
//  username_tests.swift
//  should-i-really
//
//  Created by Michael David Sin on 21/07/26.
//

import Testing
@testable import should_i_really

@MainActor
struct UsernameValidationTests {
    let gameViewModel: GameViewModel
    
    init() {
        gameViewModel = GameViewModel()
    }
    
    // MARK: - 1. Tes Username VALID (Return True)
    @Test(
        "Username valid harus diterima",
        arguments: [
            "a",
            "abcdefghijklmnop",
            "user123",
            "john_doe",
            "john.doe",
            "a_b.c_d"
        ]
    )
    func testValidUsernames(validUsername: String) {
        let result = gameViewModel.isValidUsername(validUsername)
        #expect(result == true, "Username '\(validUsername)' VALID")
    }
    
    // MARK: - 2. Tes Username INVALID (Return False)
    @Test(
        "Username invalid harus ditolak",
        arguments: [
            "",
            "abcdefghijklmnopq",
            "0",
            "john..doe",
            "john__doe",
            "john._doe",
            "john_.doe",
            "john@doe",
            "john#doe",
            "john doe"            
        ]
    )
    func testInvalidUsernames(invalidUsername: String) {
        let result = gameViewModel.isValidUsername(invalidUsername)
        #expect(result == false, "Username '\(invalidUsername)' INVALID")
    }
}
