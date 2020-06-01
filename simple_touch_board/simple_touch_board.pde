import processing.serial.*;

final int baudRate = 57600;

Serial inPort;  // the serial port
String inString; // input string from serial port
String[] splitString; // input string array after splitting
int[] status, lastStatus;

int device_number = 0;

void updateArraySerial(int[] array) {
  if (array == null) {
    return;
  }

  for(int i = 0; i < min(array.length, splitString.length - 1); i++){
    try {
      array[i] = Integer.parseInt(trim(splitString[i + 1]));
    } catch (NumberFormatException e) {
      array[i] = 0;
    }
  }
}

void setup() {
  status = new int[12];
  lastStatus = new int[12];
  
  println((Object[])Serial.list());
  
  inPort = new Serial(this, Serial.list()[device_number], baudRate); 
  inPort.bufferUntil('\n');
}

void draw() {
}

void serialEvent(Serial p) {
  inString = p.readString();
  splitString = splitTokens(inString, ": ");
  
  if (splitString[0].equals("TOUCH")) {
    updateArraySerial(status);
  }
    
  for (int i = 0; i < 12; i++) {
    if (lastStatus[i] == 0 && status[i] == 1) {
      // touched
      println("Electrode " + i + " was touched");
      lastStatus[i] = 1;
    } 
    else if(lastStatus[i] == 1 && status[i] == 0) {
      // released
      println("Electrode " + i + " was released");
      lastStatus[i] = 0;
    }
  }
}
