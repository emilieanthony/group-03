#include <vector>

#include <MQTT.h>
#include <WiFi.h>
#ifdef __SMCE__
#include <OV767X.h>
#endif

#include <Smartcar.h>

#ifndef __SMCE__
WiFiClient net;
#endif
MQTTClient mqtt;

const int fSpeed = 50;    // 50% of the full speed forward
const int bSpeed = -40;   // 40% of the full speed backward
const int lDegrees = -75; // degrees to turn left
const int rDegrees = 75;  // degrees to turn right
const auto oneSecond = 1000UL;
const auto triggerPin = 6;
const auto echoPin = 7;
const auto maxDistance = 400;

ArduinoRuntime arduinoRuntime;
BrushedMotor leftMotor(arduinoRuntime, smartcarlib::pins::v2::leftMotorPins);
BrushedMotor rightMotor(arduinoRuntime, smartcarlib::pins::v2::rightMotorPins);
DifferentialControl control(leftMotor, rightMotor);
SR04 sensor(arduinoRuntime, triggerPin, echoPin);
SR04 front(arduinoRuntime, triggerPin, echoPin, maxDistance);

std::vector<char> frameBuffer;

SimpleCar car(control);

void setup() {
    Serial.begin(9600);
    Serial.setTimeout(200);

#ifdef __SMCE__
  Camera.begin(QVGA, RGB888, 15);
  frameBuffer.resize(Camera.width() * Camera.height() * Camera.bytesPerPixel());
//  mqtt.begin("127.0.0.1", 1883, WiFi);
  mqtt.begin("aerostun.dev", 1883, WiFi);

  // mqtt.begin(WiFi); // Will connect to localhost
#else
  mqtt.begin(net);
#endif
  if (mqtt.connect("arduino", "public", "public")) {
    mqtt.subscribe("/smartcar/group3/control/#", 1);
    mqtt.onMessage([](String topic, String message) {
      if (topic == "/smartcar/group3/control/throttle") {
        car.setSpeed(message.toInt());
      } else if (topic == "/smartcar/group3/control/steering") {
        car.setAngle(message.toInt());
      } else {
        Serial.println(topic + " " + message);
      }
    });
  }
}

void loop() {
    handleInput();
    avoidObstacles();

  if (mqtt.connected()) {
    mqtt.loop();
    const auto currentTime = millis();
#ifdef __SMCE__
    static auto previousFrame = 0UL;
    if (currentTime - previousFrame >= 65) {
      previousFrame = currentTime;
      Camera.readFrame(frameBuffer.data());
      mqtt.publish("/smartcar/group3/camera", frameBuffer.data(), frameBuffer.size(),
                   false, 0);
    }
#endif
    static auto previousTransmission = 0UL;
    if (currentTime - previousTransmission >= oneSecond) {
      previousTransmission = currentTime;
      const auto distance = String(front.getDistance());
      mqtt.publish("/smartcar/group3/ultrasound/front", distance);
    }
  }
#ifdef __SMCE__
  // Avoid over-using the CPU if we are running in the emulator
  delay(35);
#endif
}

//*Title: smartCar shield manualControl
//* Author: Dimitrios Platis
//* Date: 2021-04-08
//* Availability: https://platisd.github.io/smartcar_shield/manual_control_8ino-example.html

void handleInput()
{ 
    if (Serial.available())
    {
        char input = Serial.read(); // read everything that has been received so far and log down
                                    // the last entry
        switch (input)
        {
        case 'l': // rotate counter-clockwise going forward
            car.setSpeed(fSpeed);
            car.setAngle(lDegrees);
            break;
        case 'r': // turn clock-wise
            car.setSpeed(fSpeed);
            car.setAngle(rDegrees);
            break;
        case 'f': // go ahead
            car.setSpeed(fSpeed);
            car.setAngle(0);
            break;
        case 'b': // go back
            car.setSpeed(bSpeed);
            car.setAngle(0);
            break;
        default: // if you receive something that you don't know, just stop
            car.setSpeed(0);
            car.setAngle(0);
        }
    }
}

void avoidObstacles()
{
    unsigned int distance = sensor.getDistance();
    unsigned int distanceToObstacle = 100;
    unsigned int obstacleRotate = 90;

    if (distance > 0 && distance <= distanceToObstacle)
    {
        car.setSpeed(0);
        car.setAngle(obstacleRotate);
        car.setSpeed(bSpeed);
    }
}
