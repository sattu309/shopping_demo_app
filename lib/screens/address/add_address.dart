import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shop_app/helper/common_button.dart';
import 'package:shop_app/helper/heigh_width.dart';

import '../../controllers/session_controller.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/common_textfiled.dart';
import '../../helper/custom_snackbar.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final userDataController = Get.put(SessionController());
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();

  addAddressMutation(
      {
        required String userId,
        required String fname,
        required String lname,
        required String address1,
        required String city,
        required String zipCode}) async {

    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation AddAddress(\$input: AddAddressInput!) {
        addAddress(
       input:\$input
            ) {
         id
        users_id
        address1
        city
        postcode
        fname
        lname
        }
      }
    '''),
      variables: {
        'input':{
          'fname': fname,
          'lname': lname,
          'address1': address1,
          'city': city,
          'postcode': zipCode,
        }
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      final error = result.exception!.graphqlErrors.first.message;
      print("ADD ADDRESS ERROR::::: $error");
      final snackBar = CustomSnackbar.build(
        message: error,
        backgroundColor: AppThemeColor.buttonColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? createAddress = result.data?['addAddress'];
      if (createAddress != null) {
        final snackBar = CustomSnackbar.build(
          message: "Address added successfully!",
          backgroundColor: AppThemeColor.buttonColor,
          onPressed: () {
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Get.back();
      } else {
        print('Adding address error: Invalid response data');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Add Shipping Address",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff222222)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              addHeight(20),
              CommonTextFieldWidget(
                controller: fNameController,
                hint: "First Name",
                validator: MultiValidator([
                  RequiredValidator(
                      errorText: 'Please Enter Your AddressType'),
                ]),
              ),
              addHeight(15),
              CommonTextFieldWidget(
                controller: lNameController,
                hint: "Last Name",
                validator: MultiValidator([
                  RequiredValidator(
                      errorText: 'Please Enter Your Name'),
                ]),
              ),
              addHeight(15),
              CommonTextFieldWidget(
                controller: address1Controller,
                hint: "Address",
                validator: MultiValidator([
                  RequiredValidator(
                      errorText: 'Please Enter Your Address 1'),
                ]),
              ),
              addHeight(15),
              CommonTextFieldWidget(
                controller: cityController,
                hint: "City",
                validator: MultiValidator([
                  RequiredValidator(
                      errorText: 'Please Enter Your City'),
                ]),
              ),
              addHeight(15),
              CommonTextFieldWidget(
                controller: zipCodeController,
                hint: "ZipCode",
                validator: MultiValidator([
                  RequiredValidator(
                      errorText: 'Please Enter Your ZipCode'),
                ]),
              ),
              addHeight(30),

              CommonButtonGreen(title: "SAVE ADDRESS", onPressed: () {
                log(userDataController.userId.value.toString());
                addAddressMutation(
                    userId: userDataController.userId.value.toString(),
                    fname: fNameController.text,
                    lname: lNameController.text,
                    address1: address1Controller.text,
                    city: cityController.text,
                    zipCode: zipCodeController.text);

              },)
            ],
          ),
        ),
      ),
    );
  }
}
