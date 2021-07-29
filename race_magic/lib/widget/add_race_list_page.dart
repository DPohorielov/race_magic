import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:race_magic/api/repository.dart';
import 'package:race_magic/model/entity/race_entity.dart';
import 'package:race_magic/widget/custom_form_field.dart';
import 'package:race_magic/widget/view_race_page.dart';

class AddRaceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Race'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: AddRaceForm(),
        ),
      ),
    );
  }
}

class AddRaceForm extends StatefulWidget {
  const AddRaceForm();

  @override
  _AddRaceFormState createState() => _AddRaceFormState();
}

class _AddRaceFormState extends State<AddRaceForm> {
  bool _isProcessing = false;

  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24.0),
                const Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  label: 'Title',
                  hint: 'Enter race title',
                ),
              ],
            ),
          ),
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _isProcessing = true;
                  });

                  final String id = (await Repository.addRace(
                          RaceEntity(name: _titleController.text)))
                      .id;
                  final RaceEntity entity = await Repository.getRace(id);

                  setState(() {
                    _isProcessing = false;
                  });

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ViewRacePage(race: entity),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
