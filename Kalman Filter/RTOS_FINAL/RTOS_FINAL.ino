#include <esp_now.h>
#include <WiFi.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <WiFiUdp.h>
#include "model.h"

#define WIFI_SSID                 "Etisalat-HjHC"
#define WIFI_PASSWORD             "missarahmed@246"
#define API_KEY                   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZtc3puZ3dmbWhuYmJ3eW5nenRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg4ODI4NDMsImV4cCI6MjAzNDQ1ODg0M30.0YuDgAcCgYtg3aQwpMpjxphTc-AqtwKqtt_VT8qiycc"
#define MAX_DATA_SIZE             2000
#define SERVER_IP                 "192.168.1.5"
#define UDP_PORT                  4210

// Shared variables
volatile bool startReceiving = false;
volatile bool dataReceived = false;
SemaphoreHandle_t xSemaphore;

bool protocol = 0;
bool protocol_flag = 0;
bool calibration = 0;
bool exercise = 0;
bool cx_flag = 0;
bool esp_flag = 0;
bool prediction = 0;

int Thigh_Pointer = 0;
int Calf_Pointer = 0;
int Angle_Pointer = 0;
char flag = 0;
bool calf = false;
bool thigh = false;
volatile float pitch_T = 0;
volatile float pitch_C = 0;
int angle = 0;

typedef struct sensorData
{
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

float Features[43];
Eloquent::ML::Port::RandomForest RF;

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

struct_message myData;

HTTPClient http;
WiFiUDP udp;

void setup()
{
  Serial.begin(2000000);
  
  WiFi.mode(WIFI_AP_STA);
  //WiFi.mode(WIFI_STA);
  
  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED);
  Serial.println("WiFi Connected");

  // Start UDP
  udp.begin(UDP_PORT);

  // Create the semaphore
  xSemaphore = xSemaphoreCreateMutex();

  // Create tasks on different cores
  xTaskCreatePinnedToCore(
    handleData,         // Task function
    "handleData",       // Task name
    10000,              // Stack size
    NULL,               // Task parameter
    1,                  // Task priority
    NULL,               // Task handle
    0                   // Core 0
  );

  xTaskCreatePinnedToCore(
    checkVariables,     // Task function
    "checkVariables",   // Task name
    10000,              // Stack size
    NULL,               // Task parameter
    1,                  // Task priority
    NULL,               // Task handle
    1                   // Core 1
  );

}

void loop(){}

// Callback function that will be executed when data is received
void OnDataRecv(const esp_now_recv_info *info, const uint8_t *incomingData, int len)
{
  memcpy(&myData, incomingData, sizeof(myData));
  if(calibration || exercise)
  {
    if (myData.esp_no[0] == 'T' && (flag == 0 || flag == 'T') && thigh == false)
    {
      pitch_T = myData.Pitch;
      flag = 'C';
      thigh = true;
    }
    if (myData.esp_no[0] == 'C' && (flag == 0 || flag == 'C') && calf == false)
    {
      pitch_C = myData.Pitch;
      flag = 'T';
      calf = true;
    }
    if(thigh == true && calf == true)
    {
      angle = pitch_T - pitch_C;
      Serial.print("Angle:");
      Serial.println(angle);
      calf = false;
      thigh = false;
    }
  }
  if(protocol && (Angle_Pointer<MAX_DATA_SIZE) )
  {
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
      angle = pitch_T - pitch_C;
      Angle[Angle_Pointer] = angle;
      Serial.print("Angle:");
      Serial.println(Angle_Pointer);
      Serial.println(Angle[Angle_Pointer]);
      Angle_Pointer++;
      calf = false;
      thigh = false;
    }
  }
}

void checkVariables(void *pvParameters)
{
  for (;;)
  {
    if (xSemaphoreTake(xSemaphore, portMAX_DELAY))
    {
      protocol = getValue("https://fmszngwfmhnbbwyngztc.supabase.co/rest/v1/Controls?select=protocol&id=eq.1" , "protocol");
      calibration = getValue("https://fmszngwfmhnbbwyngztc.supabase.co/rest/v1/Controls?select=calibration&id=eq.1" , "calibration");
      exercise = getValue("https://fmszngwfmhnbbwyngztc.supabase.co/rest/v1/Controls?select=exercise&id=eq.1" , "exercise");
      prediction = getValue("https://fmszngwfmhnbbwyngztc.supabase.co/rest/v1/Controls?select=stats&id=eq.1" , "stats");
      xSemaphoreGive(xSemaphore);
    }
    // Delay to yield the task
    vTaskDelay(5 / portTICK_PERIOD_MS);
  }
}

void handleData(void *pvParameters)
{
  for (;;)
  {
    if (xSemaphoreTake(xSemaphore, portMAX_DELAY))
    {
      if(prediction)
      {
        http.begin("https://fmszngwfmhnbbwyngztc.supabase.co/rest/v1/Features?select=*");
        http.addHeader("apikey", API_KEY);
        http.addHeader("Authorization", "Bearer " + String(API_KEY));
        
        http.GET();
        
        String payload = http.getString();

        // Parse JSON
        DynamicJsonDocument doc(1024);
        deserializeJson(doc, payload);
          
        for (JsonObject row : doc.as<JsonArray>())
        {
          Features[0] = row["swing_time_max"];
          Features[1] = row["stance_time_max"];
          Features[2] = row["stride_time_max"];
          Features[3] = row["stride_time_min"];
          Features[4] = row["setting_angle"];
          Features[5] = row["mean_hs_angle"];
          Features[6] = row["mean_to_angle"];
          Features[7] = row["max_stance_angles"];
          Features[8] = row["max_swing_angles"];
          Features[9] = row["thrustACCel_C"];
          Features[10] = row["thrustACCel_T"];
          Features[11] = row["Omega_X_T"];
          Features[12] = row["Omega_Y_T"];
          Features[13] = row["Omega_Z_T"];
          Features[14] = row["powerX_ 1_T"];
          Features[15] = row["powerX_ 2_T"];
          Features[16] = row["powerX_ 3_T"];
          Features[17] = row["powerX_ 5_T"];
          Features[18] = row["powerY_ 1_T"];
          Features[19] = row["powerY_ 4_T"];
          Features[20] = row["powerY_ 5_T"];
          Features[21] = row["powerY_ 6_T"];
          Features[22] = row["powerZ_ 1_T"];
          Features[23] = row["powerZ_ 2_T"];
          Features[24] = row["powerZ_ 3_T"];
          Features[25] = row["powerZ_ 4_T"];
          Features[26] = row["Omega_X_C"];
          Features[27] = row["Omega_Y_C"];
          Features[28] = row["Omega_Z_C"];
          Features[29] = row["powerX_ 1_C"];
          Features[30] = row["powerX_ 3_C"];
          Features[31] = row["powerX_ 5_C"];
          Features[32] = row["powerY_ 1_C"];
          Features[33] = row["powerY_ 3_C"];
          Features[34] = row["powerY_ 4_C"];
          Features[35] = row["powerZ_ 1_C"];
          Features[35] = row["powerZ_ 2_C"];
          Features[37] = row["powerZ_ 3_C"];
          Features[38] = row["powerZ_ 5_C"];
          Features[39] = row["powerZ_ 6_C"];
          Features[40] = row["gender"];
          Features[41] = row["age"];
          Features[42] = row["bmi"];
        }
        String final_prediction = RF.predictLabel(Features);
        Serial.println(final_prediction);
      }
      else if(protocol)
      {
        if(!protocol_flag)
        {
          Serial.println("start receiving");
          esp_now_init();
          esp_now_register_recv_cb(OnDataRecv);
          protocol_flag = 1;
        }
      }
      else if(protocol_flag)
      {
        protocol_flag = 0;
        Serial.println("start uploading");
        esp_now_unregister_recv_cb();
        esp_now_deinit();
        http.begin("https://fmszngwfmhnbbwyngztc.supabase.co/rest/v1/data");
        http.addHeader("Content-Type", "application/json");
        http.addHeader("apikey", API_KEY);
        http.addHeader("Authorization", "Bearer " + String(API_KEY));
        
        int counter = 0;
        int itr = 0;
        while(counter < Angle_Pointer)
        {
          itr++;
         // Create a JSON document to hold the array
          StaticJsonDocument<1024> jsonDoc;
          JsonArray jsonArray = jsonDoc.to<JsonArray>();
          // Populate the JSON array with data from sensorDataArray
          for (counter; counter < 100*itr ; counter++)
          {
            JsonObject jsonObject = jsonArray.createNestedObject();
            //jsonObject["id"] = i;
            jsonObject["Angle"] = Angle[counter];
            jsonObject["Acc_X_T"] = round(Thigh_Data[counter].acc_x * 100) / 100.0;
            jsonObject["Acc_Y_T"] = round(Thigh_Data[counter].acc_y * 100) / 100.0;;
            jsonObject["Acc_Z_T"] = round(Thigh_Data[counter].acc_z * 100) / 100.0;
            jsonObject["Gyr_X_T"] = round(Thigh_Data[counter].gyr_x * 100) / 100.0;
            jsonObject["Gyr_Y_T"] = round(Thigh_Data[counter].gyr_y * 100) / 100.0;
            jsonObject["Gyr_Z_T"] = round(Thigh_Data[counter].gyr_z * 100) / 100.0;
            jsonObject["Acc_X_C"] = round(Thigh_Data[counter].acc_x * 100) / 100.0;
            jsonObject["Acc_Y_C"] = round(Thigh_Data[counter].acc_y * 100) / 100.0;
            jsonObject["Acc_Z_C"] = round(Thigh_Data[counter].acc_z * 100) / 100.0;
            jsonObject["Gyr_X_C"] = round(Thigh_Data[counter].gyr_x * 100) / 100.0;
            jsonObject["Gyr_Y_C"] = round(Thigh_Data[counter].gyr_y * 100) / 100.0;
            jsonObject["Gyr_Z_C"] = round(Thigh_Data[counter].gyr_z * 100) / 100.0;
          }
          // Serialize the JSON document to a string
          String jsonString;
          serializeJson(jsonDoc, jsonString);
          Serial.println(counter);
          int httpResponseCode = 0;
          while(httpResponseCode != 201)
          {
            // Send the HTTP POST request
            httpResponseCode = http.POST(jsonString);
            Serial.println("HTTP Response code: " + String(httpResponseCode));
          };
          Serial.println("Upload Success");
        }
        Angle_Pointer = 0;
        Thigh_Pointer = 0;
        Calf_Pointer = 0;
      }
      else if(calibration || exercise)
      {
        if(!cx_flag)
        {
          esp_now_init();
          esp_now_register_recv_cb(OnDataRecv);
          cx_flag = 1;
          esp_flag = 0;
        }
        // Send the data
        udp.beginPacket(SERVER_IP, UDP_PORT);
        udp.write((uint8_t *)&angle, sizeof(angle));
        udp.endPacket();
      }
      else
      {
        if(!esp_flag)
        {
          esp_now_unregister_recv_cb();
          esp_now_deinit();
          cx_flag = 0;
          esp_flag = 1;
        }
      }
      xSemaphoreGive(xSemaphore);
    }

    // Delay to yield the task
    vTaskDelay(5 / portTICK_PERIOD_MS);
  }
}

bool getValue(String supabase_url, String target)
{
  http.begin(supabase_url);
  http.addHeader("apikey", API_KEY);
  http.addHeader("Authorization", "Bearer " + String(API_KEY));
  http.GET();

  String payload = http.getString();
    
  // Parse JSON response
  DynamicJsonDocument doc(1024);
  deserializeJson(doc, payload);

  bool value = doc[0][target];
  return value;
}