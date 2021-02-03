//
//  ContentView.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    
    var body: some View {
        ZStack {
            //second stack
            VStack {
                NavigationView {
                    ScanListView()
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
            //first stack
            if bleManager.isSearching {
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
                .frame(width: 200, height: 200, alignment: .center)
                .background(Color.gray.opacity(0.5))
            }
        }
    }
}
