import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_code_picker/text_form_field.dart';
import '../countries.dart';
import '../model/phone.dart';

class IntlPhoneField extends StatefulWidget {
  final bool obscureText;
  final TextAlign textAlign;
  final VoidCallback? onTap;
  final bool readOnly;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final ValueChanged<PhoneNumber>? onChanged;
  final ValueChanged<PhoneNumber>? onCountryChanged;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final bool autoValidate;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final Brightness keyboardAppearance;
  final String? initialValue;
  final int? maxLength;
  final String? initialCountryCode;
  final List<String>? countries;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool showDropdownIcon;
  final BoxDecoration dropdownDecoration;
  final List<TextInputFormatter>? inputFormatters;
  final String? searchText;
  final String hintText;
  final String? fontFamily;
  final Color? countryCodeTextColor;
  final Color? dropDownArrowColor;
  final Color? backgroundColor;
  final double modalSizePercent;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final Function? onSubmit;
  final TextStyle? textFielsStyle;
  final TextStyle? labelStyle;
  final String? noDataText;
  final String? label;
  final Color fillColor;

  const IntlPhoneField(
      {super.key,
        this.labelStyle,
      required this.textFielsStyle,
      required this.noDataText,
        this.initialCountryCode,
        this.label,
      this.obscureText = false,
      this.textAlign = TextAlign.left,
      this.onTap,
      this.readOnly = false,
      this.initialValue,
      this.keyboardType,
      this.autoValidate = true,
      this.controller,
      this.focusNode,
      this.decoration,
      this.style,
      this.onSubmitted,
      this.validator,
      this.onChanged,
      this.countries,
      this.onCountryChanged,
      this.onSaved,
      this.showDropdownIcon = true,
      this.dropdownDecoration = const BoxDecoration(),
      this.inputFormatters,
      this.enabled = true,
      this.keyboardAppearance = Brightness.light,
      required this.searchText,
      this.countryCodeTextColor,
      this.backgroundColor,
      this.modalSizePercent = 100,
      this.dropDownArrowColor,
      this.autofocus = false,
      this.textInputAction,
      this.maxLength,
      this.onSubmit,
      this.fontFamily,
        this.fillColor,
      required this.hintText,
      this.onEditingComplete});

  @override
  State<IntlPhoneField> createState() => _IntlPhoneFieldState();
}

class _IntlPhoneFieldState extends State<IntlPhoneField> {
  late List<Map<String, dynamic>> _countryList;
  late Map<String, dynamic> _selectedCountry;
  late List<Map<String, dynamic>> filteredCountries;
  bool empty = false;
  var dialCode = "";
  var codeWithNumber = "";

  FormFieldValidator<String>? validator;

  @override
  void initState() {
    super.initState();
    _countryList = widget.countries == null
        ? countries
        : countries
            .where((country) => widget.countries!.contains(country['code']))
            .toList();
    filteredCountries = _countryList;
    _selectedCountry = _countryList.firstWhere(
        (item) => item['code'] == (widget.initialCountryCode ?? 'US'),
        orElse: () => _countryList.first);

    validator = widget.autoValidate
        ? ((value) => value != null && value.length != 10
            ? 'Invalid Mobile Number'
            : null)
        : widget.validator;
  }

  Future<void> changeCountry() async {
    empty = false;
    filteredCountries = _countryList;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: (MediaQuery.of(this.context).size.width / 100) *
                widget.modalSizePercent,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.3),
                                blurRadius: 2,
                                spreadRadius: 1)
                          ]),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Color(0xffF66729),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  focusNode: widget.focusNode,
                  style: widget.textFielsStyle,
                  textInputAction: widget.textInputAction,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Color(0xffF66729),
                    ),
                    labelText: widget.searchText,
                    labelStyle: widget.textFielsStyle,
                  ),
                  onChanged: (value) {
                    setState(() {
                      debugPrint("filter data $filteredCountries");
                      filteredCountries = _countryList
                          .where((country) => country['name']!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                      if (filteredCountries.isEmpty) {
                        empty = true;
                      } else {
                        empty = false;
                      }
                    });
                  },
                  onSubmitted: (text) =>
                      widget.onSubmit != null ? widget.onSubmit!(text) : null,
                ),
                const SizedBox(height: 20),
                empty == true
                    ? Text(
                        widget.noDataText!,
                        style: widget.textFielsStyle,
                      )
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredCountries.length,
                          itemBuilder: (ctx, index) => Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(filteredCountries[index]['name']!,
                                    style: widget.textFielsStyle),
                                trailing: Text(
                                    '+${filteredCountries[index]['dial_code']}',
                                    style: widget.textFielsStyle),
                                onTap: () {
                                  setState(() {
                                    _selectedCountry = filteredCountries[index];
                                    // dialCode =
                                    // filteredCountries[index]['dial_code'];
                                    debugPrint("country is $_selectedCountry");
                                  });

                                  Navigator.of(context).pop();
                                },
                              ),
                              Divider(
                                indent: 20,
                                endIndent: 20,
                                thickness: 0.5,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      searchText: widget.searchText,
      label:widget.label,
      fillColor:widget.fillColor,
      hintText: widget.hintText,
      textFielsStyle: widget.textFielsStyle,
      labelStyle: widget.labelStyle,
      controller: widget.controller,
      maxLength: widget.maxLength,
      validator: widget.validator,
      needSuffixIcon: true,
      suffixIcon: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 5.0),
              child: Container(
                color: const Color(0xFF000000).withOpacity(0.3),
                width: 1,
                height: 15,
              ),
            ),
            buildFlagsButton(),
          ],
        ),
      ),
    );
  }

  DecoratedBox buildFlagsButton() {
    return DecoratedBox(
      decoration: widget.dropdownDecoration,
      child: InkWell(
        borderRadius: widget.dropdownDecoration.borderRadius as BorderRadius?,
        onTap: changeCountry,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  '+${_selectedCountry['dial_code']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff009BF2),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              widget.showDropdownIcon
                  ? const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Color(0xFF323333),
                      size: 16,
                    )
                  : const SizedBox(),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
