//
//  DeviceStatus.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import Foundation

class DeviceStatus: Identifiable {
    var id: String
    var serviceNumber: Int
    var dict: [Dict?]
    var isDataFaild: Bool
    
    class Dict {
        var uuid: String
        var value: String
        init(_ _uuid: String, _ _value: String) {
            uuid = _uuid; value = _value
        }
    }
    
    init(_id: String, _serviceNumber: Int) {
        id = _id
        serviceNumber = _serviceNumber
        dict = []
        isDataFaild = false
    }
    
    func append(_ _uuid: String, _ _value: String) {
        dict.append(Dict(_uuid, _value))
    }
}

