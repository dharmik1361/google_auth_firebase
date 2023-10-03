import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly'
]);

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, Key? Key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, Key? Key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleSignInAccount? currentuser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        currentuser = account;
      });
      if (currentuser != null) {
        print("user is already authenticated");
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> handleSignin() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print("sign in : $error");
    }
  }

  Future<void> handlesignout() => _googleSignIn.disconnect();

  Widget buildbody() {
    GoogleSignInAccount? user = currentuser;
    if (user != null) {
      return Column(
        children: [
          const SizedBox(
            height: 90,
          ),
          GoogleUserCircleAvatar(identity: user),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              user.displayName ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              user.email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Hello Welcome",
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: handlesignout,
            child: const Text("sign out"),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 90,),
          const Text("Welcome to google"),
          const SizedBox(height: 20,),
          Center(
            child: IconButton(
              onPressed: handleSignin,
              icon: const Icon(Icons.verified_user),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Container(
          child: buildbody(),
        ),
      ),
    );
  }
}
