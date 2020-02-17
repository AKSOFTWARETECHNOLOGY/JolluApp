class HistoryModel{
  HistoryModel({
    this.id,
    this.userId,
    this.userName,
    this.paymentId,
    this.price,
    this.subscriptionFrom,
    this.subscriptionTo,
    this.packageId,
    this.planName,
    this.paymentMethod,
    this.createdDate,
    this.currency,
  });
  final int id;
  final int userId;
  final String userName;
  final String paymentId;
  final int price;
  final String subscriptionFrom;
  final String subscriptionTo;
  final int packageId;
  final List planName;
  final String paymentMethod;
  final String createdDate;
  final List currency;

}