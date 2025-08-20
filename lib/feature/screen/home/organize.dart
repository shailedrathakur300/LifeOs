import 'package:flutter/material.dart';

/// A simple setup to run the daily planner screen as a standalone app.


class OrganizePage extends StatelessWidget {
  const OrganizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.green,
      ),
      home: const Scaffold(
        body: DailyPlannerScreen(),
      ),
    );
  }
}

/// The main screen widget for the Daily Planner.
class DailyPlannerScreen extends StatefulWidget {
  const DailyPlannerScreen({super.key});

  @override
  State<DailyPlannerScreen> createState() => _DailyPlannerScreenState();
}

class _DailyPlannerScreenState extends State<DailyPlannerScreen> {
  // Controllers for the question TextFields
  late final TextEditingController _q1Controller;
  late final TextEditingController _q2Controller;
  late final TextEditingController _q3Controller;
  late final TextEditingController _q4Controller;

  // A list of controllers for the time block table
  late final List<TextEditingController> _timeBlockControllers;
  final int _startHour = 6;
  final int _endHour = 21;

  @override
  void initState() {
    super.initState();
    _q1Controller = TextEditingController();
    _q2Controller = TextEditingController();
    _q3Controller = TextEditingController();
    _q4Controller = TextEditingController();

    // Initialize one controller for each hour from 06:00 to 21:00.
    final int rowCount = _endHour - _startHour + 1;
    _timeBlockControllers = List.generate(rowCount, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _q1Controller.dispose();
    _q2Controller.dispose();
    _q3Controller.dispose();
    _q4Controller.dispose();
    for (final controller in _timeBlockControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The entire screen is wrapped in a SingleChildScrollView to ensure
    // it's scrollable, especially on smaller devices or when the keyboard is open.
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ## PART 1: Organise Section ##
            _buildOrganiseSection(),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // ## PART 2: Time Block Table ##
            _buildTimeBlockSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the top section with the button and questions.
  Widget _buildOrganiseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Organise"),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Let’s make sure things are organised to avoid overwhelm",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 24),
        _QuestionField(
          question: "What’s today’s adventure (single most important task) going to be? Is it in the calendar?",
          controller: _q1Controller,
        ),
        const SizedBox(height: 20),
        _QuestionField(
          question: "Have you updated your Task & Projects List?",
          controller: _q2Controller,
        ),
        const SizedBox(height: 20),
        _QuestionField(
          question: "If you have time, what other 1–3 Tasks will you complete today? Are those written down somewhere?",
          controller: _q3Controller,
        ),
        const SizedBox(height: 20),
        _QuestionField(
          question: "When is today’s Mini Admin Party? Is it in the calendar?",
          controller: _q4Controller,
        ),
      ],
    );
  }

  /// Builds the bottom section with the time block table.
  Widget _buildTimeBlockSection() {
    return Column(
      children: List.generate(_timeBlockControllers.length, (index) {
        // Format the hour to a "HH:00" string.
        final String time = "${(_startHour + index).toString().padLeft(2, '0')}:00";
        return _TimeBlockRow(
          time: time,
          controller: _timeBlockControllers[index],
        );
      }),
    );
  }
}

/// A reusable widget for a question and its corresponding TextField.
class _QuestionField extends StatelessWidget {
  final String question;
  final TextEditingController controller;

  const _QuestionField({
    required this.question,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}

/// A reusable widget for a single row in the time block table.
class _TimeBlockRow extends StatelessWidget {
  final String time;
  final TextEditingController controller;

  const _TimeBlockRow({
    required this.time,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          // Time label with a fixed width for alignment
          SizedBox(
            width: 60,
            child: Text(
              time,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          // The TextField takes up the remaining horizontal space
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Task or Time Block',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}