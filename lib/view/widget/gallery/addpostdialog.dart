import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uqba_elibrary/config/messages.dart';
import 'package:uqba_elibrary/view/widget/gallery/videoprovider.dart';

class AddPostDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostAdded;

  const AddPostDialog({Key? key, required this.onPostAdded}) : super(key: key);

  @override
  _AddPostDialogState createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<File> selectedMediaFiles = [];
  List<bool> isImages = [];

  Future<void> _selectMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'mp4'],
    );
    if (result != null) {
      setState(() {
        selectedMediaFiles = result.paths.map((path) => File(path!)).toList();
        isImages = result.files.map((file) {
          return ['jpg', 'jpeg', 'png', 'gif'].contains(file.extension);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Color(0xFF573720)),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actionsOverflowButtonSpacing: 10.0,
        actionsOverflowDirection: VerticalDirection.down,
        actionsPadding: EdgeInsets.only(
          top: 10.0,
          right: 20.0,
          left: 20.0,
          bottom: 10.0,
        ),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.only(
          top: 10.0,
          right: 15.0,
          left: 15.0,
          bottom: 10.0,
        ),
        titlePadding: EdgeInsets.only(
          top: 10.0,
          right: 10.0,
          left: 10.0,
          bottom: 10.0,
        ),
        titleTextStyle: TextStyle(
          color: Color(0xFF573720),
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
        title: const Text(
          'إضافة منشور',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                textAlign: TextAlign.start,
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'عنوان المنشور',
                  labelStyle: TextStyle(color: Color(0xFF573720), fontSize: 16),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFF573720)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFF573720)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                textAlign: TextAlign.start,
                controller: descriptionController,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'وصف المنشور',
                  labelStyle: TextStyle(color: Color(0xFF573720), fontSize: 14),
                  alignLabelWithHint: true,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFF573720)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFF573720)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (selectedMediaFiles.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedMediaFiles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isImages[index]
                            ? Image.file(selectedMediaFiles[index])
                            : VideoProvider(
                                file: selectedMediaFiles[index],
                                autoPlay: false,
                              ),
                      );
                    },
                  ),
                ),
              ElevatedButton(
                onPressed: _selectMedia,
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Color(0xFF573720)),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'اختر الوسائط',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("إلغاء"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    // Check if title and description are not empty
                    widget.onPostAdded({
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'files': selectedMediaFiles,
                      'isImages': isImages,
                    });
                    Navigator.of(context).pop();
                  } else {
                    // Show error message if title or description is empty
                    errorMessage("يرجى إدخال عنوان ووصف للمنشور");
                  }
                },
                child: Text("نشر"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
