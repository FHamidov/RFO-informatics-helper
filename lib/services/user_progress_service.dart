import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProgressService {
  static const String _solvedProblemsKey = 'solved_problems';
  static const String _topicProgressKey = 'topic_progress';

  Future<Set<String>> getSolvedProblems() async {
    final prefs = await SharedPreferences.getInstance();
    final solvedProblems = prefs.getStringList(_solvedProblemsKey) ?? [];
    return solvedProblems.toSet();
  }

  Future<void> markProblemAsSolved(String problemId) async {
    final prefs = await SharedPreferences.getInstance();
    final solvedProblems = await getSolvedProblems();
    solvedProblems.add(problemId);
    await prefs.setStringList(_solvedProblemsKey, solvedProblems.toList());
  }

  Future<Map<String, double>> getTopicProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_topicProgressKey);
    if (progressJson == null) return {};

    final Map<String, dynamic> decoded = json.decode(progressJson);
    return decoded.map((key, value) => MapEntry(key, value.toDouble()));
  }

  Future<void> updateTopicProgress(String topicId, double progress) async {
    final prefs = await SharedPreferences.getInstance();
    final currentProgress = await getTopicProgress();
    currentProgress[topicId] = progress;
    await prefs.setString(_topicProgressKey, json.encode(currentProgress));
  }

  Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_solvedProblemsKey);
    await prefs.remove(_topicProgressKey);
  }
} 