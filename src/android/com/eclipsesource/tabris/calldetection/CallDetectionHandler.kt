package com.eclipsesource.tabris.calldetection

import com.eclipsesource.tabris.android.ActivityScope
import com.eclipsesource.tabris.android.BooleanProperty
import com.eclipsesource.tabris.android.ObjectHandler
import com.eclipsesource.tabris.android.Property
import com.eclipsesource.v8.V8Object
import kotlin.random.Random

class CallDetectionHandler(private val scope: ActivityScope) : ObjectHandler<CallDetection> {

  override val type = "com.eclipsesource.calldetection.CallDetection"

  override val properties = listOf<Property<CallDetection, *>>(
      BooleanProperty("inCall") { isInCall() }
  )

  override fun create(id: String, properties: V8Object) = CallDetection(scope)

}

class CallDetection(private val scope: ActivityScope) {

  // Skeleton step: a random value proves that the JS <-> native wiring works.
  // Real detection (AudioManager.getMode()) replaces this in the next step.
  fun isInCall(): Boolean = Random.nextBoolean()

}
