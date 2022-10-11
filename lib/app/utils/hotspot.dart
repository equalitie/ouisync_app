import 'dart:async';
import 'dart:io';

/// If wifi hotspot is enabled, find the ip address of the hotspot interface, otherwise returns null.
Future<String?> findHotspotIp() async {
  // HACK: Find the hotspot ip address by enumerating all network interfaces and returning the one
  // whose address is in the 192.168.x.x range. This is based on some experimentation and also on a
  // couple of stackoverflow answers. Hard to say how reliable this is. The reason we do it this
  // way is that there doesn't seems to be any stable API to retrieve this info. Also, the hotspot
  // interface doesn't seem to appear immediately after connectivity event, so we need to poll it
  // for a short time (typically it appears within 1 seconds or so).

  // TODO: there is a hidden android API which might be potentially more reliable. See this SO
  // question for more details:
  // https://stackoverflow.com/questions/69314959/android-developer-how-to-detect-when-wifi-hotspot-is-turned-on-off

  // It seems on android the hotspot ip is always hardcoded to an ip with this prefix.
  // TODO: We need more testing to verify this.
  const hotspotIpPrefix = "192.168";

  final stopwatch = Stopwatch()..start();
  final timeout =
      Duration(seconds: 5); // poll the interfaces for up to this time.
  final delay =
      Duration(milliseconds: 250); // wait this long between each poll.

  while (stopwatch.elapsed < timeout) {
    final interfaces =
        await NetworkInterface.list(type: InternetAddressType.IPv4);

    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (addr.address.startsWith(hotspotIpPrefix)) {
          return addr.address;
        }
      }
    }

    await Future.delayed(delay);
  }

  return null;
}
