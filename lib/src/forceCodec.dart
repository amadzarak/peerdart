Future<String> forceVP8(String sdpHere) async {
  //File f = File('lib/newTests/test.txt');
  List<String> value = sdpHere.split('\n');
  Map sdpDefinedCodecs = {};
  int videoLineIndex;
  bool h264first = false;
  bool vp8present = false;

  String newMediaDescription = '';
  RegExp findVideoLine = RegExp(r'm=video+');
  RegExp findCodec = RegExp(r'a=rtpmap:+');
  RegExp matchCodec = RegExp(r'(?<=a=rtpmap:)[0-9]+');
  RegExp extractCodecName = RegExp(r'(?<= )[A-Za-z0-9]+(?=/)');

  List<String> finalSDP = [];

  videoLineIndex = getVideoLineIndex(value);
  print('video line index $videoLineIndex');
  print(value[videoLineIndex]);
  List mediaDescription = value[videoLineIndex].split(' ');
  print(mediaDescription.skip(3).toList());
  List codecs = mediaDescription.skip(3).toList();

  for (int i = 0; i < value.length; i++) {
    if (findCodec.hasMatch(value[i])) {
      //print(value[i]);
      //print(matchCodec.stringMatch(value[i]));
      //print(extractCodecName.stringMatch(value[i]));
      sdpDefinedCodecs[extractCodecName.stringMatch(value[i])] =
          matchCodec.stringMatch(value[i]);
    }
  }
  print(sdpDefinedCodecs);

  int vp8Index = -1;
  if (sdpDefinedCodecs['H264'] == codecs[0]) {
    h264first = true;
  }

  for (int idx = 0; idx < codecs.length; idx++) {
    if (sdpDefinedCodecs['VP8'] == codecs[idx]) {
      vp8present = true;
      print('vp8 is present');
      vp8Index = idx;
    }
  }

  print(h264first);
  print(vp8present);
  if (h264first == true && vp8present == true) {
    print('flip flopping h264 and vp8');
    //list not changing value
    print(mediaDescription[3]);
    mediaDescription[3] = sdpDefinedCodecs['VP8'];
    mediaDescription[3 + vp8Index] = sdpDefinedCodecs['H264'];
    print('new mediaScription');
    print(mediaDescription.join(' '));

    value[videoLineIndex] = mediaDescription.join(' ');
  }

  return value.join('\n').trim();

  //return x.join('\n');
}

int getVideoLineIndex(List<String> sdp) {
  RegExp findVideoLine = RegExp(r'm=video+');
  for (var i = 0; i < sdp.length; i++) {
    RegExpMatch? match = findVideoLine.firstMatch(sdp[i]);
    if (match != null) {
      return i;
    }
  }
  return -1;
}
