# BleConnect

I created a library for Bluetooth connectivity on top of Core Bluetooth (Support BLE Scan, Filter device by Name, Filter by UUID, ANCS Connectivity, Background Scan, etc)


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
    func didBluetoothStateChange(_ bluetoothState : BluetoothState)
    func didDiscoverDevices(_ listOfDevice : [CBPeripheral])
}
```

```swift
public class BleConnect : ObservableObject {

    public init(delegate: ConnectBlu.BLE_Callbacks, deviceNameShouldContain: String?, deviceUUID: String?)

    public func connectDevice(_ peripheral: CBPeripheral)

    public func disconnectDevice()

    public func refreshListOfScannedDevice()

    /// The type of publisher that emits before the object has changed.
    public typealias ObjectWillChangePublisher = ObservableObjectPublisher
}
```
<br><br>
### Example
```swift

import ConnectBlu
import CoreBluetooth


class BluetoothManager : ObservableObject  {

    @Published var bluetoothState : BluetoothState = .unknown
    @Published var listOfDevice = [CBPeripheral]()
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
}
```
`didBluetoothStateChange:` will give you the current state of bluetooth.\
`didDiscoverDevices:` will give you the list of unique deivces(peripherals).\

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
