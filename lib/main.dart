import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:liquid_engine/liquid_engine.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(title: 'flutter_html Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

String htmlData = "";

class _MyHomePageState extends State<MyHomePage> {
  final raw = '''
<html>
  <title>{{ title | default: 'Liquid Example'}}</title>
  <body>
    <table>
    {% for user in users %}
      <tr>
        <td>{{ user.name }}</td>
        <td>{{ user.email }}</td>
        <td>{{ user.roles | join: ', ' | default: 'none' }}</td>
      </tr>
    {% endfor %}
    </table>
  </body>
</html>
  ''';

  final liquidContext = Context.create();

  @override
  Widget build(BuildContext context) {
    liquidContext.variables['users'] = [
      {
        'name': 'Standard User',
        'email': 'standard@test.com',
        'roles': [],
      },
      {
        'name': 'Admin Administrator',
        'email': 'admin@test.com',
        'roles': ['admin', 'super-admin'],
      },
    ];
    final template = Template.parse(liquidContext, Source.fromString(raw));
    template.render(liquidContext).then((String html) {
      setState(() {
        htmlData = html;
      });
    });

    return new Scaffold(
      appBar: AppBar(
        title: Text('flutter_html Example'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Html(
          data: htmlData,
        ),
      ),
    );
  }
}
