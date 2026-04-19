import 'package:flutter/material.dart';
import 'common_widget/custom_form_field.dart';
import 'viewmodel/add_event_viewmodel.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({Key? key}) : super(key: key);

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final AddEventViewModel viewModel = AddEventViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.addListener(_update);
  }

  @override
  void dispose() {
    viewModel.removeListener(_update);
    viewModel.dispose();
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) {
      viewModel.setDate(selected);
    }
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selected != null) {
      viewModel.setTime(selected);
    }
  }

  void _pickImage() {
    viewModel.setImagePath('assets/sample_event_image.png');
  }

  Future<void> _submitEvent() async {
    final success = await viewModel.submitEvent();
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Etkinlik başarıyla kaydedildi.')),
      );
    } else if (viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = viewModel.isLoading;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Ekle'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomFormField(
              controller: viewModel.eventNameController,
              label: 'Etkinlik Adı',
              maxLength: 20,
            ),
            const SizedBox(height: 16),
            CustomFormField(
              controller: viewModel.titleController,
              label: 'Başlık',
              maxLength: 20,
            ),
            const SizedBox(height: 16),
            CustomFormField(
              controller: viewModel.descriptionController,
              label: 'Açıklama',
              isTextarea: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: viewModel.selectedCity,
                    decoration: const InputDecoration(
                      labelText: 'İl Seçin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    items: viewModel.cityOptions
                        .map((city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        viewModel.setCity(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: viewModel.selectedDistrict,
                    decoration: const InputDecoration(
                      labelText: 'İlçe Seçin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    items: viewModel.currentDistrictOptions
                        .map((district) => DropdownMenuItem(
                              value: district,
                              child: Text(district),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        viewModel.setDistrict(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Tarih Seç'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time),
                    label: const Text('Saat Seç'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.selectedDateText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              viewModel.selectedTimeText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              viewModel.selectedImageLabel,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: isLoading ? null : _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Resim Seç'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _submitEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Kaydet',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
