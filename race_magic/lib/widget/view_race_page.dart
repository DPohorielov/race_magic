import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:race_magic/api/repository.dart';
import 'package:race_magic/model/entity/race_entity.dart';
import 'package:race_magic/widget/add_result_page.dart';
import 'package:race_magic/widget/view_number_page.dart';

class ViewRacePage extends StatefulWidget {
  final RaceEntity race;

  const ViewRacePage({Key? key, required this.race}) : super(key: key);

  @override
  State<ViewRacePage> createState() => _ViewRacePageState();
}

class _ViewRacePageState extends State<ViewRacePage> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Соревнование: ${widget.race.name}'),
          actions: [
            if (_isDeleting)
              const Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                  right: 16.0,
                ),
                child: CircularProgressIndicator(),
              )
            else
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 32,
                ),
                onPressed: () => _showDeleteDialog(),
              ),
          ],
        ),
        floatingActionButton:

        Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddResultPage(raceId: widget.race.id),
                    ),
                  );
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              FloatingActionButton(
                onPressed: () {

                },
                child: const Icon(
                  Icons.file_download_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ]
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: NumbersList(raceId: widget.race.id),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
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
      child: const Text('Удалить'),
    );

    final AlertDialog alert = AlertDialog(
      title: const Text('Вы действительно хотите удалить соревнование?'),
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
        setState(() {
          _isDeleting = true;
        });

        await Repository.deleteRace(widget.race.id);

        setState(() {
          _isDeleting = false;
        });

        Navigator.of(context).pop();
      }
    });
  }
}

class NumbersList extends StatelessWidget {
  final String raceId;

  const NumbersList({Key? key, required this.raceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Set<int>>(
      stream: Repository.getNumbers(raceId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final int number = snapshot.data!.elementAt(index);

              return Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: () async {
                    try {
                      context.loaderOverlay.show();
                      final results =
                          await Repository.getResultsByNumber(raceId, number);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewNumberPage(
                            results: results,
                            raceId: raceId,
                          ),
                        ),
                      );
                    } catch (_) {} finally {
                      context.loaderOverlay.hide();
                    }
                  },
                  title: Text(
                    '$number',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
