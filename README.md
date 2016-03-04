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
    - this ensures that the MeshCop framework can reference the correct files
  - Run `pod install`
  - The iOS commissioning app should now build. It may take some time because of the dependency on IoTivity.

Running
-------

Using Xcode, run the application in the simulator or a connected iOS device. Be sure to run a device or emulator that runs iOS 8.3 or higher. Be sure to be connected to the correct WiFi network that can route traffice to the Border Router.

// TODO: Is this Android specific language
When the app starts up, an mDNS discovery service is started. It listens for `_thread-net._udp` type
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

// TODO: Update everything below for iOS
Testing
-------

**On an Emulator**

1. Use **Genymotion**. Install it and create a virtual device. Start the virtual device.
2. Start Oracle’s **VirtualBox**.
3. You’ll see VM with the name of your virtual device. Open its settings.
4. Go to “Network —> Adapter 2”.
5. Select “Attached to: = Bridged Adapter”
6. Make sure that the “Name:” is the interface of the WiFi of your Mac.
7. OK and close.
8. Restart your virtual device on Genymotion.

From now on, you’ll be able to use the WiFi that is associated with your Mac’s or PC’s WiFi and you’ll be able to see mDNS services and connect to them.

MeshCop
-------

  MeshCop is a protocol extension on top of CoAP (MeshCop is the delivery of TLVs in CoAP-messages' payloads).
  It is implemented by the `thread-comm-iotivity` sub-module.

  The Android app interface to the MeshCop protocol is implemented through the swig-generated class `org.threadgroup.ca.jni.MCInterface`.
  The access to this interface is implemented by the Android Library project `:libraries:ca`.

  The Android reference Commissioner App `:app` is using the `:libraries:ca`'s access through its
  java-class `org.threadgroup.ca.jni.MeshCop` and java-interface `org.threadgroup.ca.jni.MeshCopIfc`.

  Callbacks from the MeshCop are handled by the `org.threadgroup.ca.jni.CallbackBase` in `:libraries:ca`

Android MeshCop SDK
-----

  The documentation of the Android MeshCop SDK can be found in the Java-Doc of the following classes:

  `org.threadgroup.ca.jni.MeshCopIfc` for info about issuing requests to the Border Router.

  `org.threadgroup.ca.jni.ACallbackBase` for info about receiving callbacks/responses from the Border Router.

  `org.threadgroup.ca.jni.MeshCopFactory.CallbackBaseWrapper` for info about handling secure storage for the native MeshCop layer.
