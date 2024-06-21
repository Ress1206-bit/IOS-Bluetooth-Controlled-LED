# IOS-Bluetooth-Controlled-LED Project

## Overview
The IOS-Bluetooth-Controlled-LED project is designed to help you explore and grasp the concept of using an iPhone app to control an Arduino. By creating a simple setup where an iPhone app controls an RGB LED, this project serves as an ideal starting point for understanding Bluetooth communication between iOS devices and Arduino. It provides a solid foundation for developing more complex projects and leveraging the integration of hardware and software to create innovative and interactive applications.

## Table of Contents
1. [Main Components](#main-components)
2. [Understanding the Bluetooth Control Mechanism](#understanding-the-bluetooth-control-mechanism)
3. [Setup and Usage Guide](#setup-and-usage-guide)
4. [Conclusion](#conclusion)
5. [Resources](#resources)
6. [License](#license)
7. [Contact](#contact)

## Main Components
- **Arduino MKR WiFi 1010**: Microcontroller used to manage the RGB LED and handle Bluetooth communication using ArduinoBLE.
  
- **RGB LED**: An LED capable of displaying different colors based on the signals received from the Arduino.
  
- **iPhone App**: Developed using Swift, this app connects to the Arduino via Bluetooth using CoreBluetooth and sends RGB values to control the LED.

## Understanding the Bluetooth Control Mechanism

### Basics of Bluetooth Communication
> Bluetooth Low Energy (BLE) is a wireless communication technology designed for low power consumption and short-range communication. In BLE, devices are categorized as:
> 1. **Central Devices**: Devices like smartphones or tablets that initiate connections and interact with peripheral devices.
> 2. **Peripheral Devices**: Devices like sensors or Arduino boards that advertise their presence and wait for central devices to connect to them.

### How Bluetooth Communication Works in This Project

#### Arduino as a Peripheral Device
- The Arduino MKR WiFi 1010 is set up as a BLE peripheral device. It advertises a BLE service with characteristics that the iPhone app can interact with.
- The BLE service has three characteristics corresponding to the red, green, and blue values of the RGB LED.

```cpp
BLEService arduinoService("af7c1fe6-d669-414e-b066-e9733f0de7a8");
BLEByteCharacteristic redCharacteristic("bf7c1fe6-d669-414e-b066-e9733f0de7a8", BLERead | BLEWrite);
BLEByteCharacteristic greenCharacteristic("cf7c1fe6-d669-414e-b066-e9733f0de7a8", BLERead | BLEWrite);
BLEByteCharacteristic blueCharacteristic("df7c1fe6-d669-414e-b066-e9733f0de7a8", BLERead | BLEWrite);
```

#### iPhone as a Central Device
- The iPhone app is developed using the CoreBluetooth framework, which allows it to act as a BLE central device. It scans for nearby BLE peripherals and connects to the Arduino.
- Once connected, the app can read from and write to the RGB characteristics, sending commands to the Arduino to control the LED colors.

```swift
let arduinoService = CBUUID(string: "af7c1fe6-d669-414e-b066-e9733f0de7a8")
let redCharacteristic = CBUUID(string: "bf7c1fe6-d669-414e-b066-e9733f0de7a8")
let greenCharacteristic = CBUUID(string: "cf7c1fe6-d669-414e-b066-e9733f0de7a8")
let blueCharacteristic = CBUUID(string: "df7c1fe6-d669-414e-b066-e9733f0de7a8")
```

### Detailed Steps of Communication

#### Advertising and Scanning
- The Arduino starts advertising its BLE service as soon as it is powered on. It continuously broadcasts its presence along with the service UUID.
- The iPhone app scans for BLE devices in its vicinity. When it detects the Arduino's advertisement, it identifies the Arduino using the service UUID.

```swift
func scanForPeripherals() {
    centralManager.scanForPeripherals(withServices: [arduinoService], options: nil)
}
```

#### Connecting
- Upon discovering the Arduino, the iPhone app attempts to connect to it.
- Once connected, the app stops scanning and proceeds to discover the available services and characteristics on the Arduino.

```swift
func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    centralManager.connect(peripheral, options: nil)
}

func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    peripheral.discoverServices([arduinoService])
}
```

#### Discovering Services and Characteristics
- After establishing a connection, the iPhone app discovers the services offered by the Arduino.
- It then discovers the characteristics for the RGB values within the service.

```swift
func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    for service in peripheral.services ?? [] {
        peripheral.discoverCharacteristics([redCharacteristic, greenCharacteristic, blueCharacteristic], for: service)
    }
}
```

#### Reading and Writing Characteristics
- The app can read the current values of the RGB characteristics to understand the initial state of the LED.
- To change the LED color, the app writes new values to the characteristics. Each write operation sends a command to the Arduino to update the LED accordingly.

```swift
func sendData(_ peripheral: CBPeripheral, r: Data, g: Data, b: Data) {
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
```

### Summary
By setting up the Arduino as a BLE peripheral and the iPhone as a BLE central, the project allows for wireless control of an RGB LED. The iPhone app communicates with the Arduino by reading and writing to BLE characteristics, enabling dynamic control over the LED colors. This setup provides a foundational framework for developing more advanced projects where an iPhone can control various devices via Bluetooth and an Arduino.

## Setup and Usage Guide

### Requirements
#### Hardware
- Arduino MKR WiFi 1010
- RGB LED
- Connecting wires

#### Software
- Arduino IDE
- Xcode
- iOS device with Bluetooth capabilities

### Steps to Set Up and Use

1. **Download the Code**:
   - Download the Arduino code and the Xcode project files from the repository.

2. **Open the Arduino Code**:
   - Open the Arduino IDE and load the provided `.ino` file.
   - Upload the code to your Arduino MKR WiFi 1010.

3. **Set Up the Hardware**:
   - Connect the RGB LED to the appropriate pins on the Arduino.

4. **Run the iOS App**:
   - Open the Xcode project.
   - Connect your iPhone and run the app.

5. **Enjoy and Expand**:
   - Use the iPhone app to control the RGB LED colors.
   - Utilize this project as a foundation to develop your own projects where your iPhone controls an Arduino through Bluetooth, enabling the creation of innovative and interactive applications.

## Conclusion
The IOS-Bluetooth-Controlled-LED project is an excellent starting point for understanding Bluetooth communication between an iPhone and Arduino. It provides a foundation for more complex projects and helps in learning the integration of hardware and software to create interactive and controllable systems. By building on this project, you can expand your skills to develop custom applications where your iPhone manages an Arduino through Bluetooth, opening up possibilities for creating unique and interactive technological solutions.

## Resources
- **ArduinoBLE Library**: [ArduinoBLE](https://www.arduino.cc/en/Reference/ArduinoBLE)
- **CoreBluetooth Documentation**: [CoreBluetooth](https://developer.apple.com/documentation/corebluetooth)
- **SwiftUI Documentation**: [SwiftUI](https://developer.apple.com/documentation/swiftui)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact
- **Email**: [adam.ress@icloud.com](mailto:adam.ress@icloud.com)

