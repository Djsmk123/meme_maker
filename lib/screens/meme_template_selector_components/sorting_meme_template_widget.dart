import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../providers/template_provider.dart';
import '../../services/authencation_service.dart';

class SortingWidget extends StatefulWidget {
  const SortingWidget({Key? key}) : super(key: key);

  @override
  State<SortingWidget> createState() => _SortingWidgetState();
}

class _SortingWidgetState extends State<SortingWidget> {
  User? user;

  @override
  Widget build(BuildContext context) {
    int index = Provider.of<TemplateProvider>(context).getSortingIndex;
    user = Authentication.user;
    return sortingRowWidget(index);
  }

  sortingRowWidget(index) {
    bool isLoggedIn = user != null;
    return Row(
      children: [
        sortingWidgets(
            title: 'Popularity',
            isActive: index == 0,
            index: 0,
            context: context,
            isLoggedIn: isLoggedIn),
        sortingWidgets(
            title: 'Latest',
            isActive: index == 1,
            index: 1,
            context: context,
            isLoggedIn: isLoggedIn),
        if (isLoggedIn)
          sortingWidgets(
              title: 'your templates',
              isActive: index == 2,
              index: 2,
              context: context,
              isLoggedIn: isLoggedIn),
      ],
    );
  }

  sortingWidgetOnTap(index, isLoggedIn) async {
    Provider.of<TemplateProvider>(context, listen: false).setSortingIndex =
        index;
    Provider.of<TemplateProvider>(context, listen: false).applyFilter(
        byTime: index == 1 ? true : false,
        uid: isLoggedIn && index == 2 ? user!.uid : null);
  }

  sortingWidgets(
      {required String title,
      required bool isActive,
      required int index,
      required BuildContext context,
      required bool isLoggedIn}) {
    return Flexible(
      child: InkWell(
        onTap: !isActive
            ? () {
                sortingWidgetOnTap(index, isLoggedIn);
              }
            : null,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: isActive ? kPrimaryColor : Colors.white,
              border: !isActive ? Border.all(color: kPrimaryColor) : null,
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: isActive ? Colors.white : kPrimaryColor,
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
