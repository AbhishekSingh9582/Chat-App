import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String username;
  final bool _isMe;
  final String _imageUrl;
  final Key key;
  ChatBubble(this.message, this.username, this._isMe, this._imageUrl,
      {this.key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
            mainAxisAlignment:
                _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: _isMe
                        ? Colors.orange[800]
                        : Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: _isMe ? Radius.circular(12) : Radius.zero,
                      bottomRight: _isMe ? Radius.zero : Radius.circular(12),
                    )),
                width: 160,
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                    crossAxisAlignment: _isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(username,
                          //textAlign: _isMe ? TextAlign.end : TextAlign.start,
                          style: TextStyle(
                            backgroundColor: Colors.white,
                            color: Colors.grey[700],
                          )),
                      Text(
                        message,
                        //textAlign: _isMe ? TextAlign.end : TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .accentTextTheme
                                .headline1
                                .color),
                      ),
                    ]),
              ),
            ]),
        Positioned(
          top: 0,
          left: _isMe ? null : 140,
          right: _isMe ? 140 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(_imageUrl),
          ),
        )
      ],
    );
  }
}
