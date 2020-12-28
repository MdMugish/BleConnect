# BleConnect

This library is for Bluetooth connectivity on top of Core Bluetooth which supports -
1. BLE Scan
2. Filter device by Name
3. Filter by UUID
4. ANCS Connectivity
5. Background Scan
6. Discover Services
7. Discover Characteristics For Service
8. Update Notification For Characteristics
9. Update Value For Characteristics
10. Write Value For Characteristics

## Library

```swift
public enum BluetoothState : String {
    case powerOff
    case powerOn
    case resetting
    case unauthorized
    case unknown
    case unsupported
    case scanning
    case idle
    case connecting
    case connectionFail
    case connected
    case disconnected
}
```


```swift
public protocol BLE_Callbacks {

    func didBluetoothStateChange(_ bluetoothState: ConnectBlu.BluetoothState)

    func didDiscoverDevices(_ listOfDevice: [CBPeripheral])

    func didDiscoverCharacteristicsForService(_ service: CBService, allCharacterisricsForThisService: [CBCharacteristic])

    func didUpdateNotificationForCharacteristics(characteristics: CBCharacteristic, error: Error?)

    func didUpdateValueForCharacteristics(characteristics: CBCharacteristic, error: Error?)

    func didWriteValueForCharacteristics(characteristics: CBCharacteristic, error: Error?)

    func didUpdateANCSAuthorized(state: Bool)
}
```
<br><br>
### Example
```swift

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
```
`deviceNameShouldContain:` will show only those device which contant that value in the device name.\
`deviceUUID:` will help you to scan device with unique device UUID.


<br> <br>


```swift
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
```
`didBluetoothStateChange:` will give you the current state of bluetooth.\
`didDiscoverDevices:` will give you the list of unique deivces(peripherals).\
`didDiscoverCharacteristicsForService:` will give you all characteristics for each services.\
`didUpdateNotificationForCharacteristics:` will notify you when you will use connectedDevice?.setNotifyValue(Bool, for: CBCharacteristic).\
`didUpdateValueForCharacteristics:` will give you the value when you will use connectedDevice?.readValue(for: CBCharacteristic).\
`didWriteValueForCharacteristics:` will give you the value when you will use  connectedDevice?.writeValue(Data, for: CBCharacteristic, type: CBCharacteristicWriteType).\
`didUpdateANCSAuthorized:` will give you the value when you will use ANCS.\

<br><br>

```swift

struct ContentView: View {
    @ObservedObject var vm = BluetoothManager()
    
    var body: some View {
        NavigationView{
            VStack{
            if vm.bluetoothState != .connected{
                List{
                    ForEach(vm.listOfDevice, id: \.self){value in
                        Button(action : {
                            vm.bleConnect.connectDevice(value)
                        }){
                            HStack{
                                Text(value.name!)
                                Spacer()
                            }
                        }
                        
                    }
                }.listStyle(PlainListStyle())
            }else if vm.bluetoothState == .connected{
                Button(action : {
                    vm.bleConnect.disconnectDevice()
                }){
                    Text("Disconnect")
                }
            }
            }
            .navigationBarTitle("\(vm.bluetoothState.rawValue.uppercased())")
            .navigationBarItems(trailing: NavBarTrailingItem )
        }
        
    }
    
    var NavBarTrailingItem : some View{
        Button(action : {
            vm.bleConnect.refreshListOfScannedDevice()
        }){
            Image(systemName : "arrow.triangle.2.circlepath").font(.system(size: 18)).padding(8)
        }
        
    }
}

```
`vm.bleConnect.connectDevice(value):` When you tap on perticular device then this function will try to connect with that perticular device.\
`vm.bleConnect.disconnectDevice():` If device is connected then only this button will be shown on the screen. You can disconnect the device by calling this function.\
`vm.bleConnect.refreshListOfScannedDevice()` You can refresh your list by calling this function.

<br><br><br>
![alt text](https://github.com/MdMugish/BleConnect/blob/main/ListOfDevices.jpeg?raw=true)
