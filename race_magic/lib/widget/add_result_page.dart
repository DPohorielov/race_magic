import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:race_magic/widget/add_result_time_page.dart';

class AddResultPage extends StatelessWidget {
  final String raceId;

  const AddResultPage({
    Key? key,
    required this.raceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Result'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: AddResultForm(raceId),
        ),
      ),
    );
  }
}

class AddResultForm extends StatefulWidget {
  final String raceId;

  const AddResultForm(this.raceId);

  @override
  _AddResultFormState createState() => _AddResultFormState();
}

class _AddResultFormState extends State<AddResultForm> {
  int? _stage;
  bool? _isStart;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                'Select stage',
                style: TextStyle(
                  fontSize: 22.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildStages(),
              const SizedBox(height: 34.0),
              const Text(
                'Select type',
                style: TextStyle(
                  fontSize: 22.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildTypes(),
            ],
          ),
        ),
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
            onPressed: _isStart == null || _stage == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddResultTimePage(
                          raceId: widget.raceId,
                          isStart: _isStart!,
                          stage: _stage!,
                        ),
                      ),
                    );
                  },
            child: const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text(
                'NEXT',
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
    );
  }

  Widget _buildStages() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Stage 1'),
          leading: Radio<int>(
            value: 1,
            groupValue: _stage,
            onChanged: (int? value) {
              setState(() {
                _stage = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Stage 2'),
          leading: Radio<int>(
            value: 2,
            groupValue: _stage,
            onChanged: (int? value) {
              setState(() {
                _stage = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Stage 3'),
          leading: Radio<int>(
            value: 3,
            groupValue: _stage,
            onChanged: (int? value) {
              setState(() {
                _stage = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTypes() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Start'),
          leading: Radio<bool>(
            value: true,
            groupValue: _isStart,
            onChanged: (bool? value) {
              setState(() {
                _isStart = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Finish'),
          leading: Radio<bool>(
            value: false,
            groupValue: _isStart,
            onChanged: (bool? value) {
              setState(() {
                _isStart = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
