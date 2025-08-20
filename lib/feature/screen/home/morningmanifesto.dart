import 'package:flutter/material.dart';

class MorningManifestoPage extends StatefulWidget {
  const MorningManifestoPage({super.key});

  @override
  State<MorningManifestoPage> createState() => _MorningManifestoPageState();
}

// Add 'with AutomaticKeepAliveClientMixin' to preserve the state
class _MorningManifestoPageState extends State<MorningManifestoPage> with AutomaticKeepAliveClientMixin {
  final _feelingController = TextEditingController();
  final _gratefulController = TextEditingController();

  // Your existing functions can be moved here directly
  @override
  void initState() {
    super.initState();
    _feelingController.addListener(_handleFeelingTextChange);
  }

  @override
  void dispose() {
    _feelingController.removeListener(_handleFeelingTextChange);
    _feelingController.dispose();
    _gratefulController.dispose();
    super.dispose();
  }
  
  void _handleFeelingTextChange() {
    // This function remains exactly the same as your original
    final oldText = _feelingController.text;
    final oldSelection = _feelingController.selection;
    final lines = oldText.split('\n');
    bool hasChanges = false;
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String newLine = line;
      if (line.startsWith('- ') || line.startsWith('* ')) {
        newLine = '• ' + line.substring(2);
      } else if (i > 0 && line.isNotEmpty && !line.startsWith('• ')) {
        newLine = '• ' + line;
      }
      if (newLine != line) {
        lines[i] = newLine;
        hasChanges = true;
      }
    }
    if (hasChanges) {
      final newText = lines.join('\n');
      final int lengthDifference = newText.length - oldText.length;
      final newSelection = TextSelection.collapsed(
        offset: oldSelection.baseOffset + lengthDifference,
      );
      _feelingController.value = TextEditingValue(
        text: newText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
  }


  // This is required to keep the state alive
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // Call super.build to enable the mixin
    super.build(context); 
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Morning Manifesto",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Reflect"),
          ),
          const SizedBox(height: 20),
          const Text("How are you feeling this Morning?"),
          TextField(
            controller: _feelingController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Type a list... (e.g., - My first point)',
            ),
          ),
          const SizedBox(height: 20),
          const Text("I am grateful for...."),
          TextField(
            controller: _gratefulController,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}