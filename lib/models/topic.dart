class Topic {
  final String id;
  final String title;
  final String description;
  final String theoreticalContent;
  final List<Problem> problems;

  Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.theoreticalContent,
    required this.problems,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      theoreticalContent: json['theoreticalContent'] as String,
      problems: (json['problems'] as List<dynamic>)
          .map((e) => Problem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Problem {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String source;
  final String url;
  final Map<String, String> solutionCodes;
  final String explanation;

  Problem({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.source,
    required this.url,
    this.solutionCodes = const {},
    this.explanation = '',
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as String,
      source: json['source'] as String,
      url: json['url'] as String,
      solutionCodes: Map<String, String>.from(json['solutionCodes'] ?? {}),
      explanation: json['explanation'] as String? ?? '',
    );
  }
} 