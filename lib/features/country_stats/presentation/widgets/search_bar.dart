import 'package:conum/core/util/get_flag.dart';
import 'package:conum/core/util/get_suggestions.dart';
import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBar extends StatefulWidget {
  final BuildContext context;
  final ScrollController scrollController;

  const SearchBar(
      {Key key, @required this.context, @required this.scrollController})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController controller = TextEditingController();
  String value = '';
  List<String> suggestions = [];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: MediaQuery.of(context).size.width - 100,
        height:
            suggestions.isEmpty ? 50 : 66 + suggestions.length.toDouble() * 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: Offset(1.0, 1.0), //(x,y)
              blurRadius: 6.0,
            )
          ],
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  //color: Colors.green,
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search a country',
                        hintStyle: TextStyle(fontSize: 18)),
                    onChanged: (str) {
                      setState(() {
                        value = str;
                        if (str != '') {
                          if (str.length == 1) {
                            widget.scrollController.animateTo(173,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate);
                          }
                          suggestions = _getSuggestions(str);
                        } else {
                          suggestions = [];
                        }
                      });
                    },
                    onSubmitted: (str) {
                      dispatchConcrete(str);
                    },
                  ),
                ),
              ),
              Icon(
                Icons.search,
                color: Colors.grey,
              ),
              SizedBox(
                width: 12,
              ),
            ]),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length,
                  itemBuilder: (context, i) {
                    if (suggestions.isNotEmpty) {
                      return GestureDetector(
                        onTap: () {
                          dispatchConcrete(suggestions[i]);
                        },
                        child: Container(
                          //height: 56,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                controller.text,
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                _handleLongCountries(suggestions[i]),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                GetFlag().call(suggestions[i]),
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return null;
                  }),
            ),
          ],
        ));
  }

  void dispatchConcrete(String str) {
    if (str != '') {
      BlocProvider.of<CountryStatsBloc>(widget.context)
          .add(GetStatsForConcreteCountry(str));
    }
  }

  String _handleLongCountries(String str) {
    if (str.length > 22) {
      return '${str.substring(controller.text.length, 22)}...';
    }

    return str.substring(controller.text.length);
  }
}

_getSuggestions(String str) {
  return GetSuggestions()(str);
}

class Suggestions extends StatelessWidget {
  final List<String> suggestions;
  final TextEditingController controller;
  final BuildContext context;

  const Suggestions(
      {Key key,
      @required this.suggestions,
      @required this.controller,
      @required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, i) {
            if (suggestions.isNotEmpty) {
              return GestureDetector(
                onTap: () {
                  dispatchConcrete(suggestions[i]);
                },
                child: Container(
                  height: 56,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        controller.text,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _handleLongCountries(suggestions[i]),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        GetFlag().call(suggestions[i]),
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              );
            }
            return null;
          }),
    );
  }

  void dispatchConcrete(String str) {
    if (str != '') {
      BlocProvider.of<CountryStatsBloc>(context)
          .add(GetStatsForConcreteCountry(str));
    }
  }

  String _handleLongCountries(String str) {
    if (str.length > 22) {
      return '${str.substring(controller.text.length, 22)}...';
    }

    return str.substring(controller.text.length);
  }
}
