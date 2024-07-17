# lginputhook-scripts
scripts to run on lg webos tv with button presses, so you can e.g. adjust backlighting with one key and not have to wait for the atrociously slow settings menu

## dependencies
https://github.com/Simon34545/lginputhook
rooted lg webos tv, able to install homebrew

## how to use
- add to e.g. /home/root or wherever you can/want to host your input scripts
- tell `lginputhook` to _execute_ a a script, giving it the full path

## example
```bash
/bin/bash /home/root/energysavingswitcher.sh
```
set to _execute_ and mapped to [button code 399](https://gist.github.com/Simon34545/31c528bfe8540880936fc4c580723a02) will use the green button to cycle through energy saving settings.

## included scripts
- energysavingswitcher.sh - cycles between auto, low, mid, max screen energy saving modes
- backlightswitcher.sh - goes through backlight intensity in increments of 10 (round-robins at 100)
- eyecomfortswitcher.sh - toggles eye comfort mode (white balance shift to warmer colours for night-time)
