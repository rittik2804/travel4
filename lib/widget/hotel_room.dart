import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/url.dart';
import '../utils/dimensions_utils.dart';
import '../utils/rgb_utils.dart';

class HotelRooms extends StatelessWidget {
  final List<Room> rooms;

  HotelRooms({required this.rooms});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: rooms.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final room = rooms[index];

        return Container(
          margin: EdgeInsets.all(
            Dimensions.smSize / 2,
          ),
          decoration: BoxDecoration(
            color: RGB.blue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(
              Dimensions.radiusSize,
            ),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueGrey)),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: CachedNetworkImage(
                    imageUrl: URL.roomsPhotoURL + room.imageUrl.split(',')[0],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            title: Text(
              room.title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              room.bedType,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: ElevatedButton(
              onPressed: () {
                List<String> photoList = room.imageUrl.split(',');
                List<String> updatedPhotoList = [];

                for (String photo in photoList) {
                  updatedPhotoList.add('${URL.roomsPhotoURL}$photo');
                }

                String photos = updatedPhotoList.join(',');

                Get.toNamed('/room_details', parameters: {
                  'id': room.id,
                  'hotel_id': room.hotel_id,
                  'name': room.title,
                  'picture': photos,
                  'bed_type': room.bedType,
                  'room_size': room.room_size,
                  'persons_allowed': room.persons_allowed,
                  'breakfast': room.breakfast,
                });
              },
              child: Text('Show Details'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onPrimary),
                padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Room {
  final String id;
  final String hotel_id;
  final String title;
  final String imageUrl;
  final String bedType;
  final String room_size;
  final String persons_allowed;
  final String breakfast;

  Room({
    required this.id,
    required this.hotel_id,
    required this.title,
    required this.imageUrl,
    required this.bedType,
    required this.room_size,
    required this.persons_allowed,
    required this.breakfast,
  });
}
