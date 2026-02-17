class CounterController {
  int _counter = 0;
  int _step = 1; 
  final List<String> _history = []; 

  int get value => _counter;
  int get step => _step;
  List<String> get history => _history;

  void setStep(int value) {
    _step = value;
  }

  void _addHistory(String message) {
    String timestamp = "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
    _history.insert(0, "[$timestamp] $message");
    if (_history.length > 5) {
      _history.removeLast();
    }
  }

  void increment() {
    _counter += _step;
    _addHistory("Ditambah $_step");
  }

  void decrement() {
    if (_counter >= _step) {
      _counter -= _step;
      _addHistory("Dikurang $_step");
    }
  }

  void reset() {
    _counter = 0;
    _addHistory("Data di-reset");
  }
}