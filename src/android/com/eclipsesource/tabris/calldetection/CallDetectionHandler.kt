package com.eclipsesource.tabris.calldetection

import android.content.Context
import android.media.AudioManager
import com.eclipsesource.tabris.android.ActivityScope
import com.eclipsesource.tabris.android.BooleanProperty
import com.eclipsesource.tabris.android.ObjectHandler
import com.eclipsesource.tabris.android.Property
import com.eclipsesource.v8.V8Object

class CallDetectionHandler(private val scope: ActivityScope) : ObjectHandler<CallDetection> {

  override val type = "com.eclipsesource.calldetection.CallDetection"

  override val properties = listOf<Property<CallDetection, *>>(
      BooleanProperty("inCall") { isInCall() }
  )

  override fun create(id: String, properties: V8Object) = CallDetection(scope.context)

}

/**
 * Detects an active call through the device audio mode, which Telecom (and VoIP apps that
 * integrate with it) switch while a call rings or is connected. Reading the mode requires no
 * permission. This is a strong signal, not proof: it can not tell who is calling and misses
 * VoIP apps that do not set a communication audio mode.
 */
class CallDetection(context: Context) {

  private val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

  fun isInCall(): Boolean = when (audioManager.mode) {
    AudioManager.MODE_RINGTONE,           // incoming call ringing
    AudioManager.MODE_IN_CALL,            // telephony call dialing or connected
    AudioManager.MODE_IN_COMMUNICATION,   // VoIP / video call
    MODE_CALL_SCREENING,                  // API 30: call being screened
    MODE_CALL_REDIRECT,                   // API 33: telephony call redirected to another device
    MODE_COMMUNICATION_REDIRECT -> true   // API 33: VoIP call redirected to another device
    else -> false
  }

  private companion object {
    // Raw values so the file compiles regardless of compileSdk; the constants are inlined anyway.
    const val MODE_CALL_SCREENING = 4
    const val MODE_CALL_REDIRECT = 5
    const val MODE_COMMUNICATION_REDIRECT = 6
  }

}
