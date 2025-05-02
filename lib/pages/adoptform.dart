import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class AdoptForm extends StatelessWidget {
  final int petId;
  final String petName;

  const AdoptForm({super.key, required this.petId, required this.petName});

  @override
  Widget build(BuildContext context) {
    final candidateController = Get.find<CandidateController>();

    return Dialog(
      backgroundColor: const Color.fromARGB(255, 135, 172, 228),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minHeight: MediaQuery.of(context).size.height * 0.6,
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Adoption Application for $petName',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color.fromARGB(255, 135, 172, 228),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CandidateInputWidget(petId: petId, petName: petName),
                    const SizedBox(height: 20),
                    _buildPendingApplications(candidateController),
                  ],
                ),
              ),
            ),
            _buildFormActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingApplications(CandidateController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const Text(
            'Your Pending Applications:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 135, 172, 228),
              ),
          ),
          const SizedBox(height: 10),
          if (controller.getApplicationsForPet(petId).isEmpty)
            const Text('No pending applications'),
          ...controller.getApplicationsForPet(petId).map((app) => ListTile(
                title: Text(app.name),
                subtitle: Text(
                    'Applied ${DateFormat.yMd().add_jm().format(app.submittedAt)}'),
                trailing: Text('Position: ${controller.getQueuePosition(app)}'),
              )),
        ],
      ),
    );
  }

  Widget _buildFormActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                color: Colors.red, 
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _submitForm(context),
            child: const Text(
              'Submit Application',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 9, 68, 196), 
              ),
            ),          ),
        ],
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (CandidateInputWidget._formKey.currentState!.saveAndValidate()) {
      final formData = CandidateInputWidget._formKey.currentState!.value;
      final candidate = Candidate(
        petId,
        petName,
        formData['candidate'],
        formData['address'],
        formData['phone'],
        formData['dob'],
        formData['job'],
        formData['description'],
      );

      final controller = Get.find<CandidateController>();
      if (controller.hasExistingApplication(petId, formData['candidate'])) {
        Get.snackbar('Error', 'You already have an application for this pet');
        return;
      }

      controller.add(candidate);
      CandidateInputWidget._formKey.currentState!.reset();
      Navigator.pop(context);
    }
  }
}

class Candidate {
  final int petId;
  final String petName;
  final String name;
  final String address;
  final String phone;
  final String dob;
  final String job;
  final String description;
  final DateTime submittedAt;

  Candidate(this.petId, this.petName, this.name, this.address, this.phone,
      this.dob, this.job, this.description)
      : submittedAt = DateTime.now();

  Map toJson() => {
        'petId': petId,
        'petName': petName,
        'name': name,
        'address': address,
        'phone': phone,
        'dob': dob,
        'job': job,
        'description': description,
        'submittedAt': submittedAt.toIso8601String(),
      };

  factory Candidate.fromJson(Map json) => Candidate(
        json['petId'],
        json['petName'],
        json['name'],
        json['address'],
        json['phone'],
        json['dob'],
        json['job'],
        json['description'],
      );
}

class CandidateController {
  final storage = Hive.box("storage");
  RxList candidates = [].obs;

  CandidateController() {
    _initializeStorage();
  }

  void _initializeStorage() {
    if (storage.get('candidates') == null) storage.put('candidates', []);
    candidates.value = storage
        .get('candidates')
        .map((c) => Candidate.fromJson(c))
        .toList();
  }

  getApplicationsForPet(int petId) {
    return _getQueueForPet(petId).where((c) => c.petId == petId).toList();
  }

  int getQueuePosition(Candidate candidate) {
    final queue = _getQueueForPet(candidate.petId);
    return queue.indexWhere((c) => c.submittedAt == candidate.submittedAt) + 1;
  }

  bool hasExistingApplication(int petId, String name) {
    return candidates.any((c) => c.petId == petId && c.name == name);
  }

  void add(Candidate candidate) {
    final exists = candidates
        .any((c) => c.petId == candidate.petId && c.name == candidate.name);

    if (exists) {
      Get.snackbar('Error', 'You already applied for this pet!');
      return;
    }

    candidates.add(candidate);
    _save();

    final queue = _getQueueForPet(candidate.petId);
    final position =
        queue.indexWhere((c) => c.submittedAt == candidate.submittedAt) + 1;

    Get.snackbar(
      'Application Submitted!',
      'You are position $position in the queue for ${candidate.petName}',
      duration: const Duration(seconds: 5),
    );
  }

  _getQueueForPet(int petId) {
    return candidates
        .where((c) => c.petId == petId)
        .toList()
      ..sort((a, b) => a.submittedAt.compareTo(b.submittedAt));
  }

  void delete(Candidate candidate) {
    candidates.remove(candidate);
    _save();
  }

  void _save() {
    storage.put('candidates', candidates.map((c) => c.toJson()).toList());
  }

  get size => candidates.length;
}

class CandidateListWidget extends StatelessWidget {
  final candidateController = Get.find<CandidateController>();

  CandidateListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final candidates = candidateController.candidates
          .where((c) => c.petId == Get.arguments?['petId'])
          .toList()
        ..sort((a, b) => a.submittedAt.compareTo(b.submittedAt));

      return candidates.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: const Text(
              'No applications yet',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 139, 175, 241), 
              ),
            ),
          )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: candidates.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(candidates[index].name),
                subtitle: Text(
                  'Position ${index + 1} - '
                  'Applied ${DateFormat.yMd().add_jm().format(candidates[index].submittedAt)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => candidateController.delete(candidates[index]),
                ),
              ),
            );
    });
  }
}

class CandidateInputWidget extends StatelessWidget {
  final int petId;
  final String petName;
  final candidateController = Get.find<CandidateController>();
  static final _formKey = GlobalKey<FormBuilderState>();

  CandidateInputWidget({super.key, required this.petId, required this.petName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            _buildFormField('candidate', 'Full Name'),
            _buildFormField('address', 'Street Address'),
            _buildFormField('phone', 'Phone Number', TextInputType.phone),
            _buildFormField('dob', 'Date of Birth'),
            _buildFormField('job', 'Occupation'),
            _buildDescriptionField(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String name, String label, [TextInputType? type]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: FormBuilderTextField(
        name: name,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: type,
        validator: FormBuilderValidators.required(),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return FormBuilderTextField(
      name: 'description',
      decoration: const InputDecoration(
        labelText: 'Tell us something about yourself, your pets, hobbies, ...',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      validator: FormBuilderValidators.required(),
    );
  }
}