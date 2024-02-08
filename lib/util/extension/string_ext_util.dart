extension StringExtUtil on String{
  validateEmailId(){
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  validateGSTN(){
    return RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[0-9A-Z]{1}[Z]{1}[0-9A-Z]{1}$').hasMatch(this);
  }

  validateNumber(){
    return RegExp(r'^0+');
  }
}