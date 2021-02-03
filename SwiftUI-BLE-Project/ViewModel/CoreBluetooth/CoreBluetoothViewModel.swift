//
//  CoreBluetoothViewModel.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import Foundation
import CoreBluetooth

class CoreBluetoothViewModel: NSObject, ObservableObject, CBPeripheralProtocolDelegate, CBCentralManagerProtocolDelegate {
    
    @Published var isBluePowerOn: Bool = false
    @Published var isSearching: Bool = false
    @Published var isConnected: Bool = false
    
    @Published var foundPeripherals: [Peripheral] = []
    @Published var peripheralService = PeripheralService()
    
    private var centralManager: CBCentralManagerProtocol!
    private var connectedPeripheral: Peripheral!
    
    private let serviceUUID: CBUUID = CBUUID()
    
    override init() {
        super.init()
        #if targetEnvironment(simulator)
        centralManager = CBCentralManagerMock(delegate: self, queue: nil)
        #else
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        #endif
    }
    
    //Control Func
    func startScan() {
        let scanOption = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        centralManager?.scanForPeripherals(withServices: nil, options: scanOption)
        print("# Start Scan")
        isSearching = true
    }
    
    func stopScan(){
        disconnectPeripheral()
        centralManager?.stopScan()
        print("# Stop Scan")
        isSearching = false
    }
    
    func connectPeripheral(_ selectPeripheral: Peripheral?) {
        guard let connectPeripheral = selectPeripheral else { return }
        centralManager.connect(connectPeripheral.peripheral, options: nil)
    }
    
    func disconnectPeripheral() {
        guard let connectedPeripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(connectedPeripheral.peripheral)
    }
    
    //MARK: CoreBluetooth CentralManager Delegete Func
    func didUpdateState(_ central: CBCentralManagerProtocol) {
        if central.state == .poweredOn {
            isBluePowerOn = true
        } else {
            isBluePowerOn = false
        }
    }
    
    func didDiscover(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, advertisementData: [String : Any], rssi: NSNumber) {
        if rssi.intValue >= 0 { return }
        
        let foundPeripheral: Peripheral = Peripheral(_peripheral: peripheral,
                                                     _advData: advertisementData,
                                                     _rssi: rssi,
                                                     _discoverCount: 0)
        
        if let index = foundPeripherals.firstIndex(where: { $0.peripheral.identifier.uuidString == peripheral.identifier.uuidString }) {
            if foundPeripherals[index].discoverCount % 50 == 0 {
                foundPeripherals[index].rssi = rssi.intValue
                foundPeripherals[index].discoverCount += 1
            } else {
                foundPeripherals[index].discoverCount += 1
            }
        } else {
            foundPeripherals.append(foundPeripheral)
            DispatchQueue.main.async { self.isSearching = false }
        }
    }
    
    func didConnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol) {
        isConnected = true
    }
    
    func didFailToConnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?) {
        disconnectPeripheral()
    }
    
    func didDisconnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?) {
        
    }
    
    func connectionEventDidOccur(_ central: CBCentralManagerProtocol, event: CBConnectionEvent, peripheral: CBPeripheralProtocol) {
        
    }
    
    func willRestoreState(_ central: CBCentralManagerProtocol, dict: [String : Any]) {
        
    }
    
    func didUpdateANCSAuthorization(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol) {
        
    }
    
    //MARK: CoreBluetooth Peripheral Delegate Func
    func didDiscoverServices(_ peripheral: CBPeripheralProtocol, error: Error?) {
        peripheral.services?.forEach { service in
            peripheralService.discoverServices(peripheral, service)
        }
    }
    
    func didDiscoverCharacteristics(_ peripheral: CBPeripheralProtocol, service: CBService, error: Error?) {
        service.characteristics?.forEach { characteristic in
            peripheralService.discoverReadableCharacteristics(peripheral, service, characteristic)
        }
    }
    
    func didUpdateValue(_ peripheral: CBPeripheralProtocol, characteristic: CBCharacteristic, error: Error?) {
        guard let characteristicValue = characteristic.value else { return }
        peripheralService.updateValueCharacteristics(peripheral, characteristic, characteristicValue)
    }
    
    func didWriteValue(_ peripheral: CBPeripheralProtocol, descriptor: CBDescriptor, error: Error?) {
        
    }
}
