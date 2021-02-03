//
//  SwiftUI_BLE_ProjectApp.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import SwiftUI

@main
struct SwiftUI_BLE_ProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CoreBluetoothViewModel())
        }
    }
}
