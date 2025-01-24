import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/topic.dart';
import '../services/user_progress_service.dart';

class ProblemDetailScreen extends StatefulWidget {
  final Problem problem;

  const ProblemDetailScreen({
    super.key,
    required this.problem,
  });

  @override
  State<ProblemDetailScreen> createState() => _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends State<ProblemDetailScreen> {
  final _userProgressService = UserProgressService();
  bool _isSolved = false;
  String _selectedLanguage = 'C++';

  @override
  void initState() {
    super.initState();
    _checkIfSolved();
  }

  Future<void> _checkIfSolved() async {
    final solvedProblems = await _userProgressService.getSolvedProblems();
    setState(() {
      _isSolved = solvedProblems.contains(widget.problem.id);
    });
  }

  Future<void> _toggleSolved() async {
    if (_isSolved) {
      // Problem already solved, do nothing
      return;
    }

    await _userProgressService.markProblemAsSolved(widget.problem.id);
    setState(() {
      _isSolved = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Məsələ həll edildi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.problem.title),
        actions: [
          IconButton(
            icon: Icon(_isSolved ? Icons.check_circle : Icons.check_circle_outline),
            color: _isSolved ? Colors.green : null,
            onPressed: _toggleSolved,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProblemInfo(),
          const SizedBox(height: 16),
          if (widget.problem.solutionCodes.isNotEmpty) ...[
            _buildSolutionSection(),
            const SizedBox(height: 16),
          ],
          if (widget.problem.explanation.isNotEmpty) ...[
            _buildExplanationSection(),
            const SizedBox(height: 16),
          ],
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProblemInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.problem.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.problem.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(widget.problem.difficulty),
                  backgroundColor: _getDifficultyColor(widget.problem.difficulty),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(widget.problem.source),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Həll Nümunəsi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: widget.problem.solutionCodes.keys
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                widget.problem.solutionCodes[_selectedLanguage] ?? '',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Həllin İzahı',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            MarkdownBody(
              data: widget.problem.explanation,
              selectable: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final url = Uri.parse(widget.problem.url);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
          icon: const Icon(Icons.launch),
          label: const Text('Məsələyə Keç'),
        ),
        ElevatedButton.icon(
          onPressed: _toggleSolved,
          icon: Icon(_isSolved ? Icons.check_circle : Icons.check_circle_outline),
          label: Text(_isSolved ? 'Həll Edilib' : 'Həll Edildi'),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'asan':
        return Colors.green.shade100;
      case 'orta':
        return Colors.orange.shade100;
      case 'çətin':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
} 