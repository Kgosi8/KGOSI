import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isObscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WitsOverflow',
        theme: ThemeData (
          primarySwatch: Colors.blue,
        ),
        home: EditProfileUI ());

    // TODO: implement build

  }
}



class EditProfileUI extends StatefulWidget {
  @override
  EditProfileUIState createState() => EditProfileUIState ();

}

class EditProfileUIState extends State <EditProfileUI> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _createUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'location': locationController.text,
      });

      print("User created with UID: ${userCredential.user!.uid}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE PAGE'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
              onPressed: (){}
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width:4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1)
                            )
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2015/11/26/00/14/woman-1063100_1280.jpg'
                              )
                          )
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right:0,
                        child: Container(
                          height: 40,
                          width:40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,


                              border: Border.all(
                            width: 4,
                            color: Colors.white
                          ),
                          color: Colors.blue
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      )
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Full Name", "Smriti", false),
              buildTextField("Email", "smritilall99@gmail.com", false),
              buildTextField("Password", "********", true),
              buildTextField("Location", "South Africa", false),
              SizedBox(height: 30),
              Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {},
                      child: Text("CANCEL", style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.black
                      )),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _createUser();
                      },
                      child: Text("SAVE", style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.white
                      )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  )
                ],
              )

            ],
          ),

        ),
      ),

    );
    // TODO: implement build
    throw UnimplementedError();
  }

  Widget buildTextField(String labelText, String placeholder, bool isPasswordTextField){
    return Padding (
      padding: EdgeInsets.only(bottom: 30),
          child: TextField(
        obscureText: isPasswordTextField ? true  :false,
            decoration: InputDecoration(
              suffixIcon: isPasswordTextField ?
                  IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.grey) ,
                    onPressed: () {
                      setState(() {
                        //isObscurePassword =! isObscurePassword;
                      });
                    }
                     ): null,
                contentPadding: EdgeInsets.only(bottom: 5),
                labelText: labelText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey
              )
            ),
          ),
    );
  }
}

    // TODO: implement createState
