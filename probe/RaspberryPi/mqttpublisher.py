import mosquitto

def sendSensorData(message):
    client = mosquitto.Mosquitto("test-client")
    client.connect("m2m.eclipse.org")
    client.loop()

    client.publish("/pots/soil/raspberrysoil", message, 1)
    client.disconnect
    