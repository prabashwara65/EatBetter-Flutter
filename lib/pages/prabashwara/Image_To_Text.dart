import 'dart:io';
import 'package:eat_better/pages/prabashwara/NextPage.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ImageToText extends StatefulWidget {
  const ImageToText({super.key});

  @override
  State<ImageToText> createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> {
  File? selectedMedia;
  String? extractedText;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: const Text('Text Recognition'),
        backgroundColor: const Color(0xFFF86A2E),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(126, 248, 100, 37), // Orange
              Colors.white, // White
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildImagePreview(), // Display blank card or selected image
              const SizedBox(height: 16),
              //_buildExtractTextView(), // Uncomment this if you want to show the extracted text
              const SizedBox(height: 16),
              _buildButtonsRow(),
              const SizedBox(height: 16),
              if (extractedText != null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NextPage(extractedText: extractedText!),
                      ),
                    );
                  },
                  child: const Text('Go Next'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 140, vertical: 12), // Adjust button size here
                    textStyle: TextStyle(fontSize: 18), // Adjust text size here
                    shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8.0), // Adjust the border radius here
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.camera),
          child: const Text('Open Camera'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            padding: EdgeInsets.symmetric(horizontal: 27, vertical: 12), // Adjust button size here
            textStyle: TextStyle(fontSize: 18), // Adjust text size here
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Adjust the border radius here
          ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          child: const Text('Open Gallery'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            padding: EdgeInsets.symmetric(horizontal: 27, vertical: 12), // Adjust button size here
            textStyle: TextStyle(fontSize: 18), // Adjust text size here
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Adjust the border radius here
          ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      if (await file.exists()) {
        setState(() {
          selectedMedia = file;
          extractedText = null; // Reset extracted text when a new image is picked
          _isLoading = true; // Start loading animation
        });
        await _extractText(file); // Extract text as soon as the image is picked
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected file does not exist')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  Widget _buildImagePreview() {
    if (selectedMedia == null) {
      return _buildBlankCard(); // Show blank card if no image is selected
    } else {
      return Container(
        width: 600, // Set your desired width
        height: 470, // Set your desired height
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.file(
            selectedMedia!,
            fit: BoxFit.cover, // Adjust how the image should be resized
          ),
        ),
      );
    }
  }

  Widget _buildBlankCard() {
    return Container(
      width: 600, // Set your desired width
      height: 470, // Set your desired height
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light grey for the blank state
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey), // Optional border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'No image selected',
          style: TextStyle(color: Colors.grey[600], fontSize: 18), // Text style for the blank state
        ),
      ),
    );
  }

  Future<void> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final InputImage inputImage = InputImage.fromFile(file);
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        extractedText = recognizedText.text;
        _isLoading = false; // Stop loading animation
      });
    } catch (e) {
      print('Error extracting text: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to extract text')),
      );
      setState(() {
        _isLoading = false; // Stop loading animation on error
      });
    } finally {
      textRecognizer.close();
    }
  }
}
