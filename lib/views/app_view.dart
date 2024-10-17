import 'package:chatapp_project/models/groups_model.dart';
import 'package:chatapp_project/views/api_view_model.dart';
import 'package:chatapp_project/views/floating/floatingAction_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  bool _isSearching = false; // Axtarış rejimini idarə edən dəyişən
  final TextEditingController _searchController = TextEditingController();
  List<GroupsModel>? _filteredGroups; // Filtrlənmiş qruplar
  bool _isLoading = false; // Yüklenme durumunu idarə edən dəyişən

  @override
  void initState() {
    super.initState();
    // API-dən bütün qrupları yükləyir
    print("Fetching groups...");
    context.read<ApiViewModel>().fetchAllGroups();
  }

  Future<void> _refreshGroups() async {
    setState(() {
      _isLoading = true; // Yüklenməni aktiv edin
    });

    await context
        .read<ApiViewModel>()
        .fetchAllGroups(); // Yenidən qrupları yükləyin

    setState(() {
      _isLoading = false; // Yüklenməni deaktiv edin
    });
  }

  void _searchWidget() {
    setState(() {
      if (_isSearching) {
        _isSearching = false; // Axtarış rejimini dəyiş
        _searchController.clear(); // Axtarış bitdikdə mətni təmizlə
        _filteredGroups = null; // Filtrlənmiş qrupları sıfırla
      } else {
        _isSearching = true; // Axtarış rejimini aç
      }
    });
  }

  void _filterGroups(String query) {
    final viewModel = context.read<ApiViewModel>();
    if (query.isNotEmpty) {
      _filteredGroups = viewModel.groupsModel!
          .where((group) =>
              group.groupName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredGroups = null; // Axtarış boşdursa bütün qrupları göstər
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ApiViewModel>();

    return SafeArea(
      child: Scaffold(
        appBar: _commonAppBar(),
        body: _groupCard(viewModel),
        floatingActionButton: FloatingactionWidget(context: context),
      ),
    );
  }

  Widget _groupCard(ApiViewModel viewModel) {
    final groupsToShow = _filteredGroups ?? viewModel.groupsModel;

    if (groupsToShow == null || groupsToShow.isEmpty) {
      return const Center(child: Text("No groups found."));
    }

    return ListView.builder(
      itemCount: groupsToShow.length, // Kartların sayı
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.purple.shade300, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              groupsToShow[index].groupName, // Qrup adları
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              groupsToShow[index].groupDescription, // Qrup təsvirləri
            ),
          ),
        );
      },
    );
  }

  AppBar _commonAppBar() {
    return AppBar(
      title: _isSearching
          ? TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Qrup axtar...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) =>
                  _filterGroups(value), // Axtarış zamanı filtrləmə
              textInputAction: TextInputAction.search,
            )
          : GestureDetector(
              // "CHAT" sözünə basıldığında yeniləmə əməliyyatı
              onTap: () async {
                await _refreshGroups(); // Yeniləmə funksiyasını çağır
              },
              child: Row(
                children: [
                  const Text(
                    'CHAT',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_isLoading) // Yüklenmə indikatorunu göstər
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade500,
              Colors.purple.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(_isSearching
              ? Icons.clear
              : Icons.search), // Axtarış rejimindən asılı olaraq ikon
          onPressed: () {
            _searchWidget();
          },
        ),
      ],
    );
  }
}
