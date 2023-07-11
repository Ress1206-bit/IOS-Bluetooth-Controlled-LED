//
//  CentralManagerDelegate.swift
//  Tester
//
//  Created by Adam Ress on 7/7/23.
//


import Foundation
import CoreBluetooth


let arduinoService = CBUUID(string: "af7c1fe6-d669-414e-b066-e9733f0de7a8")
let redCharacteristic = CBUUID(string: "bf7c1fe6-d669-414e-b066-e9733f0de7a8")
let greenCharacteristic = CBUUID(string: "cf7c1fe6-d669-414e-b066-e9733f0de7a8")
let blueCharacteristic = CBUUID(string: "df7c1fe6-d669-414e-b066-e9733f0de7a8")

class BLEManager: NSObject, ObservableObject {
    
    
    private var centralManager: CBCentralManager!
    
    var selectedPeripheral: Peripheral?
    var arduinoCBPeripheral: CBPeripheral?
    var redCBCharacteristic: CBCharacteristic?
    var greenCBCharacteristic: CBCharacteristic?
    var blueCBCharacteristic: CBCharacteristic?
    
    
    @Published var peripherals: [Peripheral] = []
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scanForPeripherals() {
        
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
}

extension BLEManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            scanForPeripherals()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        var peripheralName: String!

        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name

            let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue, cbPeripheral: peripheral, state: .disconnected)
            peripherals.append(newPeripheral)
        }
    }
    
    func connectPeripheral(Peripheral: Peripheral) {
        
        selectedPeripheral = Peripheral
        arduinoCBPeripheral = Peripheral.cbPeripheral
        centralManager.connect(Peripheral.cbPeripheral)
        
        for (index, storedPeripheral) in peripherals.enumerated() {
            if storedPeripheral.name == selectedPeripheral?.name {
                peripherals[index].state = .connecting
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("Connected")
        for (index, storedPeripheral) in peripherals.enumerated() {
            if storedPeripheral.name == selectedPeripheral?.name {
                peripherals[index].state = .connected
            }
        }
        
        peripheral.delegate = self
        peripheral.discoverServices([arduinoService])
        centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        for (index, storedPeripheral) in peripherals.enumerated() {
            if storedPeripheral.name == selectedPeripheral?.name {
                peripherals[index].state = .disconnected
            }
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        for (index, storedPeripheral) in peripherals.enumerated() {
            if storedPeripheral.name == selectedPeripheral?.name {
                peripherals[index].state = .error
            }
        }
        print(error?.localizedDescription ?? "Failed to Connect")
        
    }
    
    
}

extension BLEManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services ?? [] {
            if service.uuid == arduinoService {
                peripheral.discoverCharacteristics([redCharacteristic, greenCharacteristic, blueCharacteristic], for: service)
            }
        }
    }
    
    //Recieved data from Arduino
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if characteristic.uuid == redCharacteristic {
            // Handle received data from the peripheral
//            if let receivedData = characteristic.value {
//                let receivedString = String(data: receivedData, encoding: .utf8)
//                // Process the received data as needed
//                print("Received data: \(receivedString ?? "")")
//            }
        }
        else if characteristic.uuid == greenCharacteristic {
            
        }
        else if characteristic.uuid == blueCharacteristic {
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics ?? [] {
            if characteristic.uuid == redCharacteristic {
                // Now you can send data to the peripheral using this characteristic
                redCBCharacteristic = characteristic
            }
            else if characteristic.uuid == greenCharacteristic {
                greenCBCharacteristic = characteristic
            }
            else if characteristic.uuid == blueCharacteristic {
                blueCBCharacteristic = characteristic
            }
        }
    }
    
    func sendData(_ peripheral: CBPeripheral, r: Data, g: Data, b: Data){
        if let redCBCharacteristic = redCBCharacteristic {
            peripheral.writeValue(r, for: redCBCharacteristic, type: .withResponse)
        }
        
        if let greenCBCharacteristic = greenCBCharacteristic {
            peripheral.writeValue(g, for: greenCBCharacteristic, type: .withResponse)
        }
        
        if let blueCBCharacteristic = blueCBCharacteristic {
            peripheral.writeValue(b, for: blueCBCharacteristic, type: .withResponse)
        }
        
    }
}

enum ConnectedStatus {
    case connected
    case disconnected
    case connecting
    case error
}

struct Peripheral: Identifiable, Equatable {
    let id: Int
    let name: String
    let rssi: Int
    let cbPeripheral: CBPeripheral
    var state: ConnectedStatus = .disconnected
}

