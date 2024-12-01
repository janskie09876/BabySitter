import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  double _paymentRate = 20.0; // Default payment rate
  bool _isChoicesVisible =
      false; // State variable to track visibility of choices
  FocusNode _textFieldFocusNode = FocusNode(); // FocusNode for the text field
  TextEditingController _messageController =
      TextEditingController(); // Controller for the text field

  @override
  void initState() {
    super.initState();

    // Add a listener to the focus node to hide choices when focused
    _textFieldFocusNode.addListener(() {
      if (_textFieldFocusNode.hasFocus) {
        setState(() {
          _isChoicesVisible = false; // Hide choices when text field is focused
        });
      }
    });
  }

  void _showPaymentRateDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Payment Rate'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Payment Rate (\$)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _paymentRate =
                        double.tryParse(controller.text) ?? _paymentRate;
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _attachFile() {
    // Implement file attachment functionality here
    print('Attach file functionality goes here');
  }

  void _toggleChoices() {
    setState(() {
      _isChoicesVisible = !_isChoicesVisible; // Toggle visibility
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      // Implement sending message functionality here
      print('Sending message: ${_messageController.text}');
      _messageController.clear(); // Clear the text field after sending
    }
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose(); // Dispose of the focus node
    _messageController.dispose(); // Dispose of the message controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Babysitter'),
        backgroundColor: Colors.pink.shade100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Implement voice call functionality here
              print('Voice call icon pressed');
            },
          ),
          // Removed the video call button
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message Display Area
            Expanded(
              child: Center(
                child: Text(
                  'No messages yet.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            // Choices display
            if (_isChoicesVisible) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 250, // Set a smaller width for the choices
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.attach_file),
                          title: Text('Attach File'),
                          onTap: () {
                            _attachFile();
                            _toggleChoices(); // Hide choices after selection
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.money),
                          title: Text('Customize Payment Rate'),
                          onTap: () {
                            _showPaymentRateDialog();
                            _toggleChoices(); // Hide choices after selection
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Space between choices and text field
            ],
            // The text field is now aligned at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _textFieldFocusNode, // Assign the focus node
                      controller:
                          _messageController, // Controller for text input
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Round edges
                        ),
                        hintText: 'Type a message...',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0), // Add padding inside
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _sendMessage, // Call send message function
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
