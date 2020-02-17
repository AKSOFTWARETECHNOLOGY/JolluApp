import 'package:flutter/material.dart';
import 'package:next_hour/global.dart';

class HelpPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HelpPageState();
  }
}

class HelpPageState extends State<HelpPage> {
  final ScrollController _scrollController = ScrollController();

//  To control scrolling behaviour
    void _scrollToSelectedContent(bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      _scrollController.animateTo(isExpanded ? (box.size.height * index) : previousOffset,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

//  This list will show all the answers list
    List<Widget> _buildExpansionTileChildren(int index) => [
    Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        '${faqHelp[index]['answer']}',
        textAlign: TextAlign.justify,
        style: TextStyle(color:Color.fromRGBO( 20, 20, 20, 1.0), letterSpacing:
        0.7,
        height: 1.4),
        ),
      ),
    ];

//  This Widget will generate list of all question.
    Widget expansionTile(int index) {
    final GlobalKey expansionTileKey = GlobalKey();
    double previousOffset;
    return ExpansionTile(
      key: expansionTileKey,
      backgroundColor: Color.fromRGBO( 50, 150, 220, 0.05),
      trailing: SizedBox.shrink(),
      onExpansionChanged: (isExpanded) {
        if (isExpanded) previousOffset = _scrollController.offset;
        _scrollToSelectedContent(isExpanded, previousOffset, index, expansionTileKey);
      },
      title: Text('${faqHelp[index]['question']}',style: TextStyle(color: Color.fromRGBO( 50, 150, 220, 1.0)),),
      children: _buildExpansionTileChildren(index),
    );
  }

//  App Bar
    Widget appBar(){
      return AppBar(
        title: Text("Help",style: TextStyle(fontSize: 16.0),),
        centerTitle: true,
        backgroundColor:
        Color.fromRGBO(34,34,34, 1.0).withOpacity(0.98),
      );
    }

//  Scaffold body
    Widget scaffoldBody(){
      return ListView.builder(
        controller: _scrollController,
        itemCount: faqHelp==null? 0: faqHelp.length,
        itemBuilder: (BuildContext context, int index) => expansionTile(index),
      );
    }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      appBar: appBar(),
      body: scaffoldBody(),
    );
  }
}