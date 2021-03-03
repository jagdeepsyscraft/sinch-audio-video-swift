# sinch-audio-video-swift

![alt text](https://cdn1.bbcode0.com/uploads/2021/3/3/5c33cfe78bac4454e8e45032634d5b47-full.png)

This repo is created by using help of https://github.com/chhagansingh/Sinch-Calling-App-to-App-swift-4 I have added Swift 5 Support with Audio & Video Calling Controller Sepreate. 

sinch-audio-video-swift code is a sample application for app to app calling using Sinch framework (https://www.sinch.com/). This application is similar to the application you get while you download Sinch SDK from official website, but this is written in Swift.

# steps to run

Register yourself at Sinch.

Register your app in Sinch, you'll get the Application Key and Secret.

Paste the Application Key & Secret in initSinchClientWithUserId method of AppDelegate.

Drag and drop frame work, its simple, just download (www.sinch.com/download/) latest framework of Sinch and add it to your exsiting frame works.

# Frameworks required for calling

*libc++.dylib (libc++.tbd)
libz.tbd
Security.framework
AVFoundation.framework
AudioToolbox.framework
VideoToolbox.framework
CoreMedia.framework
CoreVideo.framework
CoreImage.framework
GLKit.framework
OpenGLES.framework
QuartzCore.framework

# INFO.PLIST

Required background modes

Application plays audio (audio))
Application provides Voice over IP services (voip)
Privacy - Microphone Usage Description (NSMicrophoneUsageDescription)

# Important Changes

do changes in build settings

FRAMEWORK_SEARCH_PATHS = '$(SDKROOT)/System/Library/Frameworks', '.'
OTHER_LDFLAGS = -ObjC ,-Xlinker ,-lc++

I am working on video calling screen to add controls. please feel free to contribute. 
# Thank You.
