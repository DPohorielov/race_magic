import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:race_magic/api/repository.dart';
import 'package:race_magic/model/entity/race_entity.dart';

class ViewRacePage extends StatelessWidget {
  final RaceEntity race;

  const ViewRacePage({Key? key, required this.race}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(race.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddResultPage(),
            ),
          );*/
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: NumbersList(raceId: race.id),
        ),
      ),
    );
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
            separatorBuilder: (context, index) => const SizedBox(height: 16.0),
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
                  /*      onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewNumberPage(number: number),
                    ),
                  ),*/
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
