import 'package:flutter/material.dart';

class BookTileHorizontal extends StatelessWidget {
  final String title;
  final String coverUrl;
  final String author;
  final String publisher;
  final String edition;
  final String pavillon;

  final VoidCallback ontap;

  const BookTileHorizontal({
    super.key,
    required this.title,
    required this.coverUrl,
    required this.author,
    required this.publisher,
    required this.edition,
    required this.pavillon,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: ontap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                width: 100, // Set a fixed width
                height: 150, // Set a fixed height
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 7),
                  Text(
                    "المؤلف : $author",
                    style: Theme.of(context).textTheme.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 7),
                  Text(
                    "د.النشر : $publisher",
                    style: Theme.of(context).textTheme.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 7),
                  Text("الطبعة: $edition",
                      style: Theme.of(context).textTheme.labelMedium),
                  SizedBox(height: 7),
                  Text("التصنيف: $pavillon",
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
