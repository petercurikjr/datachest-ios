//
//  DatachestButton.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 30/04/2022.
//

import SwiftUI

struct DatachestButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(11)
            .overlay(
                configuration.isPressed
                ?
                    Capsule(style: .continuous).stroke(lineWidth: 0)
                :
                    Capsule(style: .continuous).stroke(lineWidth: 1.1)
            )
    }
}
