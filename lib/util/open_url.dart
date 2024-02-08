import 'package:url_launcher/url_launcher.dart';

class OpenUrl{
  static void callNumber(String phoneNumber) async {
    String url = 'tel:$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void openWhatsApp(String phoneNumber) async {
    final link = "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent("")}";
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }


    // final url = Uri.parse('https://wa.me/$phoneNumber');
    // if (await canLaunchUrl(url)) {
    //   await launch(url.toString());
    // } else {
    //   throw 'Could not launch $url';
    // }
  }


  static void openEmail(String emailAddress, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    final String emailUrl = emailUri.toString();

    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      throw 'Could not launch $emailUrl';
    }
  }

  static void launchAddress(String address) async {
    String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  static void launchUpdateAddress(String address) async {
    if (await canLaunch(address)) {
      await launch(address);
    } else {
      throw 'Could not launch $address';
    }
  }



}