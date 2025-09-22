import 'package:flutter/material.dart';
import 'package:hyper_app/helper/http_service.dart';
import '../models/vc_info.dart'; // 替换为你的模型导入

class VcInfoProvider with ChangeNotifier {
  late VcInfoData vcInfo;
  List<VcInfoData> vcInfos = [];
  bool isLoading = false;
  bool isRequestError = false;
  bool isSearchError = false;

  final ApiService _apiService = ApiService();

  Future<void> getVcInfos({
    int limit = 10,
    int offset = 0,
    bool notify = false,
    bool loadmore = false,
  }) async {
    _setLoading(true, notify: notify);

    try {
      final data =
          await _apiService.get('/vc_info/vc_info?limit=$limit&offset=$offset');
      List<VcInfoData> fetchedVcInfos = (data['data'] as List)
          .map((item) => VcInfoData.fromJson(item))
          .toList();

      if (loadmore) {
        vcInfos.addAll(fetchedVcInfos);
      } else {
        vcInfos = fetchedVcInfos;
      }
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getVcInfo(int vcId) async {
    _setLoading(true);

    try {
      final data = await _apiService.get('/vc_info/vc_info/$vcId');
      vcInfo = VcInfoData.fromJson(data['data']);
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addVcInfo(VcInfoData newVcInfo) async {
    _setLoading(true);

    try {
      final data =
          await _apiService.post('/vc_info/vc_info', newVcInfo.toJson());
      vcInfo = VcInfoData.fromJson(data['data']);
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateVcInfo(int vcId, VcInfoData updatedVcInfo) async {
    _setLoading(true);

    try {
      final data = await _apiService.put(
          '/vc_info/vc_info/$vcId', updatedVcInfo.toJson());
      vcInfo = VcInfoData.fromJson(data['data']);
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteVcInfo(int vcId) async {
    _setLoading(true);

    try {
      await _apiService.delete('/vc_info/vc_info/$vcId');
      // 如果需要，可以在这里处理删除成功后的逻辑
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchVcInfos(String query) async {
    _setLoading(true);

    try {
      final data =
          await _apiService.get('/vc_info/vc_info/search?query=$query');
      vcInfos = (data['data'] as List)
          .map((item) => VcInfoData.fromJson(item))
          .toList();
    } catch (error) {
      _setSearchError(true);
    } finally {
      _setLoading(false);
    }
  }

  void setLoading(bool value) {
    _setLoading(value);
  }

  void _setLoading(bool value, {bool notify = true}) {
    isLoading = value;
    if (notify) notifyListeners();
  }

  void _setRequestError(bool value) {
    isRequestError = value;
    notifyListeners();
  }

  void _setSearchError(bool value) {
    isSearchError = value;
    notifyListeners();
  }
}
