// ignore_for_file: unnecessary_const, unnecessary_string_interpolations

import 'dart:developer';

import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:flutter/material.dart';

class Addcategory extends StatefulWidget {
  const Addcategory(
      {Key? key, required this.title, this.categoryModel, this.buttonName})
      : super(key: key);
  final String title;
  final Categorymodel? categoryModel;
  final String? buttonName;

  @override
  _AddcategoryState createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {
  TextEditingController categoryController = TextEditingController();
  final GlobalKey _formkey = GlobalKey();
  final _databaseProvider = Databaseprovider.instance;

  String dropdownValue = 'Expense';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchDetails();
    });
  }

  void fetchDetails() {
    if (widget.categoryModel != null) {
      setState(() {
        categoryController.text = widget.categoryModel!.categoryname;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            height: 340,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.blueAccent,
                ),
              ],
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 25,
                    bottom: 10,
                  ),
                  child: const Text(
                    'ADD CATEGORY',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                      shadows: [
                        Shadow(
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: categoryController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Category Name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Category Name',
                            hintText: 'Category Name',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          width: 300,
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            elevation: 16,
                            isExpanded: true,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            underline: Container(
                              height: 2,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onChanged: (String? newValue) {
                              setState(
                                () {
                                  dropdownValue = newValue!;
                                },
                              );
                            },
                            items: <String>[
                              'Expense',
                              'Income',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 37,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Container(
                          height: 35,
                          width: 78,
                          decoration: BoxDecoration(
                            color: Theme.of(context).errorColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MaterialButton(
                            color: Theme.of(context).colorScheme.secondary,
                            child: Text(
                              widget.buttonName != null
                                  ? widget.buttonName!
                                  : 'Save',
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              final FormState? form =
                                  _formkey.currentState as FormState?;
                              if (form!.validate()) {
                                log('Category Name ${categoryController.text.toString()}');
                                log('Category Type $dropdownValue');
                                final newCategory = Categorymodel(
                                    categoryname:
                                        categoryController.text.toString(),
                                    type: dropdownValue);
                                if (categoryController.text
                                    .toString()
                                    .isNotEmpty) {
                                  var catId = _databaseProvider
                                      .addCategory(newCategory);
                                  log('${catId.toString()}');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Category Added'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }

                                if (widget.categoryModel != null) {
                                  newCategory.id = widget.categoryModel!.id;
                                  _databaseProvider.updateData(newCategory);
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
