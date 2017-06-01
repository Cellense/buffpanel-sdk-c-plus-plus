# BuffPanel SDK for C++

The BuffPanel SDK is a library that is meant to be integrated into your game. It provides a simple interface allowing
you to send tracking data to the BuffPanel service.

To learn more about the BuffPanel service itself, please visit our [website](http://buffPanel.com/).

This version of the SDK is meant to be used within games written in C++ and should work without any external
dependencies on the target platforms. Bellow is a section that lists all the currently supported platforms.

If this doesn't suit your project we also provide the following versions of the SDK:
- [BuffPanel SDK for Unity](https://github.com/Cellense/buffpanel-sdk-unity)
- [BuffPanel SDK for C#](https://github.com/Cellense/buffpanel-sdk-c-sharp)

There's also the option of integrating your game into our service by communicating with our
[REST API](http://buffpanel.com/help/setting_up_tracking_in_your_game) directly.

## Contents

The repository itself contains the source files and build configurations of two projects:
1. The `BuffPanelSdK` project, which builds the BuffPanelSDK library itself into either
a _.dll dynamically loaded library_ (for Windows target platforms), a _.so shared library_ (for Linux target platforms)
or a _.dylib shared library_ (for Mac OS X target platforms).
2. The `BuffPanelSdKDemo` project, which builds an executable library which dynamically links with the BuffPanel SDK
and invokes a simple tracking call. This project is intended as an example of how the library should be included
and used in your porject.

## Integration guide

There are three ways you can include the SDK into your game:
1. Include the header files provided within the `Include` directory and one of the
[prebuilt binaries](https://cellense.com/sdk/), which suits your target platform and configuration.
2. Include the header files provided within the `Include` directory and build the required binaries (its enough to
build the `BuffPanelSdk` project). Bellow is a section detailing the specific build instructions for each of the
supported platforms.
3. Include the header files provided in the `Include` directory and include the contents of the `Source/BuffPanelSdk`
directory into your project. This is recommended only if your game is targeting a platform that we aren't already
supporting.

If you choose the second or the third option, keep in mind that you are responsible for providing the SDK`s
external dependancies. You should follow the build instructions bellow and examine the _Makefile_
or the _Visual Studio project files_ for more information.

## Supported platforms

The following is a list of platforms (including distros and versions) where the SDK was built and tested:
1. Linux CentOS 6.9 32-bit
2. Linux CentOS 6.9 64-bit
3. Linux Ubuntu 16.04.2 32-bit
4. Linux Ubuntu 16.04.2 64-bit
5. Mac OS X 10.12 Sierra 64-bit
6. Windows 10 32-bit
7. Windows 10 64-bit

This doesn't mean it shouldn't work on other platforms, these are just the ones we tried it on.

## Build instructions

Both projects allow either **Debug** or **Release** configurations to be used when building on any of the
supported platforms.

Object files are always created under the `Build`, whereas the final binaries are created under the `Dist` directory.

On all platforms except Windows, the result of the build process depends on the platform on which it is built. So to
create binaries targeting a specific operating system, distro and architecture, one must build the library on the
platform itself (cross-compiling is not supported).

The projects expect all external dependancies to be placed under the `Reference` directory. Header files should be
placed under the `Reference/Include` directory and binaries under the `Reference/Library` directory.

### For the Windows target platforms (using Visual Studio 2015)

Simply open the solution and build it for the desired target configuration and platform combinations.

### For the Linux / MacOS target platforms (using `clang -std=c++11`)

As mentioned above the binaries that are built target the current platform / architecture:
- Run `make` for the Release configuration.
- Run `make DEBUG=1` for the Debug configuration.

### For the Linux target platforms (using `g++ -std=c++0x`)

As mentioned above the binaries that are built target the current platform / architecture:
- Run `make LEGACY=1` for the Release configuration.
- Run `make LEGACY=1 DEBUG=1` for the Debug configuration.

### External dependancies

These are the 3rd libraries currently used within the SDK, please visit the vendor's site to learn more:
- [Poco 1.7.8p2](https://pocoproject.org/)

Note that there is no need to include this into your project, if you're using our prebuilt binaries as those have all external dependencies statically linked and are thus self sufficient.

## Implementation details

This section talks about important information you should be aware of before using the library in your project.

### Concurrency

The current version of the SDK uses a blocking system call to create an HTTP request when comunicating with our
service's REST API. It is probably undesirable to have this call block the main execution thread, and since
the library is thread-safe, we recommend invoking the tracking method within a secondary thread.

## Usage guide

The SDK currently enables you to notify the BuffPanel service that a **player** has run the game, triggering a
**run event**. It is important to ensure that the **run event** is triggered only once per game session at its start,
by correclty invoking the track method.

For attribution to work correctly, you need to provide the following information:
- a `gameToken`, which is a unique string identifier for your game generated earlier by the BuffPanel service
during registration.
- a `playerToken`, which is a unique string identifier for the current user of your game. This could be anything
you choose (an email address, Steam Id, etc), as long as it's unique for the given user and you use it consistantly.
The string is currently limited to a maximum length of 64 characters.
- the `isRepeated` boolean flag, indicating whether the current user has run the game before. This is important if
you already had users before you started using BuffPanel. Without this information, our service would treat any old
user it didn't see before as a new user, who had just started playing the game recently. Otherwise (i.e. you've
started using BuffPanel before launchin) it can be omitted.

Upon recieving this **run event** the BuffPanel server attempts to attribute it to any previous **click event** 
belonging to the same player. If a click event with a matching fingerprint is found, the run event gets attributed to
the click event's **campaign**.

If needed, you can also specify additional information about the current **run event** in the `attributes` parameter.
This parameter is a essentially a key => value map where you can record any custom information you deem relevant
(the user's hardware specs, the user's timezone, game specific information, etc.).

Finally, the tracking method allows you to supply an optional subclass of the `BuffPanel::Callback` class. This class
contains two virtual methods which are called when the event is successfully sent to the service or when an error
occurs.

## Examples

The simplest version of the tracking method's invocation, with the minimal required parameters:

```
BuffPanel::Client::track("demo_game", "demo_player");
```

In this version, we also specify that the current player had already run the game before:

```
BuffPanel::Client::track("demo_game", "demo_player", true);
```

This version provides the optional `attributes` key => value map:

```
std::map<string, string> attributes;

...

BuffPanel::Client::track("demo_game", "demo_player", attributes);
```

Finally, this version provides an optional callback object:

```
class MyCallback: public BuffPanel::Callback
{
	...
}

...

BuffPanel::Client::track("demo_game", "demo_player", MyCallback());
```

All examples assume that the `BuffPanel.h`
[header file](https://github.com/Cellense/buffpanel-sdk-c-plus-plus/blob/master/Include/BuffPanel.h)
is included in the current code module.

A working example can be found in this
[source file](https://github.com/Cellense/buffpanel-sdk-c-plus-plus/blob/master/Source/BuffPanelSDKCPlusPlusDemo/Main.cpp)

## Future features

We plan to add these features in future releases:
- repeated sends in case of service unavailability
- encapsulated thread management (no need to explicitly spawn threads)
- storing messages in case the user's device is offline, etc.
