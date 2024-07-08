//
//  WalletStatusPanel.swift
//
//
//  Created by Lukáš Korba on 18.12.2023.
//

import SwiftUI
import ComposableArchitecture
import Generated
import Combine

public enum WalletStatus: Equatable {
    case none
    case restoring
    case disconnected
    
    public func text() -> String {
        switch self {
        case .restoring: return L10n.WalletStatus.restoringWallet
        case .disconnected: return L10n.WalletStatus.disconnected
        default: return ""
        }
    }
}

public struct WalletStatusPanelModifier: ViewModifier {
    public enum Background {
        case pattern
        case solid
        case transparent
    }
    
    let hidden: Bool
    let background: Background
    @Shared(.inMemory(.walletStatus)) public var walletStatus: WalletStatus = .none

    public func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .zIndex(0)
            
            if walletStatus != .none && !hidden {
                if background == .pattern {
                    WalletStatusPanel(text: walletStatus.text())
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 6)
                        .background(
                            Asset.Assets.gridTile.image
                                .resizable(resizingMode: .tile)
                        )
                        .zIndex(1)
                } else {
                    WalletStatusPanel(text: walletStatus.text())
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 6)
                        .background(
                            background == .transparent
                            ? .clear
                            : Asset.Colors.background.color
                        )
                        .zIndex(1)
                }
            }
        }
    }
}

extension View {
    public func walletStatusPanel(
        _ hidden: Bool = false,
        background: WalletStatusPanelModifier.Background = .solid
    ) -> some View {
        modifier(
            WalletStatusPanelModifier(hidden: hidden, background: background)
        )
    }
}

private struct WalletStatusPanel: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom(FontFamily.Archivo.semiBold.name, size: 12))
            .foregroundStyle(Asset.Colors.restoreUI.color)
    }
}

#Preview {
    NavigationView {
        ScrollView{
            Text("Hello, World")
        }
        .padding(.vertical, 1)
        .walletStatusPanel()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Text("M")
        )
        .zashiTitle {
            Text("Title")
        }
    }
}
