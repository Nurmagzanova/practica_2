import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Кофейня',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentCategory = "ROCKET BUBBLE MILK"; // Начальная категория
  final ScrollController _scrollController = ScrollController();
  ScrollController _horizontalScrollController = ScrollController();

  List<String> categories = ["ROCKET BUBBLE MILK", "ROCKET SPECIAL", "ROCKET CLASSIC TEA", "ROCKET FRUITS"];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _horizontalScrollController = ScrollController(); // Initialize _horizontalScrollController
  }


  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _horizontalScrollController.dispose(); // Dispose _horizontalScrollController
    super.dispose();
  }



  int _calculateCategoryIndex(double offset) {
    return (offset / 450).floor();
  }

  void _scrollListener() {
    setState(() {
      int index = _calculateCategoryIndex(_scrollController.offset);
      if (index != -1 && index < categories.length) {
        currentCategory = categories[index];
        double screenWidth = MediaQuery.of(context).size.width;
        double categoryWidth = categories.length * 200;

        double scrollTo = index * 120.0 - (screenWidth - 120.0) / 2.0;
        scrollTo = scrollTo.clamp(0, categoryWidth - screenWidth);

        if (index == categories.length - 1) {
          scrollTo = categoryWidth - screenWidth;
        }

        _horizontalScrollController.animateTo(
          scrollTo,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  String _determineCategoryInView() {
  double position = 0.0;
  String categoryInView;

  for (int i = 0; i < categories.length; i++) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    double itemPosition = renderBox.localToGlobal(Offset.zero).dy;
    
    if (itemPosition >= 0 && itemPosition < MediaQuery.of(context).size.height) {
      position = i.toDouble(); // Приводим индекс к типу double
      break;
    }
  }

  categoryInView = categories[position.toInt()]; // Приводим position к типу int

  return categoryInView;
}


void _selectCategory(String category) {
  setState(() {
    currentCategory = category;
  });

  int index = categories.indexOf(category);
  if (index != -1) {
    _scrollController.jumpTo(
      index * 610,
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Горизонтальное меню категорий
          const SizedBox(height: 20,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalScrollController, // Use _horizontalScrollController here
            child: Row(
              children: categories.map((category) => _buildCategoryButton(category)).toList(),
            ),
          ),

          // Основной список товаров
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection("ROCKET BUBBLE MILK", [
                    Row(
                      children: [
                    _buildItem("Матча кокос", "assets/1.jpg", "340 ₽"),
                    _buildItem("Банан карамель", "assets/2.jpg", "340 ₽"),
                      ],
                    ),
                     Row(
                      children: [
                    _buildItem("Таро милк", "assets/3.jpg", "340 ₽"),
                    _buildItem("Кофе карамель", "assets/4.jpg", "340 ₽"),
                      ],
                    ),
                    Row(
                      children: [
                    _buildItem("Молочная карамель", "assets/5.jpg", "340 ₽"),
                      ],
                    )
                  ]),
                  _buildCategorySection("ROCKET SPECIAL", [
                    Row(
                      children: [
                    _buildItem("Манго чиз", "assets/6.jpg", "320 ₽"),
                    _buildItem("Клубнично-персиковый фьюжн", "assets/7.jpg", "320 ₽"),
                      ],),
                    Row(
                      children: [
                    _buildItem("Матча фраппе", "assets/8.jpg", "320 ₽"),
                    _buildItem("Таро коко", "assets/9.jpg", "320 ₽"),
                      ],),
                  ]),
                  _buildCategorySection("ROCKET CLASSIC TEA", [
                    Row(
                      children: [
                        _buildItem("Да хун пао", "assets/10.png", "170 ₽"),
                        _buildItem("Те гуань инь", "assets/11.png", "170 ₽"),
                      ],
                    ),
                    
                    Row(
                      children: [
                        _buildItem("Вишневый пуэр", "assets/12.jpg", "170 ₽"),
                      ],
                    )
                  ]),
                  _buildCategorySection("ROCKET FRUITS", [
                    Row (children: [
                    _buildItem("Ананас киви", "assets/13.jpg", "310 ₽"),
                    _buildItem("Апельсин-мандарин", "assets/14.jpg", "310 ₽"),
                    ],),
                    
                    Row (children: [
                    _buildItem("Киви-киви", "assets/15.jpg", "300 ₽"),
                    _buildItem("Фруктовый вайб", "assets/16.jpg", "300 ₽"),
                    ],)
                  ]),
                  const SizedBox(height: 20,)
                ],
              ),
        ]),
          ),
      )],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          _selectCategory(category);
        },
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: currentCategory == category ? const Color.fromRGBO(133, 195, 222, 1) : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: currentCategory == category ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Widget> items) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 4.0, // горизонтальный отступ между товарами
          runSpacing: 2.0, // вертикальный отступ между рядами
          children: items,
        ),
      ],
    ),
  );
}


  Widget _buildItem(String itemName, String imageUrl, String cost) {
  return GestureDetector(
    onTap: () {
      // Действие при нажатии на товар
    },
    child: Container(
      width: 160,
      height: 260,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 115,  // Ширина изображения
            height: 115, // Высота изображения
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.contain, // Подгонка изображения
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 160,
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(            
                  itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            )
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Действие при нажатии на кнопку
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 4),
                  backgroundColor: const Color.fromRGBO(133, 195, 222, 1),
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: Text(
                  cost,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}
