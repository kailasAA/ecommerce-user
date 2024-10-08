// class WishListModel {
//   String? userId;
//   String? variantId;
//   bool? isFavourite;

//   // Constructor
//   WishListModel({this.userId, this.variantId, this.isFavourite});

//   // Convert to JSON for Firebase
//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'variantId': variantId,
//       'isFavourite': isFavourite,
//     };
//   }

//   // Create a WishListModel object from Firebase data
//   factory WishListModel.fromJson(Map<String, dynamic> json) {
//     return WishListModel(
//       userId: json['userId'],
//       variantId: json['variantId'],
//       isFavourite: json['isFavourite'],
//     );
//   }
// }
