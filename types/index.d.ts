import {NativeObject} from 'tabris';

declare global {

  interface CallDetection extends NativeObject {

    /**
     * `true` while a phone call is active on the device (ringing, dialing or connected).
     * Every read queries the native side; the value is never cached.
     */
    readonly inCall: boolean;

  }

  /** Singleton provided by tabris-plugin-call-detection. Can not be disposed. */
  const callDetection: CallDetection;

}

export {};
