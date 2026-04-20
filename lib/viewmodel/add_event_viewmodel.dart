import 'dart:io';

import 'package:flutter/material.dart';

import '../model/event_model.dart';
import '../repository/event_repository.dart';
import '../services/storage_service.dart';

class AddEventViewModel extends ChangeNotifier {
  final StorageService storageService;
  final EventRepository eventRepository;

  AddEventViewModel({
    StorageService? storageService,
    EventRepository? eventRepository,
  })  : storageService = storageService ?? StorageService(),
        eventRepository = eventRepository ?? EventRepository();

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<String> cityOptions = ['Ankara', 'İstanbul', 'İzmir'];
  final Map<String, List<String>> districtOptions = {
    'Ankara': ['Keçiören', 'Çankaya', 'Yenimahalle'],
    'İstanbul': ['Kadıköy', 'Üsküdar', 'Beşiktaş'],
    'İzmir': ['Karşıyaka', 'Bornova', 'Konak'],
  };

  String selectedCity = 'Ankara';
  String selectedDistrict = 'Keçiören';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedImagePath;

  bool _isLoading = false;
  String? errorMessage;

  bool get isLoading => _isLoading;

  String get selectedDateText {
    return selectedDate == null
        ? 'Tarih seçilmedi'
        : '${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}';
  }

  String get selectedTimeText {
    return selectedTime == null
        ? 'Saat seçilmedi'
        : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
  }

  String get selectedImageLabel {
    return selectedImagePath == null ? 'Henüz resim seçilmedi' : 'Resim seçildi';
  }

  List<String> get currentDistrictOptions => districtOptions[selectedCity] ?? [];

  void setCity(String city) {
    selectedCity = city;
    final districts = districtOptions[city];
    if (districts != null && !districts.contains(selectedDistrict)) {
      selectedDistrict = districts.first;
    }
    notifyListeners();
  }

  void setDistrict(String district) {
    selectedDistrict = district;
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void setImagePath(String path) {
    selectedImagePath = path;
    notifyListeners();
  }

  Future<bool> submitEvent() async {
    _setLoading(true);
    errorMessage = null;

    try {
      String? imageUrl;
      if (selectedImagePath != null && selectedImagePath!.isNotEmpty) {
        final file = File(selectedImagePath!);
        imageUrl = await storageService.uploadEventImage(file);
      }

      final event = EventModel(
        eventName: eventNameController.text.trim(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        city: selectedCity,
        district: selectedDistrict,
        date: selectedDate,
        time: selectedTime != null
            ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
            : null,
        imagePath: imageUrl,
        organizer: null,
        participantsCount: 1,
        createdAt: DateTime.now(),
      );

      await eventRepository.addEvent(event);
      _clearForm();
      return true;
    } catch (e) {
      errorMessage = 'Etkinlik kaydedilirken bir hata oluştu.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearForm() {
    eventNameController.clear();
    titleController.clear();
    descriptionController.clear();
    selectedCity = 'Ankara';
    selectedDistrict = 'Keçiören';
    selectedDate = null;
    selectedTime = null;
    selectedImagePath = null;
    notifyListeners();
  }

  @override
  void dispose() {
    eventNameController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
