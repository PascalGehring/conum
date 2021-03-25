import 'package:conum/core/constants/countries.dart';
import 'package:conum/core/util/get_suggestions.dart';
import 'package:conum/features/country_stats/presentation/bloc/country_stats_bloc.dart';
import 'package:conum/features/country_stats/presentation/pages/country_page.dart';
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
          textFieldConfiguration: TextFieldConfiguration(
            onChanged: (val) {
              inputString = val;
            },
            onSubmitted: (val) {
              if (val != '') {
                dispatchConcrete(val);
              }
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
            return Text(
              '$suggestion',
              style: TextStyle(fontSize: 25),
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
    BlocProvider.of<CountryStatsBloc>(widget.blocContext)
        .add(GetStatsForConcreteCountry(str));
  }
}

_getSuggestions(String str) {
  List<dynamic> countries = Constants.countries;

  List<dynamic> suggestionsList = countries
      .where((element) => element.toLowerCase().startsWith(str.toLowerCase()))
      .toList();

  return suggestionsList;
}


//OutlineInputBorder(borderRadius: BorderRadius.circular(25)),