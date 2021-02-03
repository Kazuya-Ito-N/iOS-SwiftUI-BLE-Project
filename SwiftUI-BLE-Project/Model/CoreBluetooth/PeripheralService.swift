//
//  PeripheralService.swift
//  swiftui-bleapp-template
//
//  Created by kazuya ito on 2020/12/02.
//

import Foundation
import CoreBluetooth

class PeripheralService: NSObject, ObservableObject {
    @Published var characteristicValueDict: [DeviceStatus] = []
    
    public func discoverServices(_ peripheral: CBPeripheralProtocol,
                                 _ service: CBService) {
        peripheral.discoverCharacteristics(nil, for: service)
    }
    
    public func discoverReadableCharacteristics(_ peripheral: CBPeripheralProtocol,
                                                _ service: CBService,
                                                _ characteristic: CBCharacteristic) {
        peripheral.readValue(for: characteristic)
    }
    
    public func updateValueCharacteristics(_ peripheral: CBPeripheralProtocol,
                                           _ characteristic: CBCharacteristic,
                                           _ characteristicValue: Data) {
        
        let device = DeviceStatus(_id: "\(characteristicValueDict.count)", _serviceNumber: 0)
        device.append(characteristic.uuid.uuidString, characteristicValue.map({ String(format:"%02x", $0) }).joined())
        characteristicValueDict.append(device)
    }
}
