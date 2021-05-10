
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>


#define FIREBASE_HOST "FIREBASE HOST HERE"
#define FIREBASE_AUTH "FIREBASE DB SECRET HERE"
#define WIFI_SSID "WIFI SSID HERE"
#define WIFI_PASSWORD "WIFI PASSWORD HERE"

// temperature sensor pin
int tempPin = 0;

// Declare the Firebase Data object in the global scope
FirebaseData firebaseData;

int scanTemp;
float temperature;

void setup()
{

  Serial.begin(115200); 

  Serial.println("Serial communication started\n\n");

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD); //try to connect with wifi
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);

  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(500);
  }

  Serial.println();
  Serial.print("Connected to ");
  Serial.println(WIFI_SSID);
  Serial.print("IP Address is : ");
  Serial.println(WiFi.localIP());               //print local IP address
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH); // connect to firebase

  Firebase.reconnectWiFi(true);
  delay(1000);
}

void loop()
{
  // get scanTemp value from firebase
  if (Firebase.getInt(firebaseData, "/currentVisitor/scanTemp"))
  {

    if (firebaseData.dataType() == "int")
    {

      scanTemp = firebaseData.intData();
      Serial.println(scanTemp);
      Serial.println("\n Change value at firebase console to scanning temperature.");
      delay(500);
    }
  }
  else
  {
    Serial.println(firebaseData.errorReason());
  }

  if (scanTemp == 1)
  {
    Serial.println("Starting temperature scan..");
    delay(500);
    for (int i = 0; i <= 5; i++)
    {
      // temperature sensor get data here
      temperature = analogRead(tempPin);
      // read analog volt from sensor and save to variable temp
      temperature = temperature * 0.48828125;
      delay(3000);
    }

    // Firebase Error Handling And Writing Data At Specifed Path************************************************

    if (Firebase.setInt(firebaseData, "/currentVisitor/scanTemp", 0))
    {

      Serial.println("scanTemp updated Successfully");
      Serial.print("scanTemp = ");
      Serial.println(scanTemp);
      Serial.println("\n");
      delay(500);
    }

    else
    {
      Serial.println(firebaseData.errorReason());
    }
    // Firebase Error Handling And Writing Data At Specifed Path************************************************

    if (Firebase.setFloat(firebaseData, "/currentVisitor/temperature", temperature))
    {

      Serial.println("Temperature Uploaded Successfully");
      Serial.print("Temperature = ");
      Serial.println(temperature);
      Serial.println("\n");
      delay(500);
    }

    else
    {
      Serial.println(firebaseData.errorReason());
    }
  }

  delay(1000);
}
