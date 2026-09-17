#!/bin/bash
# Drives a scripted incoming and outgoing call on a running Android emulator and prints the
# example app's polled callDetection.inCall values next to the system audio mode history.
#
# Prerequisites: the example app is installed and in the foreground on the emulator
# (tabris run android), and `adb` is on the PATH. Start the emulator with -no-audio unless you
# want to hear it ring.
#
# Usage: android-call-test.sh [emulator serial]   (default: emulator-5554)

set -e
SERIAL=${1:-emulator-5554}
A="adb -s $SERIAL"
NUMBER=5551234

mark() { echo "$(date +%T)  >>> $1"; }

$A logcat -c
mark "idle";                          sleep 3
mark "incoming call rings";           $A emu gsm call $NUMBER >/dev/null;   sleep 5
mark "incoming call accepted";        $A emu gsm accept $NUMBER >/dev/null; sleep 5
mark "caller hangs up";               $A emu gsm cancel $NUMBER >/dev/null; sleep 5
mark "outgoing call dialed";          $A shell am start -a android.intent.action.CALL -d tel:$NUMBER >/dev/null 2>&1; sleep 5
mark "far end answers";               $A emu gsm accept $NUMBER >/dev/null; sleep 4
mark "call ended locally";            $A shell input keyevent KEYCODE_ENDCALL; sleep 5

echo
echo "--- callDetection.inCall as polled by the example app"
$A logcat -d 2>/dev/null | grep "callDetection.inCall = " | sed -E 's/^[0-9-]+ ([0-9:]+)\.[0-9]+ .*callDetection/\1  callDetection/'
echo
echo "--- system audio mode history (Telecom)"
$A shell dumpsys audio 2>/dev/null | grep -E "setMode\(" | tail -7 | sed -E 's/^[0-9-]+ //; s/:[0-9]{3} setMode/ setMode/; s/ from package=.*//'
echo
echo "Expected: false -> true (ringing) -> true (accepted) -> false -> true (dialed) -> true (answered) -> false"
