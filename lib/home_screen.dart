import 'package:contact_buddy/sql_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];

  //Get All Data from Database
  bool _isLoading = true;


//Refresh page after making a change//
  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  //Add Data
  Future<void> _addData() async {
    await SQLHelper.createData(
        _nameController.text, _contactNumberController.text);
    _refreshData();
  }

  //Update Data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(
        id, _nameController.text, _contactNumberController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.teal,
      content: Text(
        'Contact Updated !!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ));
    _refreshData();
  }

  //Delete Data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Contact Deleted !!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
        )));
    _refreshData();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _nameController.text = existingData['name'];
      _contactNumberController.text = existingData['contactNumber'];
    }


 //Contact adding sheet//
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      backgroundColor: Colors.white60.withOpacity(0.8),
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 50,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              style: const TextStyle(
                  color: Colors.blueGrey, fontWeight: FontWeight.w500),
              controller: _nameController,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.indigo)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.indigo)),
                  labelText: "Name",
                  labelStyle: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            TextField(
              style: const TextStyle(
                  color: Colors.blueGrey, fontWeight: FontWeight.w500),
              controller: _contactNumberController,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.indigo)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.indigo)),
                  labelText: "Contact Number",
                  labelStyle: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                ),
                onPressed: () async {
                  if (id == null) {
                    await _addData();
                  }
                  if (id != null) {
                    await _updateData(id);
                  }

                  _nameController.text = "";
                  _contactNumberController.text = "";
                  // Hide Bottom Sheet
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    id == null ? "Add Contact" : "Update",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


//Home screen//
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/pexels-eva-bronzini-6485473.jpg'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text(
            "Contacts",
            style: TextStyle(fontSize: 23, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: CustomSearchDelegate(this));
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: _allData.length,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.all(15),
                  color: Colors.white60.withOpacity(0.7),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['name'],
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    subtitle: Text(
                      _allData[index]['contactNumber'],
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showBottomSheet(_allData[index]['id']);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.teal,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteData(_allData[index]['id']);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showBottomSheet(null),
          child: const Icon(Icons.contacts),
        ),
      ),
    );
  }
}

//Search bar class//
class CustomSearchDelegate extends SearchDelegate {
  List<String> searchContacts = [];
  _HomeScreenState _homeScreenState = _HomeScreenState();

  CustomSearchDelegate(_HomeScreenState _homeScreenState) {
    this._homeScreenState = _homeScreenState;
    for (var i = 0; i < _homeScreenState._allData.length; i++) {
      searchContacts.add(_homeScreenState._allData[i]['name']);
    }
  }


//Clear all text in search bar//
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
          color: Colors.indigo,
        ),
      )
    ];
  }


//Back to home button in search bar//
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.indigo,
        ));
  }


//Get contact by searching//
  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, dynamic>> matchContacts = [];

    for (var contact in _homeScreenState._allData) {
      if (contact['name'].toLowerCase().contains(query.toLowerCase())) {
        matchContacts.add(contact);
      }
    }

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/pexels-eva-bronzini-6485473.jpg'),
              fit: BoxFit.cover)),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20),
        itemCount: matchContacts.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(15),
          color: Colors.white60.withOpacity(0.7),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                matchContacts[index]['name'],
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.indigo,
                    fontWeight: FontWeight.w600),
              ),
            ),
            subtitle: Text(
              matchContacts[index]['contactNumber'],
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _homeScreenState?.showBottomSheet(matchContacts[index]['id']);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.teal,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _homeScreenState?._deleteData(matchContacts[index]['id']);
                    close(context, matchContacts);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



//Suggestion contact list//
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var contacts in searchContacts) {
      if (contacts.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(contacts);
      }
    }
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/pexels-eva-bronzini-6485473.jpg'),
              fit: BoxFit.cover)),
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          final result = matchQuery[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
            ),
            child: ListTile(
              title: Text(
                result,
                style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              onTap: () {
                query = result;
                showResults(context);
              },
            ),
          );
        },
      ),
    );
  }
}
