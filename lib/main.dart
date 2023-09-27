import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      primaryColor: Colors.white12,
      scaffoldBackgroundColor: Colors.white12,
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
              "IB Hub",
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
                    color: Colors.white10,
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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LiveClassPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              minimumSize: const Size(480, 65),
            ),
            child: const Text('Join Live Class'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class LiveClassPage extends StatefulWidget {
  const LiveClassPage({Key? key}) : super(key: key);

  @override
  _LiveClassPageState createState() => _LiveClassPageState();
}

class _LiveClassPageState extends State<LiveClassPage> {
  String imageUrl = '';

  TextEditingController imageUrlController = TextEditingController();
  GlobalKey<_LiveImageState> imageKey = GlobalKey();

  Future<void> loadImage() async {
    final response = await http.get(Uri.parse('https://ibhubrestapi.onrender.com/live'));

    if (response.statusCode == 200) {
      setState(() {
        imageUrl = response.headers['ActiveImage-URL'] ?? '';
      });
    }
  }

  // Function to update the image URL via a POST request
  Future<void> updateImageUrl(String newImageUrl) async {
    final response = await http.post(
      Uri.parse('https://ibhubrestapi.onrender.com/live'),
      headers: {'ActiveImage-URL': newImageUrl},
    );

    if (response.statusCode == 200) {
      setState(() {
        imageUrl = newImageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Class'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: loadImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                minimumSize: const Size(270, 50),
              ),
              child: const Text('Load Image'),
            ),
            const SizedBox(height: 16),
            Image.network(
                imageUrl,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('No image currently active!');
                },
                key: imageKey,
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.75,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Image URL',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newImageUrl = imageUrlController.text;
                updateImageUrl(newImageUrl);
                imageKey.currentState?.reloadImage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                minimumSize: const Size(270, 50),
              ),
              child: const Text('Update Image URL'),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveImage extends StatefulWidget {
  final String imageUrl;

  const LiveImage({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  _LiveImageState createState() => _LiveImageState();
}

class _LiveImageState extends State<LiveImage> {
  // A key method to trigger a rebuild of this widget
  void reloadImage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(widget.imageUrl); // Display the image
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
              color: Colors.white10,
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
  List<File> pickedImages = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    setState(() {
      pickedImages = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });
    }

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
                final item = widget.notes[widget.subject]?[widget.writingType]?[index];
                if (item!.startsWith("ImageFile:")) {
                  return ListTile(
                    title: Image.file(
                      File(item.substring(10)),
                      alignment: Alignment.centerLeft,
                      width: 300,
                      height: 300,
                    ),
                  );
                } else {
                  return ListTile(
                    title: Text("• $item"),
                  );
                }
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
          ElevatedButton(
            onPressed: _pickImages,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              minimumSize: const Size(270, 50),
            ),
            child: const Text('Pick Images')
          ),
          const SizedBox(height: 16),
          if (pickedImages.isNotEmpty)
            Column(
              children: [
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: pickedImages.map((image) {
                    return SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.file(image),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final documentText = documentController.text;

                if (widget.notes[widget.subject] == null) {
                  widget.notes[widget.subject] = {};
                }

                if (widget.notes[widget.subject]?[widget.writingType] == null) {
                  widget.notes[widget.subject]?[widget.writingType] = [];
                }

                widget.notes[widget.subject]?[widget.writingType]?.add(documentText);
                widget.notes[widget.subject]?[widget.writingType]?.addAll(pickedImages.map((image) => "ImageFile:${image.path}"));

                documentController.clear();
                pickedImages.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              minimumSize: const Size(270, 50),
            ),
            child: Text('Save ${widget.writingType}'),
          ),
          const SizedBox(height: 16),
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
