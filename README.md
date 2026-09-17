# Tabris.js Call Detection Plugin

A [Tabris.js](https://tabris.com) plugin that reports whether a phone call is currently
active on the device. No UI, no runtime permissions.

```js
if (callDetection.inCall) {
  // a call is ringing, being dialed or connected
}
```

## Status

**Skeleton.** The native side currently returns a *random* boolean so the plugin wiring
(js-module, native handler registration, property access) can be verified on both platforms.
Real detection lands next:

| Platform | Signal | Permission |
|---|---|---|
| Android | `AudioManager.getMode()` in `MODE_RINGTONE` / `MODE_IN_CALL` / `MODE_IN_COMMUNICATION` | none |
| iOS | `CXCallObserver.calls` containing a call that has not ended | none |

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
(`tabris build ios`); there is no separate Xcode project.

### Example app

`example/` is a Tabris.js app consuming the plugin from the parent directory
(`spec="../"`, packed by a `before_platform_add` hook because Cordova can not consume a plugin
from a parent folder directly):

```sh
cd example && npm install && tabris run android
```

After changing anything in the plugin, run `tabris clean` first: an incremental build reuses the
existing Cordova project and silently ends up without the plugin (`callDetection is not defined`).
Use `TABRIS_ANDROID_PLATFORM=<path>` to build against a locally installed platform without a
download.

## License

Revised BSD License (3-clause license), see [LICENSE](LICENSE).
