import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({Key? key}) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputString = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number"
        ),
        onChanged: (value) {
          inputString = value;
        },
        onSubmitted: (_) {
          dispatchConcrete();
        },
      ),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              dispatchConcrete();
            },
            child: Text("Search"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              dispatchRandom();
            },
            child: Text("Get random trivia"),
          ),
        )
      ])
    ]);
  }

  void dispatchConcrete() {
    controller.clear();

    print("Concrete number trivia called");

    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }

  void dispatchRandom() {
    controller.clear();

    print("Random number trivia called");

    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForRandomNumber());
  }
}