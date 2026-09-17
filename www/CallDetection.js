const NATIVE_TYPE = 'com.eclipsesource.calldetection.CallDetection';

class CallDetection extends tabris.NativeObject {

  get _nativeType() {
    return NATIVE_TYPE;
  }

  _dispose() {
    throw new Error('callDetection can not be disposed');
  }

}

tabris.NativeObject.defineProperties(CallDetection.prototype, {
  // nocache: every read is a fresh native GET, so the value never goes stale.
  inCall: {type: 'boolean', readonly: true, nocache: true}
});

module.exports = new CallDetection();
