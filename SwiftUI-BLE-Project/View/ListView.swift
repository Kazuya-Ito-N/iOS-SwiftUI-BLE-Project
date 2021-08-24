//
//  ListView.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel

    var body: some View {
        ZStack {
            bleManager.navigationToDetailView(isDetailViewLinkActive: $bleManager.isConnected)
            
            GeometryReader { proxy in
                VStack {
                    if !bleManager.isSearching {
                        Button(action: {
                            if bleManager.isSearching {
                                bleManager.stopScan()
                            } else {
                                bleManager.startScan()
                            }
                        }) {
                            bleManager.UIButtonView(proxy: proxy,
                                                    text: bleManager.isSearching ? "スキャンを停止する" : "スキャンを開始する")
                        }
                        
                        Text(bleManager.isBlePower ? "" : "Bluetooth設定がOFFです")
                            .padding(10)
                        
                        List {
                            PeripheralCells()
                        }
                        
                        
                    } else {
                        //first stack
                        Color.gray.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)
                        ZStack {
                            VStack {
                                ProgressView()
                            }
                            VStack {
                                Spacer()
                                Button(action: {
                                    bleManager.stopScan()
                                }) {
                                    Text("スキャンを停止する")
                                        .padding()
                                }
                            }
                        }
                        .frame(width: proxy.size.width / 2,
                               height: proxy.size.width / 2,
                               alignment: .center)
                        .background(Color.gray.opacity(0.5))
                    }
                }
            }
        }
        .navigationBarTitle("SwiftUI-BLE")
    }
    
    struct PeripheralCells: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        
        var body: some View {
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
