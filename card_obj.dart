class CardObj {
  String verified;
  String firstName;
  String userName;
  String birthDate;
  String height;
  String weight;
  String bio;
  List<String> interests;
  List<String> picLinks;
  List<(String, String)> prompts;
  String latitude;
  String longitude;

  CardObj({
    required this.verified,
    required this.firstName,
    required this.userName,
    required this.birthDate,
    required this.height,
    required this.weight,
    required this.bio,
    required this.interests,
    required this.picLinks,
    required this.prompts,
    required this.latitude,
    required this.longitude,
  });

  // factory CardObj.fromJson(Map<String, dynamic> json) {
  //   return CardObj(
  //     verified: json['verified'],
  //     firstName: json['first_name'],
  //     userName: json['user_name'],
  //     birthDate: json['birth_date'],
  //     height: json['height'],
  //     weight: json['weight'],
  //     bio: json['bio'],
  //     picLinks: json['pic_link'],
  //     interests: [],
  //     picLinks: picLinks,
  //     prompts: prompts,
  //   );
  // }
}
