import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_tdd/injection_container.dart';
import 'package:flutter_tdd/features/number_trivia/presentation/widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            const SizedBox(height: 10),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return const MessageDisplay(
                    message: "Start searching"
                  );
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Success){
                  return TriviaDisplay(trivia: state.trivia);
                } else if (state is Error) {
                  return MessageDisplay(
                    message: state.message
                  );
                } else {
                  return const MessageDisplay(
                      message: "Unexpected error encountered"
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const TriviaControls()
          ]),
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({Key? key}) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputString = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Input a number"
        ),
        onChanged: (value) {
          inputString = value;
        } ,
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

            },
            child: Text("Get random trivia"),
          ),
        )
      ])
    ]);
  }

  void dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }
}
