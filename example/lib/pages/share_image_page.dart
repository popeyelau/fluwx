import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:fluwx_example/utils.dart';

class ShareImagePage extends StatefulWidget {
  const ShareImagePage({Key? key}) : super(key: key);

  @override
  State<ShareImagePage> createState() => _ShareImagePageState();
}

class _ShareImagePageState extends State<ShareImagePage> {
  WeChatScene scene = WeChatScene.session;
  String _response = '';
  String _imageToShare = 'https://cdn2.indie.cn/indie/music/01071/1848828433853976576.jpg';

  Fluwx fluwx = Fluwx();

  @override
  void initState() {
    super.initState();
    fluwx.addSubscriber((res) {
      if (res is WeChatShareResponse) {
        setState(() {
          _response = 'state :${res.isSuccessful}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('shareImage'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareImage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: '图片地址(仅限网络)'),
              controller: TextEditingController(
                text: _imageToShare,
              ),
              onChanged: (value) {
                _imageToShare = value;
              },
              keyboardType: TextInputType.multiline,
            ),
            TextField(
              decoration: InputDecoration(labelText: '缩略地址'),
              controller: TextEditingController(text: '//images/logo.png'),
              onChanged: (value) {},
            ),
            Row(
              children: <Widget>[
                const Text('分享至'),
                Row(
                  children: <Widget>[
                    Radio<WeChatScene>(
                      value: WeChatScene.session,
                      groupValue: scene,
                      onChanged: (v) {
                        if (v != null) handleRadioValueChanged(v);
                      },
                    ),
                    const Text('会话')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio<WeChatScene>(
                      value: WeChatScene.timeline,
                      groupValue: scene,
                      onChanged: (v) {
                        if (v != null) handleRadioValueChanged(v);
                      },
                    ),
                    const Text('朋友圈')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio<WeChatScene>(
                      value: WeChatScene.favorite,
                      groupValue: scene,
                      onChanged: (v) {
                        if (v != null) handleRadioValueChanged(v);
                      },
                    ),
                    const Text('收藏')
                  ],
                )
              ],
            ),
            Text(_response)
          ],
        ),
      ),
    );
  }

  void _shareImage() async{
    fluwx.share(WeChatShareImageModel(
        WeChatImageToShare(
          uint8List: await fetchImageAsUint8List(_imageToShare) ,
        ),
    ));
  }

  void handleRadioValueChanged(WeChatScene scene) {
    setState(() {
      this.scene = scene;
    });
  }
}
