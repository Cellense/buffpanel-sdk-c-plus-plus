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
prebuilt binaries (they are located in prebuilt folder in this repository), which suits your target platform and configuration.
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
1. Linux Ubuntu 18.04 64-bit
2. Mac OS X 10.11 El Capitan 64-bit
3. Windows 10 32-bit
4. Windows 10 64-bit

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
- [Poco 1.7.8p2](https://github.com/pocoproject/poco/releases/tag/poco-1.7.8p2-release)

Note that there is no need to include this into your project, if you're using our prebuilt binaries as those have all external dependencies statically linked and are thus self sufficient.

## Implementation details

This section talks about important information you should be aware of before using the library in your project.

### Concurrency

The current version of the SDK uses a blocking system call to create an HTTP request when comunicating with our
service's REST API. It is probably undesirable to have this call block the main execution thread, and since
the library is thread-safe, we recommend invoking the tracking method within a secondary thread.

### Usage guide

Include the following line of code into your project's code. It should be executed **at the startup of the game**, **once per game session** for tracking to work correctly.

```
BuffPanel::Client::track(game_token, is_existing_player, attributes, [callback]);
```

- `game_token` is a *string* value, that's generated by the BuffPanel platform during the registration process and is used to identify your game.
- `is_existing_player` is a *boolean* value, that lets us know whether the current player has already run the game before (*true*) or is a new player (*false*).
- `attributes` are a *std::map<string, string>* value, that carry any additional information valuable for you, for example purchased DLC list
- `callback` is an optional `BuffPanel::Callback` function to be called after the tracking event is delivered

Former `player_token` is no longer used, instead universally unique identifier (UUID) is generated and persisted on player's machine implicitly.


## How it works?

When the `BuffPanel::Client::track` method is called, the SDK sends an HTTP request to the REST API of the BuffPanel servers.

Upon recieving this event the BuffPanel service identifies your game using the submitted `game_token` and internally attempts to attribute the player's **run event** to any of the running **campaigns** for your game.

## Tracking Downloadable Content (DLC)

To track information about the DLC a player purchased in the past we use the `attributes` parameter. The tracking call's structure allows for tracking of either **Steam** DLC or any other DLC purchase as long as two information are passed to BuffPanel SDK:
- a unique DLC identifier for each DLC purchase
- UNIX timestamp of each DLC purchase

### Steam DLC purchase tracking

To acquire the needed information from **Steamworks SDK** you can:
1. Get the [total DLC count for the player](https://partner.steamgames.com/doc/api/ISteamApps#GetDLCCount)
2. Iterate through [all purchased DLC](https://partner.steamgames.com/doc/api/ISteamApps#BGetDLCDataByIndex), listing the entries in the `attributes` parameter format as
```
{ "dlc_<appId>": "<purchaseTimestamp>" }
```
3. Fill in the [DLC purchase UNIX timestamp](https://partner.steamgames.com/doc/api/ISteamApps#GetEarliestPurchaseUnixTime) for all the items
4. Track a run using the method containing these string values in `attributes` parameter
```
BuffPanel::Client::track(game_token, is_existing_player, attributes, [callback]);
```

#### Example call:

```
std::map<string, string> attributes = {
  { "dlc_657540", "1506599038" },
  { "dlc_643660", "1511176765" },
  { "dlc_907480", std::to_string(1511076765) }
}

BuffPanel::Client::track(
  "tetris_ultimate_4000", // buffpanel game token
  true, // whether this is an existing player
  attributes // "attributes" containing the DLC tracking information
);
```

### Tracking DLC purchase from another store

To integrate other stores and distribution platforms you use, please contact us at contact-us@buffpanel.com.

## Callbacks

You can add an optional event handler by extending the supplied `BuffPanel::Callback` interface and implementing both its methods.

To use your extended version of the `BuffPanel::Callback` interface (let's say you called it `MyCallback`), you need to include this line of code in the place in your project's code, where you wish to track the **event**:

```
BuffPanel::Client::track(game_token, is_existing_player, attributes, new MyCallback());
```

## Future features

We plan to add these features in future releases:
- repeated sends in case of service unavailability
- encapsulated thread management (no need to explicitly spawn threads)
- storing messages in case the user's device is offline, etc.
