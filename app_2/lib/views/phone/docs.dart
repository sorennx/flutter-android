import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  Future<String> downloadFile() async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';
    String url =
        'https://filesamples.com/samples/video/mp4/sample_1280x720.mp4';
    String fileName = '';
    String dir = '';
    try {
      myUrl = url + '/' + fileName;
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        fileSize = response.contentLength;
        print(fileSize);
        var bytes = await consolidateHttpClientResponseBytes(response,
            autoUncompress: true,
            onBytesReceived: (cumulative, total) => {
                  setState(() {
                    downloadedBytes = cumulative;
                    NotificationApi.showNotification(
                        id: 0,
                        title: "Downloading",
                        body: "hi",
                        payload: "download",
                        maxProgress: (fileSize > 0
                                ? fileSize
                                : (downloadedBytes + 1) * 1.1)
                            .toInt(),
                        progress: downloadedBytes);
                  })
                });
        setState(() {
          fileSize = downloadedBytes;
          NotificationApi.showNotification(
              id: 0,
              title: "Downloading",
              body: "hi",
              payload: "download",
              maxProgress:
                  (fileSize > 0 ? fileSize : (downloadedBytes + 1) * 1.1)
                      .toInt(),
              progress: downloadedBytes);
        });
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }

  void createDownloadNotification() {
    NotificationApi.showNotification(
        title: "Downloading",
        body: "hi",
        payload: "download",
        maxProgress:
            (fileSize > 0 ? fileSize : (downloadedBytes + 1) * 1.1).toInt(),
        progress: downloadedBytes);
  }

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
                  Text(fileSize.toString())
                ],
              ),
              Row(
                children: <Widget>[const Text('File type:'), Text(fileType)],
              ),
              ElevatedButton(
                onPressed: () {
                  downloadFile();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300),
                child: const Text('Download file'),
              ),
              Row(
                children: <Widget>[
                  const Text('Download progress: '),
                  Text('$downloadedBytes/$fileSize'),
                ],
              ),
              LinearProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: downloadedBytes == fileSize
                    ? AlwaysStoppedAnimation<Color>(Colors.green.shade300)
                    : AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                value: downloadedBytes /
                    (fileSize > 0 ? fileSize : (downloadedBytes + 1) * 1.1)
                        .toDouble(),
                semanticsLabel: 'Linear progress indicator',
              ),
            ])));
  }
}
