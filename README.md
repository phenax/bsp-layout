# bsp-layout
Manage layouts in bspwm (tall and wide)

[BSPWM](https://github.com/baskerville/bspwm) does one thing and it does it well. It is a window manager. But some workflows require layout management to some extent. `bsp-layout` fills that gap.


### Installation
```bash
curl https://github.com/phenax/bsp-layout/blob/master/install.sh | sudo sh -;
```


### Supported layouts
* `tall` - Master-stack with a tall window.
```
_______________
|        |____|
|        |____|
|        |____|
|________|____|
```

* `wide` - Master-stack with a wide window.
```
_______________
|             |
|             |
|_____________|
|____|____|___|
```

* `even` - Evenly balance all windows
```
_______________
|___|____|____|
|___|____|____|
|___|____|____|

OR
_______________
|    |        |
|    |________|
|    |        |
|____|________|
```


### Usage

* Set a layout in desktop on index 6
Not specifying the layout will apply the layout on the focused desktop
```bash
bsp-layout set tall ^6
```

* Remove layout applied to desktop on index 6
This will remove any layout applied
```bash
bsp-layout remove ^6
```

* Apply a layout on your focused workspace once
This will apply the layout on the current set of nodes on that workspace but newer nodes won't conform to the layout.
```bash
bsp-layout once tall
```

