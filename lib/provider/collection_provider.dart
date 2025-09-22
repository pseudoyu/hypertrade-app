import 'package:flutter/material.dart';
import 'package:hyper_app/helper/http_service.dart';
import 'package:hyper_app/models/vc_info.dart';

class CollectionProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(); // 实例化 ApiService

  bool isLoading = false; // 标识是否正在加载
  bool isRequestError = false; // 标识请求是否出错
  bool isLiked = false; // 标识某项是否已点赞
  List<VcInfoData> likeList = []; // 存储点赞的列表

  void likeItemActionUI(VcInfoData item, bool islike) {
    if (islike) {
      likeList.add(item);
    } else {
      likeList.remove(item);
    }
    notifyListeners();
  }

  // 点赞
  Future<void> likeItem(int id) async {
    _setLoading(true);
    try {
      await _apiService.post('/collection_vc/collection_vc/$id', {});
      _setRequestError(false);
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setLoading(false);
    }
  }

  // 取消点赞
  Future<void> unlikeItem(int id) async {
    _setLoading(true);
    try {
      await _apiService.delete('/collection_vc/collection_vc/$id');
      _setRequestError(false);
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setLoading(false);
    }
  }

  // 检查是否点赞
  Future<void> checkIfLiked(int id) async {
    _setLoading(true);
    try {
      final response =
          await _apiService.get('/collection_vc/collection_vc/$id');
      isLiked = response['liked'] ?? false; // 假设 API 返回的 JSON 中有 'liked' 字段
      _setRequestError(false);
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setLoading(false);
    }
  }

  // 获取点赞列表
  Future<void> fetchLikeList() async {
    _setLoading(true);
    try {
      final response = await _apiService.get('/collection_vc/collection_vc');
      likeList = (response['data'] as List)
          .map((item) => VcInfoData.fromJson(item))
          .toList();
      _setRequestError(false);
    } catch (error) {
      _setRequestError(true);
    } finally {
      _setLoading(false);
    }
  }

  // 设置加载状态
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // 设置请求错误状态
  void _setRequestError(bool value) {
    isRequestError = value;
    notifyListeners();
  }
}
