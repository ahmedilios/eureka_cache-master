import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class BlocWithCache<E extends Equatable, S> extends Bloc<E, S> {
  S stateLoadedCache();
  S eventFailure({error});
  void dispatchSuccessEvent(Map<String, dynamic> response);

  Stream<S> handleWithCacheGetError(error, responseCached) async* {
    try {
      if (responseCached.isNotEmpty) {
        yield stateLoadedCache();

        dispatchSuccessEvent(responseCached);
      } else {
        yield eventFailure(error: error.message);
      }
    } catch (_) {
      yield eventFailure(error: error.message);
    }
  }
}
