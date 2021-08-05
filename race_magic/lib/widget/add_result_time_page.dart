import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:race_magic/api/repository.dart';
import 'package:race_magic/model/entity/result_entity.dart';
import 'package:race_magic/model/enum/stages.dart';
import 'package:race_magic/util/xls_helper.dart';
import 'package:race_magic/widget/custom_form_field.dart';

class AddResultTimePage extends StatefulWidget {
  final String raceId;
  final Stages stage;
  final bool isStart;

  const AddResultTimePage({
    Key? key,
    required this.raceId,
    required this.stage,
    required this.isStart,
  }) : super(key: key);

  @override
  _AddResultTimePageState createState() => _AddResultTimePageState();
}

class _AddResultTimePageState extends State<AddResultTimePage> {
  int? _number;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.isStart ? 'СТАРТ' : 'ФИНИШ'} ${widget.stage.name}'),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: widget.isStart
                ? AddStartResultForm(
                    widget.stage, (result) => onResult(result, context))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        AddFinishResultForm(widget.stage,
                            (result) => onResult(result, context)),
                        const Expanded(
                            child: Divider(
                          color: Colors.black54,
                          thickness: 10,
                        )),
                        AddFinishResultForm(widget.stage,
                            (result) => onResult(result, context)),
                      ])),
      ),
    );
  }

  Future<void> onResult(ResultEntity resultEntity, BuildContext context) async {
    final bool success =
        await Repository.addResult(resultEntity, widget.raceId);

    if (!success) {
      final Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: const Text('Отмена'),
      );
      final Widget continueButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: const Text('Да'),
      );
      final Widget changeButton = TextButton(
        onPressed: () {
          _showChangeDialog(resultEntity, context);
        },
        child: const Text('Изменить'),
      );

      final AlertDialog alert = AlertDialog(
        title: const Text('Замер уже существует. Хотите перезаписать?'),
        actions: [
          continueButton,
          changeButton,
          cancelButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) => alert,
      ).then((value) async {
        if (value is bool && value) {
          await Repository.saveOrUpdateResult(resultEntity, widget.raceId);
        }
      });
    }
  }

  void _showChangeDialog(ResultEntity resultEntity, BuildContext context) {
    _number = null;
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Введите верный номер'),
          content: CustomFormField(
            isLabelEnabled: false,
            onChanged: (val) {
              setState(() {
                try {
                  _number = int.parse(val);
                } catch (_) {
                  _number = null;
                }
              });
            },
            keyboardType: TextInputType.number,
            inputAction: TextInputAction.done,
            label: 'Номер',
            hint: 'Введите Номер участника',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: _number == null
                  ? null
                  : () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
              child: const Text('Да'),
            ),
          ],
        );
      }),
    ).then((value) async {
      if (value is bool && value) {
        await Repository.saveOrUpdateResult(
            ResultEntity(_number!, resultEntity.time, resultEntity.stage,
                isStart: resultEntity.isStart),
            widget.raceId);
      }
    });
  }
}

class AddStartResultForm extends StatefulWidget {
  final Stages stage;
  final Function(ResultEntity) onResult;

  const AddStartResultForm(this.stage, this.onResult);

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
                          widget.onResult.call(ResultEntity(
                              _number!, _time, widget.stage,
                              isStart: true));
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
      XlsHelper.buildDateString(_time),
      style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: _isProcessing ? Colors.red : Colors.black),
    );
  }
}

class AddFinishResultForm extends StatefulWidget {
  final Stages stage;
  final Function(ResultEntity) onResult;

  const AddFinishResultForm(this.stage, this.onResult);

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
    return Padding(
      padding: const EdgeInsets.only(
        left: 28.0,
        right: 28.0,
        bottom: 8.0,
        top: 15,
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: _isStopped ? 5.0 : 11),
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
              const SizedBox(height: 6.0),
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
          const SizedBox(height: 6.0),
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
                              FocusScope.of(context).unfocus();

                              setState(() {
                                _isProcessing = true;
                              });

                              try {
                                widget.onResult.call(ResultEntity(
                                    _number!, _time, widget.stage,
                                    isStart: false));
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
                              FocusScope.of(context).unfocus();

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
      XlsHelper.buildDateString(_time),
      style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: _isProcessing || _isStopped ? Colors.red : Colors.black),
    );
  }
}
