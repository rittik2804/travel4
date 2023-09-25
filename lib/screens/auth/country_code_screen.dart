import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/data/country_codes_data.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';

class CountryCodeScreen extends StatefulWidget {
  const CountryCodeScreen({Key? key}) : super(key: key);

  @override
  State<CountryCodeScreen> createState() => _CountryCodeScreenState();
}

class _CountryCodeScreenState extends State<CountryCodeScreen> {
  final formKey = GlobalKey<FormState>();
  List searchCountryDataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 40,
          child: TextFormField(
            keyboardType: TextInputType.text,
            onChanged: (value) {
              searchCountryDataList = countryData
                  .where((e) => e.name.contains(value.capitalizeFirst))
                  .toList();
              setState(() {});
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: RGB.lightDarker,
                ),
              ),
              hintText: 'Search',
              fillColor: RGB.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusSize),
                borderSide: const BorderSide(
                  color: RGB.muted,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusSize),
                borderSide: const BorderSide(
                  color: RGB.muted,
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Dimensions.smSize,
              ),
            ),
            cursorColor: RGB.dark,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Padding(
              padding: EdgeInsets.only(
                right: Dimensions.defaultSize,
              ),
              child: Icon(
                Icons.close_outlined,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: searchCountryDataList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: searchCountryDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        searchCountryDataList[index].dialCode.toString(),
                      );
                    },
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.defaultSize,
                        vertical: Dimensions.smSize,
                      ),
                      color: searchCountryDataList[index].dialCode == ''
                          ? RGB.muted.withOpacity(0.5)
                          : RGB.white,
                      child: searchCountryDataList[index].dialCode == ''
                          ? Text(searchCountryDataList[index].name)
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  searchCountryDataList[index].name,
                                ),
                                Text(
                                  searchCountryDataList[index].dialCode,
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                    ),
                  );
                },
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: countryData.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        countryData[index].dialCode.toString(),
                      );
                    },
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.defaultSize,
                        vertical: Dimensions.smSize,
                      ),
                      color: countryData[index].dialCode == ''
                          ? RGB.muted.withOpacity(0.5)
                          : RGB.white,
                      child: countryData[index].dialCode == ''
                          ? Text(countryData[index].name)
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  countryData[index].name,
                                ),
                                Text(
                                  countryData[index].dialCode,
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
