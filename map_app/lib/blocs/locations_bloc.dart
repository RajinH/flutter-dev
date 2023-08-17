import 'package:latlong2/latlong.dart';
import 'package:map_app/blocs/locations_events.dart';
import 'package:map_app/blocs/locations_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/repositories/locations_repo.dart';
import 'package:map_app/shared/utils.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final LocationsRepository _locationsRepository;

  LocationsBloc(this._locationsRepository) : super(LocationsLoadingState()) {
    on<LoadLocationsEvent>((event, emit) async {
      emit(LocationsLoadingState());
      try {
        List<LatLng> randomLatLongs = [];
        for (var i = 0; i < 20; i++) {
          randomLatLongs.add(
            LatLng(
              Utils.generateRandomNumberInRangeWithDecimals(
                  -35.515, -35.118, 6),
              Utils.generateRandomNumberInRangeWithDecimals(148.921, 149.26, 6),
            ),
          );
        }

        final locations =
            await _locationsRepository.getLocations(randomLatLongs);
        emit(LocationsLoadedState(locations));
      } catch (e) {
        emit(LocationsErrorState(e.toString()));
      }
    });
  }
}
