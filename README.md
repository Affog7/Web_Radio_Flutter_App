

# flutter_radio_player

SION RADIO

![Pub Version](https://img.shields.io/pub/v/flutter_radio_player?style=plastic)
![Pub Likes](https://img.shields.io/pub/likes/flutter_radio_player)
![Pub Points](https://img.shields.io/pub/points/flutter_radio_player)
![Pub Popularity](https://img.shields.io/pub/popularity/flutter_radio_player)

# 
<p align="center">
  <img src="https://github.com/Affog7/Web_Radio_Flutter_App/blob/main/images/shot/1.png" width="250" title="Accueil">
    <img src="https://github.com/Affog7/Web_Radio_Flutter_App/blob/main/images/shot/4.png" width="250" title="Fonctionnalités">
    <img src="https://github.com/Affog7/Web_Radio_Flutter_App/blob/main/images/shot/5.png" width="250" title="Directives">
    <img src="https://github.com/Affog7/Web_Radio_Flutter_App/blob/main/images/shot/7.png" width="250" title="Equalizer">
    <img src="https://github.com/Affog7/Web_Radio_Flutter_App/blob/main/images/shot/8.png" width="250" title="Record/Enregistrement">
      <img src="https://github.com/Affog7/Web_Radio_Flutter_App/blob/main/images/shot/6.png" width="250" title="Playlist">
</p>
Flutter radio plugin handles a single streaming media preciously. This plugin was developed with maximum usage in mind.
Flutter Radio player enables Streaming audio content on both Android and iOS natively, as an added feature this plugin supports
background music play as well. This plugin also integrate deeply with both core media capabilities such as MediaSession on Android and
RemoteControl capabilities (Control Center) on iOS. This plugin also support controlling the player via both wearOS and WatchOS.

## Features

* Supports both android and ios
* Supports background music playing
* Integrates well with watchOS and WearOS.
* Handles network interruptions.
* Reactive
* Developer friendly (Logs are placed though out the codebase, so it's easy to trace a bug)

## Reactivity ?

Unlike any other Music Playing plugin Flutter Radio Player is very reactive. It communicates with the native layer using Event and Streams, this
making the plugin very reactive to both Application (Flutter) side and the native side.

### Plugin events

This plugin utilises Android LocalBroadcaster and iOS Notification center for pushing out events. Names of the events are listed below.

* `flutter_radio_playing`
* `flutter_radio_paused`
* `flutter_radio_stopped`
* `flutter_radio_error`
* `flutter_radio_loading`


## Getting Started

1. Add this to your package's pubspec.yaml file

```yaml
dependencies:
  flutter_radio_player: ^2.X.X
  flutter_radio: ^0.1.8
  http: ^0.13.3
  flutter_media_notification: ^1.2.6
  volume: ^1.0.1
  equalizer: ^0.0.2+2
  flutter_xlider: ^3.4.0
  preload_page_view: ^0.1.6
  carousel_slider: ^3.0.0
  record: ^2.1.1
  path_provider: ^1.5.1
  contactus: ^1.1.9
  url_launcher: ^6.0.3
  flutter_share_me: ^0.10.0
  flutter_share: ^2.0.0
```

2. Install its

```shell script
$ flutter pub get
```

3. Import its

```dart
import 'package:flutter_radio/flutter_radio.dart';
...
```

4. Configure it

* Stream Server Setup
  As you can see, we pass the connection link to the streaming server ie the online web radio, in our case it is the server **<a href="#">radio king </a>**
  The link is passed as a parameter to the `playOrPause()` method of **FluterRadio**

````
 static const streamUrl ="https://www.radioking.com/play/sion-radio";
FlutterRadio.playOrPause(url: streamUrl);
````

 * This function is the one that starts the radio when the application is launched
 *MediaNotification* is the plugin that allows us to display a notification of the stream playback.
 The *showNotification()* method which takes the title of the stream being broadcast as a parameter,...
  **isPlaying**: indicates the playing status:
    <img src="https://github.com/Affog7/Web_Radio_Flutter_App/blob/main/images/shot/noification.png" width="350" title="">

  
```flutter
  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    MediaNotification.showNotification(
        title: title, author: 'SION RADIO',isPlaying: false);
  }
```

* Some other stream processing functions: *stop()* to stop a playback (this is also used to disconnect the stream)

```flutter
 FlutterRadio.stop();
 FlutterRadio.pause(url: streamUrl);
```


* Sound management and mainly the volume managed by the *Volume* plugin (at the launch of the application the state of the system sound volume is retrieved)

```dart
void updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
  }
```
 
 * The change in sound volume is linked to the slider marking the volume on the application and vice versa
```dart
Slider(
      activeColor: Color.fromARGB(150, 13, 150, 173),

      value: currentVol.toDouble(),
      divisions: maxVol,
      max: maxVol.toDouble(),
      min: 0,
      onChanged: (double d) {
        setVol(d.toInt());
        updateVolumes(); 
        },
                      )
```
Besides above-mentioned method, below are the methods that FRP exposes.

* ```stop()``` - Will stop all the streaming audio streams and detaches itself from `FOREGROUND SERVICE`. You need to reinitialize to  use the plugin again,

```dart
 FlutterRadio.stop();
```

* ```start()``` - Will start the audio stream using the initialized object.

```dart
 FlutterRadio.start();
```

* ```pause()``` - Will pause the audio stream using the initialized object.

```dart
 FlutterRadio.pause();
```

 


* If you are planing to keep track of the media-sources by your-self, you can use below.

```dart
_flutterRadioPlayer.seekToMediaSource(position,  playWhenReady);
```



## iOS and Android Support

If the plugin is failing to initiate, kindly make sure your permission for background processes are given for your application

For your Android application you might want to add permissions in `AndroidManifest.xml`. This is already added for in the library level.

```xml
    <!--  Permissions for the plugin  -->
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.INTERNET" />

    <!--  Services for the plugin  -->
    <application android:usesCleartextTraffic="true">
        <service android:name=".core.StreamingCore"/>
    </application>
```


## Support

Please hit a like to plugin on pub if you used it and love it. put a ⭐️ my GitHub [repo](https://github.com/Affog7/Web_Radio_Flutter_App) and show me some ♥️ so i can keep working on this.

### Found a bug ?

Please feel free to throw in a pull request. Any support is warmly welcome.

## Contributor
* [Augustin AFFOGNON](https://www.linkedin.com/in/augustin-affognon-54a867248/)

## License
* [MIT](https://github.com/Affog7/Web_Radio_Flutter_App/blob/main/LICENSE)
