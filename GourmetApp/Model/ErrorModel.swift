//
//  ErrorModel.swift
//  GourmetApp
//
//  Created by 藤井紗良 on 2024/02/08.
//

// MARK: - APIError

enum APIError: Error {
    case failCreateURL
    case sessionError
    case requestError(Error)
    case decodeError(Error)

    var errorTitle: String {
        switch self {
        case .failCreateURL:
            "不明なエラー"
        case .sessionError:
            "通信エラー"
        case .requestError(_):
            "リクエストエラー"
        case .decodeError(_):
            "デコードエラー"
        }
    }

    var errorMessage: String {
        switch self {
        case .failCreateURL:
            "エラーが発生しました"
        case .sessionError:
            "インターネットに接続していることを確認してください"
        case .requestError:
            "リクエストに失敗しました"
        case .decodeError:
            "データの取得に失敗しました"
        }
    }

}
