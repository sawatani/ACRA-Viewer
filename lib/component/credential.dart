library credential_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/credential.dart';

@Component(
    selector: 'credential',
    templateUrl: 'packages/acra_viewer/component/credential.html')
class CredentialComponent {
  final Credential cred;
  
  bool get authorized => Credential.isConnected;

  CredentialComponent(this.cred) {
    if (!Credential.isConnected) {
      cred.signinGoogle(true);
    }
  }

  void signIn() {
    if (!authorized) {
      print("Start SignIn with Google");
      cred.signinGoogle(false);
    }
  }
}
