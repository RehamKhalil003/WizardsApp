//
//  WizardsAppApp.swift
//  WizardsApp
//
//  Created by Reham Khalil on 02/10/2024.
//

import SwiftUI
import CoreData

struct WizardContentView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var wizardsViewModel: WizardViewModel
    @State private var animatedItems: [Bool] = []
    @Namespace var animationNamespace

    @State private var hasLoadedData: Bool = false

    init() {
        self._wizardsViewModel = StateObject(wrappedValue: WizardViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        ZStack {
            BaseContentView() {
                VStack {
                    if wizardsViewModel.isLoading {
                        LoadingSpinner()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(wizardsViewModel.wizards.indices, id: \.self) { index in
                                CustomListCell(
                                    imageName: "defaultImage",
                                    text: "\(wizardsViewModel.wizards[index].firstName ?? "") \(wizardsViewModel.wizards[index].lastName ?? "")",
                                    destination: AnyView(
                                        ElixirContentView(
                                            wizardId: wizardsViewModel.wizards[index].id ?? "118e7366-1c65-4275-8121-8f6c553e5783",
                                            wizardName: "\(wizardsViewModel.wizards[index].firstName ?? "") \(wizardsViewModel.wizards[index].lastName ?? "")"
                                        )
                                    )
                                )
                                .matchedGeometryEffect(id: wizardsViewModel.wizards[index].id, in: animationNamespace)
                                .offset(x: animatedItems.indices.contains(index) && animatedItems[index] ? 0 : -UIScreen.main.bounds.width)
                                .animation(
                                    .easeOut(duration: 0.5)
                                    .delay(Double(index) * 0.1), value: animatedItems.indices.contains(index) ? animatedItems[index] : false
                                )
                            }
                        }
                        .background(Color.white)
                        .scrollContentBackground(.hidden)
                        .listStyle(PlainListStyle())
                    }
                }
                .onAppear {
                    if !hasLoadedData {
                        loadWizardData()
                        hasLoadedData = true
                    }
                }
            }
            
            ToastMessage(message: wizardsViewModel.toastMessage, isShowing: $wizardsViewModel.showToast)
        }
    }

    private func loadWizardData() {
        wizardsViewModel.getWizardList {
            animatedItems = Array(repeating: false, count: wizardsViewModel.wizards.count)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                for index in wizardsViewModel.wizards.indices {
                    animatedItems[index] = true
                }
            }
        }
    }
}
