class StripeHistoryModel{
  StripeHistoryModel({
    this.id,
    this.userId,
    this.name,
    this.stripeId,
    this.stripePlan,
    this.subscriptionFrom,
    this.subscriptionTo,
    this.subCreatedDate,
    this.subCurrency,
    this.subAmount,
//    this.planName,
  });
  final int id;
  final int userId;
  final String name;
  final String stripeId;
  final String stripePlan;
  final String subscriptionFrom;
  final String subscriptionTo;
  final String subCreatedDate;
  final String subCurrency;
  final int subAmount;
//  final String planName;

}