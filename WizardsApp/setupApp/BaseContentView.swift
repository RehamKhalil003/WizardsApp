//
//  WizardContentView.swift
//  WizardsApp
//
//  Created by Reham Khalil on 02/10/2024.
//

import SwiftUI

struct BaseContentView<Content: View>: View {
    var title: String
    var backgroundColor: Color = .white
    var showBackButton: Bool = true
    var content: Content
    
    @Environment(\.presentationMode) var presentationMode
    
    init(title: String = "", backgroundColor: Color = .white, showBackButton: Bool = true, @ViewBuilder content: () -> Content) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.showBackButton = showBackButton
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                content
                    .padding(.horizontal , 0)
                    .padding(.vertical , 0)
                    .padding(.top , 0)
                    .padding(.bottom , 0)
            }
            //            .background(backgroundColor)
            //            .navigationBarTitle(title, displayMode: .inline)
//            .toolbar {
                //                if showBackButton == true {
                //                    ToolbarItem(placement: .navigationBarLeading) {
                //                        Button(action: {
                //                            presentationMode.wrappedValue.dismiss()
                //                        }) {
                //                            Image("Back_Button")
                //                        }
                //                    }
                //                }
                
                //                ToolbarItem(placement: .principal) {
                //                    Text(title)
                //                        .font(.system(size: 25))
                //                        .foregroundColor(.black)
                //                        .bold()
                //                }
                //            }
                .toolbarColorScheme(.light, for: .automatic)
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(StackNavigationViewStyle())
//            }
        }
    }
}
