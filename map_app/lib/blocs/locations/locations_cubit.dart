import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/blocs/locations/locations_states.dart';
import 'package:map_app/repositories/locations_repository.dart';
import 'package:map_app/shared/utils.dart';

class LocationsCubit extends Cubit<LocationsState> {
  final LocationsRepository _locationsRepository;

  LocationsCubit(this._locationsRepository) : super(LocationsLoadingState()) {
    load();
  }

  Future<void> load() async {
    emit(LocationsLoadingState());
    try {
      List<LatLng> randomLatLongs = [];
      for (var i = 0; i < 3; i++) {
        randomLatLongs.add(
          LatLng(
            Utils.generateRandomNumberInRangeWithDecimals(-35.515, -35.118, 6),
            Utils.generateRandomNumberInRangeWithDecimals(148.921, 149.26, 6),
          ),
        );
      }

      final locations = await _locationsRepository.getLocations(randomLatLongs);
      emit(LocationsLoadedState(locations));
    } catch (e) {
      emit(LocationsErrorState(e.toString()));
    }
  }
}
