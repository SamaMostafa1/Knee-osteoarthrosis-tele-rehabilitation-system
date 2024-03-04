#include <WiFi.h>

const char* ssid = "Mi Note 10 Lite";
const char* password = "misara246";
const int serverPort = 4080;
float receivedAccX = 0.0; // Variable to store the received value
float receivedAccY = 0.0; // Variable to store the received value
float receivedAccZ = 0.0;

WiFiServer TCPserver(serverPort);

void setup()
{
  Serial.begin(115200);
  while (!Serial);
  Serial.println("ESP32 #2: TCP SERVER RECEIVING SENSOR DATA");

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(10);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  // Print your local IP address:
  Serial.print("ESP32 #2: TCP Server IP address: ");
  Serial.println(WiFi.localIP());

  // Start listening for a TCP client (from ESP32 #1)
  TCPserver.begin();
}

void loop() {
  // Wait for a TCP client from ESP32 #1:
  WiFiClient client = TCPserver.available();

  if (client) {
    // Read the received variable from the TCP client:
    if (client.available()) {
      String receivedData = client.readStringUntil('\n');
      Serial.println("Received data: " + receivedData);

      // Parse the received data
      int commaPosition1 = receivedData.indexOf(',');
      if (commaPosition1 != -1) {
        receivedAccX = receivedData.substring(receivedData.indexOf("AccX: ") + 6, commaPosition1).toFloat();
        String remainingData = receivedData.substring(commaPosition1 + 1);

        int commaPosition2 = remainingData.indexOf(',');
        if (commaPosition2 != -1) {
          receivedAccY = remainingData.substring(receivedData.indexOf("AccY: ") + 6, commaPosition2).toFloat();
          receivedAccZ = remainingData.substring(commaPosition2 + 6).toFloat();
        }
      }

      // Now, you have receivedAccX, receivedAccY, and receivedAccZ with the values sent from ESP32 #1
    }

    client.stop();
  }
}