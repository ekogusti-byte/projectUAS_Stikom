import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/database/dbconn.dart';

import 'models/trans.dart';

enum TransType { earning, expense }

class AddDataWidget extends StatefulWidget {
  AddDataWidget();

  @override
  _AddDataWidgetState createState() => _AddDataWidgetState();
}

class _AddDataWidgetState extends State<AddDataWidget> {
  _AddDataWidgetState();

  DbConn dbconn = DbConn();
  final _addFormKey = GlobalKey<FormState>();
  final format = DateFormat("dd-MM-yyyy");
  final _transDateController = TextEditingController();
  final _transNameController = TextEditingController();
  String transType = 'earning';
  final _amountController = TextEditingController();
  TransType _transType = TransType.earning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Card(
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: 440,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Tanggal Transaksi'),
                              DateTimeField(
                                format: format,
                                controller: _transDateController,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate: currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Nama Transaksi'),
                              TextFormField(
                                controller: _transNameController,
                                decoration: const InputDecoration(
                                  hintText: 'Nama Transaksi',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Silahkan masukkan nama transaksi disini';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Jenis Transaksi'),
                              ListTile(
                                title: const Text('Pemasukan'),
                                leading: Radio(
                                  value: TransType.earning,
                                  groupValue: _transType,
                                  onChanged: (TransType value) {
                                    setState(() {
                                      _transType = value;
                                      transType = 'earning';
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Pengeluaran'),
                                leading: Radio(
                                  value: TransType.expense,
                                  groupValue: _transType,
                                  onChanged: (TransType value) {
                                    setState(() {
                                      _transType = value;
                                      transType = 'expense';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Jumlah'),
                              TextFormField(
                                controller: _amountController,
                                decoration: const InputDecoration(
                                  hintText: 'Jumlah',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Masukkan jumlah transaksi disini';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              RaisedButton(
                                splashColor: Colors.green,
                                onPressed: () {
                                  if (_addFormKey.currentState.validate()) {
                                    _addFormKey.currentState.save();
                                    final initDB = dbconn.initDB();
                                    initDB.then((db) async {
                                      dbconn.insertTrans(Trans(transDate: _transDateController.text, transName: _transNameController.text, transType: transType, amount: int.parse(_amountController.text)));
                                    });

                                    Navigator.pop(context) ;
                                  }
                                },
                                child: Text('Simpan', style: TextStyle(color: Colors.white)),
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                )
            ),
          ),
        ),
      ),
    );
  }
}