import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/api_endpoints.dart';

class ProgressService extends GetxService {
  var unlockedWritingLetter = 0.obs;
  var unlockedWritingWord = 0.obs;
  var unlockedSpellingLetter = 0.obs;
  var unlockedSpellingWord = 0.obs;

  // --- MAPS MISSION STATE ---
  var currentMissionIndex = 0.obs;
  var completedMissions = <int>[].obs;
  
  late SharedPreferences _prefs;

  Future<ProgressService> init() async {
    _prefs = await SharedPreferences.getInstance();
    unlockedWritingLetter.value = _prefs.getInt('unlocked_writing_letter') ?? 0;
    unlockedWritingWord.value = _prefs.getInt('unlocked_writing_word') ?? 0;
    unlockedSpellingLetter.value = _prefs.getInt('unlocked_spelling_letter') ?? 0;
    unlockedSpellingWord.value = _prefs.getInt('unlocked_spelling_word') ?? 0;

    currentMissionIndex.value = _prefs.getInt('current_mission_index') ?? 0;
    List<String>? savedMissions = _prefs.getStringList('completed_missions');
    if (savedMissions != null) {
      completedMissions.value = savedMissions.map((e) => int.parse(e)).toList();
    }
    return this;
  }

  void _saveLocal(String key, int value) {
    _prefs.setInt(key, value);
    _syncToBackend();
  }
  
  void updateMissionProgress(int index, List<int> completed) {
    currentMissionIndex.value = index;
    completedMissions.value = completed;
    _prefs.setInt('current_mission_index', index);
    _prefs.setStringList('completed_missions', completed.map((e) => e.toString()).toList());
    _syncToBackend();
  }

  void completeWritingLetter(int currentIndex) {
    if (currentIndex >= unlockedWritingLetter.value) {
      unlockedWritingLetter.value = currentIndex + 1;
      _saveLocal('unlocked_writing_letter', unlockedWritingLetter.value);
    }
  }

  void completeWritingWord(int currentIndex) {
    if (currentIndex >= unlockedWritingWord.value) {
      unlockedWritingWord.value = currentIndex + 1;
      _saveLocal('unlocked_writing_word', unlockedWritingWord.value);
    }
  }

  void completeSpellingLetter(int currentIndex) {
    if (currentIndex >= unlockedSpellingLetter.value) {
      unlockedSpellingLetter.value = currentIndex + 1;
      _saveLocal('unlocked_spelling_letter', unlockedSpellingLetter.value);
    }
  }

  void completeSpellingWord(int currentIndex) {
    if (currentIndex >= unlockedSpellingWord.value) {
      unlockedSpellingWord.value = currentIndex + 1;
      _saveLocal('unlocked_spelling_word', unlockedSpellingWord.value);
    }
  }

  void completeObjectHunt(int currentIndex) {
    // Tidak ada lock/unlock untuk object hunt — setiap item bisa diulang
    // Fungsi ini tetap disimpan untuk consistency logging
    _syncToBackend();
  }
  
  void fromJson(Map<String, dynamic> json) {
    if (json['unlocked_writing_letter'] != null) {
      unlockedWritingLetter.value = json['unlocked_writing_letter'];
      _prefs.setInt('unlocked_writing_letter', unlockedWritingLetter.value);
    }
    if (json['unlocked_writing_word'] != null) {
      unlockedWritingWord.value = json['unlocked_writing_word'];
      _prefs.setInt('unlocked_writing_word', unlockedWritingWord.value);
    }
    if (json['unlocked_spelling_letter'] != null) {
      unlockedSpellingLetter.value = json['unlocked_spelling_letter'];
      _prefs.setInt('unlocked_spelling_letter', unlockedSpellingLetter.value);
    }
    if (json['unlocked_spelling_word'] != null) {
      unlockedSpellingWord.value = json['unlocked_spelling_word'];
      _prefs.setInt('unlocked_spelling_word', unlockedSpellingWord.value);
    }

    if (json['current_mission_index'] != null) {
      currentMissionIndex.value = json['current_mission_index'];
      _prefs.setInt('current_mission_index', currentMissionIndex.value);
    }
    if (json['completed_missions'] != null && json['completed_missions'] is List) {
      List<int> missions = (json['completed_missions'] as List).map((e) => int.parse(e.toString())).toList();
      completedMissions.value = missions;
      _prefs.setStringList('completed_missions', missions.map((e) => e.toString()).toList());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "unlocked_writing_letter": unlockedWritingLetter.value,
      "unlocked_writing_word": unlockedWritingWord.value,
      "unlocked_spelling_letter": unlockedSpellingLetter.value,
      "unlocked_spelling_word": unlockedSpellingWord.value,
      "current_mission_index": currentMissionIndex.value,
      "completed_missions": completedMissions.toList(),
    };
  }
  
  void _syncToBackend() async {
    try {
      String email = _prefs.getString('user_email') ?? "";
      if (email.isEmpty) return; // Belum login

      Map<String, dynamic> payload = toJson();
      payload['email'] = email;
      
      final url = Uri.parse(ApiEndpoints.syncProgress);
      await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
    } catch (e) {
      print("Sync Progress Error: $e");
    }
  }
}
