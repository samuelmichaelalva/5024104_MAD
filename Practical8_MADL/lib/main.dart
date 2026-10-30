import 'package:flutter/material.dart';

void main() => runApp(const NotesApp());

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Notes',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xfff5f6fa),
      ),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final searchController = TextEditingController();

  final List<String> notes = [];
  bool loading = false;
  int editingIndex = -1;
  String status = 'Ready';

  void saveNote() {
    final title = titleController.text.trim();
    final body = bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      setState(() => status = 'Please enter title and content');
      return;
    }

    setState(() {
      if (editingIndex == -1) {
        notes.insert(0, '$title\n$body');
        status = 'Note saved successfully';
      } else {
        notes[editingIndex] = '$title\n$body';
        editingIndex = -1;
        status = 'Note updated successfully';
      }
      titleController.clear();
      bodyController.clear();
    });
  }

  void editNote(int index) {
    final parts = notes[index].split('\n');
    titleController.text = parts.first;
    bodyController.text = parts.skip(1).join('\n');
    setState(() {
      editingIndex = index;
      status = 'Editing note ${index + 1}';
    });
  }

  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      status = 'Note deleted successfully';
      if (editingIndex == index) {
        editingIndex = -1;
        titleController.clear();
        bodyController.clear();
      }
    });
  }

  void clearAll() {
    if (notes.isEmpty) {
      setState(() => status = 'There are no notes to delete');
      return;
    }

    setState(() {
      notes.clear();
      editingIndex = -1;
      titleController.clear();
      bodyController.clear();
      status = 'All notes deleted';
    });
  }

  void cancelEdit() {
    titleController.clear();
    bodyController.clear();
    setState(() {
      editingIndex = -1;
      status = 'Ready';
    });
  }

  List<int> get filteredIndexes {
    final query = searchController.text.toLowerCase();
    return List.generate(notes.length, (i) => i)
        .where((i) => notes[i].toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.note_alt_outlined),
            SizedBox(width: 10),
            Text(
              'Smart Notes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Delete all notes',
            onPressed: clearAll,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Notes',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Create, edit and securely store your notes.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _statCard(Icons.notes_outlined, 'Total Notes', '${notes.length}'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(Icons.storage_outlined, 'Storage', 'Browser'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          editingIndex == -1 ? 'Create New Note' : 'Edit Note',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            prefixIcon: Icon(Icons.title),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: bodyController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Note content',
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.edit_note),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: saveNote,
                                icon: Icon(
                                  editingIndex == -1 ? Icons.save_outlined : Icons.update,
                                ),
                                label: Text(
                                  editingIndex == -1 ? 'Save Note' : 'Update Note',
                                ),
                              ),
                            ),
                            if (editingIndex != -1) ...[
                              const SizedBox(width: 10),
                              OutlinedButton(
                                onPressed: cancelEdit,
                                child: const Text('Cancel'),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Saved Notes',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text('${filteredIndexes.length} found'),
                  ],
                ),
                const SizedBox(height: 12),
                if (filteredIndexes.isEmpty)
                  _emptyState()
                else
                  ...filteredIndexes.map((index) => _noteCard(index)),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(.07),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    'Powered by Flutter Web + Browser Local Storage',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String title, String value) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: const [
            Icon(Icons.note_add_outlined, size: 50, color: Colors.grey),
            SizedBox(height: 12),
            Text('No notes found'),
          ],
        ),
      ),
    );
  }

  Widget _noteCard(int index) {
    final parts = notes[index].split('\n');
    final noteTitle = parts.first;
    final noteBody = parts.skip(1).join('\n');

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        title: Text(
          noteTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            noteBody,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => editNote(index),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () => deleteNote(index),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
