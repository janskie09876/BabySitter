import 'package:flutter/material.dart';

class BabysitterChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<BabysitterChatPage> {
  double _paymentRate = 20.0; // Default payment rate
  bool _isMessageSent =
      false; // State variable to track if a message has been sent
  FocusNode _textFieldFocusNode = FocusNode(); // FocusNode for the text field
  TextEditingController _messageController =
      TextEditingController(); // Controller for the text field

  void _showPaymentRateDialog() {
    // Define the available payment rates
    List<double> availableRates = [370, 450, 510, 570, 650];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose a Payment Rate'),
          content: Container(
            width: double.maxFinite, // Allow the dialog to use full width
            child: ListView.builder(
              itemCount: availableRates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('\₱${availableRates[index]}'),
                  onTap: () {
                    setState(() {
                      _paymentRate =
                          availableRates[index]; // Update the payment rate
                    });

                    // Set the message with the selected rate
                    _messageController.text =
                        'The selected payment rate is ₱${_paymentRate.toString()}';

                    // Send the message immediately after setting the text
                    _sendMessage();

                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without sending a message
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      // Implement sending message functionality here
      print('Sending message: ${_messageController.text}');
      setState(() {
        _isMessageSent = true; // Set message as sent
      });
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
        ],
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align everything to the left
        children: [
          // Display the message content or the "No messages yet." text
          Expanded(
            child: Center(
              child: _isMessageSent
                  ? Text(
                      _messageController.text,
                      style: TextStyle(fontSize: 18),
                    )
                  : Text(
                      'No messages yet.',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ),
          // Add space between the chat content and the card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap:
                        _showPaymentRateDialog, // Trigger the customize payment rate dialog
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Customize Rate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade100,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: 10), // Add space between the card and text field
              ],
            ),
          ),
          // Chat TextField for message input at the bottom
          Padding(
            padding: const EdgeInsets.all(1),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _textFieldFocusNode, // Assign the focus node
                    controller: _messageController, // Controller for text input
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
    );
  }
}
