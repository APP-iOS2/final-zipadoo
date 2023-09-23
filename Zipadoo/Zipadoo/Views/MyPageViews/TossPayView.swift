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
    @State private var myPotato: Int = 10
    @State private var payMethod: String = "카드"
    
    @Binding var isShownFullScreenCover: Bool
    
    private let payButtonValues: [String] = ["₩1,000", "₩5,000", "₩10,000", "₩50,000", "₩100,000"]
    let potatoes: String = "현재 보유한 감자"
    private let payCount: [Int] = [100, 500, 1000, 5000, 10000]
    
    var paymentInfoLabelText: String {
        """
        주문정보:
        \(paymentInfo.orderedInfo)
        """
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text(potatoes)
                            .bold()
                            .font(.title3)
                        Spacer()
                        Text("\(myPotato)개")
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    Divider()
                    
                    HStack {
                        Text("결제 방법")
                            .bold()
                            .font(.title3)
                        Spacer()
                        Text("카드결제")
                    }
                    .padding(.top, 30)
                    
                    HStack {
                        Image(systemName: "info.circle")
                        Text("다양한 결제 서비스 준비중입니다.")
                    }
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                    
                    ForEach(Array(zip(payButtonValues, payCount)), id: \.0) { value, count in
                        selectPotatoCount(value: value, count: count)
                        Divider()
                    }
                    .padding(.top, 3)
                    .padding(.bottom, 3)
                    
                }
                .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("감자농장")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShownFullScreenCover.toggle()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .renderingMode(.template)
                            .foregroundColor(.black)
                            .opacity(0.5)
                    }
                }
            }
        }
    }
    
    func selectPotatoCount(value: String, count: Int) -> some View {
        return
        HStack {
            Text("감자 \(count)개")
            Spacer()
            Button(action: {
                showingTossPayments.toggle()
            }, label: {
                Text("\(value)")
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 40)
                    .background(.blue)
                    .cornerRadius(5)
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
            })
        }
    }
}

#Preview {
    TossPayView(isShownFullScreenCover: .constant(false))
}

#endif
