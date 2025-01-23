import 'package:flutter/foundation.dart';
import '../models/topic.dart';
import '../services/topic_service.dart';

class TopicProvider with ChangeNotifier {
  final TopicService _topicService = TopicService();
  List<Topic> _topics = [];
  Problem? _dailyChallenge;
  bool _isLoading = false;
  String? _error;

  List<Topic> get topics => _topics;
  Problem? get dailyChallenge => _dailyChallenge;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTopics() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _topics = await _topicService.getTopics();
    } catch (e) {
      _error = 'Mövzuları yükləyərkən xəta baş verdi: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDailyChallenge() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _dailyChallenge = await _topicService.getDailyChallenge();
    } catch (e) {
      _error = 'Günün məsələsini yükləyərkən xəta baş verdi: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Problem>> getProblemsForTopic(String topicId) async {
    try {
      return await _topicService.getProblemsForTopic(topicId);
    } catch (e) {
      _error = 'Məsələləri yükləyərkən xəta baş verdi: ${e.toString()}';
      notifyListeners();
      return [];
    }
  }
} 