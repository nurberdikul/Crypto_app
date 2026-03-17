import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_app/bloc/crypto_event.dart';
import 'package:crypto_app/bloc/crypto_state.dart';
import 'package:crypto_app/crypto_model.dart';
import 'package:crypto_app/crypto_repository.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository cryptoRepository;

  List<CryptoModel> _originalList = [];

  CryptoBloc(this.cryptoRepository) : super(const CryptoState()) {
    on<FetchCryptoData>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));

      try {
        final data = await cryptoRepository.fetchCryptoData();

        _originalList = data;

        emit(state.copyWith(isLoading: false, cryptoList: data));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Ошибка при получении данных',
          ),
        );
      }
    });

    on<FilterGainers>((event, emit) {
      final filtered = _originalList
      .where((item) => double.parse(item.changePercent24Hr) > 0)
      .toList();
      emit(state.copyWith(cryptoList: filtered));
    });

    on<ResetFilters>((event, emit) {
      emit(state.copyWith(cryptoList: _originalList));
    });

    on<ShowFalling>((event, emit) {
      final filtered = _originalList
      .where((item) => double.parse(item.changePercent24Hr) < 0)
      .toList();
      emit(state.copyWith(cryptoList: filtered));
      });

    on<ShowTop10>((event, emit) {
      final top10 = List<CryptoModel>.from(_originalList)
      ..sort((a, b) => double.parse(b.priceUsd).compareTo(double.parse(a.priceUsd)));
      emit(state.copyWith(cryptoList: top10.take(10).toList()));
      });

  
  }
}