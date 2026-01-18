part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const AUTH = _Paths.AUTH;
  static const SUBMISSION_WAITING = _Paths.SUBMISSION_WAITING;
  static const SUBMISSION_RESULT = _Paths.SUBMISSION_RESULT;
  static const LEADERBOARD = _Paths.LEADERBOARD;
  static const GAME_GATE = _Paths.GAME_GATE;
  static const RULES = _Paths.RULES;
  static const CREDITS = _Paths.CREDITS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const AUTH = '/auth';
  static const SUBMISSION_WAITING = '/submission-waiting';
  static const SUBMISSION_RESULT = '/submission-result';
  static const LEADERBOARD = '/leaderboard';
  static const GAME_GATE = '/game-gate';
  static const RULES = '/rules';
  static const CREDITS = '/credits';
}
