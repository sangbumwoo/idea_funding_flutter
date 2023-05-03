import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

void main() {
  runApp(App());
}

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Getx example',
//       home: HomePage(),
//     );
//   }
// }

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () => const TemplatePage()), // InsidePage에 대한 루트 삭제.
      ],
    );
  }
}

class TemplatePage extends StatelessWidget {
  const TemplatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        // 네비게이터 추가.
        key: Get.nestedKey(1), // id 설정.
        initialRoute: '/outside', // OutsidePage를 initialRoute로 설정.
        onGenerateRoute: (settings) {
          if (settings.name == '/outside') {
            return GetPageRoute(
              page: () => const OutsidePage(),
            );
          } else if (settings.name == '/inside') {
            // `InsidePage`에 대한 루트 설정.
            return GetPageRoute(
              page: () => const InsidePage(),
            );
          }
          return null;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'First',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Second',
          ),
        ],
      ),
    );
  }
}

class InsidePage extends StatelessWidget {
  const InsidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inside Page'),
      ),
    );
  }
}

class OutsideController extends GetxController {
  var number = 0.obs;
  static OutsideController get to => Get.find(); // add this line
  increase() {
    return number++;
  }
}

class OutsidePage extends StatelessWidget {
  const OutsidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OutsideController c = Get.put(OutsideController());
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Outside Page'),
        title: Obx(() => Text("Outside Page - Clicks: ${c.number.value}")),
      ),
      body: Center(
          child: Column(
        children: [
          TextButton(
            onPressed: () => Get.toNamed('/inside', id: 1), // id 추가.
            child: const Text('Inside'),
          ),
          // const Obx(() => Text(c.number.value)),
          ElevatedButton(
              onPressed: () => c.increase(), child: const Text("Increase()"))
        ],
      )),
    );
  }
}
