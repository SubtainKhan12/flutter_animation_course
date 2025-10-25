import 'package:flutter/material.dart';
import 'package:flutter_animation_course/views/home_view_5.dart';

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;

  Person({required this.name, required this.age, required this.emoji});
}

final people = [
  Person(name: 'John', age: 20, emoji: '🙋🏻‍♂️'),
  Person(name: 'Jane', age: 21, emoji: '👸🏽'),
  Person(name: 'Jack', age: 20, emoji: '🙋🏻‍♂️'),
];

class HomeView4 extends StatefulWidget {
  const HomeView4({super.key});

  @override
  State<HomeView4> createState() => _HomeView4State();
}

class _HomeView4State extends State<HomeView4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation 4'),
        centerTitle: true,
        elevation: 5,
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailPage(person: person),
                ),
              );
            },
            leading: Hero(
              tag: person.name,
              child: Text(person.emoji, style: const TextStyle(fontSize: 40)),
            ),
            title: Text(person.name),
            subtitle: Text('${person.age} years old'),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final Person person;

  const DetailPage({super.key, required this.person});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.person.name,
          flightShuttleBuilder:
              (
                flightContext,
                animation,
                flightDirection,
                fromHeroContext,
                toHeroContext,
              ) {
                switch (flightDirection) {
                  case HeroFlightDirection.push:
                    return Material(
                      color: Colors.transparent,
                      child: ScaleTransition(
                        scale: animation.drive(
                          Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.fastOutSlowIn))
                        ),
                        child: toHeroContext.widget,
                      ),
                    );
                  case HeroFlightDirection.pop:
                    return Material(
                      color: Colors.transparent,
                      child: fromHeroContext.widget,
                    );
                }
              },
          child: Text(widget.person.emoji, style: TextStyle(fontSize: 30)),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeView5()));
        },
        child: Center(
          child: Column(
            spacing: 10,
            children: [
              Text(widget.person.name, style: TextStyle(fontSize: 20)),
              Text(widget.person.age.toString(), style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
