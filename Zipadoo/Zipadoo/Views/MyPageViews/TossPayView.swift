//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by 김진규 on 2022/09/27.
//

#if !os(macOS) && canImport(SwiftUI)
import SwiftUI
import TossPayments

// MARK: - 토스 관련 열거형
private enum Constants {
    /// 클라이언트 키
    static let clientKey: String = "test_ck_OyL0qZ4G1VODAxdNWDkroWb2MQYg"
    /// 더미 데이터
    static let 테스트결제정보: PaymentInfo = DefaultPaymentInfo(
        amount: 10000,
        orderId: "9lD0azJWxjBY0KOIumGzH",
        orderName: "감자 100개",
        customerName: "지파두"
    )
}

struct PayButton {
    let payCount: String
    let payButtonValue: String
}

// MARK: - 감자 충전 및 토스페이 팝업창 뷰
struct TossPayView: View {
    // MARK: - 토스 페이 관련 프로퍼티
    
    /// 토스 페이 결제 정보 (메세지 제목, 메세지)
    @State private var resultInfo: (title: String, message: String)?
    /// 토스 페이 결제 정보 (결제수단)
    @State private var paymentMethod: PaymentMethod = .카드
    /// 토스 페이 결제 정보 (결제 안내)
    @State private var paymentInfo: PaymentInfo = Constants.테스트결제정보
    
    // MARK: - 토스페이 뷰 프로퍼티
    /// 토스 페이 결제창 bool 값
    @State private var isShowingTossPayments: Bool = false
    /// 토스 페이 결제 결과 bool 값
    @State private var isShowingResultAlert: Bool = false
    /// 내 감자(더미데이터)
    @State private var myPotatos: Int = 1000
    /// 유저가 보유한 감자
    let myPotatosText: String = "현재 보유한 감자"
    /// 감자 결제 버튼
    let payButtonArray: [PayButton] = [
        PayButton(payCount: "감자 100개", payButtonValue: "₩1,000"),
        PayButton(payCount: "감자 500개", payButtonValue: "₩5,000"),
        PayButton(payCount: "감자 1000개", payButtonValue: "₩10,000"),
        PayButton(payCount: "감자 5000개", payButtonValue: "₩50,000"),
        PayButton(payCount: "감자 10000개", payButtonValue: "₩100,000")
    ]
    /// 마이 페이지 뷰로부터 감자 충전 시트뷰 Bool값
    @Binding var isShownFullScreenCover: Bool
    /// 주문 정보 텍스트
    var labeltext: String {
        """
        주문정보:
        \(paymentInfo.orderedInfo)
        """
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    // MARK: - 내 보유 감자
                    HStack {
                        Image("potato")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 23, height: 20)
                        
                        Text(myPotatosText)
                            .bold()
                            .font(.title3)
                        
                        Spacer()
                        
                        Text("\(myPotatos)개")
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    Divider()
                    // MARK: - 결제 방법
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
                    // MARK: - 감자 결제 버튼 리스트
                    ForEach(payButtonArray, id: \.payCount) { payButton in
                        HStack {
                            Image("potato")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 23, height: 20)
                            
                            Text("\(payButton.payCount)")
                            
                            Spacer()
                            
                            Button {
                                isShowingTossPayments.toggle()
                            } label: {
                                Text("\(payButton.payButtonValue)")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 40)
                                    .background(.blue)
                                    .cornerRadius(5)
                            }
                        }
                        Divider()
                    }
                    .padding(.top, 3)
                    .padding(.bottom, 3)
                }
                .padding(.horizontal, 12)
                // MARK: 토스결제 팝업창
                // 버튼을 추가해야 결제 버튼이 동작했던 않는 이슈 해결
                .popover(isPresented: $isShowingTossPayments, content: {
                    TossPaymentsView(
                        clientKey: Constants.clientKey,
                        paymentMethod: paymentMethod,
                        paymentInfo: paymentInfo,
                        isPresented: $isShowingTossPayments
                    )
                    // 결제창 띄우기 성공시
                    .onSuccess { (paymentKey: String, orderId: String, amount: Int64) in
                        print("onSuccess paymentKey \(paymentKey)")
                        print("onSuccess orderId \(orderId)")
                        print("onSuccess amount \(amount)")
                        let title = "TossPayments 요청에 성공하였습니다."
                        let nickNameMessage = """
                                          onSuccess
                                          paymentKey: \(paymentKey)
                                          orderId: \(orderId)
                                          amount: \(amount)
                                          """
                        resultInfo = (title, nickNameMessage)
                        isShowingResultAlert = true
                    }
                    // 결제창 띄우기 실패시
                    .onFail { (errorCode: String, errorMessage: String, orderId: String) in
                        print("onFail errorCode \(errorCode)")
                        print("onFail errorMessage \(errorMessage)")
                        print("onFail orderId \(orderId)")
                        let title = "TossPayments 요청에 실패하였습니다."
                        let nickNameMessage = """
                                      onFail
                                      errorCode: \(errorCode)
                                      errorMessage: \(errorMessage)
                                      orderId: \(orderId)
                                      """
                        resultInfo = (title, nickNameMessage)
                        isShowingResultAlert = true
                    }
                })
            } // ScrollView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("감자농장")
            .navigationBarTitleDisplayMode(.inline)
            // MARK: - 현재창 닫기 툴바
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
}

#Preview {
    TossPayView(isShownFullScreenCover: .constant(false))
}

#endif
