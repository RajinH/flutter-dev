import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:map_app/models/location.dart';

@immutable
abstract class LocationsState extends Equatable {}

class LocationsLoadingState extends LocationsState {
  @override
  List<Object?> get props => [];
}

class LocationsLoadedState extends LocationsState {
  final List<Location> locations;
  LocationsLoadedState(this.locations);
  @override
  List<Object?> get props => [locations];
}

class LocationsErrorState extends LocationsState {
  final String error;
  LocationsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
