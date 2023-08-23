import 'package:agrocart/backend/models/faqModel.dart';
import 'package:agrocart/universal/add_scaffold.dart';
import 'package:flutter/material.dart';

class FaqActivity extends StatefulWidget {
  @override
  _FaqActivityState createState() => _FaqActivityState();
}


class _FaqActivityState extends State<FaqActivity> {
  int _activeMeterIndex;
  @override
  void initState() {
    super.initState();
  }

  List<EventFaq> _list = [
    EventFaq(
      'How can I get help?',
      'There is Get Help section, you just need to fill all the details and you are good to go!'
    ),

    EventFaq(
      'How can I give help',
      'There is Give Help section, you just need to fill all the details and you are good to go!'
    ),

    EventFaq(
      'How can I edit my existing ad',
      'In Profile page, you can find the history section where you can find ypur all ad which you have given, click on that and edit on your choice'
    ),

    EventFaq(
      ' How can I be sure of the accuracy of a claim post?',
      '''This app is giving a platform to build a connection between the help seeker and help provider. It is not to blame for any false post. It is totally on the users to trust or not on any post. Please review other offerer's posts also before providing any claimer'''
    ),
  ];

  Future<List<EventFaq>> loadFaqQue(que) async {
    List<EventFaq> fque = que;
    return fque;
  }

  @override
  Widget build(BuildContext context) {
    // print(_list);
    return AddScaffold(
        title: 'FAQ',
        body: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (BuildContext context, int i) {
              print(
                _list[i],
              );

              return Container(
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool status) {
                    setState(() {
                      _activeMeterIndex = _activeMeterIndex == i ? null : i;
                    });
                  },
                  children: [
                    new ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: _activeMeterIndex == i,
                      headerBuilder: (BuildContext context, bool isExpanded) =>
                          new Container(
                              padding: const EdgeInsets.only(left: 15.0),
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                _list[i].name,
                              )),
                      body: new Container(
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        child: new Text(_list[i].detail),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
