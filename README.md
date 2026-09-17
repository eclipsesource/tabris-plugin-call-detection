# Tabris.js Call Detection Plugin

A [Tabris.js](https://tabris.com) plugin that reports whether a phone call is currently
active on the device. No UI, no runtime permissions.

```js
if (callDetection.inCall) {
  // a call is ringing, being dialed or connected
}
```

## Status

| Platform | Signal | Permission | State |
|---|---|---|---|
| Android | `AudioManager.getMode()` in `MODE_RINGTONE`, `MODE_IN_CALL`, `MODE_IN_COMMUNICATION` (plus the call-screening and redirect modes) | none | **implemented**, verified on the emulator |
| iOS | `CXCallObserver.calls` containing a call that has not ended | none | **implemented**; compiles and runs on the Simulator, real-call test on a device pending |

### What the Android signal means

Telecom switches the device audio mode while a cellular call rings, is dialed or is connected,
and VoIP apps that integrate with Telecom or set the communication mode do the same. Reading
the mode requires no permission and no Play Store data-safety disclosure. It is a strong risk
signal, not proof:

- It can not tell who is calling, or distinguish a fraud call from a legitimate one.
- VoIP apps that neither use Telecom nor set `MODE_IN_COMMUNICATION` are invisible.
- Any app that sets `MODE_IN_COMMUNICATION` (voice assistants, recorders) reads as a call.
- Outgoing calls read as active from the moment they are dialed.

### What the iOS signal means

CallKit reports every call the system knows about, without permission and without exposing who
is calling: cellular calls and VoIP calls of apps that integrate with CallKit (FaceTime,
WhatsApp and most others). A call counts from dialing or ringing until it has ended.

- VoIP apps that do not use CallKit are invisible.
- With Live Voicemail enabled (iOS 17+), a declined incoming call may still count as active
  until the caller hangs up.
- The Simulator has no calls; `inCall` is always `false` there.
- Apple documents `CXCallObserver` for observing the system's calls; it is widely used for this
  purpose, but there is no API contract that other apps' calls will always be reported.

## Usage

Add the plugin to your app's `cordova/config.xml`:

```xml
<plugin name="tabris-plugin-call-detection" spec="<git url or version>" />
```

The plugin registers the global singleton `callDetection`. TypeScript typings are included;
reference them via the package's `types` entry.

### API

| Member | Type | Description |
|---|---|---|
| `callDetection.inCall` | `boolean`, readonly | `true` while a call is active. Every read queries the native side. |

The object can not be disposed.

## Development

### Android

`project/android` is an Android Studio / Gradle project that compiles `src/android` against
the Tabris.js client library of a locally installed Tabris.js Android platform:

```sh
export TABRIS_ANDROID_PLATFORM=~/.tabris-cli/platforms/android/<version>
cd project/android && ./gradlew :call-detection:assembleDebug
```

### iOS

The Objective-C sources in `src/ios` are compiled as part of the app build
(`tabris build ios`); there is no separate Xcode project. Xcode 14.3.1 (iOS 16.4 SDK) is
sufficient to build and run the example on the Simulator:

```sh
cd example && npm install && tabris build ios --debug --emulator
xcrun simctl install booted "build/cordova/platforms/ios/build/emulator/Call Detection Plugin Example for Tabris.js.app"
xcrun simctl launch booted com.eclipsesource.tabris.calldetection.example
```

If your npm is configured for the old `npm.tabrisjs.com` mirror, prefix the build with
`npm_config_registry=https://registry.npmjs.org/`: the mirror serves tarballs whose checksums
do not match `package-lock.json`.

### Example app

`example/` is a Tabris.js app consuming the plugin from the parent directory
(`spec="../"`, packed by a `before_platform_add` hook because Cordova can not consume a plugin
from a parent folder directly):

```sh
cd example && npm install && tabris run android
```

#### Testing calls on the emulator

The emulator's virtual GSM modem drives Telecom exactly like a real radio, so the audio mode
switches the same way. With the example app running in the foreground:

```sh
example/scripts/android-call-test.sh            # incoming + outgoing call, prints inCall vs. audio mode
```

Start the emulator with `-no-audio` unless you want to hear it ring. `MODE_IN_COMMUNICATION`
(VoIP) can not be simulated on the emulator; test it with a real device and a VoIP app.

After changing anything in the plugin, run `tabris clean` first: an incremental build reuses the
existing Cordova project and silently ends up without the plugin (`callDetection is not defined`).
Use `TABRIS_ANDROID_PLATFORM=<path>` to build against a locally installed platform without a
download.

## License

Revised BSD License (3-clause license), see [LICENSE](LICENSE).
