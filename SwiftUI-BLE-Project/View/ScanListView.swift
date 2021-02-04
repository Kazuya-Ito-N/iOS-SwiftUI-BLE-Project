//
//  ScanListView.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import SwiftUI

struct ScanListView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel

    var body: some View {
        VStack {
            NavigationLink("", destination: ScanDetailView(isRootViewActive: $bleManager.isConnected),
                           isActive: $bleManager.isConnected)
            
            Button(action: {
                if bleManager.isSearching {
                    bleManager.stopScan()
                } else {
                    bleManager.startScan()
                }
            }) {
                UIButtonView(text: bleManager.isSearching ? "スキャンを停止する" : "スキャンを開始する")
            }
            
            Text(bleManager.isBlePower ? "" : "Bluetooth設定がOFFです")
                .padding(10)
            
            PeripheralCells()
       
            .navigationBarTitle("SwiftUI-BLE")
        }
    }
    
    struct UIButtonView: View {
        var text: String
        
        var body: some View {
            Text(text)
                .frame(width: 350, height: 50, alignment: .center)
                .foregroundColor(Color.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2))
        }
    }
    
    struct PeripheralCells: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        
        var body: some View {
            List {
                ForEach(0..<bleManager.foundPeripherals.count, id: \.self) { num in
                    Button(action: {
                        bleManager.connectPeripheral(bleManager.foundPeripherals[num])
                    }) {
                        HStack {
                            Text("\(bleManager.foundPeripherals[num].name)")
                            Spacer()
                            Text("\(bleManager.foundPeripherals[num].rssi) dBm")
                        }
                    }
                }
            }
        }
    }
}
