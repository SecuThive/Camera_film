import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gal/gal.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart'; // [추가] 데이터 저장

// ---------------------------------------------------------
// 1. 데이터 모델
// ---------------------------------------------------------
class Film {
  final String name;
  final String subTitle;
  final String desc;
  final Color filterColor;
  final String imageUrl;
  final String category;

  Film({
    required this.name,
    required this.subTitle,
    required this.desc,
    required this.filterColor,
    required this.imageUrl,
    required this.category,
  });
}

// ---------------------------------------------------------
// 2. 데이터 생성
// ---------------------------------------------------------
const String fallbackImageUrl = 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=800&q=80';

final Film adFilmData = Film(
  name: 'AD', subTitle: 'AD', desc: 'AD', 
  filterColor: Colors.black, imageUrl: '', category: 'AD',
);

List<Film> generateFilmList() {
  List<Film> films = [];

  // [WARM] 15개
  List<String> warmImages = [
    'https://images.unsplash.com/photo-1470058869958-2a77ade41c02?w=800&q=80',
    'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&q=80',
    'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?w=800&q=80',
    'https://images.unsplash.com/photo-1433838552652-f9a46b332c40?w=800&q=80',
    'https://images.unsplash.com/photo-1495121553079-4c61bc118bce?w=800&q=80',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800&q=80',
    'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800&q=80',
    'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=800&q=80',
    'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=800&q=80',
    'https://images.unsplash.com/photo-1504198458649-3128b932f49e?w=800&q=80',
    'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=800&q=80',
    'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=800&q=80',
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=800&q=80',
    'https://images.unsplash.com/photo-1532274402911-5a369e4c4bb5?w=800&q=80',
    'https://images.unsplash.com/photo-1505245208761-ba872912fac0?w=800&q=80',
  ];
  for (int i = 0; i < warmImages.length; i++) {
    films.add(Film(name: 'KODAK GOLD ${100 + i * 10}', subTitle: 'WARM VINTAGE', desc: '따뜻한 오후의 햇살 감성 No.${i+1}', filterColor: const Color(0xFFE6C17B).withOpacity(0.1 + (i % 3) * 0.05), imageUrl: warmImages[i], category: 'WARM'));
  }
  // [COOL] 10개
  List<String> coolImages = [
    'https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?w=800&q=80',
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800&q=80',
    'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=800&q=80',
    'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800&q=80',
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80',
    'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800&q=80',
    'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800&q=80',
    'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800&q=80',
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&q=80',
    'https://images.unsplash.com/photo-1500485035595-cbe6f645feb1?w=800&q=80',
  ];
  for (int i = 0; i < coolImages.length; i++) {
    films.add(Film(name: 'CINESTILL ${i * 50}D', subTitle: 'NIGHT BLUE', desc: '차가운 도시의 새벽 공기 No.${i+1}', filterColor: const Color(0xFF225577).withOpacity(0.15 + (i % 3) * 0.05), imageUrl: coolImages[i], category: 'COOL'));
  }
  // [MONO] 8개
  List<String> monoImages = [
    'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=800&q=80',
    'https://images.unsplash.com/photo-1493863641943-9b68992a8d07?w=800&q=80',
    'https://images.unsplash.com/photo-1517423568366-8b83523034fd?w=800&q=80',
    'https://images.unsplash.com/photo-1552168324-d612d77725e3?w=800&q=80',
    'https://images.unsplash.com/photo-1485230905346-71acb9518d9c?w=800&q=80',
    'https://images.unsplash.com/photo-1572061486794-f2a58b688319?w=800&q=80',
    'https://images.unsplash.com/photo-1503376763036-066120622c74?w=800&q=80',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&q=80',
  ];
  for (int i = 0; i < monoImages.length; i++) {
    films.add(Film(name: 'ILFORD HP${i+1}', subTitle: 'CLASSIC B/W', desc: '거친 입자감의 흑백 영화 No.${i+1}', filterColor: const Color(0xFF111111).withOpacity(0.3 + (i % 2) * 0.1), imageUrl: monoImages[i], category: 'MONO'));
  }
  // [VIVID] 10개
  List<String> vividImages = [
    'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=800&q=80',
    'https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=800&q=80',
    'https://images.unsplash.com/photo-1555685812-4b943f3e99a9?w=800&q=80',
    'https://images.unsplash.com/photo-1456926631375-92c8ce872def?w=800&q=80',
    'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&q=80',
    'https://images.unsplash.com/photo-1499540633125-484965b60031?w=800&q=80',
    'https://images.unsplash.com/photo-1530785602389-07594daf831d?w=800&q=80',
    'https://images.unsplash.com/photo-1531219435436-9d190f15f70c?w=800&q=80',
    'https://images.unsplash.com/photo-1505118380757-91f5f5632de0?w=800&q=80',
    'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?w=800&q=80',
  ];
  for (int i = 0; i < vividImages.length; i++) {
    films.add(Film(name: 'AGFA VISTA $i', subTitle: 'COLOR POP', desc: '강렬한 색감의 스트릿 포토 No.${i+1}', filterColor: const Color(0xFFD93025).withOpacity(0.1 + (i % 3) * 0.04), imageUrl: vividImages[i], category: 'VIVID'));
  }
  // [SPECIAL] 7개
  List<String> specialImages = [
    'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?w=800&q=80',
    'https://images.unsplash.com/photo-1565626424177-85d774776e0d?w=800&q=80',
    'https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?w=800&q=80',
    'https://images.unsplash.com/photo-1563291074-2bf8677ac0e5?w=800&q=80',
    'https://images.unsplash.com/photo-1535295972055-1c762f4483e5?w=800&q=80',
    'https://images.unsplash.com/photo-1580191947416-62d35a55e71d?w=800&q=80',
    'https://images.unsplash.com/photo-1605218427306-0343d611a24c?w=800&q=80',
  ];
  for (int i = 0; i < specialImages.length; i++) {
    films.add(Film(name: 'NEON 2077-$i', subTitle: 'CYBERPUNK', desc: '미래지향적 보라빛 감성 No.${i+1}', filterColor: const Color(0xFF6A0DAD).withOpacity(0.15), imageUrl: specialImages[i], category: 'SPECIAL'));
  }
  return films;
}

final List<Film> allFilms = generateFilmList();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  CameraDescription? firstCamera;
  try {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) firstCamera = cameras.first;
  } catch (e) { print("Error: $e"); }

  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF101010),
      textTheme: GoogleFonts.dmSerifDisplayTextTheme(),
    ),
    home: firstCamera == null 
        ? const Scaffold(body: Center(child: Text("No Camera Found"))) 
        : HomeScreen(camera: firstCamera),
    debugShowCheckedModeBanner: false,
  ));
}

// ---------------------------------------------------------
// 3. 홈 화면 (광고 및 리스트)
// ---------------------------------------------------------
class HomeScreen extends StatefulWidget {
  final CameraDescription camera;
  const HomeScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  String _selectedCategory = 'ALL';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Film> get _displayList {
    List<Film> filtered;
    if (_selectedCategory == 'ALL') {
      filtered = allFilms;
    } else {
      filtered = allFilms.where((film) => film.category == _selectedCategory).toList();
    }
    List<Film> finalList = [];
    for (int i = 0; i < filtered.length; i++) {
      finalList.add(filtered[i]);
      if ((i + 1) % 3 == 0) finalList.add(adFilmData);
    }
    return finalList;
  }

  void _changeCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _currentPage = 0;
      if (_pageController.hasClients) _pageController.jumpToPage(0);
    });
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    final currentList = _displayList;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: const Color(0xFF1A1A1A),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white12))),
              child: Center(
                child: Text('FILM\nCATEGORY', textAlign: TextAlign.center, style: GoogleFonts.bebasNeue(fontSize: 40, color: Colors.white, letterSpacing: 2)),
              ),
            ),
            _buildDrawerItem('ALL FILMS', 'ALL'),
            _buildDrawerItem('WARM & VINTAGE', 'WARM'),
            _buildDrawerItem('COOL & FRESH', 'COOL'),
            _buildDrawerItem('MONO & NOIR', 'MONO'),
            _buildDrawerItem('VIVID COLOR', 'VIVID'),
            _buildDrawerItem('SPECIAL EFFECT', 'SPECIAL'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Row(
                      children: [
                        const Icon(Icons.menu, color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Text('FILM LOG', style: GoogleFonts.bebasNeue(fontSize: 32, letterSpacing: 2.0, color: Colors.white)),
                      ],
                    ),
                  ),
                  Text('Category: $_selectedCategory', style: GoogleFonts.ptMono(fontSize: 14, color: const Color(0xFFFFD700), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: currentList.isEmpty
              ? const Center(child: Text("No films found", style: TextStyle(color: Colors.white)))
              : PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                itemCount: currentList.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final film = currentList[index];
                  final isFocused = _currentPage == index;
                  final bool isAd = film.category == 'AD';

                  if (isAd) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: isFocused ? 20 : 50),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212), 
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: const NativeAdCard(),
                      ),
                    );
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: isFocused ? 20 : 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                             color: Colors.grey[900], 
                             child: Image.network(
                              film.imageUrl,
                              fit: BoxFit.cover,
                              color: Colors.black.withOpacity(0.2),
                              colorBlendMode: BlendMode.darken,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(child: CircularProgressIndicator(color: Colors.white24));
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(fallbackImageUrl, fit: BoxFit.cover, color: Colors.black.withOpacity(0.2), colorBlendMode: BlendMode.darken);
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.9)], stops: const [0.5, 1.0])),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(border: Border.all(color: Colors.white70), borderRadius: BorderRadius.circular(20)), child: Text(film.subTitle, style: GoogleFonts.ptMono(fontSize: 12, color: Colors.white))),
                                  const SizedBox(width: 8),
                                  Text('#${film.category}', style: GoogleFonts.ptMono(fontSize: 12, color: Colors.white54)),
                                ]),
                                const SizedBox(height: 12),
                                Text(film.name, style: GoogleFonts.dmSerifDisplay(fontSize: 36, color: Colors.white)),
                                const SizedBox(height: 8),
                                Text(film.desc, style: GoogleFonts.lato(fontSize: 14, color: Colors.white70)),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => FilmCameraScreen(camera: widget.camera, selectedFilm: film), transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)));
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    child: const Text('LOAD FILM', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, String categoryKey) {
    final bool isSelected = _selectedCategory == categoryKey;
    return ListTile(
      title: Text(title, style: GoogleFonts.bebasNeue(fontSize: 24, color: isSelected ? const Color(0xFFFFD700) : Colors.white70, letterSpacing: 1.5)),
      trailing: isSelected ? const Icon(Icons.check, color: Color(0xFFFFD700)) : null,
      onTap: () => _changeCategory(categoryKey),
    );
  }
}

// ---------------------------------------------------------
// 4. 광고 위젯
// ---------------------------------------------------------
class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key});

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _nativeAd = NativeAd(
      adUnitId: Platform.isAndroid 
          ? 'ca-app-pub-3940256099942544/2247696110' 
          : 'ca-app-pub-3940256099942544/3986624511',
      listener: NativeAdListener(
        onAdLoaded: (ad) { setState(() { _isAdLoaded = true; }); },
        onAdFailedToLoad: (ad, error) { ad.dispose(); print('Ad load failed: $error'); },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium, 
        mainBackgroundColor: const Color(0xFF121212), 
        callToActionTextStyle: NativeTemplateTextStyle(textColor: Colors.black, backgroundColor: Colors.white, style: NativeTemplateFontStyle.bold, size: 18.0),
        primaryTextStyle: NativeTemplateTextStyle(textColor: Colors.white, backgroundColor: Colors.transparent, style: NativeTemplateFontStyle.bold, size: 22.0),
        secondaryTextStyle: NativeTemplateTextStyle(textColor: Colors.grey[300], backgroundColor: Colors.transparent, style: NativeTemplateFontStyle.normal, size: 15.0),
        tertiaryTextStyle: NativeTemplateTextStyle(textColor: Colors.grey[600], backgroundColor: Colors.transparent, style: NativeTemplateFontStyle.normal, size: 13.0),
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded) return const Center(child: CircularProgressIndicator(color: Colors.white24));
    return AdWidget(ad: _nativeAd!);
  }
}

// ---------------------------------------------------------
// 5. 카메라 화면 (앨범 연동 수정됨)
// ---------------------------------------------------------
class FilmCameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final Film selectedFilm;
  const FilmCameraScreen({Key? key, required this.camera, required this.selectedFilm}) : super(key: key);

  @override
  State<FilmCameraScreen> createState() => _FilmCameraScreenState();
}

class _FilmCameraScreenState extends State<FilmCameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var camera = _controller.value;
            final size = MediaQuery.of(context).size;
            var scale = size.aspectRatio * camera.aspectRatio;
            if (scale < 1) scale = 1 / scale;

            return Stack(
              fit: StackFit.expand,
              children: [
                Transform.scale(scale: scale, child: Center(child: CameraPreview(_controller))),
                IgnorePointer(child: Container(color: widget.selectedFilm.filterColor)),
                IgnorePointer(child: CustomPaint(painter: GridPainter(), child: Container())),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => Navigator.pop(context)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
                              child: Text(widget.selectedFilm.name.toUpperCase(), style: GoogleFonts.ptMono(color: const Color(0xFFFFD700), fontWeight: FontWeight.bold)),
                            ),
                            const Icon(Icons.flash_off, color: Colors.white, size: 28),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)])),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // [수정된 앨범 버튼] 해당 필름의 갤러리 화면으로 이동
                        GestureDetector(
                          onTap: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => FilmGalleryScreen(film: widget.selectedFilm)));
                          },
                          child: Container(width: 50, height: 50, decoration: BoxDecoration(border: Border.all(color: Colors.white30), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.grid_view, color: Colors.white54)),
                        ),

                        GestureDetector(
                          onTap: () async {
                             try {
                               setState(() => _isCapturing = true);
                               await Future.delayed(const Duration(milliseconds: 100)); 
                               final image = await _controller.takePicture(); 
                               setState(() => _isCapturing = false);
                               if (!mounted) return;
                               await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewScreen(imagePath: image.path, film: widget.selectedFilm)));
                             } catch(e) {
                               print("촬영 에러: $e");
                               setState(() => _isCapturing = false);
                             }
                          },
                          child: Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: _isCapturing ? Colors.grey : Colors.white, boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)]),
                            child: Center(child: Container(width: 70, height: 70, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2), color: Colors.white))),
                          ),
                        ),
                        Container(width: 50, height: 50, decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle), child: const Icon(Icons.flip_camera_ios, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Positioned(right: 20, bottom: 120, child: Text("'98  12  24", style: GoogleFonts.vt323(color: const Color(0xFFFF8C00), fontSize: 24, shadows: [const Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1,1))]))),
                if (_isCapturing) Container(color: Colors.black)
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// 6. 프리뷰 화면 (저장 시 필름별 기록 저장)
// ---------------------------------------------------------
class PreviewScreen extends StatelessWidget {
  final String imagePath;
  final Film film;

  const PreviewScreen({Key? key, required this.imagePath, required this.film}) : super(key: key);

  // [핵심] 사진 정보를 로컬 저장소에 기록하는 함수
  Future<void> _saveToFilmLog(String path) async {
    final prefs = await SharedPreferences.getInstance();
    // 1. 해당 필름 이름으로 저장된 리스트를 가져옴 (없으면 빈 리스트)
    List<String> currentList = prefs.getStringList(film.name) ?? [];
    // 2. 새 사진 경로 추가
    currentList.add(path);
    // 3. 다시 저장
    await prefs.setStringList(film.name, currentList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("PREVIEW", style: GoogleFonts.bebasNeue(letterSpacing: 2)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () async {
              try {
                // 1. 실제 갤러리에 저장
                final hasAccess = await Gal.hasAccess();
                if (!hasAccess) await Gal.requestAccess();
                await Gal.putImage(imagePath);
                
                // 2. [NEW] 우리 앱의 "필름 갤러리"를 위해 기록 남기기
                await _saveToFilmLog(imagePath);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ 저장 완료!"), backgroundColor: Colors.green));
                  Navigator.pop(context); // 카메라 화면으로 복귀
                }
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("저장 실패: $e"), backgroundColor: Colors.red));
              }
            },
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(imagePath), fit: BoxFit.cover),
          IgnorePointer(child: Container(color: film.filterColor)),
          Positioned(right: 20, bottom: 50, child: Text("'98  12  24", style: GoogleFonts.vt323(color: const Color(0xFFFF8C00), fontSize: 24, shadows: [const Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1,1))]))),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// [NEW] 7. 필름별 갤러리 화면
// ---------------------------------------------------------
class FilmGalleryScreen extends StatefulWidget {
  final Film film;
  const FilmGalleryScreen({Key? key, required this.film}) : super(key: key);

  @override
  State<FilmGalleryScreen> createState() => _FilmGalleryScreenState();
}

class _FilmGalleryScreenState extends State<FilmGalleryScreen> {
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // 해당 필름 이름으로 저장된 사진 목록만 불러오기
      _imagePaths = prefs.getStringList(widget.film.name) ?? [];
      // 최신 사진이 위로 오게 뒤집기
      _imagePaths = _imagePaths.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.film.name, style: GoogleFonts.bebasNeue(letterSpacing: 1.5)),
      ),
      body: _imagePaths.isEmpty
          ? Center(child: Text("No photos yet.", style: TextStyle(color: Colors.white54)))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3열로 표시
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                final path = _imagePaths[index];
                return GestureDetector(
                  onTap: () {
                    // 클릭하면 크게 보기 (간단 구현)
                    Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImage(imagePath: path, film: widget.film)));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(File(path), fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey, child: Icon(Icons.broken_image, color: Colors.white))),
                        // 필름 효과 씌우기 (갤러리에서도 느낌 유지)
                        Container(color: widget.film.filterColor),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// 전체 화면 보기 (갤러리에서 클릭 시)
class FullScreenImage extends StatelessWidget {
  final String imagePath;
  final Film film;
  const FullScreenImage({Key? key, required this.imagePath, required this.film}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(imagePath), fit: BoxFit.contain),
          IgnorePointer(child: Container(color: film.filterColor)),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3)..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height / 3), Offset(size.width, size.height / 3), paint);
    canvas.drawLine(Offset(0, size.height * 2 / 3), Offset(size.width, size.height * 2 / 3), paint);
    canvas.drawLine(Offset(size.width / 3, 0), Offset(size.width / 3, size.height), paint);
    canvas.drawLine(Offset(size.width * 2 / 3, 0), Offset(size.width * 2 / 3, size.height), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}