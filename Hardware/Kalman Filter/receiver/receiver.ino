#include <esp_now.h>
#include <WiFi.h>
#include <esp_wifi.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
//#include <FirebaseESP32.h>
//#include "addons/RTDPHelper.h"
#include <ESP32_Supabase.h>
#include <ArduinoJson.h>
#include <WiFiUdp.h>

#define WIFI_SSID "Etisalat-HjHC"
#define WIFI_PASSWORD "missarahmed@246"

// #define WIFI_SSID "STUDBME2"
// #define WIFI_PASSWORD "BME2Stud"

#define API_KEY "AIzaSyAmk93YedMEzsH5Srh2NdJYbzAk3lFOS_0"
#define DATABASE_URL "https://graduation-data-default-rtdb.firebaseio.com/"

// Put your supabase URL and Anon key here...
String supabase_url = "https://fmszngwfmhnbbwyngztc.supabase.co";
String anon_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZtc3puZ3dmbWhuYmJ3eW5nenRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg4ODI4NDMsImV4cCI6MjAzNDQ1ODg0M30.0YuDgAcCgYtg3aQwpMpjxphTc-AqtwKqtt_VT8qiycc";

Supabase db;

// Put your target table here
String table = "Grad_Data";

bool upsert = false;
float x = 0.0;

// Define which core to run each task on
#define RECEIVER_CORE 0 // Core 0 for receiving data
#define PRINTER_CORE 1  // Core 1 for printing data

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signupOK = false;

// Declare variables volatile to ensure they're shared between cores
volatile unsigned long startTime;
volatile double elapsedTime_1 = 0;

volatile float pitch_1 = 0;
volatile float pitch_2 = 0;

volatile float acc_x_T = 0;
volatile float acc_y_T = 0;
volatile float acc_z_T = 0;
volatile float gyr_x_T = 0;
volatile float gyr_y_T = 0;
volatile float gyr_z_T = 0;

volatile float acc_x_C = 0;
volatile float acc_y_C = 0;
volatile float acc_z_C = 0;
volatile float gyr_x_C = 0;
volatile float gyr_y_C = 0;
volatile float gyr_z_C = 0;

// Flag to indicate whether the header has been printed or not
volatile bool headerPrinted = false;

// Structure example to receive data
typedef struct struct_message
{
  char esp_no[1];
  float gyr_x;
  float gyr_y;
  float gyr_z;
  float acc_x;
  float acc_y;
  float acc_z;
  float Pitch;
} struct_message;

// Create a struct_message called myData
struct_message myData;

// Callback function that will be executed when data is received
void OnDataRecv(const uint8_t *mac, const uint8_t *incomingData, int len)
{
  elapsedTime_1 = ((millis() - startTime) / 1000.0);
  memcpy(&myData, incomingData, sizeof(myData));

  if (myData.esp_no[0] == 'T')
  {
    pitch_1 = myData.Pitch;
    acc_x_T = myData.acc_x;
    acc_y_T = myData.acc_y;
    acc_z_T = myData.acc_z;
    gyr_x_T = myData.gyr_x;
    gyr_y_T = myData.gyr_y;
    gyr_z_T = myData.gyr_z;
  }
  else
  {
    pitch_2 = myData.Pitch;
    acc_x_C = myData.acc_x;
    acc_y_C = myData.acc_y;
    acc_z_C = myData.acc_z;
    gyr_x_C = myData.gyr_x;
    gyr_y_C = myData.gyr_y;
    gyr_z_C = myData.gyr_z;
  }
}

//char buffer[20];
int angle;
// UDP setup
WiFiUDP udp;
const char* serverIP = "192.168.1.5"; // IP address of the Flutter app's device
// const char* serverIP = "172.28.128.87";
const unsigned int udpPort = 4210;   // Port on which the Flutter app is listening 

// Task to print data
void printDataTask(void *pvParameters)
{
  //float x = 0.0;
  for (;;)
  {
    //x++;
    //FirebaseJson json;
    //json.set("fields/temperature/floatValue", ++x);
    // if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 500 || sendDataPrevMillis == 0))
    // //if (Firebase.ready() && signupOK)
    // {
    // sendDataPrevMillis = millis();
    // if(Firebase.RTDB.setFloat(&fbdo, "Try/angle", ++x))
    // { 
    //   Serial.println("Data sent to Firebase successfully");
    //   //Serial.println("Path: " + fbdo.dataPath());
    //   //Serial.println("Data type: " + fbdo.dataType());
    // }
    // else
    // {
    //   Serial.println("Failed to send data to Firebase");
    //   Serial.println("Reason: " + fbdo.errorReason());
    // }
    // }
    // if (!headerPrinted)
    // {
    //   // Print the header
    //   Serial.println("");
    //   Serial.println("Time, Pitch Difference, Acc_x_T, Acc_y_T, Acc_z_T, Gyr_x_T, Gyr_y_T, Gyr_z_T, Acc_x_C, Acc_y_C, Acc_z_C, Gyr_x_C, Gyr_y_C, Gyr_z_C");
    //   headerPrinted = true;
    // }

    // Serial.print(elapsedTime_1);
    // Serial.print(",");
    // Serial.print(pitch_1 - pitch_2);
    // Serial.print(",");
    // angle = pitch_1 - pitch_2;
    //dtostrf(int(pitch_1 - pitch_2), 6, 0, buffer);

    // Send the data
    // udp.beginPacket(serverIP, udpPort);
    // //udp.write((uint8_t*)buffer, strlen(buffer));
    // udp.write((uint8_t *)&angle, sizeof(angle));
    // udp.endPacket();
    
    // Create JSON data
    String JSON = createJsonData( (pitch_1-pitch_2), acc_x_T, acc_y_T, acc_z_T, gyr_x_T, gyr_y_T, gyr_z_T, acc_x_C, acc_y_C, acc_z_C, gyr_x_C, gyr_y_C, gyr_z_C);
    int code = db.insert(table, JSON, upsert);
    Serial.println(code);
    //delay(10);

    //Firebase.RTDB.setFloat(&fbdo, "Try/angle", ++x);
    //Firebase.RTDB.setJSON(&fbdo, "Try/angle" , &json);
    //json.set("Try/angle", ++x);
    /////////
    // Serial.print(acc_x_T);
    // Serial.print(",");
    // Serial.print(acc_y_T);
    // Serial.print(",");
    // Serial.print(acc_z_T);
    // Serial.print(",");
    // Serial.print(gyr_x_T);
    // Serial.print(",");
    // Serial.print(gyr_y_T);
    // Serial.print(",");
    // Serial.print(gyr_z_T);
    // Serial.print(",");
    // Serial.print(acc_x_C);
    // Serial.print(",");
    // Serial.print(acc_y_C);
    // Serial.print(",");
    // Serial.print(acc_z_C);
    // Serial.print(",");
    // Serial.print(gyr_x_C);
    // Serial.print(",");
    // Serial.print(gyr_y_C);
    // Serial.print(",");
    // Serial.println(gyr_z_C);
    ///////
    // Serial.print(",");
    // Serial.print(pitch_1);
    // Serial.print(",");
    // Serial.println(pitch_2);
    vTaskDelay(10 / portTICK_PERIOD_MS);
    //delay(5);
  }
}

void setup()
{
  Serial.begin(2000000);
  
  WiFi.mode(WIFI_AP_STA);

  // Set ESP-NOW channel
  //esp_wifi_set_channel(1, WIFI_SECOND_CHAN_NONE);

  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("WiFi connected");
  // // // Serial.println(WiFi.localIP());
  // // // Serial.println();

  // // // Get the channel of the connected Wi-Fi network
  // int channel = WiFi.channel();
  // Serial.print("Connected to Wi-Fi channel: ");
  // Serial.println(channel);

  // config.api_key = API_KEY;
  // config.database_url = DATABASE_URL;

  // if (Firebase.signUp(&config, &auth, "", ""))
  // {
  //   Serial.println("Authentication successful");
  //   signupOK = true;
  // }
  // else
  // {
  //   Serial.printf("Authentication failed: %s\n", config.signer.signupError.message.c_str());
  // }

  // config.token_status_callback = tokenStatusCallback;
  
  // Firebase.begin(&config, &auth);
  // Firebase.reconnectWiFi(true);

  //startTime = millis();

  //WiFi.mode(WIFI_STA);
  
  // Beginning Supabase Connection
  db.begin(supabase_url, anon_key);

  // Start UDP
  //udp.begin(udpPort);

  if (esp_now_init() != ESP_OK)
  {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  // Set ESP-NOW channel
  //esp_wifi_set_channel(channel, WIFI_SECOND_CHAN_NONE);
  //esp_now_register_recv_cb(OnDataRecv);

  xTaskCreatePinnedToCore(
      printDataTask,   // Function to implement the task
      "printDataTask", // Name of the task
      10000,           // Stack size in words
      NULL,            // Task input parameter
      1,               // Priority of the task
      NULL,            // Task handle.
      PRINTER_CORE
      );   // Core to run the task on
}

void loop()
{
  // Empty, because tasks handle everything
}

String createJsonData(float angle, float acc_x_T, float acc_y_T, float acc_z_T, float gyr_x_T, float gyr_y_T, float gyr_z_T, float acc_x_C, float acc_y_C, float acc_z_C, float gyr_x_C, float gyr_y_C, float gyr_z_C)
{
  // Using ArduinoJson to create JSON data
  StaticJsonDocument<512> doc;
  doc["Angle"] = angle;
  doc["Acc_X_T"] = acc_x_T;
  doc["Acc_Y_T"] = acc_y_T;
  doc["Acc_Z_T"] = acc_z_T;
  doc["Gyr_X_T"] = gyr_x_T;
  doc["Gyr_Y_T"] = gyr_y_T;
  doc["Gyr_Z_T"] = gyr_z_T;
  doc["Acc_X_C"] = acc_x_C;
  doc["Acc_Y_C"] = acc_y_C;
  doc["Acc_Z_C"] = acc_z_C;
  doc["Gyr_X_C"] = gyr_x_C;
  doc["Gyr_Y_C"] = gyr_y_C;
  doc["Gyr_Z_C"] = gyr_z_C;
  String jsonData;
  serializeJson(doc, jsonData);
  return jsonData;
}