import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:race_magic/api/repository.dart';
import 'package:race_magic/model/entity/race_entity.dart';
import 'package:race_magic/widget/add_race_list_page.dart';
import 'package:race_magic/widget/view_race_page.dart';

class RaceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Races'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddRaceListPage(),
            ),
          );
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
          child: RaceList(),
        ),
      ),
    );
  }
}

class RaceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RaceEntity>>(
      stream: Repository.getRaces(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final RaceEntity entity = snapshot.data![index];

              return Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewRacePage(race: entity),
                    ),
                  ),
                  title: Text(
                    entity.name,
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
