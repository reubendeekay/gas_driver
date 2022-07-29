import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_driver/constants.dart';
import 'package:gas_driver/providers/auth_provider.dart';
import 'package:gas_driver/widgets/my_text_field.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? name, email, phone;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.35,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.black,
                      Colors.black,
                      Colors.black,
                      Colors.transparent,
                    ],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  height: size.height * 0.35,
                  width: size.width,
                  child: Image.network(user.profilePic!, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Full name',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MyTextField(
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      hintText: user.fullName!,
                      prefixIcon: Iconsax.user),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Email address',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MyTextField(
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    hintText: user.email!,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Phone number',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MyTextField(
                    onChanged: (val) {
                      setState(() {
                        phone = val;
                      });
                    },
                    hintText: user.phone!,
                    prefixIcon: Iconsax.call,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const MyTextField(
                    hintText: '* * * * * *',
                    prefixIcon: Iconsax.lock,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: RaisedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.userId)
                      .update({
                    'fullName': name ?? user.fullName,
                    'phone': phone ?? user.phone,
                    'email': email ?? user.email,
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Profile updated successfully!'),
                  ));
                },
                color: kIconColor,
                textColor: Colors.white,
                child: const Text('Save Changes'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
