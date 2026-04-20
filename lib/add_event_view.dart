import 'package:flutter/material.dart';
import 'common_widget/custom_form_field.dart';
import 'viewmodel/add_event_viewmodel.dart';

const Color _primaryOrange = Color(0xFFFF8C00);
const Color _successGreen = Color(0xFF4CAF50);
const Color _neutralGray = Color(0xFF9E9E9E);
const Color _backgroundColor = Color(0xFFF7F3EE);

class AddEventView extends StatefulWidget {
  const AddEventView({super.key});

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

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = viewModel.isLoading;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Yeni Etkinlik Oluştur',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Profesyonel bir etkinlik oluşturmak için gerekli tüm alanlar aşağıda.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              CustomFormField(
                controller: viewModel.eventNameController,
                label: 'Etkinlik Adı',
                maxLength: 20,
                prefixIcon: Icons.event,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: viewModel.titleController,
                label: 'Başlık',
                maxLength: 20,
                prefixIcon: Icons.title,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: viewModel.descriptionController,
                label: 'Açıklama',
                isTextarea: true,
                prefixIcon: Icons.description,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: viewModel.selectedCity,
                      decoration: const InputDecoration(
                        labelText: 'İl Seçin',
                        prefixIcon: Icon(Icons.location_on, color: _neutralGray),
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
                        prefixIcon: Icon(Icons.location_city, color: _neutralGray),
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
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildInfoChip(viewModel.selectedDateText, Icons.calendar_today),
                  _buildInfoChip(viewModel.selectedTimeText, Icons.access_time),
                  _buildInfoChip(viewModel.selectedImageLabel, Icons.photo_library),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildActionButton('Tarih Seç', Icons.calendar_today, _pickDate)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildActionButton('Saat Seç', Icons.access_time, _pickTime)),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Resim Seç'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _successGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : _submitEvent,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
