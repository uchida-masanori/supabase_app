import 'package:flutter/material.dart';
import 'package:supabase_app/pages/splash_page.dart';
import 'package:supabase_app/util/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kcjfiqrictmyahdvgesh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjamZpcXJpY3RteWFoZHZnZXNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM2NDI3NzAsImV4cCI6MjAwOTIxODc3MH0.1CUEuIWruGUIMlXrAWfWsuTCJl938kPbrA6a1pbvu9g',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Chat App',
      theme: appTheme,
      home: const SplashPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _noteStream =
      Supabase.instance.client.from('notes').stream(primaryKey: ['id']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _noteStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final notes = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        notes[index]['body'],
                      ),
                    );
                  },
                  childCount: notes.length,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return SimpleDialog(
                  title: const Text('Add a Note'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 1),
                  children: [
                    TextFormField(
                      onFieldSubmitted: (value) async {
                        await Supabase.instance.client
                            .from('notes')
                            .insert({'body': value});
                      },
                    )
                  ],
                );
              }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
