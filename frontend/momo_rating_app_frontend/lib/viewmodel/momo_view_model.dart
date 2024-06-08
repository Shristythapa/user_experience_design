import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/model/momo/momo_model.dart';
import 'package:momo_rating_app_frontend/repo/momo/momo_repo.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/momo_state.dart';

final MoMoViewModelProvider =
    StateNotifierProvider.autoDispose<MoMoViewModel, MoMoState>((ref) =>
        MoMoViewModel(moMoRemoteRepo: ref.read(momoDataSourceProvider)));

class MoMoViewModel extends StateNotifier<MoMoState> {
  final MoMoRemoteRepo moMoRemoteRepo;

  MoMoViewModel({required this.moMoRemoteRepo})
      : super(MoMoState.initialState());

  void addMoMo(File image, MoMoApiModel moMoApiModel, BuildContext context) {
    state.copyWith(isLoading: true);
    moMoRemoteRepo.addMoMo(image, moMoApiModel).then((value) {
      value.fold(
          (failure) => state = state.copyWith(
              message: failure.error,
              isLoading: false,
              showMessage: true,
              isError: true), (success) {
        state = state.copyWith(
            isLoading: false,
            showMessage: true,
            message: "MoMo Added Sucessfully");
        Navigator.of(context).pop();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const GetStarted()),
        // );
      });
    });
  }
}
