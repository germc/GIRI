GIRI
================================

Voice recognition for iOS.

Usage
-------------------------
1. clone https://github.com/jhurt/FLACiOS
2. Build the "Framework" target
3. Add FLACiOS.framework to your XCode project. (right click on Products->libFLACiOS.a, select Show In Finder to find FLACiOS.framework)
4. clone https://github.com/jhurt/GIRI
5. Build the "Framework" target
6. Add GIRI.framework to your XCode project. (right click on Products->libGIRI.a, select Show In Finder to find GIRI.framework)
7. add #import <GIRI/GIRI.h> to your source file.
8. make a call to recognize speech from a wave file:
    
```objective-c
[GIRI recognizeSpeech:wavFile onComplete:^(NSString *text, NSError *error) { 
    //do something with the text
}];
```

Example
-------------------------
Checkout an example at https://github.com/jhurt/SpeakHereGIRI