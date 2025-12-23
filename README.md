# 📸 Film Log (필름 로그)

**"당신의 순간을 아날로그 감성으로 기록하세요."**

Flutter로 개발된 감성 필름 카메라 앱입니다. 50가지의 고유한 필름 필터와 독자적인 갤러리 시스템을 통해 아날로그 감성을 디지털 환경에서 완벽하게 구현했습니다.

## 📱 스크린샷 (Screenshots)
| 홈 화면 | 촬영 화면 | 필름 갤러리 |
|:---:|:---:|:---:|
| <img src="" width="200" /> | <img src="" width="200" /> | <img src="" width="200" /> |

## ✨ 주요 기능 (Key Features)

* **50종의 고유 필름:** WARM, COOL, MONO, VIVID, SPECIAL 등 5가지 카테고리의 중복 없는 필름 제공.
* **리얼타임 필터 프리뷰:** 촬영 전 필름 색감을 미리 확인 가능.
* **커스텀 갤러리 시스템:** `SharedPreferences`를 활용하여 각 필름별로 촬영한 사진만 모아보는 독립적인 앨범 기능 구현.
* **네이티브 광고 통합:** Google AdMob Native Advanced 템플릿을 커스텀하여 앱 디자인(Dark Mode)에 자연스럽게 녹아드는 광고 UI 구현.
* **날짜 스탬프:** 90년대 필름 카메라 감성의 날짜('98 12 24) 워터마크 자동 적용.

## 🛠 사용 기술 (Tech Stack)

* **Framework:** Flutter (Dart)
* **State Management:** `setState` (Native)
* **Camera:** `camera` package
* **Storage:** `gal` (Gallery saving), `shared_preferences` (Local data)
* **Ads:** `google_mobile_ads`
* **UI:** `google_fonts` (Bebas Neue, PT Mono, VT323)

## 🚀 설치 및 실행 (Installation)

```bash
# 1. 저장소 복제
git clone [https://github.com/SecuThive/Camera_film.git](https://github.com/SecuThive/Camera_film.git)

# 2. 패키지 설치
flutter pub get

# 3. 앱 실행
flutter run
