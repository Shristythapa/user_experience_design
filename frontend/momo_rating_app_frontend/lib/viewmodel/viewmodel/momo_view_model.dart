import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/model/momo/momo_model.dart';
import 'package:momo_rating_app_frontend/main.dart';
import 'package:momo_rating_app_frontend/repo/momo/momo_repo.dart';
import 'package:momo_rating_app_frontend/repo/momo/review_repo.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/screens/momodetails.dart';
import 'package:momo_rating_app_frontend/screens/search/search_result.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/momo_state.dart';

final moMoViewModelProvider = StateNotifierProvider<MoMoViewModel, MoMoState>(
    (ref) => MoMoViewModel(
        moMoRemoteRepo: ref.read(momoDataSourceProvider),
        reviewRepo: ref.read(reviewDataSourceProvider)));

class MoMoViewModel extends StateNotifier<MoMoState> {
  final MoMoRemoteRepo moMoRemoteRepo;
  final ReviewRepo reviewRepo;
  MoMoViewModel({required this.moMoRemoteRepo, required this.reviewRepo})
      : super(MoMoState.initialState()) {
    getAllMomos();
  }

  Future resetState() async {
    state = MoMoState.initialState();
    getAllMomos();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void addMoMo(
      {required File? image,
      required MoMoApiModel moMoApiModel,
      required String userId,
      required int overallRating,
      required int fillingAmount,
      required int sizeOfMomo,
      required int sauceVariety,
      required int aesthetic,
      required int spiceLevel,
      required int priceValue,
      required String textReview,
      required BuildContext context}) {
    setLoading(true);
    if (image == null) {
      state = state.copyWith(
          isLoading: false,
          showMessage: true,
          message: "Image is required",
          isError: true);
      return;
    }
    moMoRemoteRepo
        .addMoMo(
            image: image,
            moMoApiModel: moMoApiModel,
            overallRating: overallRating,
            fillingAmount: fillingAmount,
            sizeOfMomo: sizeOfMomo,
            sauceVariety: sauceVariety,
            spiceLevel: spiceLevel,
            aesthetic: aesthetic,
            priceValue: priceValue,
            textReview: textReview)
        .then((value) {
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboard()),
        );
      });
    });
  }

  Future<void> getAllMomos() async {
    state.copyWith(isLoading: true);
    final result = await moMoRemoteRepo.getAllMomos();
    result.fold(
        (failure) => state = state.copyWith(
            isError: true,
            message: failure.error,
            showMessage: true,
            isLoading: false), (data) {
      state = state.copyWith(momo: data, isLoading: false);
    });
  }

  Future<void> getMomoById(
      String id, String userId, BuildContext context) async {
    state.copyWith(isLoading: true);
    final result = await moMoRemoteRepo.getMoMoById(momoId: id, userId: userId);

    result.fold((failure) {
      state = state.copyWith(
          isError: true,
          message: failure.error,
          showMessage: true,
          isLoading: false);
    }, (data) {
      state = state.copyWith(isError: false, isLoading: false);
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MoMoDetails(moApiModel: data)));
    });
  }

  Future<void> searchMomo(
      {String? query,
      List<FillingType>? filling,
      List<CookType>? cook,
      required BuildContext context}) async {
    state.copyWith(isLoading: true);
    final result = await moMoRemoteRepo.searchMomo(
        query: query, filling: filling, cook: cook);
    result.fold((failure) {
      state = state.copyWith(
          isError: true,
          message: failure.error,
          showMessage: true,
          isLoading: false);
    }, (data) {
      state = state.copyWith(isError: false, isLoading: false, momo: data);
      Navigator.of(context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SearchResult()));
    });
  }
}
