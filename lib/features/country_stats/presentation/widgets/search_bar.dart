import 'package:conum/core/constants/countries.dart';
import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchBar extends StatefulWidget {
  final BuildContext blocContext;

  const SearchBar({Key key, @required this.blocContext}) : super(key: key);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final controller = TextEditingController();
  String inputString;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 20),
      child: Material(
        elevation: 0,
        child: TypeAheadField(
          hideOnLoading: true,
          hideOnEmpty: true,
          textFieldConfiguration: TextFieldConfiguration(
            onChanged: (val) {
              inputString = val;
            },
            onSubmitted: (val) {
              dispatchConcrete(val);
            },
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            textAlign: TextAlign.center,
            autofocus: false,
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(fontStyle: FontStyle.normal, fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Search a country',
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              // OutlineInputBorder(
              //   borderRadius: const BorderRadius.all(
              //     const Radius.circular(20.0),
              //   ),
              // ),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
          suggestionsCallback: (str) {
            return _getSuggestions(str);
          },
          itemBuilder: (context, suggestion) {
            return Container(
              color: Colors.white,
              height: 30,
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '$suggestion',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          },
          onSuggestionSelected: (suggestion) {
            print(suggestion);
            dispatchConcrete(suggestion);
          },
        ),
      ),
    );
  }

  void dispatchConcrete(String str) {
    if (str != '') {
      BlocProvider.of<CountryStatsBloc>(widget.blocContext)
          .add(GetStatsForConcreteCountry(str));
    }
  }
}

_getSuggestions(String str) {
  if (str != '') {
    List<dynamic> countries = Constants.countries;

    List<dynamic> suggestionsList = countries
        .where((element) => element.toLowerCase().startsWith(str.toLowerCase()))
        .take(5)
        .toList();

    return suggestionsList;
  }
}


//OutlineInputBorder(borderRadius: BorderRadius.circular(25)),