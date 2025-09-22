import 'package:flutter/material.dart';
import 'package:hyper_app/models/vc_info.dart';
import 'package:provider/provider.dart';
import 'package:hyper_app/provider/collection_provider.dart';

class LikeButton extends StatefulWidget {
  final VcInfoData item;

  const LikeButton({super.key, required this.item});

  @override
  LikeButtonState createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  bool? isLiked;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 初始化动画控制器和缩放动画
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 设置动画监听器，在动画完成后反转动画
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final collectionProvider = Provider.of<CollectionProvider>(context);
    // 初始化 isLiked 状态
    isLiked = collectionProvider.likeList.any((vc) => vc.id == widget.item.id);
  }

  void toggleLike() {
    final previousLiked = isLiked;

    setState(() {
      // isLiked = !isLiked!; // 立即更新本地 UI
      _controller.forward(); // 开始动画
    });

    // 使用 Future.delayed 确保异步操作在 UI 更新后执行
    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);
    collectionProvider.likeItemActionUI(widget.item, !previousLiked!);
    Future.microtask(() => checkLike(!previousLiked));
  }

  void checkLike(bool previousLiked) async {
    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);

    try {
      if (previousLiked) {
        await collectionProvider.likeItem(widget.item.id!);
      } else {
        await collectionProvider.unlikeItem(widget.item.id!);
      }
    } catch (e) {
      // 请求失败，恢复到之前的状态
      print(e.toString());
      collectionProvider.likeItemActionUI(widget.item, !previousLiked);
    } finally {
      await collectionProvider.fetchLikeList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: FloatingActionButton(
            onPressed: toggleLike,
            backgroundColor: Colors.white,
            child: Icon(
              isLiked == true ? Icons.favorite : Icons.favorite_border,
              color: isLiked == true ? Colors.red : Colors.grey,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
