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
      body: SingleChildScrollView(
        child: buildBody(context)
      ),
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
                if (state is EmptyState) {
                  return const MessageDisplay(
                    message: "Start searching"
                  );
                } else if (state is LoadingState) {
                  return const LoadingWidget();
                } else if (state is SuccessState){
                  return TriviaDisplay(trivia: state.trivia);
                } else if (state is ErrorState) {
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
