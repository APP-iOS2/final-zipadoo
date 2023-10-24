//
//  Validation.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/10/05.
//

import Foundation

/// 이메일 유효한 형식인지 확인
func isCorrectEmail(email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

    return emailPredicate.evaluate(with: email)
}

/// 닉네임 유효한 형식 확인
func isCorrectNickname(nickname: String) -> Bool {
    let nicknameRegex = "[a-zA-Z0-9가-힣]{2,6}"
    let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
    
    return nicknamePredicate.evaluate(with: nickname)
}

/// 전화번호 유효한 형식 확인
func isCorrectPhoneNumber(phonenumber: String) -> Bool {
    let passwordRegex = "01([0-9])([0-9]{3,4})([0-9]{4})$"
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

    return passwordPredicate.evaluate(with: phonenumber)
}

/// 비밀번호 유효한 형식 확인
func isCorrectPassword(password: String) -> Bool {
//        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{6,16}$"
    let passwordRegex = ".{6,15}$" // 6 ~ 15 자리
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

    return passwordPredicate.evaluate(with: password)
}
