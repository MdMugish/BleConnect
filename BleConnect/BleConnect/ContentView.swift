//
//  ContentView.swift
//  BleConnect
//
//  Created by mohammad mugish on 22/12/20.
//

import SwiftUI


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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
