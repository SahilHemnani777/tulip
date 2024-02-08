import 'package:rxdart/rxdart.dart';

class SearchObservable{
  final _searchEditTextFetch = PublishSubject<String>();

  Stream<String> get _searchEditTextObservable => _searchEditTextFetch.stream;
  Stream<String> get debounceTextObservable => _searchEditTextObservable.debounceTime(const Duration(milliseconds: 500));

  void addSearchText(String text){
    _searchEditTextFetch.sink.add(text);
  }

  dispose() {
    _searchEditTextFetch.close();
  }
}