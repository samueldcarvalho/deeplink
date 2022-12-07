class AppConsts {
  static String apiURLProd = '';
  static String apiURLHomolog = '';

  static String getURLAPI({isProducao = true}) {
    return isProducao ? apiURLProd : apiURLHomolog;
  }

  static String errorConnectionInternet =
      'Ops! Estamos com algum problema na conexão. \nVerifique sua internet e tente novamente mais tarde.';
}
