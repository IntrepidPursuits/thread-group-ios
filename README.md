# Thread Commissioning App for iOS
Thread Commissioner reference app for iOS.

##### Cloning
You will need to clone the iOS commissioning app and the IoTivity/MeshCop code.

##### Dependencies

  - iOS device or Simulator running iOS 8.3 or higher
  - Xcode (7.0 or higher)
  - SDK (9.0 or higher)
  - [Cocoapods](https://cocoapods.org/)
    - Reachability
    - UICKeyChainStore (2.0)
    - UIDeviceIdentifier (https://github.com/squarefrog/UIDeviceIdentifier.git)
    - PureLayout (3.0)
  - [IoTivity](https://bitbucket.org/threadgroup/thread-comm-iotivity) should be cloned to the same root directory as the iOS Thread Commissioning project

##### Compiling and Building the app.

  - Make sure the IoTivity repository shares the same base directory as the iOS commissioning app
  - Make sure you've checked out the `intrepid-develop-ios` branch of the `thread-comm-iotivity` repository
    - this ensures that the MeshCop framework can reference the correct files before the branches are correctly merged
  - Run `pod install`
  - The iOS commissioning app should now build. It may take some time because of the dependency on IoTivity.

Running
-------

Using Xcode, run the application in the simulator or a connected iOS device. Be sure to run a device or emulator that runs iOS 8.3 or higher. Be sure to be connected to the correct WiFi network that can route traffic to the Border Router.

When the app starts up, the iOS mDNS discovery service is started. It listens for `_thread-net._udp` type
entries on the `.local` domain. Be sure that the service has a `<TXT>` record containing the
attributes `net_name` and `xpanid`.

When the app finds the service, it will show it as an item in a list. The user can either pick that
item or the item is automatically selected if a previous successful connection was made earlier.

If there is no known Commissioner passphrase or the passphrase is incorrect, the user will be presented
with a dialog to provide the passphrase. After providing a new passphrase, the app will attempt
to petition for becoming the Commissioner again.

When the app successfully connects to the Border Router and becomes the Thread network's Commissioner,
the user will be presented options to add known devices that may want to join the network at a later
time and to manage and view the network's parameters/settings.

Note that the app listens to incoming UDP/CoAP message only when it is running in the foreground in
order to preserve battery life. All network related thread and processes will be stopped when the apps
moves to the background.

After a successful petition for becoming the Commissioner has finalized, the app can start adding devices
to its list of known joiner-devices. The user can either enter just a passphrase, which will match to _any_
future joiner-device with the same passphrase. Alternatively, the user can scan a joiner-device's
QR-code. In this case, both the future joiner-device's ID and passphrase must match to be successfully
joined to the network.

MeshCop
-------

  MeshCop is a protocol extension on top of CoAP (MeshCop is the delivery of TLVs in CoAP-messages' payloads).
  It is implemented by the `meshcop` sub-project.

  The iOS app interface to the MeshCop protocol is simply an objective-C wrapper around the MeshCop C API and is implemented in the file `TGMeshcopManager.m`


iOS MeshCop SDK
-----

  Not yet available.
