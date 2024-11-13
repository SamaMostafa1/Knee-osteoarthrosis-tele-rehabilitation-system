#include <esp_now.h>
#include <WiFi.h>
#include <esp_wifi.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include <ESP32_Supabase.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include <ArduinoJson.h>
#include <WiFiUdp.h>
#include <HTTPClient.h>

#define WIFI_SSID "Etisalat-HjHC"
#define WIFI_PASSWORD "missarahmed@246"
#define MAX_DATA_SIZE 200

// Put your supabase URL and Anon key here...
//String supabase_url = "https://fmszngwfmhnbbwyngztc.supabase.co";
String supabaseUrl = "https://fmszngwfmhnbbwyngztc.supabase.co/rest/v1/data";
String apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZtc3puZ3dmbWhuYmJ3eW5nenRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg4ODI4NDMsImV4cCI6MjAzNDQ1ODg0M30.0YuDgAcCgYtg3aQwpMpjxphTc-AqtwKqtt_VT8qiycc";

#define API_KEY "AIzaSyAmk93YedMEzsH5Srh2NdJYbzAk3lFOS_0"
#define DATABASE_URL "https://graduation-data-default-rtdb.firebaseio.com/"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signupOK = false;

int Thigh_Pointer = 0;
int Calf_Pointer = 0;
int Angle_Pointer = 0;
char flag = 0;
bool calf = false;
bool thigh = false;
volatile float pitch_T = 0;
volatile float pitch_C = 0;

typedef struct sensorData{
  float acc_x;
  float acc_y;
  float acc_z;
  float gyr_x;
  float gyr_y;
  float gyr_z;
}sensorData;

sensorData Calf_Data[MAX_DATA_SIZE];
sensorData Thigh_Data[MAX_DATA_SIZE];
int Angle[MAX_DATA_SIZE];

Supabase db;

// Put your target table here
//String table = "Grad_Data";

bool upsert = false;

// Define which core to run each task on
#define RECEIVER_CORE 0 // Core 0 for receiving data
#define PRINTER_CORE 1  // Core 1 for printing data

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

// UDP setup
WiFiUDP udp;
const char* serverIP = "192.168.1.2"; // IP address of the Flutter app's device
const unsigned int udpPort = 4210;   // Port on which the Flutter app is listening

void setup()
{
  Serial.begin(2000000);
  
  //WiFi.mode(WIFI_STA);
  WiFi.mode(WIFI_AP_STA);
  
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
  
  if (esp_now_init() != ESP_OK)
  {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  esp_now_register_recv_cb(OnDataRecv);

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

// Callback function that will be executed when data is received
void OnDataRecv(const esp_now_recv_info *info, const uint8_t *incomingData, int len)
{
  memcpy(&myData, incomingData, sizeof(myData));

  if (myData.esp_no[0] == 'T' && (flag == 0 || flag == 'T') && thigh == false)
  {
    pitch_T = myData.Pitch;
    Thigh_Data[Thigh_Pointer].acc_x = myData.acc_x;
    Thigh_Data[Thigh_Pointer].acc_y = myData.acc_y;
    Thigh_Data[Thigh_Pointer].acc_z = myData.acc_z;
    Thigh_Data[Thigh_Pointer].gyr_x = myData.gyr_x;
    Thigh_Data[Thigh_Pointer].gyr_y = myData.gyr_y;
    Thigh_Data[Thigh_Pointer].gyr_z = myData.gyr_z;
    //Serial.print("Thigh:");
    //Serial.println(Thigh_Pointer);
    Thigh_Pointer++;
    flag = 'C';
    thigh = true;
  }
  if (myData.esp_no[0] == 'C' && (flag == 0 || flag == 'C') && calf == false)
  {
    pitch_C = myData.Pitch;
    Calf_Data[Calf_Pointer].acc_x = myData.acc_x;
    Calf_Data[Calf_Pointer].acc_y = myData.acc_y;
    Calf_Data[Calf_Pointer].acc_z = myData.acc_z;
    Calf_Data[Calf_Pointer].gyr_x = myData.gyr_x;
    Calf_Data[Calf_Pointer].gyr_y = myData.gyr_y;
    Calf_Data[Calf_Pointer].gyr_z = myData.gyr_z;
    //Serial.print("Calf:");
    //Serial.println(Calf_Pointer);
    Calf_Pointer++;
    flag = 'T';
    calf = true;
  }
  if(Thigh_Pointer == Calf_Pointer && thigh == true && calf == true)
  {
    Angle[Angle_Pointer] = pitch_T - pitch_C;
    Serial.print("Angle:");
    Serial.println(Angle_Pointer);
    Serial.println(Angle[Angle_Pointer]);
    Angle_Pointer++;
    calf = false;
    thigh = false;
  }
}

// Task to print data
void printDataTask(void *pvParameters)
{
  for (;;)
  {
    if(Angle_Pointer >= MAX_DATA_SIZE)
    {
      // Unregister the receive callback function
      esp_now_unregister_recv_cb();

      // Deinitialize ESP-NOW
      esp_now_deinit();

      HTTPClient http;
      http.setTimeout(30000);
      http.begin(supabaseUrl);
      http.addHeader("Content-Type", "application/json");
      http.addHeader("apikey", apiKey);
      http.addHeader("Authorization", "Bearer " + String(apiKey));

      // Create a JSON document to hold the array
      StaticJsonDocument<1024> jsonDoc;
      JsonArray jsonArray = jsonDoc.to<JsonArray>();

      // Populate the JSON array with data from sensorDataArray
      //for (int i = 0; i < sizeof(sensorDataArray) / sizeof(sensorDataArray[0]); i++)
      for (int i = 0; i < MAX_DATA_SIZE ; i++)
      {
        JsonObject jsonObject = jsonArray.createNestedObject();
        jsonObject["id"] = i;
        jsonObject["Angle"] = Angle[i];
        jsonObject["Acc_X_T"] = round(Thigh_Data[i].acc_x * 100) / 100.0;
        jsonObject["Acc_Y_T"] = round(Thigh_Data[i].acc_y * 100) / 100.0;;
        jsonObject["Acc_Z_T"] = round(Thigh_Data[i].acc_z * 100) / 100.0;
        jsonObject["Gyr_X_T"] = round(Thigh_Data[i].gyr_x * 100) / 100.0;
        jsonObject["Gyr_Y_T"] = round(Thigh_Data[i].gyr_y * 100) / 100.0;
        jsonObject["Gyr_Z_T"] = round(Thigh_Data[i].gyr_z * 100) / 100.0;
        jsonObject["Acc_X_C"] = round(Thigh_Data[i].acc_x * 100) / 100.0;
        jsonObject["Acc_Y_C"] = round(Thigh_Data[i].acc_y * 100) / 100.0;
        jsonObject["Acc_Z_C"] = round(Thigh_Data[i].acc_z * 100) / 100.0;
        jsonObject["Gyr_X_C"] = round(Thigh_Data[i].gyr_x * 100) / 100.0;
        jsonObject["Gyr_Y_C"] = round(Thigh_Data[i].gyr_y * 100) / 100.0;
        jsonObject["Gyr_Z_C"] = round(Thigh_Data[i].gyr_z * 100) / 100.0;
      }
      // Serialize the JSON document to a string
      String jsonString;
      serializeJson(jsonDoc, jsonString);
      Serial.println("Start Sending");
      int httpResponseCode = 0;
      while(httpResponseCode != 201)
      {
        // Send the HTTP POST request
        httpResponseCode = http.POST(jsonString);
        Serial.println("HTTP Response code: " + String(httpResponseCode));
      };
      Serial.println("Send Success");

      // Print the response
      // if (httpResponseCode > 0)
      // {
      //   String response = http.getString();
      //   Serial.println("HTTP Response code: " + String(httpResponseCode));
      //   Serial.println("Response: " + response);
      // } 
      // else
      // {
      //   Serial.println("Error on sending POST: " + String(httpResponseCode));
      //   String errorReason = http.errorToString(httpResponseCode);
      //   Serial.println("Error reason: " + errorReason);
      // }

      // End the HTTP connection
      http.end();

      // Beginning Supabase Connection
      //db.begin(supabase_url, anon_key);
      
      Angle_Pointer = 0;
    }

    // Start UDP
    // udp.begin(udpPort);
    // Send the data
    // udp.beginPacket(serverIP, udpPort);
    // //udp.write((uint8_t*)buffer, strlen(buffer));
    // udp.write((uint8_t *)&angle, sizeof(angle));
    // udp.endPacket();
    
    //delay(10);
    vTaskDelay(1 / portTICK_PERIOD_MS);
    //delay(5);
  }
}