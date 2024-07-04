import 'package:flutter/material.dart';

class ProductButton extends StatefulWidget {
  final int price;

  ProductButton({Key? key, required this.price}) : super(key: key);

  @override
  _ProductButtonState createState() => _ProductButtonState();
}

class _ProductButtonState extends State<ProductButton> {
  int totalItemsInCart = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle between displaying buttons and displaying the price
          totalItemsInCart = totalItemsInCart == 0 ? 1 : 0;
        });
      },
      child: totalItemsInCart == 0
          ? Container(
              width: 138.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(205, 180, 219, 1) ,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Center(
                child: Text(
                  '${widget.price} ₽',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (totalItemsInCart > 0) {
                        totalItemsInCart--;
                      }
                    });
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(205, 180, 219, 1) 
                    ),
                    child: const Icon(Icons.remove, color:  Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ),
                const SizedBox(width: 4,),
                Container(
                  width: 60,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:  const Color.fromRGBO(205, 180, 219, 1) ,
                  ),
                  child: Center(
                    child: Text(
                      '$totalItemsInCart',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4,),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (totalItemsInCart < 10) {
                        totalItemsInCart++;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Превышено количество товара в корзине'),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color:  Color.fromRGBO(205, 180, 219, 1) ,
                    ),
                    child: const Icon(Icons.add, color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ),
              ],
            ),
    );
  }
}