import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Hotel {
  final String img;
  final String hotelName;
  final String address;
  final String googleMapsLink;
  final String place;

  Hotel({
    required this.img,
    required this.hotelName,
    required this.address,
    required this.googleMapsLink,
    required this.place,
  });
}

class HotelListScreen extends StatefulWidget {
  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  late List<Hotel> dummyHotels;
  late List<Hotel> filteredHotels;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dummyHotels = [
      Hotel(
        img:
            'https://images.jdmagicbox.com/comp/udupi/w2/0820px820.x820.231025152153.m1w2/catalogue/samudyatha-inn-and-suites-kundapura-udupi-lodging-services-9rc5b38969.jpg?clr=',
        hotelName: 'JK Hotel',
        address: 'Shastri Circle, Kundapura',
        googleMapsLink: 'https://maps.app.goo.gl/BanhnZQrxLBeTqBr7',
        place: 'Udupi',
      ),
      Hotel(
        img:
            'https://lh3.googleusercontent.com/p/AF1QipMDqaNdwuJwE1ZXtQEymONAv7tAiGdyGhn2TllV=w287-h192-n-k-rw-no-v1',
        hotelName: 'Hotel White Rock',
        address: 'Gururaja Layout,Bangalore',
        googleMapsLink: 'https://maps.app.goo.gl/HFYqu7mP1kzu8LsFA',
        place: 'Bangalore',
      ),
      Hotel(
        img:
            'https://lh5.googleusercontent.com/p/AF1QipPhospNr_lzno5sjZjk9eWhsm53CZkFcqvPFpr5=w408-h272-k-no',
        hotelName: 'FabHotel Suvee Boutique Hotel',
        address: 'Main Ring Road,Banashankari',
        googleMapsLink: 'https://maps.app.goo.gl/TRSCbVf2epEwaW3y7',
        place: 'Bangalore',
      ),
      Hotel(
        img:
            'https://lh5.googleusercontent.com/p/AF1QipOIJPa97g6VzltmFcgypJsWllzx9EHW90_Od-x1=w408-h306-k-no',
        hotelName: 'Hotel Pandurang International',
        address: 'Gandhi Nagar,Kumta',
        googleMapsLink: 'https://maps.app.goo.gl/Ckj842PDJeT2PKzB8',
        place: 'Karwar District',
      ),
      Hotel(
        img:
            'https://lh5.googleusercontent.com/p/AF1QipN3ZAmUtv_b21Iop0ITSxXosp5CPTUt5pl-Orbp=w408-h272-k-no',
        hotelName: 'Novotel Ahmedabad',
        address: 'Iscon Cross Roads,Sarkhej',
        googleMapsLink: 'https://maps.app.goo.gl/dR4mHcJnifyJVXCo9',
        place: 'Ahmedabad',
      ),
      Hotel(
        img:
            'https://lh3.googleusercontent.com/gps-proxy/AMy85WIMJQG70Nk7x0zJmskaBfx2ZSHIlsir4P7M8l9cupBJtinDfUh9nuyzjBZCgA0uOtbY2v9zdk-ONVpun8wzLTSsQEfcUpNvtiie711XFhQOT-yTF8sfWDxAJ5MDqsnDxTwWOJGHT2Ghyc39xa6gSiw6HWoNwejjpVh12E6JO5ruZNqpjDnPLNCi=w408-h409-k-no',
        hotelName: 'Trident Hotel Cochin',
        address: 'Bristow Road,Willingdon Island',
        googleMapsLink: 'https://maps.app.goo.gl/rQPVhdx6yiv3oKiT7',
        place: 'Kochi',
      ),
      Hotel(
        img:
            'https://lh3.googleusercontent.com/gps-proxy/AMy85WK23905b-9oRs8hsSEq2hKxcZgxd75mliMgDrf7lcmTxC8dYvf7isZURxSPCV7lhbLhe8UOevRsVVxZxhF1Qq7JjV9vZmaTQ5fSaD0x1PeErrTetJ1vegUG5VoBrCT5cEuDCxTCRbVBU4JQzzXHTHFzV-3fq4fwoqgWizx8XWctC-_fXWUA1J_Y=w548-h240-k-no',
        hotelName: 'Taj Lands End',
        address: 'B.J Road,Mumbai',
        googleMapsLink: 'https://maps.app.goo.gl/cBDy7oyzqFKXeQLS6',
        place: 'Maharashtra',
      ),
      Hotel(
        img:
            'https://lh5.googleusercontent.com/p/AF1QipMuFUjvGhh0W7ikEZtvfKspLg83bMkwCHPR_Zfk=w426-h240-k-no',
        hotelName: 'Hyatt Regency',
        address: 'Ring Rd,Bhikaji cama place ',
        googleMapsLink: 'https://maps.app.goo.gl/UnKidM2MJy1Fh5aE8',
        place: 'New Delhi',
      ),
      Hotel(
        img:
            'https://lh3.googleusercontent.com/gps-proxy/AMy85WIwaDuSwsxe3VrgQCx48JLyHnG6SCLvBJ40KECI-8BmeXfYpjMfy1Mqw-qyoFAi3as-Z24Vmr7OT4U2Q1qrvbghrjp_j50rX4oceDyDRgFXOXZQCWYmP9J401OQbSCfvN_yuRKQHdYvf7xV1dgB7cXg18JYB94tnCw6NSB82W4ff9KGtiJOpNYePg=w408-h273-k-no',
        hotelName: 'Eros Hotel ',
        address: 'Nehru Place',
        googleMapsLink: 'https://maps.app.goo.gl/vrNcWDwki5DEW6V58',
        place: 'New Delhi',
      ),
      Hotel(
        img:
            'https://lh5.googleusercontent.com/p/AF1QipMcyKNksUz5ZQt8b8FWhO5_iszzU4_MvU9E9WaM=w408-h272-k-no',
        hotelName: 'Golden Tulip',
        address: 'Station Rd, Lucknow',
        googleMapsLink: 'https://maps.app.goo.gl/KBuESXqDDA6RqVW27',
        place: 'Uttar Pradesh',
      ),
    ];

    filteredHotels = dummyHotels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(225, 232, 252, 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterHotels(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Search by hotel or place',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredHotels.length,
                itemBuilder: (context, index) {
                  Hotel hotel = filteredHotels[index];
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          hotel.img,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(hotel.hotelName),
                      subtitle: Text(hotel.address),
                      trailing: Icon(Icons.location_on),
                      onTap: () {
                        launchGoogleMaps(hotel.googleMapsLink);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void launchGoogleMaps(String link) async {
    Uri uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $link';
    }
  }

  void filterHotels(String query) {
    setState(() {
      filteredHotels = dummyHotels
          .where((hotel) =>
              hotel.hotelName.toLowerCase().contains(query.toLowerCase()) ||
              hotel.place.toLowerCase().contains(query.toLowerCase()) ||
              hotel.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}

class HotelSearch extends SearchDelegate<String> {
  final List<Hotel> hotels;

  HotelSearch(this.hotels);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results here
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? hotels
        : hotels
            .where((hotel) =>
                hotel.hotelName.toLowerCase().contains(query.toLowerCase()) ||
                hotel.place.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        Hotel hotel = suggestionList[index];
        return ListTile(
          title: Text(hotel.hotelName),
          subtitle: Text(hotel.place),
          onTap: () {
            close(context, hotel.hotelName);
          },
        );
      },
    );
  }
}
