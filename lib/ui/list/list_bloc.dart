import 'package:bloc/bloc.dart';
import 'package:infinite_listview/data/generator/list_data_source.dart';
import 'package:infinite_listview/ui/list/list.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ListDataSource _dataSource;

  ListBloc(this._dataSource);

  void getNextListPage() {
    dispatch(FetchNextPage());
  }

  @override
  ListState get initialState => ListState.initial();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    final _currentState = currentState;
    if (event is FetchNextPage) {
      try {
        final nextPageItems = await _dataSource.getNextLIstPage();
        yield ListState.success(_currentState.listItems + nextPageItems);
      } on NoNextPageException catch (_) {
        yield _currentState.rebuild((b) => b..hasReachedEndOfResults = true);
      }
    }
  }
}
