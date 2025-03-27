import 'package:flutter/material.dart';
import 'AbsFileSystem.dart';
import 'flash_card.dart';

class AddFlashcardPage extends StatefulWidget {
  @override
  _AddFlashcardPageState createState() => _AddFlashcardPageState();
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  void _addFlashcard() {
    if (_questionController.text.isNotEmpty && _answerController.text.isNotEmpty) {
      setState(() {
        int pos = Flashcard.curIndexNum + 1; // add behind current
        var flashcard = Flashcard(
          question: _questionController.text,
          answer: _answerController.text,
        );
        if (pos == qaList.length - 1) {
          qaList.add(flashcard);
          Flashcard.curIndexNum = qaList.length - 1;
        } else {
          qaList.insert(pos, flashcard);
          Flashcard.curIndexNum++;
        }

        _questionController.clear();
        _answerController.clear();

        AbsFileSystem fs = AbsFileSystem.forThisPlatform();
        fs.save("aos-thai", qaList, (String doNothing) { } );

      });

      _questionController.clear();
      _answerController.clear();

      Navigator.pop(context);
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter the Question and Answer of your choice"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Enter Question',
              ),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: 'Enter Answer',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addFlashcard, 
              child: Text("Add Flashcard"),
            ),
          ],
        ),
      ),
    );
  }
}

//  THIS IS THE CODE WHEN TEXTFIELD FOR QnA ARE ON HOMEPAGE
// import 'package:flutter/material.dart';
// import 'flash_card.dart' ;

// class AddFlashcardPage extends StatefulWidget {
//   const AddFlashcardPage({super.key});

//   @override
//   State<AddFlashcardPage> createState() => _AddFlashcardPageState();
// }

// class _AddFlashcardPageState extends State<AddFlashcardPage> {
//   final _questionController = TextEditingController();
//   final _answerController = TextEditingController();

//   void _addFlashcard() {
//     setState(() {
//       qaList.add(Flashcard(
//         question: _questionController.text,
//         answer: _answerController.text,
//       ));
//       _questionController.clear();
//       _answerController.clear();

//       Navigator.pop(context);
//     });
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _questionController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Question',
//               ),
//             ),
//             TextField(
//               controller: _answerController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Answer',
//               ),
//             ),
//             SizedBox(height: 20),

//             ElevatedButton.icon(
//                         onPressed: () {
//                           _addFlashcard;
//                         },
//                         icon: Icon(Icons.telegram_rounded, size: 30,color: Color(0xFFE4E4E4),),
//                         label: Text(""),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green[700],
//                             shape: CircleBorder(
//                                 ),
//                             padding: EdgeInsets.only(
//                                 right: 20, left: 25, top: 15, bottom: 15))),

//             // ElevatedButton(
//             //   onPressed: _addFlashcard,
//             //   child: Text("Add"),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }