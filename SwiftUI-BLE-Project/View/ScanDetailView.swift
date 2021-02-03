//
//  ScanDetailView.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import SwiftUI

struct ScanDetailView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    
    @Binding var isRootViewActive: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                isRootViewActive = false
                bleManager.disconnectPeripheral()
                bleManager.stopScan()
            }) {
                UIButtonView(text: "切断する")
            }
            
            Text(bleManager.isBluePowerOn ? "" : "Bluetooth設定がOFFです")
                .padding(10)
            
            CharacteriticCells()
       
            .navigationBarTitle("コネクト結果")
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
    
    struct CharacteriticCells: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        
        var body: some View {
            List {
                ForEach(0..<bleManager.foundService.count, id: \.self) { num in
                    Section(header: Text("\(bleManager.foundService[num].uuid.uuidString)")) {
                        ForEach(0..<bleManager.foundCharacteristic.count, id: \.self) { j in
                            if bleManager.foundService[num].uuid == bleManager.foundCharacteristic[j].service.uuid {
                                Button(action: {
                                    //write action
                                }) {
                                    VStack {
                                        HStack {
                                            Text("uuid: \(bleManager.foundCharacteristic[num].uuid.uuidString)")
                                                .font(.system(size: 14))
                                                .padding(.bottom, 2)
                                            Spacer()
                                        }
                                        
                                        HStack {
                                            Text("description: \(bleManager.foundCharacteristic[num].description)")
                                                .font(.system(size: 14))
                                                .padding(.bottom, 2)
                                            Spacer()
                                        }
                                        HStack {
                                            Text("value: \(bleManager.foundCharacteristic[num].readValue)")
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
}
