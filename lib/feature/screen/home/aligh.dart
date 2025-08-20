import 'package:flutter/material.dart';

class AlignPage extends StatelessWidget {
  const AlignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeOS Onboarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.deepPurple, // You can change this to match your brand color
      ),
      home: const OnboardingLifeOSScreen(),
    );
  }
}
class OnboardingLifeOSScreen extends StatefulWidget {
  const OnboardingLifeOSScreen({super.key});

  @override
  State<OnboardingLifeOSScreen> createState() => _OnboardingLifeOSScreenState();
}

class _OnboardingLifeOSScreenState extends State<OnboardingLifeOSScreen> {
  final Map<String, List<Widget>> _kanbanData = {
    'Work Main Quest': List.generate(1, (_) => const _KanbanCard()),
    'Life Main Quest': List.generate(1, (_) => const _KanbanCard()),
    'Side Quest': List.generate(2, (_) => const _KanbanCard()),
    'Weekly Priorities': List.generate(3, (_) => const _KanbanCard()),
    'Project': List.generate(4, (_) => const _KanbanCard()),
    'Task': List.generate(8, (_) => const _KanbanCard()),
  };

  /// A function to add a new card to a specified column and refresh the UI.
  void _addCard(String key) {
    setState(() {
      _kanbanData[key]?.add(const _KanbanCard());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get screen dimensions for a responsive layout.
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        // CustomScrollView is used for its ability to combine different scrollable
        // elements (slivers) into a single seamless scroll view.
        child: CustomScrollView(
          slivers: [
            // ## PART 1: LifeOS Quests, Projects & Tasks Tracker ##
            _buildTrackerSection(context, screenHeight, screenWidth),

            // ## PART 2: Alignment & Reflection ##
            _buildReflectionSection(context),
          ],
        ),
      ),
    );
  }

  /// Builds the top section containing the title and the Kanban board.
  SliverList _buildTrackerSection(BuildContext context, double screenHeight, double screenWidth) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Text(
            "LifeOS Quests, Projects & Tasks Tracker",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        // The horizontally scrolling section is constrained to 50% of the screen height.
        SizedBox(
          height: screenHeight * 0.5,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _kanbanData.length,
            itemBuilder: (context, index) {
              final title = _kanbanData.keys.elementAt(index);
              final cards = _kanbanData[title]!;
              // Each item in the horizontal list is a fully functional Kanban column.
              return _KanbanColumn(
                title: title,
                // Each column is 80% of the screen width to show a "peek" of the next one.
                width: screenWidth * 0.8,
                children: cards,
                onAdd: () => _addCard(title),
              );
            },
          ),
        ),
      ]),
    );
  }

  /// Builds the bottom section containing the alignment button and reflection questions.
  SliverToBoxAdapter _buildReflectionSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text("Align", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Let's check in with our Quests and key Priorities.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const _QuestionField(
              question: "What are your Quarterly Quests? How are they going?",
            ),
            const SizedBox(height: 24),
            const _QuestionField(
              question: "What were your top three outcomes for this week? How are they going?",
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget representing a single column in the Kanban board.
class _KanbanColumn extends StatelessWidget {
  final String title;
  final double width;
  final List<Widget> children;
  final VoidCallback onAdd;

  const _KanbanColumn({
    required this.title,
    required this.width,
    required this.children,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Theme.of(context).colorScheme.primary),
                  onPressed: onAdd,
                  tooltip: 'Add new item',
                ),
              ],
            ),
          ),
          // The Expanded widget ensures the ListView takes up all available
          // vertical space, making it scrollable.
          Expanded(
            child: ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) => children[index],
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget for an individual card within a Kanban column.
class _KanbanCard extends StatelessWidget {
  const _KanbanCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {}, // Placeholder for card tap functionality
        borderRadius: BorderRadius.circular(12),
        child: const SizedBox(
          height: 60, // Gives cards a consistent, tappable height.
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            // In a real application, the content of the card would go here.
            child: Text(''),
          ),
        ),
      ),
    );
  }
}

/// A reusable widget for the reflection questions and their text fields.
class _QuestionField extends StatelessWidget {
  final String question;

  const _QuestionField({required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        TextField(
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
