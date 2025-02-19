enum AppIcons {
  robot('robot-outline.svg'),
  chat('chat-outline.svg'),
  menuOpen('menu-open.svg'),
  menuClose('menu-close.svg'),
  dotsHorizontal('dots-horizontal.svg'),
  history('history.svg'),
  messageText('message-text-outline.svg'),
  database('database-outline.svg'),
  forum('forum-outline.svg'),
  github('github.svg'),
  ollama('ollama.svg'),
  tune('tune.svg'),
  headSnowflake('head-snowflake-outline.svg'),
  keyboard('keyboard-outline.svg'),
  ;

  static const String _basePath = 'assets/icons/';

  final String _path;

  const AppIcons(this._path);

  String get path => '$_basePath$_path';
}
