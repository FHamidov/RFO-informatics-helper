import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/topic.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;

  const TopicDetailScreen({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTheorySection(context),
          const SizedBox(height: 16),
          _buildProblemsList(context),
        ],
      ),
    );
  }

  Widget _buildTheorySection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nəzəri Hissə',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            MarkdownBody(
              data: topic.theoreticalContent,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                h1: Theme.of(context).textTheme.headlineMedium,
                h2: Theme.of(context).textTheme.titleLarge,
                p: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemsList(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Məsələlər',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topic.problems.length,
              itemBuilder: (context, index) {
                final problem = topic.problems[index];
                return Card(
                  child: ListTile(
                    title: Text(problem.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(problem.description),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Chip(
                              label: Text(problem.difficulty),
                              backgroundColor: _getDifficultyColor(problem.difficulty),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(problem.source),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.launch),
                      onPressed: () => _launchProblemUrl(problem.url),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
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

  Future<void> _launchProblemUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }
} 