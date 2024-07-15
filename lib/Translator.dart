import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'nav_drawer.dart';

class TranslatorApp extends StatefulWidget {
  const TranslatorApp({Key? key}) : super(key: key);

  @override
  State<TranslatorApp> createState() => _TranslatorAppState();
}

class _TranslatorAppState extends State<TranslatorApp> {
  List<String> languages = [
    'Auto detect',
    'English (US)',
    'French',
    'Spanish',
    'Portuguese',
    'German',
    'Arabic',
    'Hausa',
    'Russian',
    'Korean',
    'Japanese',
    'Italian'
  ];
  List<String> languagescode = [
    'auto',
    'en',
    'fr',
    'es',
    'pt',
    'de',
    'ar',
    'ha',
    'ru',
    'ko',
    'ja',
    'it'
  ];
  final translator = GoogleTranslator();
  String from = 'auto';
  String to = 'en';
  String data = '';
  String selectedvalue = 'Auto detect';
  String selectedvalue2 = 'English (US)';
  TextEditingController controller = TextEditingController(text: '');
  TextEditingController translatedController = TextEditingController(text: '');
  final formkey = GlobalKey<FormState>();
  bool isloading = false;
  final FlutterTts flutterTts = FlutterTts();
  stt.SpeechToText speech = stt.SpeechToText();
  bool _isListening = false;
  XFile? selectedMedia;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    translatedController.dispose(); // Dispose translated text controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.translate, color: Colors.lightBlueAccent,),
        centerTitle: true,
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(240,20,20,20)
            )),
        title: const Text(
          'Translation',
          style: TextStyle(
              color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
      endDrawer: const MyDrawer(),
      backgroundColor: const Color.fromARGB(150,50,50,50),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('From:', style: TextStyle( color: Colors.black),),
                  const SizedBox(
                    width: 100,
                  ),
                  DropdownButton(
                    menuMaxHeight: 300,
                    value: selectedvalue,
                    focusColor: Colors.transparent,
                    items: languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                        onTap: () {
                          if (lang == languages[0]) {
                            from = languagescode[0];
                          } else if (lang == languages[1]) {
                            from = languagescode[1];
                          } else if (lang == languages[2]) {
                            from = languagescode[2];
                          } else if (lang == languages[3]) {
                            from = languagescode[3];
                          } else if (lang == languages[4]) {
                            from = languagescode[4];
                          } else if (lang == languages[5]) {
                            from = languagescode[5];
                          } else if (lang == languages[6]) {
                            from = languagescode[6];
                          } else if (lang == languages[7]) {
                            from = languagescode[7];
                          } else if (lang == languages[8]) {
                            from = languagescode[8];
                          } else if (lang == languages[9]) {
                            from = languagescode[9];
                          } else if (lang == languages[10]){
                            from = languagescode[10];
                          } else if (lang == languages[11]){
                            from = languagescode[11];
                          }
                          setState(() {});
                        },
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedvalue = value!;
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: Form(
                key: formkey,
                child: TextFormField(
                  controller: controller,
                  maxLines: null,
                  minLines: null,
                  onChanged: (text) {
                    translate(); // Translate text in real-time while typing
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    errorStyle: TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                        // Clear translated text field as well
                        setState(() {
                          data = '';
                          translatedController.clear();
                        });
                      },
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('To:', style: TextStyle(color: Colors.black),),
                  const SizedBox(
                    width: 100,
                  ),
                  DropdownButton(
                    menuMaxHeight: 300,
                    value: selectedvalue2,
                    focusColor: Colors.transparent,
                    items: languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                        onTap: () {
                          if (lang == languages[0]) {
                            to = languagescode[0];
                          } else if (lang == languages[1]) {
                            to = languagescode[1];
                          } else if (lang == languages[2]) {
                            to = languagescode[2];
                          } else if (lang == languages[3]) {
                            to = languagescode[3];
                          } else if (lang == languages[4]) {
                            to = languagescode[4];
                          } else if (lang == languages[5]) {
                            to = languagescode[5];
                          } else if (lang == languages[6]) {
                            to = languagescode[6];
                          } else if (lang == languages[7]) {
                            to = languagescode[7];
                          } else if (lang == languages[8]) {
                            to = languagescode[8];
                          } else if (lang == languages[9]) {
                            to = languagescode[9];
                          } else if (lang == languages[10]) {
                            to = languagescode[10];
                          } else if (lang == languages[11]) {
                            to  = languagescode[11];
                          }

                          setState(() {});
                        },
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedvalue2 = value!;
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: Center(
                child: SelectableText(
                  data,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    stop();
                  },
                  icon: const Icon(Icons.stop),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: _listen,
                  icon: const Icon(Icons.mic),
                  color: _isListening ? Colors.red : Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    if (data.isNotEmpty) {
                      speak(text: data, to: to);
                    }
                  },
                  icon: const Icon(Icons.volume_up),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: _onOCRButtonPressed,
                  icon: Icon(Icons.camera_alt),
                  color: Colors.white,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                translate();
                FocusScope.of(context).unfocus(); // Hide keyboard after translate button pressed
              },
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.white60),
                  fixedSize: MaterialStateProperty.all(Size(300, 45))),
              child: isloading? SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(color: Colors.white,),
              ): Text('Translate', style: TextStyle(color: Colors.black),)),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Future<void> translate() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });

      var translation = await translator.translate(controller.text, from: from, to: to);
      setState(() {
        data = translation.text;
        isloading = false;
      });

      // Update translated text field
      translatedController.text = translation.text;
    }
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await speech.initialize(
        onStatus: (status) {},
        onError: (error) => print('Error: $error'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        speech.listen(
          onResult: (result) {
            setState(() {
              controller.text = result.recognizedWords;
            });
          },
          listenFor: const Duration(seconds: 30),
          localeId: from,
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      speech.stop();
    }
  }

  Future<void> speak({required String text, required String to}) async {
    await flutterTts.setLanguage(to);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  void _onOCRButtonPressed() {
    imagePickerModal(context, onCameraTap: () {
      log("Camera");
      _pickImage(ImageSource.camera);
    }, onGalleryTap: () {
      log("Gallery");
      _pickImage(ImageSource.gallery);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        selectedMedia = pickedFile;
      });
      _navigateToRecognizePage(pickedFile.path);
    }
  }

  void _navigateToRecognizePage(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      isloading = true;
    });

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    controller.text = recognizedText.text;

    setState(() {
      isloading = false;
    });

    // Close the modal bottom sheet
    Navigator.of(context).pop();
  }
}

void imagePickerModal(BuildContext context,
    {VoidCallback? onCameraTap, VoidCallback? onGalleryTap}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 220,
          child: Column(
            children: [
              GestureDetector(
                onTap: onCameraTap,
                child: Card(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: const Text("Camera",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onGalleryTap,
                child: Card(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: const Text("Gallery",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TranslatorApp(),
  ));
}
