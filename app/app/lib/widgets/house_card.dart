import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  var thumbUrl;

  var category;

  var title;

  var location;

  var price;

  var city;

  ItemCard(this.thumbUrl, this.city, this.title, this.location, this.price,
      this.onTap,
      {Key? key});

  Function()? onTap;
  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade200)),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade200,
                    image: DecorationImage(
                        image: NetworkImage(widget.thumbUrl.length > 0
                            ? widget.thumbUrl[0]["picture_url"]
                            : widget.thumbUrl),
                        fit: BoxFit.cover)),
              ),
              const SizedBox(height: 10.0),
              Text(
                "${widget.city}",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "${widget.title}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  Text("${widget.location}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0,
                          color: Colors.grey.shade600),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.price}\$/Month",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_outline_outlined))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
