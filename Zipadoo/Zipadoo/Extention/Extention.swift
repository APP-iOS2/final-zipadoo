//
//  Extention.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

// View extension을 위해 import
import CoreLocation
import Foundation
import MapKit
import SwiftUI

// View의 Extension
extension View {
    /// View에서 키보드 숨기는 함수
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// 약속 장소 도착시 띄워주는 Alert
    func arrivalMessageAlert (isPresented: Binding<Bool>, arrival: ArrivalMsgModel) -> some View {
        return modifier(ArrivalMessagingModifier(isPresented: isPresented, arrival: arrival)
        )
    }
    
    func profileImageModifier() -> some View {
        self.modifier(ImageStyleModifier())
    }
    
    /// 뷰의 cornerRadius 각 마다 따로주기
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    /// 로그인뷰 상단 빈 공간
    func spacerView(_ height: CGFloat) -> some View {
        Spacer()
            .frame(height: height)
    }
    
    /// TextField 언더라인 뷰
    func underLine() -> some View {
        Rectangle().frame(height: 1)
            .foregroundStyle(Color.secondary)
            .padding(.bottom, 5)
    }
    
    /// 로그인뷰 TextField 뷰
    func loginTextFieldView(_ text: Binding<String>, _ hint: String, isvisible: Bool) -> some View {
        VStack {
            // 보이는 TextField라면
            if isvisible == true {
                TextField(hint, text: text, prompt: Text(hint)
                    .foregroundColor(.secondary.opacity(0.7)))
            } else {
                SecureField(hint, text: text, prompt: Text(hint)
                    .foregroundColor(.secondary.opacity(0.7)))
            }
        }
        .font(.title3)
        .fontWeight(.semibold)
        .autocapitalization(.none) // 소문자로 시작
        .frame(height: 35)
    }
    
    /// TextFiled 내용 지우는 버튼
    func eraseButtonView(_ text: Binding<String>) -> some View {
        Button {
            text.wrappedValue = ""
        } label: {
            Image(systemName: "x.circle.fill")
        }
        .foregroundColor(Color.primary.opacity(0.4))
    }
    
    /// 현재시간 기준으로 추적중인지 추적중이 아닌지 판단
    func classifyTime(promiseDate: Date, afterThreeHourTime: Date) -> TimeType {
        // 현재 시간을 가져오기
        let currentTime = Date()

        if Calendar.current.dateComponents([.second], from: currentTime, to: afterThreeHourTime).second ?? 0 > 0 {
            return .traking // 아직 지각 아닌 시간대
        } else {
            return .endTracking
        }
    }
     
}

/// 회원가입 유효성 검사함수 포함
extension LoginEmailCheckView {
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

}
/// 참여자들의 도착상태 enum
extension ArriveResultView {
    enum Result {
        case notLate
        case late
        case notArrive
    }
}

extension PromiseDetailProgressBarView {
    /// 현재 거리 비율을 계산하여 반환하는 함수
    func distanceRatio(depature: Double, arrival: Double) -> Double {
        let current: Double = arrival - depature
        var remainingDistance: Double = current / arrival
        
        // 만약 remainingDistance가 0보다 작다면 그냥 0을 반환
        if remainingDistance < 0 {
            remainingDistance = 0
        }
        // 현재거리/총거리 비율
        return remainingDistance
    }
    
    /// 두 지점 간의 직선 거리를 계산하는 함수
    func straightDistance(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
        let z: Double = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))
        return z
    }
    
    /// 현재 위치와 목적지 간의 비율을 계산하는 함수
    func calculateRatio(location: Location) -> Double {
        let totalDistance = straightDistance(x1: location.departureLatitude, y1: location.departureLongitude, x2: promise.latitude, y2: promise.longitude)
        let remainingDistance = straightDistance(x1: location.currentLatitude, y1: location.currentLongitude, x2: promise.latitude, y2: promise.longitude)
        return distanceRatio(depature: remainingDistance, arrival: totalDistance)
    }
    
    /// 지구가 원이라고 가정할 때, 각도를 라디안으로 변환하는 함수
    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    /// 두 지점 간의 거리를 미터로 계산하는 함수
    func calculateDistanceInMeters(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
        let earthRadius = 6371000.0 // 지구의 반경 (미터)
        
        let lat1 = degreesToRadians(x1)
        let lon1 = degreesToRadians(y1)
        let lat2 = degreesToRadians(x2)
        let lon2 = degreesToRadians(y2)
        
        let dLat = lat2 - lat1
        let dLon = lon2 - lon1
        
        let a = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        let distance = earthRadius * c
        return distance
    }
    
    /// 미터 단위의 거리를 형식화하여 문자열로 반환하는 함수
    func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            let distanceInKilometers = distance / 1000.0
            return String(format: "%.2f km", distanceInKilometers)
        }
    }
    
    /// 약속시간 도달여부를 확인하는 함수
    func calculateTimeRemaining(targetTime: Double) -> Bool {
        // 현재 시간을 가져오기
        let currentTime = Date().timeIntervalSince1970
        // 목표 시간과 현재 시간의 차이 계산
        let timeDifference = targetTime - currentTime
        
        // 시간이 지났는지 여부를 반환
        if timeDifference <= 0 {
            // 약속 시간이 이미 지났음
            return true
        } else {
            // 아직 약속 시간이 남아있음
            return false
        }
    }
}

extension PromiseTitleAndTimeView {
    /// 남은 시간을 계산하여 문자열로 반환하는 함수
    ///
    /// - Parameters:
    ///   - targetTime: 목표 시간 (Unix Timestamp)
    /// - Returns: 계산된 시간 문자열
    func calculateTimeRemaining(targetTime: Double) -> String {
        // 현재 시간
        let currentTime = Date().timeIntervalSince1970
        // 목표 시간과의 차이
        let timeDifference = targetTime - currentTime
        
        // 시간이 이미 지났을 경우
        if timeDifference <= 0 {
            return "Time has expired"
        } else {
            // 남은 일, 시, 분, 초 계산
            let days = Int(timeDifference / 86400)
            let hours = Int((timeDifference.truncatingRemainder(dividingBy: 86400) / 3600))
            let minutes = Int((timeDifference.truncatingRemainder(dividingBy: 3600) / 60))
            let seconds = Int(timeDifference.truncatingRemainder(dividingBy: 60))
            
            // 남은 일수가 있을 경우
            if days > 0 {
                return String(format: "%d일 %02d시 %02d분 %02d초", days, hours, minutes, seconds)
            } else {
                // 일수가 없는 경우
                return String(format: "%02d시 %02d분 %02d초", hours, minutes, seconds)
            }
        }
    }
}
