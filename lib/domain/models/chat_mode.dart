enum ChatMode {
  general('General Assistant', {
    'temperature': 0.7,
    'top_k': 50,
    'top_p': 0.9,
    'repeat_penalty': 1.1,
    'max_tokens': 2000,
  }),
  coding('Code Expert', {
    'temperature': 0.2,
    'top_k': 40,
    'top_p': 0.95,
    'repeat_penalty': 1.2,
    'max_tokens': 4000,
    'frequency_penalty': 1.1,
  }),
  creative('Creative Writer', {
    'temperature': 0.9,
    'top_k': 60,
    'top_p': 0.99,
    'repeat_penalty': 1.0,
    'max_tokens': 3000,
    'frequency_penalty': 0.7,
  }),
  technical('Technical Writer', {
    'temperature': 0.4,
    'top_k': 45,
    'top_p': 0.85,
    'repeat_penalty': 1.15,
    'max_tokens': 2500,
  }),
  ;

  final String label;
  final Map<String, dynamic> options;

  const ChatMode(this.label, this.options);

  ChatMode? findByLabel(String label) {
    try {
      return ChatMode.values.firstWhere((element) => element.label == label);
    } catch (e) {
      return null;
    }
  }
}
