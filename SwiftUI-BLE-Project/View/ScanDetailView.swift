//
//  ScanDetailView.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import SwiftUI

struct ScanDetailView: View {
    @Binding var isRootViewActive: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                isRootViewActive = false
            }) {
                UIButtonView(text: "切断する")
            }
            
            Text("Bluetooth設定がOFFです")
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
        var body: some View {
            List {
                ForEach(0..<1) { num in
                    Text("Characteritic Name\(num)")
                }
            }
        }
    }
}
