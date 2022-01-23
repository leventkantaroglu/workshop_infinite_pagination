import 'package:flutter/material.dart';
import 'package:workshop_infinite_pagination/repository/page_status.dart';
import 'package:workshop_infinite_pagination/repository/user_repo.dart';

import 'widget/list_item.dart';

PageStorageKey pageStorageKey = const PageStorageKey("pageStorageKey");
final PageStorageBucket pageStorageBucket = PageStorageBucket();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepository userRepo = UserRepository();
  ScrollController? scrollController;

  @override
  void initState() {
    createScrollController();
    userRepo.getInitialUsers();
    super.initState();
  }

  void createScrollController() {
    scrollController = ScrollController();
    scrollController?.addListener(loadMoreUsers);
  }

  Future<void> loadMoreUsers() async {
    if (scrollController!.position.pixels >
            scrollController!.position.maxScrollExtent &&
        userRepo.pageStatus.value != PageStatus.newPageLoading) {
      await userRepo.loadMoreUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: body(),
      ),
    );
  }

  Widget body() {
    return ValueListenableBuilder<PageStatus>(
      valueListenable: userRepo.pageStatus,
      builder: (context, PageStatus pageStatus, _) {
        switch (pageStatus) {
          case PageStatus.idle:
            return idleWidget();
          case PageStatus.firstPageLoading:
            return firstPageLoadingWidget();
          case PageStatus.firstPageError:
            return firstPageErrorWidget();
          case PageStatus.firstPageNoItemsFound:
            return firstPageNoItemsFoundWidget();
          case PageStatus.newPageLoaded:
          case PageStatus.firstPageLoaded:
            return firstPageLoadedWidget();
          case PageStatus.newPageLoading:
            return newPageLoadingWidget();
          case PageStatus.newPageError:
            return newPageErrorWidget();
          case PageStatus.newPageNoItemsFound:
            return newPageNoItemsFoundWidget();
        }
      },
    );
  }

  Widget listViewBuilder() {
    if (scrollController?.hasClients == true) {
      scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
    }
    return PageStorage(
      key: pageStorageKey,
      bucket: pageStorageBucket,
      child: ListView.builder(
        controller: scrollController,
        itemCount: userRepo.users.length,
        itemBuilder: (context, index) {
          var currentUser = userRepo.users[index];
          return ListItem(currentUser, index);
        },
      ),
    );
  }

  Widget idleWidget() => const SizedBox();

  Widget firstPageLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget firstPageNoItemsFoundWidget() {
    return const Center(
      child: Text("İçerik bulunmadı"),
    );
  }

  Widget firstPageLoadedWidget() {
    return listViewBuilder();
  }

  Widget firstPageErrorWidget() {
    return const Center(
      child: Text("Hata oluştu"),
    );
  }

  Widget newPageLoadingWidget() {
    return Stack(
      children: [
        listViewBuilder(),
        bottomIndicator(),
      ],
    );
  }

  Widget newPageNoItemsFoundWidget() {
    return Column(
      children: [
        Expanded(
          child: listViewBuilder(),
        ),
        bottomMessage("İlave içerik bulunamadı")
      ],
    );
  }

  Widget newPageErrorWidget() {
    return Column(
      children: [
        Expanded(
          child: listViewBuilder(),
        ),
        bottomMessage("Yeni sayfa bulunamadı")
      ],
    );
  }

  Widget bottomIndicator() {
    return bottomWidget(
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: LinearProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget bottomMessage(String message) {
    return bottomWidget(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text(message),
      ),
    );
  }

  Widget bottomWidget({required Widget child}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }
}
