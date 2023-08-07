import 'package:http_interceptor/http_interceptor.dart';
import 'package:qr_bar_code_flutter/src/provider/session_provider.dart';


class Interceptor implements InterceptorContract {
  SessionProvider _prov = new SessionProvider();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) {
      // TODO: implement interceptRequest
      throw UnimplementedError();
    }
  
    @override
    Future<ResponseData> interceptResponse({required ResponseData data}) {
    // TODO: implement interceptResponse
    throw UnimplementedError();
  }
  /*
  @override
  Future<RequestData?> interceptRequest({RequestData? data}) async {
    try {
      if (await _prov.validaRefresh()) {
        //AGREGAR ACCESS TOKEN EN CADA PETICION
        String? accessToken = _prov.session.access;
        data!.headers["Authorization"] = "Bearer $accessToken";
        return data;
      } else {
        return data;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<ResponseData?> interceptResponse({ResponseData? data}) async {
    return data;
  }
  */
}
