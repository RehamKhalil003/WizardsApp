//
//  CustomListCell.swift
//  WizardsApp
//
//  Created by Reham Khalil on 04/10/2024.
//

import SwiftUI

struct CustomListCell: View {
    let imageName: String
    let text: String
    let destination: AnyView // To allow flexibility in destination view navigation

    var body: some View {
        ZStack {
            // Background View with Corner Radius and Shadow
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white) // Table cell background color set to white
                .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 0, y: 5) // Shadow for the card effect

            // Content (Image and Text) inside the rounded and shadowed background
            NavigationLink(destination: destination) {
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .background(Color.clear)
                        .clipShape(Circle())

                    Text(text)
                        .bold()
                        .foregroundColor(.black)
                        .frame(height: 50)
                }
                .padding(10)
            }
            .padding(5)  // Add padding inside the row to avoid clipping with corner radius
        }
        .padding(.vertical, 5) // Padding between list items
        .listRowBackground(Color.white)  // Ensures the row background is white
        .listRowSeparator(.hidden)  // Remove default row separator
    }
}
