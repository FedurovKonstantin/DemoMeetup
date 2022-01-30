import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class Clothes extends StatelessWidget {
  const Clothes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClothesCubit(
        ClothesServer(),
      )..getClothes(),
      child: ClothesView(),
    );
  }
}

class ClothesView extends StatelessWidget {
  const ClothesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Navigator(
        onGenerateRoute: (_) {
          return MaterialPageRoute(
            builder: (_) => BlocBuilder<ClothesCubit, ClothesState>(
              builder: (context, state) {
                if (state is ClothesInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  );
                } else if (state is ClothesFailure) {
                  return Center(
                    child: Text(state.error),
                  );
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 55,
                    ),
                    child: Wrap(
                      spacing: 70,
                      runSpacing: 60,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: (state as ClothesSuccess)
                          .clothes
                          .map(
                            (e) => DressView(e),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DressView extends StatefulWidget {
  final Dress dress;

  const DressView(this.dress);

  @override
  State<DressView> createState() => _DressViewState();
}

class _DressViewState extends State<DressView> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DressDetails(widget.dress),
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHovered = false;
          });
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/${widget.dress.photoUrl}',
                  ),
                ),
              ),
              width: 360,
              height: 360,
            ),
            AnimatedOpacity(
              opacity: isHovered ? 1 : 0,
              duration: const Duration(
                milliseconds: 300,
              ),
              child: Container(
                width: 360,
                height: 360,
                padding: const EdgeInsets.all(10),
                color: isHovered ? Colors.black26 : Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.dress.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "${widget.dress.price.toString()} P.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Купить",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DressDetails extends StatelessWidget {
  final Dress dress;
  const DressDetails(this.dress);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                image: DecorationImage(
                  image: AssetImage('assets/${dress.photoUrl}'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      dress.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "${dress.price} P.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 35,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizeChoiser(),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      dress.description,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      dress.description,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SizeChoiser extends StatefulWidget {
  const SizeChoiser({Key? key}) : super(key: key);

  @override
  State<SizeChoiser> createState() => _SizeChoiserState();
}

class _SizeChoiserState extends State<SizeChoiser> {
  int currentSize = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            "Размер:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          ...Size.values
              .map(
                (e) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() {
                    currentSize = e.index;
                  }),
                  child: SizeItem(
                    e,
                    e.index == currentSize,
                    ValueKey(e),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

class SizeItem extends StatefulWidget {
  final Size size;
  bool isPressed;

  SizeItem(
    this.size,
    this.isPressed,
    Key key,
  ) : super(key: key);

  @override
  State<SizeItem> createState() => _SizeItemState();
}

class _SizeItemState extends State<SizeItem> {
  late bool isHovered;

  @override
  void initState() {
    isHovered = widget.isPressed;
  }

  @override
  void didUpdateWidget(covariant SizeItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    isHovered = widget.isPressed;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() {
        isHovered = true;
      }),
      onExit: (event) => setState(() {
        isHovered = widget.isPressed;
      }),
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: isHovered ? Colors.white : null,
        child: Center(
          child: Text(
            widget.size.toString().split('.').last.toUpperCase(),
            style: TextStyle(
              color: isHovered ? Colors.black.withOpacity(0.9) : Colors.white,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}

class ClothesCubit extends Cubit<ClothesState> {
  ClothesServer clothesServer;

  ClothesCubit(this.clothesServer) : super(ClothesInProgress());

  Future<void> getClothes() async {
    // await Future.delayed(Duration(seconds: 1));
    emit(ClothesSuccess(clothes));
    // emit(ClothesInProgress());
    // try {
    //   final clothes = await clothesServer.getClothes();
    //   emit(ClothesSuccess(clothes));
    // } on Exception catch (e) {
    //   emit(ClothesFailure(e.toString()));
    // }
  }
}

abstract class ClothesState {}

class ClothesInProgress extends ClothesState {}

class ClothesFailure extends ClothesState {
  final String error;

  ClothesFailure(this.error);
}

final clothes = [
  Dress(
    size: Size.l,
    name: "Death Got Her Eyes : The Art Prospective by Saharnaya & PHARAOH",
    photoUrl: "1.jpg",
    price: 5300,
    description: '''
Материал: 50% хлопок, 50% полиэстер

Страна-производитель: Россия

Вы можете произвести оплату банковскими картами платежных систем: Visa, Mastercard
    ''',
  ),
  Dress(
    size: Size.l,
    name: "Sex Gang Hoodie Black",
    photoUrl: "3.png",
    price: 2300,
    description: '''
Материал: 50% хлопок, 50% полиэстер

Страна-производитель: Россия

Вы можете произвести оплату банковскими картами платежных систем: Visa, Mastercard
    ''',
  ),
  Dress(
    size: Size.l,
    name: "Balaclava Pegasus Reflective Black",
    photoUrl: "2.png",
    price: 5000,
    description: '''
Материал: 50% хлопок, 50% полиэстер

Страна-производитель: Россия

Вы можете произвести оплату банковскими картами платежных систем: Visa, Mastercard
    ''',
  ),
  Dress(
    size: Size.l,
    name: "Welcome To My Nightmare Tee Black",
    photoUrl: "4.png",
    price: 2000,
    description: '''
Материал: 50% хлопок, 50% полиэстер

Страна-производитель: Россия

Вы можете произвести оплату банковскими картами платежных систем: Visa, Mastercard
    ''',
  ),
  Dress(
    size: Size.l,
    name: "UNDERWATER IDOL HOODIE BLACK",
    photoUrl: "5.png",
    price: 5000,
    description: '''
Материал: 50% хлопок, 50% полиэстер

Страна-производитель: Россия

Вы можете произвести оплату банковскими картами платежных систем: Visa, Mastercard
    ''',
  ),
  Dress(
    size: Size.l,
    name: "Temporary Tattoo Set",
    photoUrl: "6.jpg",
    price: 300,
    description: '''
Материал: 50% хлопок, 50% полиэстер

Страна-производитель: Россия

Вы можете произвести оплату банковскими картами платежных систем: Visa, Mastercard
    ''',
  ),
  Dress(
    size: Size.l,
    name: "2LP MILLION DOLLAR DEPRESSION",
    photoUrl: "7.png",
    price: 2000,
    description: '''
Материал: 50% хлопок, 50% полиэстер

Страна-производитель: Россия

Вы можете произвести оплату банковскими картами платежных систем: Visa, Mastercard
    ''',
  ),
];

class ClothesSuccess extends ClothesState {
  final List<Dress> clothes;

  ClothesSuccess(this.clothes);
}

class ClothesServer {
  Future<List<Dress>> getClothes() async {
    final responce = await http.get(Uri.parse('https://pharaoh.rru/api/clothes'));
    final json = jsonDecode(responce.body);
    return json.map((e) => Dress.fromJson(e)).toList();
  }
}

class Dress {
  final Size size;
  final String name;
  final String photoUrl;
  final int price;
  final String description;

  Dress({
    required this.size,
    required this.name,
    required this.photoUrl,
    required this.price,
    required this.description,
  });

  Dress.fromJson(Map<String, dynamic> json)
      : size = json["size"],
        name = json["name"],
        photoUrl = json["photoUrl"],
        price = json["price"],
        description = json["description"];
}

enum Size { s, m, l, xl, xxl }
