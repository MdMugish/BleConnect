//
//  BluetoothManager.swift
//  BleConnect
//
//  Created by mohammad mugish on 22/12/20.
//

import Foundation
import ConnectBlu
import CoreBluetooth

class BluetoothManager : ObservableObject  {

    @Published var bluetoothState : BluetoothState = .unknown{
        didSet{
            if bluetoothState  == .connected{
                connectedDevice = bleConnect.connectedDevice()
            }
        }
    }
    
    @Published var listOfDevice = [CBPeripheral]()
    var connectedDevice : CBPeripheral?
    
    var bleConnect: BleConnect!

    init() {
        bleConnect = BleConnect(delegate: self, deviceNameShouldContain: nil, deviceUUID: nil)
        
    }

}

extension BluetoothManager : BLE_Callbacks{


    
    func didBluetoothStateChange(_ bluetoothState: BluetoothState) {
        self.bluetoothState = bluetoothState
    }
    

     func didDiscoverDevices(_ listOfDevice: [CBPeripheral]) {
        self.listOfDevice = listOfDevice
    }
    
    func didDiscoverCharacteristicsForService(_ service: CBService, allCharacterisricsForThisService: [CBCharacteristic]) {
        print("Service : \(service) and All characteristics for this service is \(allCharacterisricsForThisService)")
    }
    
    func didUpdateNotificationForCharacteristics(characteristics: CBCharacteristic, error: Error?) {
        
    }

    
    func didUpdateValueForCharacteristics(characteristics: CBCharacteristic, error: Error?) {
        
    }
    
    func didWriteValueForCharacteristics(characteristics: CBCharacteristic, error: Error?) {
        
    }
    
    func didUpdateANCSAuthorized(state: Bool) {
        
    }
    
   
}
