abstract class Failure {
  final String errorMessage;
  Failure(this.errorMessage);
}

class ServierFailuer extends Failure {
  ServierFailuer(super.errorMessage);
}
