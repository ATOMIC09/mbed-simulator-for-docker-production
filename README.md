# mbed-simulator
Online mbed simulator LPC1768

## Experimental simulator for Mbed OS 5 applications

**Demo: https://labs.mbed.com/simulator**

[More information in the introductionary blog post](https://os.mbed.com/blog/entry/introducing-mbed-simulator/)

## Docs

* Installation, see below.
* [Configuration and compiler options](docs/simconfig.md)
* [Peripherals](docs/peripherals.md)
* [File systems and block devices](docs/fs.md)
* [Pelion Device Management](docs/pelion.md)
* [Debugging](docs/debugging.md)
* [Architecture](docs/architecture.md)

There are two ways of installing and running the simulator: either using Docker or installing a locally hosted version.

**Docker installation** 
Install Docker (Tested on Windows with WSL2)
Build the Docker image:
docker build -t mbed/simulator .
Run the Docker image:
docker run -p 8002:7829 mbed/simulator
The simulator can now be accessed at
http://localhost:8002

## Installation

### Prerequisites

1. Install [Mbed CLI](https://github.com/ARMmbed/mbed-cli).
1. Install [Python 2.7](https://www.python.org/downloads/windows/) - **not Python 3!**.
1. Install [Git](https://git-scm.com/).
1. Install [Mercurial](https://www.mercurial-scm.org/wiki/Download).
1. Install [Node.js](https://nodejs.org/en/) v12 or higher.

Make sure that all of these are in your PATH. Verify this by opening a command prompt or terminal, and running:

```
$ where mbed
C:\Python27\Scripts\mbed.exe

$ where node
C:\Program Files\nodejs2\node.exe

$ where git
C:\Program Files\Git\cmd\git.exe

$ where hg
C:\Program Files\TortoiseHg\hg.exe
```

On Linux and macOS use `which` instead of `where`.

If one of the `where` / `which` commands does not yield a path, the utility is not in your PATH.

### Installing Emscripten

To install the Emscripten cross-compilation toolchain, open a command prompt and:

1. Clone the repository and install SDK version 1.38.21:

    ```
    $ git clone https://github.com/emscripten-core/emsdk.git
    $ cd emsdk
    $ emsdk install emscripten-1.38.21
    $ emsdk install sdk-fastcomp-tag-1.38.21-64bit
    $ emsdk activate emscripten-1.38.21
    $ emsdk activate fastcomp-clang-tag-e1.38.21-64bit

    # on Windows only:
    $ emsdk_env.bat --global
    ```

1. Verify that the installation was successful:

    ```
    $ emcc -v
    emcc (Emscripten gcc/clang-like replacement + linker emulating GNU ld) 1.38.21
    ```

1. Find the folder where emcc was installed:

    **Windows**

    ```
    $ where emcc
    C:\simulator\emsdk\emscripten\1.38.21\emcc
    ```

    **macOS and Linux**

    ```
    $ which emcc
    ~/toolchains/emsdk/emscripten/1.38.21/emcc
    ```

1. Add this folder to your PATH.
    * On Windows:
        * Go to **System Properties > Advanced > Environmental variables**.
        * Find `PATH`.
        * Add the folder you found in the previous step, and add it prefixed by `;`. E.g.: `;C:\simulator\emsdk\emscripten\1.38.21\`
    * On macOS / Linux:
        * Open `~/.bash_profile` or `~/.bashrc` and add:

        ```
        PATH=$PATH:~/toolchains/emsdk/emscripten/1.38.21
        ```

1. Open a new command prompt and verify that `emcc` can still be found by running:

    ```
    $ where emcc
    C:\simulator\emsdk\emscripten\1.38.21\emcc
    ```

1. All set!

### Installing the simulator through npm

Last, install the simulator. Easiest is through npm:

1. Install the simulator:

    ```
    $ npm install mbed-simulator -g
    ```

1. Clone an Mbed OS example program:

    ```
    $ mbed import mbed-os-example-blinky
    $ cd mbed-os-example-blinky
    ```

1. Run the simulator:

    ```
    $ mbed-simulator .
    ```

    Note that this will download all dependencies (including Mbed OS) and will build the common `libmbed` library so this'll take some time.

### Installing the simulator from source

1. Install the simulator through git:

    ```
    $ git clone https://github.com/janjongboom/mbed-simulator.git
    $ cd mbed-simulator
    $ npm install
    $ npm install . -g
    ```

1. Build your first example:

    ```
    $ node cli.js -i demos\blinky -o out --launch
    ```

    Note that this will download all dependencies (including Mbed OS) and will build the common `libmbed` library so this'll take some time.

1. Done! The Mbed Simulator should now launch in your default browser.

### Troubleshooting

**Windows: [Error 87] The parameter is incorrect**

This error is thrown on Windows systems when the path length limit is hit. Move the `mbed-simulator` folder to a folder closer to root (e.g. `C:\mbed-simulator`).

## How to run the hosted version

1. Install all dependencies, and clone the repository from source (see above).
1. Run:

    ```
    $ npm install

    # Windows
    $ build-demos.bat

    # macOS / Linux
    $ sh build-demos.sh
    ```

1. Then, start a web server:

    ```
    $ node server.js
    ```

1. Open http://localhost:7829 in your browser.
1. Blinky runs!

## CLI

The simulator comes with a CLI to run any Mbed OS 5 project under the simulator.

**Running**

To run an Mbed OS 5 project:

```
$ mbed-simulator .
```

The project will build and a web browser window will open for you.

To see if your program runs in the simulator, check the `TARGET_SIMULATOR` macro.

**Running in headless mode**

You can also run the simulator in headless mode, which is great for automated testing. All output (through `printf` and traces) will be routed to your terminal. To run in headless mode, add the `--launch-headless` option. You might also want to limit the amount of logging the server does through `--disable-runtime-logs` to keep the output clean.

## Changing mbed-simulator-hal

After changing anything in the simulator HAL, you need to recompile the libmbed library:

1. Run:

    ```
    $ rm mbed-simulator-hal/libmbed.bc
    ```

1. Rebuild your application. libmbed will automatically be generated.

## Updating demo's

In the `out` folder a number of pre-built demos are listed. To upgrade them:

**macOS and Linux**

```
$ sh build-demos.sh
```

**Windows**

```
$ build-demos.bat
```

**Commands to Install (tested in Debian/Ubuntu)**
apt update -y && apt upgrade –y
apt-get install python2 curl wget git mercurial build-essential nodejs npm -y
update-alternatives --install /usr/bin/python python /usr/bin/python2 1
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
python get-pip.py
pip install mbed-cli
dpkg --add-architecture i386
apt-get update -y
apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 –y
cd /usr/local && wget https://github.com/Kitware/CMake/releases/download/v3.10.3/cmake-3.10.3.tar.gz && \
tar -zxvf cmake-3.10.3.tar.gz && cd cmake-3.10.3 && \
./bootstrap && make && make install
cd /emsdk && ./emsdk install emscripten-1.38.21 && \
./emsdk install sdk-fastcomp-tag-1.38.21-64bit && \
./emsdk activate emscripten-1.38.21 && \
./emsdk activate fastcomp-clang-tag-e1.38.21-64bit && \
chmod +x /emsdk/emsdk_env.sh && ./emsdk_env.sh
echo "PATH=$PATH:/emsdk/emscripten/1.38.21" >> ~/.bashrc
curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt install nodejs –y
npm install
build-demos.sh

So...just put in your browser:
http://localhost:7829

And voilà!


## Attribution

* `viewer/img/controller_mbed.svg` - created by [Fritzing](https://github.com/fritzing/fritzing-parts), licensed under Creative Commons Attribution-ShareALike 3.0 Unported.
* Thermometer by https://codepen.io/mirceageorgescu/pen/Ceylz. Licensed under MIT.
* LED icons from https://pixabay.com/en/led-icon-logo-business-light-1715226/, Licensed under CC0 Creative Commons.
