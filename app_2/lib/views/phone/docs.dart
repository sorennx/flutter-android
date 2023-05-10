import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../push_notifications/notification_api.dart';

class PhoneDocsView extends StatefulWidget {
  const PhoneDocsView({super.key, required this.downloadLink});
  final String downloadLink;
  @override
  State<PhoneDocsView> createState() => _PhoneDocsView();
}

class _PhoneDocsView extends State<PhoneDocsView>
    with TickerProviderStateMixin {
  int fileSize = 0;
  String fileType = '';
  int downloadedBytes = 0;
  final progressNotifier = ValueNotifier<double?>(0);

  Future<void> downloadFileInfo() async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';
    String url =
        'https://filesamples.com/samples/video/mp4/sample_1280x720.mp4';
    String fileName = '';

    try {
      // myUrl = url;
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      // var r = await httpClient.head(url);
      // print(request.headers.contentLength);
      if (response.statusCode == 200) {
        print(response.headers);
        // print(response.headers);
        // var bytes = await consolidateHttpClientResponseBytes(response);
        setState(() {
          fileSize = response.contentLength;
          fileType = response.headers['content-type']!.join();
        });
      } else {
        print("else ");
        filePath = 'Error code:${response.statusCode}';
      }
    } catch (ex) {
      print("error");
      filePath = 'Can not fetch url';
    }
  }

  void downloadFile() async {
    String url = 'https://www.samplelib.com/lib/preview/mp4/sample-30s.mp4';

    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      
      final id = await FlutterDownloader.enqueue(
          url: url, savedDir: baseStorage!.path, fileName: DateTime.now().toString().replaceAll(".", "").replaceAll(" ", ""), showNotification: true);
      
    } else {
      print("no permission");
    }
  }
  double progress = 0;
  ReceivePort receivePort = ReceivePort();
  @override 
  void initState(){
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloadFile");
    receivePort.listen((dynamic data) {
      setState(() {
        String id = data[0];
        DownloadTaskStatus status = data[1];
        progress = data[2];
        // progress = message;
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  static downloadCallback(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloadFile")!;
    
    sendPort.send([id, status, progress]);
  }

  // void createDownloadNotification() {
  //   NotificationApi.showNotification(
  //       title: "Downloading",
  //       body: "hi",
  //       payload: "download",
  //       maxProgress:
  //           (fileSize > 0 ? fileSize : (downloadedBytes + 1) * 1.1).toInt(),
  //       progress: downloadedBytes);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Download phone docs")),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              Row(
                children: [const Text("Link: "), Text(widget.downloadLink)],
              ),
              ElevatedButton(
                onPressed: () {
                  downloadFileInfo();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300),
                child: const Text('Download information'),
              ),
              Row(
                children: <Widget>[
                  const Text('File size:'),
                  Text(fileSize > 0 ? fileSize.toString() : "?")
                ],
              ),
              Row(
                children: <Widget>[const Text('File type:'), Text(fileType)],
              ),
              ElevatedButton(
                onPressed: downloadFile,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300),
                child: const Text('Download file'),
              ),
              Row(
                children: <Widget>[
                  const Text('Download progress: '),
                  Text('$downloadedBytes/${fileSize > 0 ? fileSize : '?'}'),
                ],
              ),
              LinearProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: progress < 100
                    ? AlwaysStoppedAnimation<Color>(Colors.green.shade300)
                    : AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                value: 0,
                semanticsLabel: 'Linear progress indicator',
              ),
            ])));
  }
}
