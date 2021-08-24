//
//  DetailView.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Button(action: {
                    bleManager.disconnectPeripheral()
                    bleManager.stopScan()
                }) {
                    bleManager.UIButtonView(proxy: proxy, text: "切断する")
                }
                
                Text(bleManager.isBlePower ? "" : "Bluetooth設定がOFFです")
                    .padding(10)
                
                List {
                    CharacteriticCells()
                }
                .navigationBarTitle("コネクト結果")
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    struct CharacteriticCells: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        
        var body: some View {
            ForEach(0..<bleManager.foundServices.count, id: \.self) { num in
                Section(header: Text("\(bleManager.foundServices[num].uuid.uuidString)")) {
                    ForEach(0..<bleManager.foundCharacteristics.count, id: \.self) { j in
                        if bleManager.foundServices[num].uuid == bleManager.foundCharacteristics[j].service.uuid {
                            Button(action: {
                                //write action
                            }) {
                                VStack {
                                    HStack {
                                        Text("uuid: \(bleManager.foundCharacteristics[j].uuid.uuidString)")
                                            .font(.system(size: 14))
                                            .padding(.bottom, 2)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("description: \(bleManager.foundCharacteristics[j].description)")
                                            .font(.system(size: 14))
                                            .padding(.bottom, 2)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("value: \(bleManager.foundCharacteristics[j].readValue)")
                                            .font(.system(size: 14))
                                            .padding(.bottom, 2)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
