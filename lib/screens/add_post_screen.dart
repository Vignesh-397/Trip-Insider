import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tripinsider/models/user.dart';
import 'package:tripinsider/providers/user_provider.dart';
import 'package:tripinsider/resources/firestore_methods.dart';
import 'package:tripinsider/utils/colorsScheme.dart';
import 'package:tripinsider/utils/utils.dart';
import 'package:tripinsider/widgets/text_field.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _homeStayController = TextEditingController();
  final TextEditingController _expdController = TextEditingController();

  bool _isUploading = false;

  String selectedTransportation = '';

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Create a post',
              style: TextStyle(color: mobileBackgroundColor),
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Take a photo',
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void postUpload(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isUploading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
        _descController.text,
        _file!,
        uid,
        username,
        profImage,
        _destinationController.text,
        _originController.text,
        _homeStayController.text,
        _expdController.text,
        selectedTransportation,
      );
      if (res == 'success') {
        setState(() {
          _isUploading = false;
        });
        showSnackbar('Posted', context);
        clearData();
      } else {
        setState(() {
          _isUploading = false;
        });
        showSnackbar(res, context);
      }
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  void clearData() {
    setState(() {
      _file = null;
      _descController.clear();
      _destinationController.clear();
      _expdController.clear();
      _originController.clear();
      _homeStayController.clear();
      selectedTransportation = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 232, 252),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 232, 252),
        leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Clear All'),
                    content: const Text('Are you sure you want to clear all?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog

                          clearData();
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.clear_all,
              color: mobileBackgroundColor,
            )),
        title: const Text(
          'TRIPINSIDER',
          style: TextStyle(
              color: mobileBackgroundColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isUploading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 111, 87, 210),
                        borderRadius: BorderRadius.circular(20)),
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 40)
                            .copyWith(bottom: 5),
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: Text(
                        'About Your Journey',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _file != null
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Clear Image'),
                                        content: const Text(
                                            'Are you sure you want to clear the selected image?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog

                                              setState(() {
                                                _file =
                                                    null; // Clear the selected image
                                              });
                                            },
                                            child: const Text(
                                              'Clear',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    image: DecorationImage(
                                      image: MemoryImage(_file!),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 120,
                                width: 120,
                                decoration: const BoxDecoration(
                                  color: loginButtonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    _selectImage(context);
                                  },
                                  icon: const Icon(Icons.add_a_photo),
                                )),
                        const SizedBox(
                          height: 30,
                        ),
                        PostTextFieldInput(
                          textEditingController: _destinationController,
                          hintText: 'Destination',
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        PostTextFieldInput(
                          textEditingController: _originController,
                          hintText: 'Origin',
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        PostTextFieldInput(
                          textEditingController: _expdController,
                          hintText: 'Expenditure',
                          textInputType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        PostTextFieldInput(
                          textEditingController: _homeStayController,
                          hintText: 'Where did you stay?',
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Mode of transport',
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                buildTransportationIcon('Train', Icons.train),
                                buildTransportationIcon(
                                    'Bus', Icons.directions_bus),
                                buildTransportationIcon(
                                    'Plane', Icons.airplanemode_active),
                                buildTransportationIcon(
                                    'Car', Icons.directions_car),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(150, 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                mobileBackgroundColor),
                          ),
                          onPressed: () {
                            if (_validateInputs()) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Your Experience'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                            'Tell everyone about your trip!'),
                                        TextField(
                                          controller: _descController,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _descController.clear();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  mobileBackgroundColor),
                                        ),
                                        onPressed: () {
                                          postUpload(user.uid, user.username,
                                              user.imgUrl);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Add Post',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showSnackbar(
                                  'Please fill in all the fields.', context);
                            }
                          },
                          child: const Text(
                            'Add Post',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildTransportationIcon(String mode, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTransportation = mode;
        });
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: selectedTransportation == mode
                ? const Color.fromARGB(255, 111, 87, 210)
                : mobileBackgroundColor,
          ),
          const SizedBox(height: 8),
          Text(mode),
        ],
      ),
    );
  }

  bool _validateInputs() {
    return _destinationController.text.isNotEmpty &&
        _originController.text.isNotEmpty &&
        _expdController.text.isNotEmpty &&
        _homeStayController.text.isNotEmpty &&
        _file != null &&
        selectedTransportation != '';
  }
}
