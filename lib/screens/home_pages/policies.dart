import 'package:dine_a_tap/screens/home_pages/reusables.dart';
import 'package:flutter/material.dart';

class PoliciesPage extends StatefulWidget {
  const PoliciesPage({super.key});

  @override
  State<PoliciesPage> createState() => _PoliciesPageState();
}

class _PoliciesPageState extends State<PoliciesPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(155.0),
        child: CustomAppBar(
          title: 'Policies',
          leftIcon: 'menu',
          rightIcon: 'shop',
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  "Terms and Conditions for AUTOINNOTECH PRIVATE LIMITED",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
              Divider(
                color: Colors.black12,
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  "Terms and Conditions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  'Last updated on Mar 27 2024 \n\nFor the purpose of these Terms and Conditions, The term "we", "us", "our" used anywhere on this page shall mean AUTOINNOTECH PRIVATE LIMITED, whose registered/operational office is Flat no. 201,7-2-1087/9/E, Sanath Nagar, hyderabad Hyderabad TELANGANA 500018 . "you", “your”, "user", “visitor” shall mean any natural or legal person who is visiting our website and/or agreed to purchase from us.\n\nYour use of the website and/or purchase from us are governed by following Terms and Conditions:\n\n -The content of the pages of this website is subject to change without notice.\n\n -Neither we nor any third parties provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness or suitability of the information and materials found or offered on this website for any particular purpose. You acknowledge that such information and materials may contain inaccuracies or errors and we expressly exclude liability for any such inaccuracies or errors to the fullest extent permitted by law.\n\n -Neither we nor any third parties provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness or suitability of the information and materials found or offered on this website for any particular purpose. You acknowledge that such information and materials may contain inaccuracies or errors and we expressly exclude liability for any such inaccuracies or errors to the fullest extent permitted by law.\n\n -Our website contains material which is owned by or licensed to us. This material includes, but are not limited to, the design, layout, look, appearance and graphics. Reproduction is prohibited other than in accordance with the copyright notice, which forms part of these terms and conditions.\n\n -All trademarks reproduced in our website which are not the property of, or licensed to, the operator are acknowledged on the website.\n\n -Unauthorized use of information provided by us shall give rise to a claim for damages and/or be a criminal offense.\n\n -From time to time our website may also include links to other websites. These links are provided for your convenience to provide further information.\n\n -You may not create a link to our website from another website or document without AUTOINNOTECH PRIVATE LIMITED’s prior written consent.\n\n -Any dispute arising out of use of our website and/or purchase with us and/or any engagement with us is subject to the laws of India .\n\n -We, shall be under no liability whatsoever in respect of any loss or damage arising directly or indirectly out of the decline of authorization for any Transaction, on Account of the Cardholder having exceeded the preset limit mutually agreed by us with our acquiring bank from time to time.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  "Cancellation and Refund",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  'AUTOINNOTECH PRIVATE LIMITED believes in helping its customers as far as possible, and has therefore a liberal cancellation policy. Under this policy:\n\n -Cancellations will be considered only if the request is made within 7 days of placing the order. However, the cancellation request may not be entertained if the orders have been communicated to the vendors/merchants and they have initiated the process of shipping them.\n -AUTOINNOTECH PRIVATE LIMITED does not accept cancellation requests for perishable items like flowers, eatables etc. However, refund/replacement can be made if the customer establishes that the quality of product delivered is not good.\n -In case of receipt of damaged or defective items please report the same to our Customer Service team. The request will, however, be entertained once the merchant has checked and determined the same at his own end. This should be reported within 7 days of receipt of the products.\n -In case you feel that the product received is not as shown on the site or as per your expectations, you must bring it to the notice of our customer service within 7 days of receiving the product. The Customer Service Team after looking into your complaint will take an appropriate decision.\n -In case of complaints regarding products that come with a warranty from manufacturers, please refer the issue to them.\n -In case of any Refunds approved by the AUTOINNOTECH PRIVATE LIMITED, it’ll take 3-5 days for the refund to be processed to the end customer.',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  "Shipping and Delivery",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  "For International buyers, orders are shipped and delivered through registered international courier companies and/or International speed post only. For domestic buyers, orders are shipped through registered domestic courier companies and /or speed post only. Orders are shipped within 0-7 days or as per the delivery date agreed at the time of order confirmation and delivering of the shipment subject to Courier Company / post office norms. AUTOINNOTECH PRIVATE LIMITED is not liable for any delay in delivery by the courier company / postal authorities and only guarantees to hand over the consignment to the courier company or postal authorities within 0-7 days rom the date of the order and payment or as per the delivery date agreed at the time of order confirmation. Delivery of all orders will be to the address provided by the buyer. Delivery of our services will be confirmed on your mail ID as specified during registration. For any issues in utilizing our services you may contact our helpdesk on 8885718689 or info.autoinnovationtech@gmail.com",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  'This privacy policy sets out how AUTOINNOTECH PRIVATE LIMITED uses and protects any information that you give AUTOINNOTECH PRIVATE LIMITED when you visit their website and/or agree to purchase from them.\n\nAUTOINNOTECH PRIVATE LIMITED is committed to ensuring that your privacy is protected. Should we ask you to provide certain information by which you can be identified when using this website, and then you can be assured that it will only be used in accordance with this privacy statement.\n\nAUTOINNOTECH PRIVATE LIMITED may change this policy from time to time by updating this page. You should check this page from time to time to ensure that you adhere to these changes.\n\nWe may collect the following information:\n\n -Name\n -Contact information including email address\n -Demographic information such as postcode, preferences and interests, if required\n -Other information relevant to customer surveys and/or offers\n\nWhat we do with the information we gather\nWe require this information to understand your needs and provide you with a better service, and in particular for the following reasons:\n\n -Internal record keeping.\n -We may use the information to improve our products and services.\n -We may periodically send promotional emails about new products, special offers or other information which we think you may find interesting using the email address which you have provided.\n -From time to time, we may also use your information to contact you for market research purposes. We may contact you by email, phone, fax or mail. We may use the information to customise the website according to your interests.\n\nWe are committed to ensuring that your information is secure. In order to prevent unauthorised access or disclosure we have put in suitable measures.\n\nHow we use cookies\nA cookie is a small file which asks permission to be placed on your computer`s hard drive. Once you agree, the file is added and the cookie helps analyze web traffic or lets you know when you visit a particular site. Cookies allow web applications to respond to you as an individual. The web application can tailor its operations to your needs, likes and dislikes by gathering and remembering information about your preferences.\nWe use traffic log cookies to identify which pages are being used. This helps us analyze data about webpage traffic and improve our website in order to tailor it to customer needs. We only use this information for statistical analysis purposes and then the data is removed from the system.\nOverall, cookies help us provide you with a better website, by enabling us to monitor which pages you find useful and which you do not. A cookie in no way gives us access to your computer or any information about you, other than the data you choose to share with us.\nYou can choose to accept or decline cookies. Most web browsers automatically accept cookies, but you can usually modify your browser setting to decline cookies if you prefer. This may prevent you from taking full advantage of the website.\nControlling your personal information\nYou may choose to restrict the collection or use of your personal information in the following ways:\n\n -whenever you are asked to fill in a form on the website, look for the box that you can click to indicate that you do not want the information to be used by anybody for direct marketing purposes\n -if you have previously agreed to us using your personal information for direct marketing purposes, you may change your mind at any time by writing to or emailing us at info.autoinnovationtech@gmail.com\n\nWe will not sell, distribute or lease your personal information to third parties unless we have your permission or are required by law to do so. We may use your personal information to send you promotional information about third parties which we think you may find interesting if you tell us that you wish this to happen.\nIf you believe that any information we are holding on you is incorrect or incomplete, please write to Flat no. 201,7-2-1087/9/E, Sanath Nagar, hyderabad Hyderabad TELANGANA 500018 . or contact us at 8885718689 or info.autoinnovationtech@gmail.com as soon as possible. We will promptly correct any information found to be incorrect.',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  "Contact Us",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text(
                  'You may contact us using the information below:\n\nMerchant Legal entity name: AUTOINNOTECH PRIVATE LIMITED\nRegistered Address: Flat no. 201,7-2-1087/9/E, Sanath Nagar, hyderabad Hyderabad TELANGANA 500018\nOperational Address: Flat no. 201,7-2-1087/9/E, Sanath Nagar, hyderabad Hyderabad TELANGANA 500018\nTelephone No: 8885718689\nE-Mail ID: info.autoinnovationtech@gmail.com',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
              Divider(
                color: Colors.black12,
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 0, 4),
                child: Text("AUTOINNOTECH"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
