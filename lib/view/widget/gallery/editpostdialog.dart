import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uqba_elibrary/view/widget/gallery/videoprovider.dart';

class EditPostDialog extends StatefulWidget {
  final Function(String, Map<String, dynamic>) onPostEdited;
  final Map<String, dynamic> post;

  const EditPostDialog(
      {Key? key, required this.onPostEdited, required this.post})
      : super(key: key);

  @override
  _EditPostDialogState createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  List<File> selectedMediaFiles = [];
  List<bool> isImages = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.post['title']);
    descriptionController =
        TextEditingController(text: widget.post['description']);
    isImages = List<bool>.from(widget.post['isImages']);
    // Initialize selectedMediaFiles if you have the local files available
    // For now, assume that the URLs of the files are available in widget.post['files']
  }

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
          'تعديل المنشور',
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
              if (widget.post['files'].isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.post['files'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isImages[index]
                            ? Image.network(widget.post['files'][index])
                            : VideoProvider(
                                url: widget.post['files'][index],
                                autoPlay: false,
                              ),
                      );
                    },
                  ),
                ),
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
                    widget.onPostEdited(
                      widget.post['id'],
                      {
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'files': selectedMediaFiles.isNotEmpty
                            ? selectedMediaFiles
                            : widget.post['files'],
                        'isImages': isImages,
                      },
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Text("حفظ التعديلات"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
