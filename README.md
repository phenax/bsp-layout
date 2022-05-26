# bsp-layout
Manage layouts in bspwm (tall and wide)

[BSPWM](https://github.com/baskerville/bspwm) does one thing and it does it well. It is a window manager. But some workflows require layout management to some extent. `bsp-layout` fills that gap.

> **[Looking for maintainers](https://github.com/phenax/bsp-layout/issues/27)**



### Dependencies
* `bash`
* `bspc`
* `bc`
* `man`


### Installation

#### AUR
Arch users can install it from AUR [bsp-layout](https://aur.archlinux.org/packages/bsp-layout) or [bsp-layout-git](https://aur.archlinux.org/packages/bsp-layout-git)
```bash
# If you are using yay
yay -S bsp-layout

# Or for git master
yay -S bsp-layout-git
```

#### Install script
Others can install it directly using the install script.

**Note: Please read scripts like these before executing it on your machine**
```bash
curl https://raw.githubusercontent.com/phenax/bsp-layout/master/install.sh | bash -;
```

#### Clone and make
You can also clone the repo on your machine and run `sudo make install` in the cloned directory



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

* `grid` - Horizontal grid layout
```
_____________
|   |   |   |
|___|___|___|
|   |   |   |
|___|___|___|
```

* `rgrid` - Vertical grid layout
```
_____________
|_____|_____|
|_____|_____|
|_____|_____|
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

* Set tall layout to desktop with a 40% split
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

* Go back through layouts
Go back through all (or a custom list of) layouts.
```bash
# Switch to previous layout
bsp-layout previous

# Or to go back through a custom list of layouts
bsp-layout previous --layouts tall,monocle,wide

# For a specific desktop
bsp-layout previous --layouts tall,monocle,wide --desktop 4
```

* Go through layouts
Go through all (or a custom list of) layouts.
```bash
# Switch to next layout
bsp-layout next

# Or to go through a custom list of layouts
bsp-layout next --layouts tall,monocle,wide

# For a specific desktop
bsp-layout next --layouts tall,monocle,wide --desktop 4
```

* Toggle layout
```bash
# Toggle between monocle and tall layouts
bsp-layout next tall,monocle
```



### Configuration

You can configure the size of the master window in percentage in `$XDG_CONFIG_DIR/bsp-layout/layoutrc` file.
An example of that file can be found in [`example.layoutrc`](https://github.com/phenax/bsp-layout/blob/master/example.layoutrc)

```bash
mkdir ~/.config/bsp-layout && curl https://raw.githubusercontent.com/phenax/bsp-layout/master/example.layoutrc > ~/.config/bsp-layout/layoutrc;
```
