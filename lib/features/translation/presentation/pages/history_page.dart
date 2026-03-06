import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/translation_bloc.dart';
import '../bloc/translation_event.dart';
import '../bloc/translation_state.dart';
import '../../../../core/routes/app_router.dart'; // Needed for routing

@RoutePage()
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Trigger the BLoC to load history from SQLite when the page opens
    context.read<TranslationBloc>().add(LoadHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translation History')),
      body: BlocBuilder<TranslationBloc, TranslationState>(
        builder: (context, state) {
          if (state is TranslationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TranslationHistoryLoaded) {
            if (state.history.isEmpty) {
              return const Center(child: Text('No history found.'));
            }
            return ListView.builder(
              itemCount: state.history.length,
              itemBuilder: (context, index) {
                final item = state.history[index];
                return ListTile(
                  title: Text(
                    item.originalText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.translatedText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // Navigate to detail page passing the entity
                    context.router.push(
                      TranslationDetailRoute(translation: item),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: Text('Failed to load history.'));
        },
      ),
    );
  }
}
