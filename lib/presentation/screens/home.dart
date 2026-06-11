import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/contact/contact_bloc.dart';
import '../../data/source/local/model/contact.dart';
import 'add_contact.dart';
import 'login.dart';
import 'update_contact.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    context.read<ContactBloc>().add(LoadContacts());
  }

  Future<void> _showDeleteDialog(Contact contact) async {
    bool _deleting = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>
          StatefulBuilder(
            builder: (ctx, setDialogState) =>
                Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFE85D5D),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Delete contact',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            if (!_deleting)
                              GestureDetector(
                                onTap: () => Navigator.pop(ctx),
                                child: const Icon(Icons.close, color: Colors
                                    .grey),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Do you want delete ${contact.name}?',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Spacer(),
                            SizedBox(
                              width: 100,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: _deleting
                                    ? null
                                    : () async {
                                  setDialogState(() => _deleting = true);
                                  context.read<ContactBloc>().add(DeleteContact(
                                    docId: contact.id!,
                                  ));
                                  if (ctx.mounted) Navigator.pop(ctx);
                                  _loadContacts();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE85D5D),
                                  disabledBackgroundColor: const Color(
                                    0xFFE85D5D,
                                  ).withValues(alpha: 0.6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _deleting
                                    ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                    : const Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }

  Future<void> _showSignOutDialog() async {
    bool _loading = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>
          StatefulBuilder(
            builder: (ctx, setDialogState) =>
                Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.logout, color: Color(
                                  0xFFE85D5D)),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Sign Out',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            if (!_loading)
                              GestureDetector(
                                onTap: () => Navigator.pop(ctx),
                                child: SizedBox(
                                  width: 30,
                                  child: Image.asset("assets/img/close.png"),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Do you want unregister or logout?',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _loading ? null : (){
                                  context.read<AuthBloc>().add(Unregister());
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0xFFE85D5D)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFE85D5D),
                                    strokeWidth: 2.5,
                                  ),
                                )
                                    : const Text(
                                  'UnRegister',
                                  style: TextStyle(
                                    color: Color(0xFFE85D5D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _loading ? null : () {
                                  context.read<AuthBloc>().add(Logout());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE85D5D),
                                  disabledBackgroundColor: const Color(
                                    0xFFE85D5D,
                                  ).withValues(alpha: 0.6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                    : const Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }

  Color _avatarColor(String name) {
    final colors = [
      const Color(0xFFE85D5D),
      const Color(0xFF5D8FE8),
      const Color(0xFF5DCE8F),
      const Color(0xFFE8A45D),
      const Color(0xFF9B5DE8),
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            }
          },
        ),
        BlocListener<ContactBloc, ContactState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Xatolik')));
            }
          },
        ),
      ],
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        const Text(
                          'My Contacts',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _showSignOutDialog,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEEEE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Color(0xFFE85D5D),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: state.isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE85D5D),
                      ),
                    )
                        : state.list?.isEmpty ?? true
                        ? const Center(
                      child: Text(
                        'No contacts yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                        : RefreshIndicator(
                      color: const Color(0xFFE85D5D),
                      onRefresh: _loadContacts,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        itemCount: state.list?.length ?? 0,
                        itemBuilder: (context, index) {
                          final contact = state.list![index];
                          return _ContactTile(
                            contact: contact,
                            avatarColor: _avatarColor(contact.name),
                            onEdit: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      UpdateContactScreen(
                                        index: contact.id as String,
                                        contact: contact,
                                      ),
                                ),
                              );
                              _loadContacts();
                            },
                            onDelete: () => _showDeleteDialog(contact),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddContactScreen()),
                );
                _loadContacts();
              },
              backgroundColor: const Color(0xFFE85D5D),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Contact contact;
  final Color avatarColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ContactTile({
    required this.contact,
    required this.avatarColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final initials = contact.name.isNotEmpty
        ? contact.name[0].toUpperCase()
        : '?';
    return ListTile(
      onTap: onEdit,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: CircleAvatar(
        backgroundColor: avatarColor,
        radius: 22,
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        contact.name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        contact.phone,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz, color: Colors.grey),
        onPressed: onDelete,
      ),
    );
  }
}
