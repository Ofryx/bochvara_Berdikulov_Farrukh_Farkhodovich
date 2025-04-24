#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <FirebaseFS.h>

// Конфигурационные константы
#define WIFI_SSID "B"
#define WIFI_PASSWORD "23232323"
#define API_KEY "AIzaSyDlphKVm2SpuWGW5W63FZu9pq09rmVusmY"
#define DATABASE_URL "https://vkr-bff-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define USER_EMAIL "test@gmail.com"
#define USER_PASSWORD "123456"

// Глобальные объекты (создаются один раз)
FirebaseData fbdo;
FirebaseData firestoreData;
FirebaseAuth auth;
FirebaseConfig config;

// Переменные для повторного использования
FirebaseJson jsonData;
FirebaseJson firestoreContent;
unsigned long sendDataPrevMillis = 0;
const unsigned long sendInterval = 5000;

void setup() {
  Serial.begin(115200);
  
  // Подключение к WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println("\nConnected with IP: " + WiFi.localIP().toString());

  // Настройка Firebase
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;

  fbdo.setBSSLBufferSize(2048, 512);  
  fbdo.setResponseSize(1024);
  firestoreData.setBSSLBufferSize(2048, 512);
  firestoreData.setResponseSize(1024);

  Firebase.begin(&config, &auth);
  Firebase.setDoubleDigits(3);  
  config.timeout.serverResponse = 5000;  
}

void sendSensorData(float temp, float hum, int press, float spd) {
  // Очистка предыдущих данных
  jsonData.clear();
  firestoreContent.clear();

  // Подготовка данных для Realtime Database
  jsonData.set("temperature", temp);
  jsonData.set("humidity", hum);
  jsonData.set("pressure", press);
  jsonData.set("speed", spd);
  jsonData.set("timestamp", millis());

  // Отправка в Realtime Database
  if (!Firebase.RTDB.setJSON(&fbdo, "/sensor", &jsonData)) {
    Serial.println("RTDB Error: " + fbdo.errorReason());
  }

  // Подготовка данных для Firestore
  String docPath = "sensor_data/doc_" + String(millis());
  
  firestoreContent.set("fields/temperature/doubleValue", temp);
  firestoreContent.set("fields/humidity/doubleValue", hum);
  firestoreContent.set("fields/pressure/integerValue", press);
  firestoreContent.set("fields/speed/doubleValue", spd);
  firestoreContent.set("fields/timestamp/integerValue", (int)millis());

  // Отправка в Firestore
  if (!Firebase.Firestore.createDocument(&firestoreData, "vkr-bff", "", docPath.c_str(), firestoreContent.raw())) {
    Serial.println("Firestore Error: " + firestoreData.errorReason());
  }
}

void loop() {
  if (millis() - sendDataPrevMillis >= sendInterval) {
    sendDataPrevMillis = millis();
    
    if (WiFi.status() == WL_CONNECTED && Firebase.ready()) {
      float temperature = random(200, 300) / 10.0;
      float humidity = random(400, 700) / 10.0;
      int pressure = random(950, 1050);
      float speed = random(100, 500) / 100.0;
      
      sendSensorData(temperature, humidity, pressure, speed);
      
      Serial.printf("Free heap: %d bytes\n", ESP.getFreeHeap());
    } else {
      jsonData.clear();
      jsonData.set("temperature", "offline");
      jsonData.set("humidity", "offline");
      jsonData.set("pressure", "offline");
      jsonData.set("speed", "offline");
      Firebase.RTDB.setJSON(&fbdo, "/sensor_status", &jsonData);
    }
  }
}