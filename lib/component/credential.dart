library credential_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/credential.dart';

@Component(
    selector: 'credential',
    templateUrl: 'credential.html')
class CredentialComponent {
  final Credential cred;

  bool authorized = false;

  CredentialComponent(this.cred) {
    print("CredentialComponent is instantiated with ${cred}");
    cred.signinGoogle(true).then((bool connected) {
      authorized = connected;
    });
  }

  void signIn() {
    print("Start SignIn with Google");
    cred.signinGoogle(false).then((bool connected) {
      authorized = connected;
    });
  }
}
