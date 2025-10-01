import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_track_fit/core/services/language_service.dart';

// Events
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LanguageChanged extends LanguageEvent {
  final String languageCode;

  const LanguageChanged(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class LanguageInitialized extends LanguageEvent {
  const LanguageInitialized();
}

// States
abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial();
}

class LanguageLoaded extends LanguageState {
  final String currentLanguage;
  final bool isArabic;
  final bool isEnglish;

  const LanguageLoaded({
    required this.currentLanguage,
    required this.isArabic,
    required this.isEnglish,
  });

  @override
  List<Object> get props => [currentLanguage, isArabic, isEnglish];
}

class LanguageError extends LanguageState {
  final String message;

  const LanguageError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageService _languageService;

  LanguageBloc({required LanguageService languageService})
      : _languageService = languageService,
        super(const LanguageInitial()) {
    on<LanguageInitialized>(_onLanguageInitialized);
    on<LanguageChanged>(_onLanguageChanged);
  }

  Future<void> _onLanguageInitialized(
    LanguageInitialized event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      await _languageService.initialize();
      emit(LanguageLoaded(
        currentLanguage: _languageService.currentLanguage,
        isArabic: _languageService.isArabic,
        isEnglish: _languageService.isEnglish,
      ));
    } catch (e) {
      emit(LanguageError(e.toString()));
    }
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      await _languageService.changeLanguage(event.languageCode);
      emit(LanguageLoaded(
        currentLanguage: _languageService.currentLanguage,
        isArabic: _languageService.isArabic,
        isEnglish: _languageService.isEnglish,
      ));
    } catch (e) {
      emit(LanguageError(e.toString()));
    }
  }
}
