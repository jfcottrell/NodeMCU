// Firmware to interface NodeMCU(EDP8266) with a TMP102 on a breakout board
// ssid, password and host need to be filled in
// 2017 John Cottrell

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <Wire.h>

const char* ssid = "";
const char* password = "";
const char* host = "";
int value = 0;
int tmp102Addr = 0x48;
int delayTime = 20000;    // delay 20,000ms or 20s

void setup() {
  Serial.begin(115200);
  Serial.print("Connecting to ");
  Serial.print(ssid);

  WiFi.begin(ssid, password);

  // Wait until WiFi is connected
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  Wire.begin(D1, D2);
}

void loop() {

  Serial.print("connecting to ");
  Serial.println(host);

  if(WiFi.status() == WL_CONNECTED) {

    HTTPClient http;
    http.begin("http://<host>/esp_post.php");
    http.addHeader("Content-Type", "application/x-www-form-urlencoded");

    float temp = getTemp();
    float tempF = (1.8 * temp) + 32;

    String postMessage;
    postMessage = "value=" + String(tempF);
    Serial.println(postMessage);
    int httpCode = http.POST(postMessage);
    String payload = http.getString();
    http.end();

    // send server response to console
    Serial.println(httpCode);
    Serial.println(payload);

  } else {
    Serial.println("Error in WiFi connection");
  }
 delay(delayTime);
}

float getTemp() {
  Wire.requestFrom(tmp102Addr, 2);
  byte MSB = Wire.read();
  byte LSB = Wire.read();

  int tempSum = ((MSB << 8) | LSB) >> 4;
  float c = tempSum * 0.0625;
  return c;
}
