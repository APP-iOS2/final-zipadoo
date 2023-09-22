//
//  TossPayView.swift
//  Zipadoo
//
//  Created by 나예슬 on 2023/09/22.
//

#if !os(macOS) && canImport(SwiftUI)
import SwiftUI
import TossPayments

private enum Constants {
    static let clientKey: String = "test_ck_OyL0qZ4G1VODAxdNWDkroWb2MQYg"
    static let 테스트결제정보: PaymentInfo = DefaultPaymentInfo(
        amount: 10000,
        orderId: "9lD0azJWxjBY0KOIumGzH",
        orderName: "감자 100개",
        customerName: "지파두"
    )
}

struct TossPayView: View {
    @State private var showingTossPayments: Bool = false
    
    @State private var showingResultAlert: Bool = false
    @State private var resultInfo: (title: String, message: String)?
    
    @State private var paymentMethod: PaymentMethod = .카드
    @State private var paymentInfo: PaymentInfo = Constants.테스트결제정보
    
    var paymentInfoLabelText: String {
        """
        입력한 결제정보:
        \(paymentInfo.orderedInfo)
        """
    }
    
    var body: some View {
        
        Text("뷰 꾸밀 예정~~~")
        
        Text(paymentInfoLabelText)
            .padding()
       
        Button("시작", action: {
            showingTossPayments.toggle()
        })
        .popover(isPresented: $showingTossPayments, content: {
            TossPaymentsView(
                clientKey: Constants.clientKey,
                paymentMethod: paymentMethod,
                paymentInfo: paymentInfo,
                isPresented: $showingTossPayments
            )
            .onSuccess { (paymentKey: String, orderId: String, amount: Int64) in
                print("onSuccess paymentKey \(paymentKey)")
                print("onSuccess orderId \(orderId)")
                print("onSuccess amount \(amount)")
                let title = "TossPayments 요청에 성공하였습니다."
                let message = """
                    onSuccess
                    paymentKey: \(paymentKey)
                    orderId: \(orderId)
                    amount: \(amount)
                    """
                resultInfo = (title, message)
                showingResultAlert = true
            }
            .onFail { (errorCode: String, errorMessage: String, orderId: String) in
                print("onFail errorCode \(errorCode)")
                print("onFail errorMessage \(errorMessage)")
                print("onFail orderId \(orderId)")
                let title = "TossPayments 요청에 실패하였습니다."
                let message = """
                onFail
                errorCode: \(errorCode)
                errorMessage: \(errorMessage)
                orderId: \(orderId)
                """
                resultInfo = (title, message)
                showingResultAlert = true
            }
            .alert(isPresented: $showingResultAlert) {
                Alert(
                    title: Text("\(resultInfo?.title ?? "")"),
                    message: Text("\(resultInfo?.message ?? "")"),
                    primaryButton: .default(Text("확인"), action: {
                        resultInfo = nil
                    }),
                    secondaryButton: .destructive(Text("클립보드에 복사하기"), action: {
                        UIPasteboard.general.string = resultInfo?.message
                        resultInfo = nil
                    })
                )
            }
        })
    }
}

#Preview {
    TossPayView()
}

#endif
