import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pdfx/pdfx.dart';
import 'review_details_screen.dart';

class DocumentUploadScreen extends StatefulWidget {
  final File selfie; // ✅ Selfie passed from previous step

  const DocumentUploadScreen({super.key, required this.selfie});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  List<PlatformFile> _pickedDocuments = [];

  /// Pick multiple documents
  Future<void> _pickDocuments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedDocuments.addAll(result.files);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No documents selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking documents: $e')),
      );
    }
  }

  /// Remove a selected document
  void _removeDocument(int index) {
    setState(() {
      _pickedDocuments.removeAt(index);
    });
  }

  /// Preview selected document
  void _previewDocument(PlatformFile document) {
    final ext = document.extension?.toLowerCase();
    if (ext == 'jpg' || ext == 'jpeg' || ext == 'png') {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Image.file(File(document.path!)),
        ),
      );
    } else if (ext == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfPreviewScreen(filePath: document.path!, fileName: document.name),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preview not available for this file type.')),
      );
    }
  }

  /// Continue button → Navigate to ReviewDetailsScreen
  void _navigateToNextScreen() {
    if (_pickedDocuments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one document.')),
      );
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, _) => ReviewDetailsScreen(
          selfie: widget.selfie,
          documents: _pickedDocuments.map((e) => File(e.path!)).toList(),
        ),
        transitionsBuilder: (context, animation, _, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          return FadeTransition(opacity: curved, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              "Step 6 of 6",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LinearProgressIndicator(
                value: 1.0,
                color: Colors.green,
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 24),
              const Text(
                "Upload Required Documents",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200, width: 1.5),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please upload documents like bank statements, payslips, etc. (PDF, JPG, PNG accepted)",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    Text("• Bank Statement (last 3 months)", style: TextStyle(fontSize: 14, color: Colors.black54)),
                    Text("• Payslip (last 3 months, if employed)", style: TextStyle(fontSize: 14, color: Colors.black54)),
                    Text("• Business Registration Documents (if self-employed)", style: TextStyle(fontSize: 14, color: Colors.black54)),
                    Text("• Proof of Address (e.g., utility bill, lease agreement, etc.)", style: TextStyle(fontSize: 14, color: Colors.black54)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _pickDocuments,
                icon: const Icon(Iconsax.document_upload, color: Colors.green),
                label: const Text("Select Documents", style: TextStyle(fontSize: 16, color: Colors.green)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: Colors.green.shade200)),
                  elevation: 2,
                ),
              ),
              const SizedBox(height: 20),
              if (_pickedDocuments.isNotEmpty)
                const Text(
                  "Selected Documents:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              const SizedBox(height: 10),
              Expanded(
                child: _pickedDocuments.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.folder_open, size: 60, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      const Text("No documents selected yet.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: _pickedDocuments.length,
                  itemBuilder: (context, index) {
                    final document = _pickedDocuments[index];
                    final fileName = document.name;
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: Icon(_getFileIcon(fileName), color: Theme.of(context).primaryColor),
                        title: Text(fileName, style: const TextStyle(fontSize: 14)),
                        onTap: () => _previewDocument(document),
                        trailing: IconButton(
                          icon: const Icon(Iconsax.trash, color: Colors.redAccent),
                          onPressed: () => _removeDocument(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToNextScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("Continue", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns appropriate file icon
  IconData _getFileIcon(String fileName) {
    if (fileName.endsWith('.pdf')) return Iconsax.document_1;
    if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) return Iconsax.document_text;
    if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg') || fileName.endsWith('.png')) return Iconsax.gallery;
    return Iconsax.document;
  }
}

/// PDF Preview Screen
class PdfPreviewScreen extends StatelessWidget {
  final String filePath;
  final String fileName;

  const PdfPreviewScreen({super.key, required this.filePath, required this.fileName});

  @override
  Widget build(BuildContext context) {
    final pdfController = PdfController(document: PdfDocument.openFile(filePath));

    return Scaffold(
      appBar: AppBar(title: Text(fileName)),
      body: PdfView(controller: pdfController),
    );
  }
}
