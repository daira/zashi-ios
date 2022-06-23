//
//  TransactionState.swift
//  secant-testnet
//
//  Created by Lukáš Korba on 26.04.2022.
//

import Foundation
import ZcashLightClientKit

/// Representation of the transaction on the SDK side, used as a bridge to the TCA wallet side. 
struct TransactionState: Equatable, Identifiable {
    enum Status: Equatable {
        case paid(success: Bool)
        case received
        case failed
    }

    var expirationHeight = -1
    var memo: String?
    var minedHeight = -1
    var shielded = true
    var zAddress: String?

    var id: String
    var status: Status
    var subtitle: String
    var timestamp: TimeInterval
    var zecAmount: Zatoshi
    
    var address: String { zAddress ?? "" }
}

extension TransactionState {
    init(confirmedTransaction: ConfirmedTransactionEntity, sent: Bool = false) {
        timestamp = confirmedTransaction.blockTimeInSeconds
        id = confirmedTransaction.transactionEntity.transactionId.toHexStringTxId()
        shielded = true
        status = sent ? .paid(success: confirmedTransaction.minedHeight > 0) : .received
        subtitle = "sent"
        zAddress = confirmedTransaction.toAddress
        zecAmount = sent ? Zatoshi(amount: -Int64(confirmedTransaction.value)) : Zatoshi(amount: Int64(confirmedTransaction.value))
        if let memo = confirmedTransaction.memo {
            self.memo = memo.asZcashTransactionMemo()
        }
        minedHeight = confirmedTransaction.minedHeight
    }
    
    init(pendingTransaction: PendingTransactionEntity, latestBlockHeight: BlockHeight? = nil) {
        timestamp = pendingTransaction.createTime
        id = pendingTransaction.rawTransactionId?.toHexStringTxId() ?? String(pendingTransaction.createTime)
        shielded = true
        status = .paid(success: pendingTransaction.isSubmitSuccess)
        expirationHeight = pendingTransaction.expiryHeight
        subtitle = "pending"
        zAddress = pendingTransaction.toAddress
        zecAmount = Zatoshi(amount: -Int64(pendingTransaction.value))
        if let memo = pendingTransaction.memo {
            self.memo = memo.asZcashTransactionMemo()
        }
        minedHeight = pendingTransaction.minedHeight
    }
}

// MARK: - Placeholders

extension TransactionState {
    static func placeholder(
        amount: Zatoshi,
        shielded: Bool = true,
        status: Status = .received,
        subtitle: String = "",
        timestamp: TimeInterval,
        uuid: String = UUID().debugDescription
    ) -> TransactionState {
        .init(
            expirationHeight: -1,
            memo: nil,
            minedHeight: -1,
            shielded: shielded,
            zAddress: nil,
            id: uuid,
            status: status,
            subtitle: subtitle,
            timestamp: timestamp,
            zecAmount: status == .received ? amount : Zatoshi(amount: -amount.amount)
        )
    }
}

struct TransactionStateMockHelper {
    var date: TimeInterval
    var amount: Zatoshi
    var shielded = true
    var status: TransactionState.Status = .received
    var subtitle = "cleared"
    var uuid = ""
}
