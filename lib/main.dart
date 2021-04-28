import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Intrest Calculator",
    home: SIForm(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  _SIFormState createState() => _SIFormState();
}

class _SIFormState extends State<SIForm> {
  var _formkey = GlobalKey<FormState>();
  var currencies = ["Rupees", "Dollars", "Pounds"];
  final _minimumpaddig = 5.0;
  var currentItemSelected = '';
  @override
  void initState() {
    super.initState();
    currentItemSelected = currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();
  var displayResult = '';
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Simple Interest Calculator")),
      body: Form(
          key: _formkey,
          //Principal
          child: Padding(
            padding: EdgeInsets.all(_minimumpaddig * 2),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumpaddig, bottom: _minimumpaddig),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(13)
                      ],
                      controller: principalController,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "please enter the principal amount";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Principal",
                        hintText: "Enter Principal eg.1200",
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                            color: Colors.yellowAccent, fontSize: 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      )),
                ),
                //Rate of Interest
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumpaddig, bottom: _minimumpaddig),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(5)
                      ],
                      controller: roiController,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "please enter rate of interest";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Rate of Interest",
                        hintText: "Percentage",
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                            fontSize: 15.0, color: Colors.yellowAccent),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      )),
                ),
                //Term
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumpaddig, bottom: _minimumpaddig),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(5)
                              ],
                              style: textStyle,
                              controller: termController,
                              validator: (String vlaue) {
                                if (vlaue.isEmpty) {
                                  return "please enter the valid term";
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Term",
                                hintText: "Time in Years",
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.yellowAccent,
                                    fontSize: 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ))),
                      Container(
                        width: _minimumpaddig * 5,
                      ),
                      // DropDownButton 
                      Expanded(
                          child: DropdownButton<String>(
                              items: currencies.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: textStyle,
                                    ));
                              }).toList(),
                              value: currentItemSelected,
                              onChanged: (String newValueSelected) {
                                _ondropDownItemSelected(newValueSelected);
                              }))
                    ],
                  ),
                ),
                // Calculate Button
                Padding(
                  padding: EdgeInsets.only(
                      bottom: _minimumpaddig, top: _minimumpaddig),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                "Calculate",
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_formkey.currentState.validate())
                                    this.displayResult =
                                        _calculateTotalReturn();
                                });
                              })),
                              // Reset Button
                      Expanded(
                          child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                "Reset",
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  _reset();
                                });
                              })),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(_minimumpaddig * 2),
                  child: Text(this.displayResult, style: textStyle),
                ),
              ],
            ),
          )),
    );
  }

  void _ondropDownItemSelected(String newValueSelected) {
    setState(() {
      this.currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturn() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;
    String result =
        'after $term years ,your investment will be worth $totalAmountPayable $currentItemSelected';
    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    currentItemSelected = currencies[0];
  }
}
