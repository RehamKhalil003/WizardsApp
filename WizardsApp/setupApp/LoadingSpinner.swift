//
//  LoadingSpinner.swift
//  WizardsApp
//
//  Created by Reham Khalil on 04/10/2024.
//

import Foundation
import SwiftUI

struct LoadingSpinner: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
            .scaleEffect(1.5)
            .frame(width: 200, height: 200)
    }
}

