import 'dart:convert';

class PasswordModel {
  String? mensagem;
  String? exception;
  String? mensagens;
  String? dados;

  PasswordModel({
    this.mensagem,
    this.exception,
    this.mensagens,
    this.dados,
  });

  PasswordModel copyWith({
    String? mensagem,
    String? exception,
    String? mensagens,
    String? dados,
  }) {
    return PasswordModel(
      mensagem: mensagem ?? this.mensagem,
      exception: exception ?? this.exception,
      mensagens: mensagens ?? this.mensagens,
      dados: dados ?? this.dados,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mensagem': mensagem,
      'exception': exception,
      'mensagens': mensagens,
      'dados': dados,
    };
  }

  factory PasswordModel.fromMap(Map<String, dynamic> map) {
    print('maps');
    print(map);

    return PasswordModel(
      mensagem: map['mensagem'] ?? '',
      exception: map['exception'] ?? '',
      mensagens: map['mensagens'] ?? '',
      dados: map['dados'] ?? 'teste',
    );
  }

  String toJson() => json.encode(toMap());

  factory PasswordModel.fromJson(String source) {
    print('decoded');
    print(json.decode(source));
    print('decoded');
    return PasswordModel.fromMap(json.decode(source));
  }

  @override
  String toString() {
    return 'PasswordModel(mensagem: $mensagem, exception: $exception, mensagens: $mensagens, dados: $dados)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PasswordModel &&
        other.mensagem == mensagem &&
        other.exception == exception &&
        other.mensagens == mensagens &&
        other.dados == dados;
  }

  @override
  int get hashCode {
    return mensagem.hashCode ^
        exception.hashCode ^
        mensagens.hashCode ^
        dados.hashCode;
  }
}
