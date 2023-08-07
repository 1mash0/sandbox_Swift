final class Sandbox_DiffableDataSource_Model {
    enum Regions: CaseIterable {
        case hokkaido, tohoku, kanto, chubu, kinki, chugoku, shikoku, kyushuOkinawa

        var text: String {
            switch self {
                case .hokkaido:
                    return "北海道 地方"
                case .tohoku:
                    return "東北 地方"
                case .kanto:
                    return "関東 地方"
                case .chubu:
                    return "中部 地方"
                case .kinki:
                    return "近畿 地方"
                case .chugoku:
                    return "中国 地方"
                case .shikoku:
                    return "四国 地方"
                case .kyushuOkinawa:
                    return "九州沖縄 地方"
            }
        }

        var prefectures: [Prefectures] {
            switch self {
                case .hokkaido:
                    return [
                        .hokkaido
                    ]
                case .tohoku:
                    return [
                        .aomori, .iwate, .miyagi, .akita, .yamagata, .fukushima
                    ]
                case .kanto:
                    return [
                        .ibaraki, .tochigi, .gunma, .saitama, .chiba, .tokyo, .kanagawa
                    ]
                case .chubu:
                    return [
                        .niigata, .toyama, .ishikawa, .fukui, .yamanashi, .nagano, .gifu, .sizuoka, .aichi
                    ]
                case .kinki:
                    return [
                        .mie, .shiga, .kyoto, .osaka, .hyogo, .nara, .wakayama
                    ]
                case .chugoku:
                    return [
                        .tottori, .shimane, .okayama, .hiroshima, .yamaguchi
                    ]
                case .shikoku:
                    return [
                        .tokushima, .kagawa, .ehime, .kochi
                    ]
                case .kyushuOkinawa:
                    return [
                        .fukuoka, .saga, .nagasaki, .kumamoto, .oita, .miyazaki, .kagoshima, .okinawa
                    ]
            }
        }
    }

    enum Prefectures: Int, CaseIterable {
        case hokkaido = 1
        case aomori, iwate, miyagi, akita, yamagata, fukushima
        case ibaraki, tochigi, gunma, saitama, chiba, tokyo, kanagawa
        case niigata, toyama, ishikawa, fukui, yamanashi, nagano, gifu, sizuoka, aichi
        case mie, shiga, kyoto, osaka, hyogo, nara, wakayama
        case tottori, shimane, okayama, hiroshima, yamaguchi
        case tokushima, kagawa, ehime, kochi
        case fukuoka, saga, nagasaki, kumamoto, oita, miyazaki, kagoshima, okinawa

        var text: String {
            switch self {
                case .hokkaido:
                    return "北海道"
                case .aomori:
                    return "青森県"
                case .iwate:
                    return "岩手県"
                case .miyagi:
                    return "宮城県"
                case .akita:
                    return "秋田県"
                case .yamagata:
                    return "山形県"
                case .fukushima:
                    return "福島県"
                case .ibaraki:
                    return "茨城県"
                case .tochigi:
                    return "栃木県"
                case .gunma:
                    return "群馬県"
                case .saitama:
                    return "埼玉県"
                case .chiba:
                    return "千葉県"
                case .tokyo:
                    return "東京都"
                case .kanagawa:
                    return "神奈川県"
                case .niigata:
                    return "新潟県"
                case .toyama:
                    return "富山県"
                case .ishikawa:
                    return "石川県"
                case .fukui:
                    return "福井県"
                case .yamanashi:
                    return "山梨県"
                case .nagano:
                    return "長野県"
                case .gifu:
                    return "岐阜県"
                case .sizuoka:
                    return "静岡県"
                case .aichi:
                    return "愛知県"
                case .mie:
                    return "三重県"
                case .shiga:
                    return "滋賀県"
                case .kyoto:
                    return "京都府"
                case .osaka:
                    return "大阪府"
                case .hyogo:
                    return "兵庫県"
                case .nara:
                    return "奈良県"
                case .wakayama:
                    return "和歌山県"
                case .tottori:
                    return "鳥取県"
                case .shimane:
                    return "島根県"
                case .okayama:
                    return "岡山県"
                case .hiroshima:
                    return "広島県"
                case .yamaguchi:
                    return "山口県"
                case .tokushima:
                    return "徳島県"
                case .kagawa:
                    return "香川県"
                case .ehime:
                    return "愛媛県"
                case .kochi:
                    return "高知県"
                case .fukuoka:
                    return "福岡県"
                case .saga:
                    return "佐賀県"
                case .nagasaki:
                    return "長崎県"
                case .kumamoto:
                    return "熊本県"
                case .oita:
                    return "大分県"
                case .miyazaki:
                    return "宮崎県"
                case .kagoshima:
                    return "鹿児島県"
                case .okinawa:
                    return "沖縄県"
            }
        }
    }

    struct RegionData: Hashable {
        let region: Regions
        var isSelected: Bool
    }

    struct PrefectureData: Hashable {
        let prefecture: Prefectures
        var isSelected: Bool
    }

    struct MunicipalityData: Hashable {
        let id: String
        let municipality: String
        var isSelected: Bool
    }
}
