Vamos
-----

Vamos is a 2D component-oriented game development library written in the ooc
programming language. It is inspired by FlashPunk, also drawing ideas from
LÖVE and over game libraries.

### Features
+ Modular graphic and collision system (based on FlashPunk)
+ Component system, allows you create reusable behaviours for entities.
+ Existing components for timers, tweening, and simple physics.
+ Graphic classes for images, bitmap fonts, tilemaps (WIP), and animation.
+ Easy management, loading, and generation of assets.
+ Framerate-independent update loop.
+ Few dependencies (the whole engine only needs one DLL/shared lib, for SDL)

### Dependencies
To get started with Vamos, you'll need to install the following three ooc 
packages:
+ [ooc-sdl2](https://github.com/geckojsc/ooc-sdl2)
+ [ooc-stb-image](https://github.com/nddrylliog/ooc-stb-image)
+ [ooc-stb-vorbis](https://github.com/geckojsc/ooc-stb-vorbis)

Of these, only ooc-sdl2 requires extra setup. You'll need to download the
SDL 2.0 C sources from http://www.libsdl.org/hg.php and compile and install
them for your system.

stb-image is used to load .png files (and other image formats). stb-vorbis is
used for playing music in .ogg format. These two libraries are entirely
self-contained, you just have to copy them to your ooc libs folder.

### Todo
(more stuff will be added here as we think of it)
+ Improve performance of tilemaps
+ Get sound working (currently only music works, and it's not so simple to use)
+ Tutorials
