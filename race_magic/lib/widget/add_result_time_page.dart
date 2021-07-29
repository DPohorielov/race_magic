import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:race_magic/api/repository.dart';
import 'package:race_magic/model/entity/result_entity.dart';
import 'package:race_magic/widget/custom_form_field.dart';

class AddResultTimePage extends StatelessWidget {
  final String raceId;
  final int stage;
  final bool isStart;

  const AddResultTimePage({
    Key? key,
    required this.raceId,
    required this.stage,
    required this.isStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${isStart ? 'START' : 'FINISH'} Stage $stage'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: AddResultForm(
            raceId,
            stage,
            isStart: isStart,
          ),
        ),
      ),
    );
  }
}

class AddResultForm extends StatefulWidget {
  final String raceId;
  final int stage;
  final bool isStart;

  const AddResultForm(this.raceId, this.stage, {required this.isStart});

  @override
  _AddResultFormState createState() => _AddResultFormState();
}

class _AddResultFormState extends State<AddResultForm> {
  bool _isProcessing = false;
  int? _number;
  late DateTime _time;

  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    _numberController.addListener(() {
      setState(() {
        try {
          _number = int.parse(_numberController.text);
        } catch (_) {
          _number = null;
        }
      });
    });

    super.initState();
  }

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
                  'Number',
                  style: TextStyle(
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  inputAction: TextInputAction.done,
                  label: 'Number',
                  hint: 'Enter racer Number',
                ),
                const SizedBox(height: 40.0),
                Center(
                  child: Text(
                    _number == null ? '' : 'Racer# $_number',
                    style: TextStyle(
                        fontSize: 32.0,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: _isProcessing ? Colors.red : Colors.black),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: _isProcessing
                      ? _buildTime()
                      : StreamBuilder(
                          stream:
                              Stream.periodic(const Duration(milliseconds: 1)),
                          builder: (context, snapshot) => _buildTime(),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40.0),
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.red,
                ),
              ),
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
                onPressed: _number == null
                    ? null
                    : () async {
                        setState(() {
                          _isProcessing = true;
                        });

                        try {
                          Repository.addResult(
                              ResultEntity(_number!, _time, widget.stage,
                                  isStart: widget.isStart),
                              widget.raceId);
                        } catch (_) {}

                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            _isProcessing = false;
                            _numberController.text = '';
                          });
                        });
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

  Widget _buildTime() {
    _time = DateTime.now();
    final int ms = _time.millisecond;

    final StringBuffer msString = StringBuffer();

    if (ms < 10) {
      msString.write('0');
    }
    if (ms < 100) {
      msString.write('0');
    }
    msString.write(ms);

    return Text(
      '${DateFormat('hh:mm:ss').format(_time)}:$msString',
      style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: _isProcessing ? Colors.red : Colors.black),
    );
  }
}
