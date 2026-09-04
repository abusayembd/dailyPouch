import 'package:equatable/equatable.dart';
import '../../domain/entities/utility_module.dart';

class LauncherState extends Equatable {
  final List<UtilityModule> allModules;
  final List<UtilityModule> filteredModules;
  final String searchQuery;
  final ModuleCategory selectedCategory;

  const LauncherState({
    required this.allModules,
    required this.filteredModules,
    this.searchQuery = '',
    this.selectedCategory = ModuleCategory.all,
  });

  factory LauncherState.initial() {
    return const LauncherState(
      allModules: UtilityModule.defaultModules,
      filteredModules: UtilityModule.defaultModules,
      searchQuery: '',
      selectedCategory: ModuleCategory.all,
    );
  }

  LauncherState copyWith({
    List<UtilityModule>? allModules,
    List<UtilityModule>? filteredModules,
    String? searchQuery,
    ModuleCategory? selectedCategory,
  }) {
    return LauncherState(
      allModules: allModules ?? this.allModules,
      filteredModules: filteredModules ?? this.filteredModules,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
        allModules,
        filteredModules,
        searchQuery,
        selectedCategory,
      ];
}
