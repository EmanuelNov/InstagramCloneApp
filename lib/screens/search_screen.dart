import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowingUser = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Search for users'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowingUser = true;
            });
          },
        ),
      ),
      body:isShowingUser? FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: searchController.text)
            .get(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(child:CircularProgressIndicator());
          }
          return ListView.builder(
            itemBuilder: (context, index){
              return InkWell(
                onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid:(snapshot.data! as dynamic).docs[index]['uid']))),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['photoUrl']),
                    radius: 24,
                  ),
                  title: Text((snapshot.data! as dynamic).docs[index]['username']),
                ),
              );
            },
            itemCount: (snapshot.data! as dynamic).docs.length,
          );
        },
      ):Text(' '),
    );
  }
}
