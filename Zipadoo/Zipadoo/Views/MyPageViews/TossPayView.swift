//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by 김진규 on 2022/09/27.
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
    
    let potatos: String = "현재 보유한 감자"
    @State private var myPotato: Int = 1000
    
    struct PayButton {
        let payCount: String
        let payButtonValue: String
    }
    
    let payButtonArray: [PayButton] = [
        PayButton(payCount: "감자 100개", payButtonValue: "₩1,000"),
        PayButton(payCount: "감자 500개", payButtonValue: "₩5,000"),
        PayButton(payCount: "감자 1000개", payButtonValue: "₩10,000"),
        PayButton(payCount: "감자 5000개", payButtonValue: "₩50,000"),
        PayButton(payCount: "감자 10000개", payButtonValue: "₩100,000")
    ]
    
    @Binding var isShownFullScreenCover: Bool
    
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
                    HStack {
                        Image("potato")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 23, height: 20)
                        
                        Text(potatos)
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
                    
                    ForEach(payButtonArray, id: \.payCount) { payButton in
                        HStack {
                            Image("potato")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 23, height: 20)
                            
                            Text("\(payButton.payCount)")
                            
                            Spacer()
                            
                            Button(action: {
                                showingTossPayments.toggle()
                            }, label: {
                                Text("\(payButton.payButtonValue)")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 40)
                                    .background(.blue)
                                    .cornerRadius(5)
                            })
                        }
                        Divider()
                    }
                    .padding(.top, 3)
                    .padding(.bottom, 3)
                    
                    Button(action: {
                        showingTossPayments.toggle()
                    }, label: {
                        Text("")
                            .foregroundColor(.white)
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
                            let nickNameMessage = """
                                              onSuccess
                                              paymentKey: \(paymentKey)
                                              orderId: \(orderId)
                                              amount: \(amount)
                                              """
                            resultInfo = (title, nickNameMessage)
                            showingResultAlert = true
                        }
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
                            showingResultAlert = true
                        }
                    })
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
}

#Preview {
    TossPayView(isShownFullScreenCover: .constant(false))
}

#endif
