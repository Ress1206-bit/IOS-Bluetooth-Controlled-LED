
//  ContentView.swift
//  Tester
//
//  Created by Adam Ress on 7/5/23.


import SwiftUI

struct ContentView: View {
    
    @ObservedObject var bleManager = BLEManager()
    
    @State var red: Double = 0
    @State var green: Double = 0
    @State var blue: Double = 0
    
    
    @State var showColorSwitcher = false
    @State var isOn = true
    
    
    @State var rgbColor: Color = Color(red: 0.5, green: 0.5, blue: 0.5)
    
    @State var redCheck: Double = 0
    @State var greenCheck: Double = 0
    @State var blueCheck: Double = 0
    
    
    var body: some View {
        
        var height: CGFloat {
            if showColorSwitcher {
                return 200
            }
            return 500
        }
        
        VStack {
            Text("Nearby Bluetooth Devices")
                .blur(radius: showColorSwitcher ? 2 : 0)
            
            List(bleManager.peripherals) { peripheral in
                
                HStack {
                    Text(peripheral.name)
                    Spacer()
                    Text(getStatus(peripheral))
                }
                .onTapGesture {
                    bleManager.connectPeripheral(Peripheral: peripheral)
                }
                .disabled(showColorSwitcher)
            }
            .frame(height: height)
            .blur(radius: showColorSwitcher ? 4 : 0)
            
            
            Spacer()
            
            if showColorSwitcher {
                ColorPicker(red: $red, green: $green, blue: $blue, showColorSwitcher: $showColorSwitcher)
                    .padding()
                Spacer()
            }
            
            Text(isOn ? "Light is On" : "Light is Off")
                .padding()
            
            ZStack{
                Button {
                    
                    
                    if(red == 0 && green == 0 && blue == 0){
                        isOn = true
                    }
                    
                    if(!isOn){
                        sendData(red, green, blue)
                        isOn = true
                    }
                    else {
                        sendData(0, 0, 0)
                        isOn = false
                    }
                    
                    
                } label: {
                    Circle()
                        .frame(width: 100)
                        .foregroundColor(isOn ? Color(red: red, green: green, blue: blue) : Color.black)
                        .shadow(radius: 1)
                }
                .disabled(showColorSwitcher)
                .simultaneousGesture(LongPressGesture(minimumDuration: 0.3).onEnded({ _ in
                    showColorSwitcher = true
                }))
                
                Circle()
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 5))
                    .frame(width: 105)
                
            }
            .blur(radius: showColorSwitcher ? 1 : 0)
            
        }
        .onChange(of: red) { newValue in
            
            
            if isOn && (abs(newValue - redCheck) >= (40/255) || newValue == 0 || newValue == 255) {
                redCheck = red
                
                sendData(red, green, blue)
            }
            
            if red == 0 && green == 0 && blue == 0 {
                isOn = false
            }
        }
        .onChange(of: green) { newValue in
            if isOn && (abs(newValue - greenCheck) >= (40/255) || newValue == 0 || newValue == 255) {
                greenCheck = green
                
                sendData(red, green, blue)
            }
            
            if red == 0 && green == 0 && blue == 0 {
                isOn = false
            }
        }
        .onChange(of: blue) { newValue in
            if isOn && (abs(newValue - blueCheck) >= (40/255) || newValue == 0 || newValue == 255) {
                blueCheck = blue
                
                sendData(red, green, blue)
            }
            
            if red == 0 && green == 0 && blue == 0 {
                isOn = false
            }
        }
        
    }
    
    func getStatus(_ peripheral: Peripheral) -> String {
        switch (peripheral.state) {
        case .connected:
            return "Connected"
        case .disconnected:
            return "Not Connected"
        case .connecting:
            return "Connecting..."
        case .error:
            return "Failed Connecting"
        }
    }
    
    func sendData(_ red: Double, _ green: Double, _ blue: Double) {
        
        let peripheral = bleManager.arduinoCBPeripheral
        let r = Data([UInt8(Int(red*255))])
        let g = Data([UInt8(Int(green*255))])
        let b = Data([UInt8(Int(blue*255))])
        
        print("----Send Data----")
        print("Is ON: " + String(isOn))
        print("red: " + String(Int(red*255)))
        print("green: " + String(Int(green*255)))
        print("blue: " + String(Int(blue*255)))
        
        if let peripheral = peripheral {
            bleManager.sendData(peripheral, r: r, g: g, b: b)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
