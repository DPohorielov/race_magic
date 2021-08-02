import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:race_magic/api/repository.dart';
import 'package:race_magic/model/entity/result_entity.dart';
import 'package:race_magic/model/enum/categories.dart';
import 'package:race_magic/model/enum/stages.dart';
import 'package:race_magic/widget/custom_form_field.dart';

class AddResultTimePage extends StatelessWidget {
  final String raceId;
  final Stages stage;
  final Categories category;
  final bool isStart;

  const AddResultTimePage({
    Key? key,
    required this.raceId,
    required this.stage,
    required this.isStart,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${isStart ? 'СТАРТ' : 'ФИНИШ'} ${stage.name} ${category.name}'),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: isStart
                ? AddStartResultForm(raceId, stage, category)
                : AddFinishResultForm(raceId, stage, category)),
      ),
    );
  }
}

class AddStartResultForm extends StatefulWidget {
  final String raceId;
  final Stages stage;
  final Categories category;

  const AddStartResultForm(this.raceId, this.stage, this.category);

  @override
  _AddStartResultFormState createState() => _AddStartResultFormState();
}

class _AddStartResultFormState extends State<AddStartResultForm> {
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
                  'Номер',
                  style: TextStyle(
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomFormField(
                  enabled: !_isProcessing,
                  isLabelEnabled: false,
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  inputAction: TextInputAction.done,
                  label: 'Номер',
                  hint: 'Введите Номер участника',
                ),
                const SizedBox(height: 25.0),
                Center(
                  child: Text(
                    _number == null ? '' : 'Участник #$_number',
                    style: TextStyle(
                        fontSize: 32.0,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: _isProcessing ? Colors.red : Colors.black),
                  ),
                ),
                SizedBox(height: _isProcessing ? 31.0 : 20.0),
                Center(
                  child: Text(
                    'Текущее время:',
                    style: TextStyle(
                        fontSize: 25.0,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: _isProcessing ? Colors.red : Colors.black),
                  ),
                ),
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
                                  widget.category,
                                  isStart: true),
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
                    'СОХРАНИТЬ',
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

    return Text(
      buildDateString(_time),
      style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: _isProcessing ? Colors.red : Colors.black),
    );
  }
}

class AddFinishResultForm extends StatefulWidget {
  final String raceId;
  final Stages stage;
  final Categories category;

  const AddFinishResultForm(this.raceId, this.stage, this.category);

  @override
  _AddFinishResultFormState createState() => _AddFinishResultFormState();
}

class _AddFinishResultFormState extends State<AddFinishResultForm> {
  bool _isProcessing = false;
  bool _isStopped = false;
  int? _number;
  late DateTime _time;

  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocus = FocusNode();

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
                  'Номер',
                  style: TextStyle(
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomFormField(
                  focusNode: _numberFocus,
                  enabled: _isStopped && !_isProcessing,
                  isLabelEnabled: false,
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  inputAction: TextInputAction.done,
                  label: 'Номер',
                  hint: 'Введите Номер участника',
                ),
                SizedBox(height: _isStopped ? 25.0 : 31),
                Center(
                  child: Text(
                    _number == null ? '' : 'Участник #$_number',
                    style: TextStyle(
                        fontSize: 32.0,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: _isProcessing || _isStopped
                            ? Colors.red
                            : Colors.black),
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Text(
                    'Текущее время:',
                    style: TextStyle(
                        fontSize: 25.0,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: _isProcessing || _isStopped
                            ? Colors.red
                            : Colors.black),
                  ),
                ),
                Center(
                  child: _isProcessing || _isStopped
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
              child: _isStopped
                  ? ElevatedButton(
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
                                        widget.category,
                                        isStart: false),
                                    widget.raceId);
                              } catch (_) {}

                              Future.delayed(const Duration(seconds: 5), () {
                                setState(() {
                                  _isProcessing = false;
                                  _isStopped = false;
                                  _numberController.text = '';
                                });
                              });
                            },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'СОХРАНИТЬ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: _isStopped || _isProcessing
                          ? null
                          : () async {
                              setState(() {
                                _isStopped = true;
                                _numberFocus.requestFocus();
                              });
                            },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'ФИНИШ',
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
    if (!_isStopped) {
      _time = DateTime.now();
    }

    return Text(
      buildDateString(_time),
      style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: _isProcessing || _isStopped ? Colors.red : Colors.black),
    );
  }
}

String buildDateString(DateTime time) {
  final int ms = time.millisecond;

  final StringBuffer msString = StringBuffer();

  if (ms < 10) {
    msString.write('0');
  }
  if (ms < 100) {
    msString.write('0');
  }
  msString.write(ms);
  return '${DateFormat('hh:mm:ss').format(time)}.$msString';
}
