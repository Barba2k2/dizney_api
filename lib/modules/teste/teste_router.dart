import 'package:dizney_api/modules/teste/teste_controller.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../application/routers/i_router.dart';

class TesteRouter implements IRouter {
  @override
  void configure(Router router) {
    router.mount('/hello/', TesteController().router);
  }
}
