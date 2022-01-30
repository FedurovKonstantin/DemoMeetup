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
      body: BlocBuilder<ClothesCubit, ClothesState>(
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
                horizontal: 100,
                vertical: 45,
              ),
              child: Wrap(
                spacing: 60,
                runSpacing: 45,
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
  }
}

class DressView extends StatefulWidget {
  final Dress dress;

  const DressView(this.dress);

  @override
  State<DressView> createState() => _DressViewState();
}

class _DressViewState extends State<DressView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/${widget.dress.photoUrl}'),
        ),
      ),
      width: 330,
      height: 330,
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
    name: "SEX GANG HOODIE BLACK",
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
    name: "DEATH GOT HER EYES : THE ART PROSPECTIVE BY SAHARNAYA & PHARAOH",
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
    name: "Balaclava Pegasus Reflective Black",
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
    name: "TEMPORARY TATTOO SET",
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
    name: "Welcome To My Nightmare Tee Black",
    photoUrl: "4.png",
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
