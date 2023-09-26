import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.blueGrey.shade900,
    ),
    home: const NoteApp(),
  ));
}

class NoteApp extends StatefulWidget {
  const NoteApp({Key? key}) : super(key: key);

  @override
  _NoteAppState createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  final List<Map<String, dynamic>> subjects = [
    {'name': 'Mathematics AA', 'icon': Icons.calculate},
    {'name': 'Physics', 'icon': Icons.bolt},
    {'name': 'Chemistry', 'icon': Icons.biotech},
    {'name': 'Biology', 'icon': Icons.energy_savings_leaf},
    {'name': 'English A', 'icon': Icons.book},
    {'name': 'Serbian Literature', 'icon': Icons.book},
    {'name': 'TOK', 'icon': Icons.lightbulb},
    {'name': 'CAS', 'icon': Icons.group},
    {'name': 'EE', 'icon': Icons.emoji_objects},
    {'name': 'Digital Society', 'icon': Icons.computer},
    {'name': 'Psychology', 'icon': Icons.psychology},
    {'name': 'Economics', 'icon': Icons.attach_money},
    // Add more subjects as needed
  ];
  final Map<String, Map<String, List<String>>> notes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "IB Portal",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                ),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    color: Colors.blueGrey.shade800,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WritingTypeSelection(
                              subject: subjects[index]['name'],
                              notes: notes,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(subjects[index]['icon'], size: 48),
                          const SizedBox(height: 8),
                          Text(
                            subjects[index]['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WritingTypeSelection extends StatelessWidget {
  final String subject;
  final Map<String, Map<String, List<String>>> notes;

  const WritingTypeSelection({
    Key? key,
    required this.subject,
    required this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
      ),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2),
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            List<String> writingTypes = ['Notes', 'Essay', 'Revision', 'Homework'];
            List<IconData> icons = [Icons.note, Icons.edit, Icons.description, Icons.assignment];

            return Card(
              elevation: 5,
              color: Colors.blueGrey.shade800,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentPage(
                        subject: subject,
                        notes: notes,
                        writingType: writingTypes[index],
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(icons[index], size: 48),
                    const SizedBox(height: 8),
                    Text(
                      writingTypes[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DocumentPage extends StatefulWidget {
  final String subject;
  final Map<String, Map<String, List<String>>> notes;
  final String writingType;

  const DocumentPage({
    Key? key,
    required this.subject,
    required this.notes,
    required this.writingType,
  }) : super(key: key);

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  final TextEditingController documentController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.subject} - ${widget.writingType}"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: (widget.notes[widget.subject]?[widget.writingType]?.length) ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.notes[widget.subject]?[widget.writingType]?[index] ?? ""),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: documentController,
              maxLines: null,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Write ${widget.writingType}',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: imageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Add Images (URLs)',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final documentText = documentController.text;
                final imageUrls = imageController.text.split('\n');

                if (widget.notes[widget.subject] == null) {
                  widget.notes[widget.subject] = {};
                }

                if (widget.notes[widget.subject]?[widget.writingType] == null) {
                  widget.notes[widget.subject]?[widget.writingType] = [];
                }

                widget.notes[widget.subject]?[widget.writingType]?.add(documentText);
                widget.notes[widget.subject]?[widget.writingType]?.addAll(imageUrls);

                documentController.clear();
                imageController.clear();
              });
            },
            child: Text('Save ${widget.writingType}'),
          ),
        ],
      ),
    );
  }
}

class NotePage extends StatefulWidget {
  final String subject;
  final Map<String, Map<String, List<String>>> notes;

  const NotePage({
    required this.subject,
    required this.notes,
    Key? key,
  }) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: (widget.notes[widget.subject]?['Notes']?.length) ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.notes[widget.subject]?['Notes']?[index] ?? ""),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: noteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Write note',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final noteText = noteController.text;

                if (widget.notes[widget.subject] == null) {
                  widget.notes[widget.subject] = {};
                }

                if (widget.notes[widget.subject]?['Notes'] == null) {
                  widget.notes[widget.subject]?['Notes'] = [];
                }

                widget.notes[widget.subject]?['Notes']?.add(noteText);
                noteController.clear();
              });
            },
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }
}
