import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4, // number of tabs
        child: _TabsNonScrollableDemo(),
      ),
    );
  }
}

class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() => __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;

  final RestorableInt tabIndex = RestorableInt(0);

  // required for TextFields on tab 2
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,// number of tabs
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    // dispose TextEditingControllers created for TextFields on tab 2
    nameController.dispose();
    noteController.dispose();

    super.dispose();
  }
  // function to show AlertDialog on tab 1
  void _showAlertDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: const Text('This is an AlertDialog from Tab 1.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // tab titles
    final tabs = ['Alert', 'Image', 'Button', 'List'];
    // sample items for ListView on tab 4
    final items = List.generate(10, (i) => 'Item ${i + 1}');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tabs Demo by Alan P.'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          // removed previous for loop and used individual containers for each tab
          // ***** TAB 1: Text + AlertDialog *****
          Container(
            color: Colors.lightBlue.shade100,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tab 1: Text + Alert Dialog',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _showAlertDialog,
                    child: const Text('Show Alert Dialog'),
                  ),
                ],
              ),
            ),
          ),

          // ****** TAB 2: Image + Text Inputs ******
          Container(
            color: Colors.lightGreen.shade100,
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const Text(
                  'Tab 2: Image + Text Inputs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Image.network(
                    'https://picsum.photos/300/200',
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),

          // ****** TAB 3: Button + SnackBar ******
          Container(
            color: Colors.orange.shade100,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Button pressed in ${tabs[2]} tab!'),
                    ),
                  );
                },
                child: const Text('Click me'),
              ),
            ),
          ),

          // ****** TAB 4: ListView + Card widgets ******
          Container(
            color: Colors.purple.shade100,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(items[index]),
                    subtitle: const Text('Card details go here'),
                    leading: const Icon(Icons.list),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // bottom navigation with FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _tabController.index = 3;
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.looks_one),
                onPressed: () => _tabController.index = 0,
              ),
              IconButton(
                icon: const Icon(Icons.looks_two),
                onPressed: () => _tabController.index = 1,
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.looks_3),
                onPressed: () => _tabController.index = 2,
              ),
              IconButton(
                icon: const Icon(Icons.looks_4),
                onPressed: () => _tabController.index = 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}