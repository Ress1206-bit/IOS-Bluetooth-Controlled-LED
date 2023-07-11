#include <ArduinoBLE.h>

// Define the service UUID
BLEService arduinoService("af7c1fe6-d669-414e-b066-e9733f0de7a8");

// Define the characteristics UUIDs
BLEByteCharacteristic redCharacteristic("bf7c1fe6-d669-414e-b066-e9733f0de7a8", BLERead | BLEWrite);
BLEByteCharacteristic greenCharacteristic("cf7c1fe6-d669-414e-b066-e9733f0de7a8", BLERead | BLEWrite);
BLEByteCharacteristic blueCharacteristic("df7c1fe6-d669-414e-b066-e9733f0de7a8", BLERead | BLEWrite);

const int redPin = 1;
const int greenPin = 2;
const int bluePin = 3;

void setup() {
  Serial.begin(9600);
  while (!Serial);

  // Initialize the BLE library
  if (!BLE.begin()) {
    Serial.println("Failed to initialize BLE");
    while (1);
  }

  // Set name / advertise the service
  BLE.setLocalName("Your Color Light");
  BLE.setAdvertisedService(arduinoService);

  // Add the characteristics to the service
  arduinoService.addCharacteristic(redCharacteristic);
  arduinoService.addCharacteristic(greenCharacteristic);
  arduinoService.addCharacteristic(blueCharacteristic);

  // Advertise the service
  BLE.addService(arduinoService);

  // Start advertising
  BLE.advertise();

  pinMode(redPin, OUTPUT);

  Serial.println("BLE peripheral started");
}

void loop() {
  BLEDevice central = BLE.central();

  if (central) {
    Serial.print("Connected to central: ");
    Serial.println(central.address());

    while (central.connected()) {
      if (redCharacteristic.written() || greenCharacteristic.written() || blueCharacteristic.written()) {
        uint8_t redValue = redCharacteristic.value();
        uint8_t greenValue = greenCharacteristic.value();
        uint8_t blueValue = blueCharacteristic.value();

        Serial.println(redValue);
        Serial.println(greenValue);
        Serial.println(blueValue);

        setColor((int)redValue, (int)greenValue, (int)blueValue);
      }
    }

    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
    setColor(0,0,0);
  }
}


void setColor(int red, int green, int blue) {
  analogWrite(redPin, red);  
  analogWrite(greenPin, green);  
  analogWrite(bluePin, blue);   
}