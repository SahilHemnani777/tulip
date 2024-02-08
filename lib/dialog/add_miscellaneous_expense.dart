import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/model/expense_model/expense_details_list.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class AddMiscellaneousExpense extends StatefulWidget {
  final MiscellaneousExpense? miscellaneousExpense;
  const AddMiscellaneousExpense({Key? key, this.miscellaneousExpense}) : super(key: key);

  @override
  _AddMiscellaneousExpenseState createState() => _AddMiscellaneousExpenseState();
}

class _AddMiscellaneousExpenseState extends State<AddMiscellaneousExpense> {
  MiscellaneousExpense? miscellaneousExpense;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    if(widget.miscellaneousExpense!=null){
      miscellaneousExpense=MiscellaneousExpense.fromJson(widget.miscellaneousExpense!.toJson());
    }
    else{
      miscellaneousExpense = MiscellaneousExpense(amount: 0,description: "");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: Column(
                children: [
                  Container(
                    width: 80.w,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    padding: EdgeInsets.only(left: 4.w,right: 4.w,bottom: 1.h,top: 1.h),
                    decoration: BoxDecoration(
                        color: const Color(0xffF8F8F8),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text("Add Miscellaneous Expense",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),),


                        SizedBox(height: 1.h),
                         CustomTextFormField(
                          hintText: "Enter amount",
                          labelText: "Amount",
                           keyboardType: TextInputType.number,
                           validator: (val){
                            if(val!=null && val.isNotEmpty){
                              return null;
                            }
                            else{
                              return "Enter Amount";
                            }
                          },
                          onSaved: (val) => miscellaneousExpense?.amount = double.parse(val!),
                           initialValue: miscellaneousExpense?.amount?.toStringAsFixed(2),
                        ),

                         CustomTextFormField(
                          hintText: "Enter Description",
                          labelText: "Description",
                          maxLines: 3,
                          onSaved: (val) => miscellaneousExpense?.description = val!,
                          initialValue: miscellaneousExpense?.description,
                        ),



                        CustomButton(title: "Save",onTabButtonCallback: onSaveClick),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffF8F8F8),
                        ),
                        child: const Icon(Icons.close,color: Color(0xff009EE0))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSaveClick(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      print(miscellaneousExpense?.toJson());
      Get.back(result: miscellaneousExpense);
    }else{
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }


}
