import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/edge_theme.dart';

class CodePreviewScreen extends StatefulWidget {
  final String code;
  final String language;

  const CodePreviewScreen({
    super.key,
    required this.code,
    required this.language,
  });

  @override
  State<CodePreviewScreen> createState() => _CodePreviewScreenState();
}

class _CodePreviewScreenState extends State<CodePreviewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    
    // Prepare HTML content
    String htmlContent = widget.code;
    if (widget.language == 'javascript') {
      htmlContent = '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { 
            background: #0A0A0B; 
            color: #FFFFFF; 
            font-family: sans-serif; 
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }
        #output { text-align: center; }
    </style>
</head>
<body>
    <div id="output"></div>
    <script>
        try {
            const originalLog = console.log;
            console.log = function(...args) {
                document.getElementById('output').innerHTML += args.join(' ') + '<br>';
                originalLog.apply(console, args);
            };
            ${widget.code}
        } catch (e) {
            document.body.innerHTML = '<pre style="color: #FF5252;">Error: ' + e.message + '</pre>';
        }
    </script>
</body>
</html>
''';
    } else if (widget.language == 'html' && !widget.code.contains('<!DOCTYPE')) {
       htmlContent = '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { background: #0A0A0B; color: #FFFFFF; margin: 0; font-family: sans-serif; }
    </style>
</head>
<body>
    ${widget.code}
</body>
</html>
''';
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(EdgeTheme.primaryBackground)
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EdgeTheme.primaryBackground,
      appBar: AppBar(
        title: const Text('CODE OUTPUT'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.rotate, size: 14),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
