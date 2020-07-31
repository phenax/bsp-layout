# bsp-layout
Manage layouts in bspwm (tall and wide)

[BSPWM](https://github.com/baskerville/bspwm) does one thing and it does it well. It is a window manager. But some workflows require layout management to some extent. `bsp-layout` fills that gap.

### Dependencies
* `bspc`
* `bash`
* `bc`

### Installation

Arch users can install it from AUR [bsp-layout](https://aur.archlinux.org/packages/bsp-layout/)
```bash
yay -S bsp-layout
# OR
yaourt bsp-layout
```

Others can install it directly using the install script

```bash
curl https://raw.githubusercontent.com/phenax/bsp-layout/master/install.sh | sudo sh -;
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

* `rtall` - Master-stack with a reversed tall window.
```
_______________
|____|        |
|____|        |
|____|        |
|____|________|
```

* `wide` - Master-stack with a wide window.
```
_______________
|             |
|             |
|_____________|
|____|____|___|
```

* `rwide` - Master-stack with a reversed wide window.
```
_______________
|____|____|___|
|             |
|             |
|_____________|
```

* `even` - Evenly balances all window areas
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

* `tiled` - Default bspwm's tiled layout
```
_______________
|        |    |
|        |____|
|        |  | |
|________|__|_|
```

* `monocle` - Default bspwm's monocle layout
```
_______________
|             |
|             |
|             |
|_____________|
```



### Usage

* Help menu
```bash
bsp-layout help
```

* Set a layout in desktop named 6
Not specifying the layout will apply the layout on the focused desktop
```bash
bsp-layout set tall 6
```

* Remove layout applied to desktop named 6 with a 40% split
Set the master size for layout
```bash
// Currently focused workspace
bsp-layout set tall -- --master-size 0.4

// Workspace 6
bsp-layout set tall 6 -- --master-size 0.4
```

* Remove layout applied to desktop named 6
This will remove any layout applied
```bash
bsp-layout remove 6
```

* Apply a layout on your focused workspace once
This will apply the layout on the current set of nodes on that workspace but newer nodes won't conform to the layout.
```bash
bsp-layout once tall
```


### Configuration

You can configure the size of the master window in percentage in `$XDG_CONFIG_DIR/bsp-layout/layoutrc` file.
An example of that file can be found in [`example.layoutrc`](https://github.com/phenax/bsp-layout/blob/master/example.layoutrc)

```bash
mkdir ~/.config/bsp-layout && curl https://raw.githubusercontent.com/phenax/bsp-layout/master/example.layoutrc > ~/.config/bsp-layout/layoutrc;
```
