import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/utility_module.dart';
import 'launcher_state.dart';

class LauncherCubit extends Cubit<LauncherState> {
  LauncherCubit({List<UtilityModule>? initialModules})
      : super(
          initialModules != null
              ? LauncherState(
                  allModules: initialModules,
                  filteredModules: initialModules,
                )
              : LauncherState.initial(),
        );

  /// Updates the text search query and re-filters the module list.
  void updateSearchQuery(String query) {
    emit(_applyFilters(query: query, category: state.selectedCategory));
  }

  /// Updates the category filter and re-filters the module list.
  void selectCategory(ModuleCategory category) {
    emit(_applyFilters(query: state.searchQuery, category: category));
  }

  /// Resets search and category filter.
  void resetFilters() {
    emit(state.copyWith(
      searchQuery: '',
      selectedCategory: ModuleCategory.all,
      filteredModules: state.allModules,
    ));
  }

  LauncherState _applyFilters({
    required String query,
    required ModuleCategory category,
  }) {
    final cleanQuery = query.trim().toLowerCase();

    final filtered = state.allModules.where((module) {
      final matchesCategory =
          category == ModuleCategory.all || module.category == category;

      final matchesQuery = cleanQuery.isEmpty ||
          module.title.toLowerCase().contains(cleanQuery) ||
          module.shortTitle.toLowerCase().contains(cleanQuery) ||
          module.description.toLowerCase().contains(cleanQuery);

      return matchesCategory && matchesQuery;
    }).toList();

    return state.copyWith(
      searchQuery: query,
      selectedCategory: category,
      filteredModules: filtered,
    );
  }
}
