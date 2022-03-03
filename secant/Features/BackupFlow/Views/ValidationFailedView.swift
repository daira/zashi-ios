//
//  ValidationFailed.swift
//  secant-testnet
//
//  Created by Francisco Gindre on 12/22/21.
//

import SwiftUI
import ComposableArchitecture

struct ValidationFailedView: View {
    var store: RecoveryPhraseValidationStore

    var body: some View {
        WithViewStore(store) { viewStore in
            GeometryReader { proxy in
                VStack {
                    VStack(alignment: .center, spacing: 20) {
                        Text("validationFailed.title")
                            .font(.custom(FontFamily.Rubik.regular.name, size: 30))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.bottom, 20)

                    CircularFrame()
                        .backgroundImage(
                            Asset.Assets.Backgrounds.callout1.image
                        )
                        .frame(
                            width: proxy.size.width * 0.84,
                            height: proxy.size.width * 0.84
                        )
                        .badgeIcon(.error)

                    Spacer()

                    VStack(alignment: .center, spacing: 40) {
                        VStack(alignment: .center, spacing: 20) {
                            Text("validationFailed.description")
                                .bodyText()
                                .fixedSize(horizontal: false, vertical: true)

                            Text("validationFailed.incorrectBackupDescription")
                                .bodyText()
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Button(
                            action: { viewStore.send(.reset) },
                            label: { Text("validationFailed.button.tryAgain") }
                        )
                        .activeButtonStyle
                        .frame(height: 60)
                    }
                    .padding()
                    
                    Spacer()
                }
                .frame(width: proxy.size.width)
                .scrollableWhenScaledUp()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .applyErredScreenBackground()
        }
    }
}

struct ValidationFailed_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ValidationFailedView(store: .demo)

            ValidationFailedView(store: .demo)
                .environment(\.sizeCategory, .accessibilityLarge)
        }
    }
}