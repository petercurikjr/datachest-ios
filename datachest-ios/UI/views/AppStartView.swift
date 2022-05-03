//
//  AppStartView.swift
//  datachest-ios
//
//  Created by Peter Čuřík Jr. on 23/04/2022.
//

import SwiftUI

struct AppStartView: View {
    var body: some View {
        ProgressView().padding(5)
        Text("Starting the application...").font(.title3)
    }
}

struct AppStartView_Previews: PreviewProvider {
    static var previews: some View {
        AppStartView()
    }
}
