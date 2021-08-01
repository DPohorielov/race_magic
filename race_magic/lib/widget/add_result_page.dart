import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:race_magic/model/enum/categories.dart';
import 'package:race_magic/model/enum/stages.dart';
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
        title: const Text('Добавить Замер'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 6.0,
            right: 6.0,
            bottom: 6.0,
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
  Stages? _stage;
  Categories? _category;
  bool? _isStart;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Flexible(
              flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6.0),
                    const Text(
                      'Участок',
                      style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStages(),
                    const SizedBox(height: 6.0),
                    const Text(
                      'Тип',
                      style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildTypes(),
                  ],
                ),
              ),
              Flexible(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6.0),
                    const Text(
                      'Категория',
                      style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildCategories(),
                  ],
                ),
              ),
            ]),
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
              onPressed: _isStart == null || _stage == null || _category == null
                  ? null
                  : () => _showViewDialog(),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'ДАЛЬШЕ',
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

  Widget _buildStages() {
    return ListView.builder(
        itemCount: Stages.values.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(Stages.values[i].name),
            leading: Radio<Stages>(
              value: Stages.values[i],
              groupValue: _stage,
              onChanged: (Stages? value) {
                setState(() {
                  _stage = value;
                });
              },
            ),
          );
        });
  }

  Widget _buildCategories() {
    return ListView.builder(
        itemCount: Categories.values.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(Categories.values[i].name),
            leading: Radio<Categories>(
              value: Categories.values[i],
              groupValue: _category,
              onChanged: (Categories? value) {
                setState(() {
                  _category = value;
                });
              },
            ),
          );
        });
  }

  Widget _buildTypes() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Старт'),
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
          title: const Text('Финиш'),
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

  void _showViewDialog() {
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
      child: const Text('Продолжить'),
    );

    final AlertDialog alert = AlertDialog(
      title: Text('Вы действительно хотите сделать замер '
          '${_isStart! ? 'Старта' : 'Финиша'}  '
          '${_stage!.name} '
          'категория ${_category!.name}?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    ).then((value) async {
      if (value is bool && value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddResultTimePage(
              raceId: widget.raceId,
              isStart: _isStart!,
              stage: _stage!,
              category: _category!,
            ),
          ),
        );
      }
    });
  }
}
