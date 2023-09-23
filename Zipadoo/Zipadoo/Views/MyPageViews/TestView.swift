//
//  TestView.swift
//  Zipadoo
//
//  Created by 나예슬 on 2023/09/22.
//

#if !os(macOS) && canImport(SwiftUI)
import SwiftUI
import TossPayments

private enum Constants {
    static let clientKey: String = "test_ck_D5GePWvyJnrK0W0k6q8gLzN97Eoq"
    static let 테스트결제정보: PaymentInfo = DefaultPaymentInfo(
        amount: 1000,
        orderId: "9lD0azJWxjBY0KOIumGzH",
        orderName: "토스 티셔츠 외 2건",
        customerName: "박토스"
    )
}

struct TestView: View {
    @State private var showingSuccess: Bool = false
    @State private var showingFail: Bool = false
    
    @StateObject
    var viewModel = PaymentContentModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                PaymentMethodWidgetView(widget: viewModel.widget, amount: PaymentMethodWidget.Amount(value: 1000))
                AgreementWidgetView(widget: viewModel.widget)
            }
        }
        Button("결제하기") {
            viewModel.requestPayment(info: DefaultWidgetPaymentInfo(orderId: "123", orderName: "김토스"))
        }
        .alert(isPresented: $showingSuccess, content: {
            Alert(title: Text(verbatim: "Success"), message: Text(verbatim: viewModel.onSuccess?.orderId ?? ""))
        })
        .alert(isPresented: $showingFail, content: {
            Alert(title: Text(verbatim: "Fail"), message: Text(verbatim: viewModel.onFail?.orderId ?? ""))
        })
        .onReceive(viewModel.$onSuccess.compactMap { $0 }) { success in
            showingSuccess = true
        }
        .onReceive(viewModel.$onFail.compactMap { $0 }) { fail in
            showingFail = true
        }
    }
}

#endif

#Preview {
    TestView()
}
