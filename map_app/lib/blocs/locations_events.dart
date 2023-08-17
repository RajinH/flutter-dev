import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LocationsEvent extends Equatable {
  const LocationsEvent();
}

class LoadLocationsEvent extends LocationsEvent {
  @override
  List<Object?> get props => [];
}
