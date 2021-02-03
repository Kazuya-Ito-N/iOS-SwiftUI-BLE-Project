import Foundation
import CoreBluetooth

class ServiceCharacteristicsMock {
    private let serviceUuid: CBUUID = CBUUID(string: "00112233-4455-6677-8899-AABBCCDDEEFF")
    private let characteristic: CBUUID = CBUUID(string: "10112233-4455-6677-8899-AABBCCDDEEFF")
    
	public func service() -> [CBMutableService] {
		return [
			CBMutableService(type: serviceUuid, primary: true),
		]
	}

	public func characteristics(_ serviceUUID: CBUUID) -> [CBCharacteristic] {
		switch serviceUUID {
		case serviceUuid:
			return [
				mutableCharacteristic(uuid: characteristic),
			]
		default:
			return []
		}
	}

	private func mutableCharacteristic(uuid: CBUUID) -> CBMutableCharacteristic {
		return CBMutableCharacteristic(type: uuid,
										properties: [.read, .write, .notify],
										value: nil,
										permissions: .readable)
	}

	public func value(uuid: CBUUID) -> Data {
		switch uuid {
		case characteristic:
			return Data([UInt8(0x01)])
		
		default:
			return Data()
		}
	}
}

