import 'package:dio/dio.dart';

class MessageException implements Exception {
  final String message;

  MessageException(this.message);

  @override
  String toString() {
    return message;
  }
}

String extractErrorMessageFromDioExcept(DioExceptionType except) {
  switch (except) {
    case DioExceptionType.connectionTimeout:
      return "Ops! Parece que nossa conexão está demorando mais do que o esperado. Por favor, verifique sua internet e tente novamente.";
    case DioExceptionType.sendTimeout:
      return "Parece que houve um atraso ao enviar seus dados. Por favor, tente novamente mais tarde.";
    case DioExceptionType.receiveTimeout:
      return "Estamos tendo dificuldades para receber uma resposta. Talvez sua conexão esteja instável. Por favor, tente novamente.";
    case DioExceptionType.badCertificate:
      return "Detectamos um problema de certificado de segurança. Certifique-se de que sua conexão é segura e tente novamente.";
    case DioExceptionType.badResponse:
      return "Recebemos uma resposta inesperada do servidor. Por favor, tente novamente mais tarde.";
    case DioExceptionType.cancel:
      return "A operação foi cancelada. Se isso foi um erro, por favor, tente novamente.";
    case DioExceptionType.connectionError:
      return "Houve um problema de conexão com o servidor. Por favor, verifique sua internet e tente novamente.";
    default:
      return "Algo deu errado, mas não conseguimos identificar o problema. Por favor, tente novamente mais tarde ou entre em contato com o suporte.";
  }
}

String extractErroMessageFromResponseStatusCode(int statusCode) {
  if (statusCode >= 400 && statusCode < 500) {
    return 'Erro do cliente: Houve um problema com a solicitação.';
  } else if (statusCode >= 500 && statusCode < 600) {
    return 'Erro do servidor: O servidor encontrou um problema ao processar a requisição.';
  } else {
    return 'Código de status fora do intervalo esperado.';
  }
}

String extractErrorMessageFromResponse(Response response) {
  try {
    Map<String, dynamic> responseData = response.data;

    if (responseData.containsKey("detail")) {
      // FastAPI (list of dicts)
      if (responseData["detail"] is List) {
        List<dynamic> errors = responseData["detail"];
        return errors.map((error) => error["msg"]).join(",");
      }

      if (responseData["detail"] is String) {
        // HTTP exception or manual message
        return responseData["detail"];
      }
    }

    return extractErrorMessageFromDioExcept(DioExceptionType.unknown);
  } catch (e) {
    return response.statusCode == null
        ? extractErrorMessageFromDioExcept(DioExceptionType.unknown)
        : extractErroMessageFromResponseStatusCode(response.statusCode!);
  }
}

String handleDioException(DioException e) {
  return (e.response == null)
      ? extractErrorMessageFromDioExcept(e.type)
      : extractErrorMessageFromResponse(e.response!);
}

void throwInvalidProviderState(
    {required String provider, required String detail}) {
  throw Exception(
    "$detail: The $provider provider is not initialized. "
    "Ensure that the provider has been properly set up before attempting "
    "to create a $provider.",
  );
}
