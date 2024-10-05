//
//  ToastMessage.swift
//  WizardsApp
//
//  Created by Reham Khalil on 04/10/2024.
//

import Foundation
import SwiftUI

struct ToastMessage: View {
    let message: String
    let isShowing: Binding<Bool>
    
    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.bottom, 50)
                .animation(.easeInOut)
                .transition(.move(edge: .bottom))
                .opacity(isShowing.wrappedValue ? 1 : 0)
        }
    }
}
