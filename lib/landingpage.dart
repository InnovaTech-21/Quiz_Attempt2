import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:quiz_website/Views/Login/login_view.dart';
import 'package:quiz_website/Views/sign%20up/signUpView.dart';
import 'package:quiz_website/ColourPallete.dart';
import 'package:quiz_website/Views/CreateQuiz/create_Quiz.dart';
import 'package:quiz_website/Views/AnswerQuiz/answerShortAns.dart';
import 'package:quiz_website/Views/AnswerQuiz/answerMCQ.dart';
import '../../Database Services/database.dart';



class SelectaPage extends StatefulWidget {
  const SelectaPage({Key? key}) : super(key: key);

  @override
  State<SelectaPage> createState() => _SelectaPageState();
}

class _SelectaPageState extends State<SelectaPage> {
  
void deletePendingQuizzes() async {
  final collectionReference = FirebaseFirestore.instance.collection('Quizzes');

  final querySnapshot = await collectionReference
      .where('Status', isEqualTo: 'Pending')
      .get();

  for (final documentSnapshot in querySnapshot.docs) {
    await documentSnapshot.reference.delete();
  }

  print('Pending quizzes deleted successfully');
}
  DatabaseService service = DatabaseService();
  final List<String> _QuizName = [];
  final List<int> _TimerTime = [];
  final List<bool> _QuizTimed = [];// load in the questions

  ///List of correct answers
  final List <String> _QuizType=[];
  final List<String> _QuizDesc = []; // load in the questions

  ///List of correct answers
  final List <String> _NumberofQuestions=[];
  final List<String> _QuizCategory = []; // load in the questions
  final List<String> _Quiz_ID = [];


  String _selectedFilter = 'All'; // Variable to store selected filter, set initial value to 'All'
  ///method to load completed quiz's from database
 Future<void> checkslength(){
    int x =_Quiz_ID.length;
     if (x>0){

     }
     else{

     }
  }
    Future<void> getQuizInformation(String x) async {


      List<Map<String, dynamic>> questionsAnswersList = await service.getQuizInformation(x);
      for (var i = 0; i < questionsAnswersList.length; i++) {

        _Quiz_ID.add(questionsAnswersList[i]["Quiz_ID"]);
        _QuizTimed.add(questionsAnswersList[i]["QuizTimed"]);
        _TimerTime.add(questionsAnswersList[i]["TimerTime"]);
        _QuizName.add(questionsAnswersList[i]["QuizName"]);
        _QuizDesc.add(questionsAnswersList[i]["Quiz_Description"]);
        _QuizCategory.add(questionsAnswersList[i]["Quiz_Category"]);
        _QuizType.add(questionsAnswersList[i]["Quiz_Type"]);
        _NumberofQuestions.add(questionsAnswersList[i]["Number_of_questions"]);

      }
     // _userAnswers=List.filled(questionsAnswersList.length, '');
    }

 void initState() {
    super.initState();
    getQuizInformation(_selectedFilter);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: ColourPallete.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: ColourPallete.backgroundColor,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/InnovaTechLogo.png',
                  width: 110,
                ),
                SizedBox(width: 10),
                Text(
                  "InnovaTech Quiz Platform",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
                Spacer(),
                Container(
                  //color: ColourPallete.backgroundColor,
                  width: 290,
                  height: 45,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: ColourPallete.gradient1, width: 2),
                    color: ColourPallete.backgroundColor,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColourPallete.backgroundColor,
                            hintText: 'Search for a quiz/category',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                NavItem(
                  key: ValueKey('home'),
                  title: 'Home',
                  tapEvent: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectaPage()),
                    );
                  },
                ),
                NavItem(
                  key: ValueKey('Create a Quiz'),
                  title: 'Create a Quiz',
                  tapEvent: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateQuizPage()),
                    );
                  },
                ),
                //NavItem(
                  //key: ValueKey('Answer a Quiz'),
                  //title: 'Answer a Quiz',
                  //tapEvent: () {},
                //),
                // NavItem(
                // key: ValueKey('contactus'),
                //title: 'Contact Us',
                //tapEvent: () {},
                //),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColourPallete.gradient1,
                        ColourPallete.gradient2,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ElevatedButton(
                    onPressed: ()  {
                      deletePendingQuizzes();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(80,35), backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 11),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColourPallete.gradient2,
                        ColourPallete.gradient1,

                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ElevatedButton(
                    onPressed: ()  {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>Signup() ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(95,35), backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),


        body: Material(

            color: ColourPallete.backgroundColor,
            ///builds widget when quiz details are retrieved
            child: FutureBuilder(
              future: getQuizInformation("All"),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return Column(
                    children: [
                      SizedBox(height: 50),
                    Text(
                    'Trending Quizzes',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                      SizedBox(height: 50),
                  Center(
                  child: SizedBox(
                  height: 350,
                  width: 580,
                  child: CarouselSlider.builder(
                  itemCount: _QuizName.length,
                  itemBuilder: (BuildContext context, int i, int realIndex) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: ColourPallete.borderColor.withOpacity(0.5),
                                width: 3,
                              ),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: ColourPallete.backgroundColor,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset(
                                      'assets/images/InnovaTechLogo.png',
                                      width: 300,
                                      height: 300,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        

                                          Center(
                                            child: Text(
                                              '${_QuizName[i].toUpperCase()}',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Text(
                                                'CATEGORY:',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Spacer(),
                                              Text(
                                                '${_QuizCategory[i]}',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                'TYPE:',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Spacer(),
                                              Text(
                                                '${_QuizType[i]}',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                '${_NumberofQuestions[i]} Questions',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_QuizType[i] == "Short-Answer") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ShortQuizAnswer(
                                                        quizID: _Quiz_ID[i],
                                                        bTimed: _QuizTimed[i],
                                                        iTime: _TimerTime[i],
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (_QuizType[i] == "Multiple Choice") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => mcqQuizAnswer(
                                                        quizID: _Quiz_ID[i],
                                                        bTimed: _QuizTimed[i],
                                                        iTime: _TimerTime[i],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.all(15),
                                                backgroundColor: ColourPallete.backgroundColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(21),
                                                  side: BorderSide(
                                                    color: ColourPallete.gradient2,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: Text('Start Quiz'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayCurve: Curves.easeInOut,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.8,
                    ),
                  ),
                  ),
                  ),
                    ],
                  );


                }
            )
        )
    );


  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    required Key key,
    required this.title,
    required this.tapEvent
  }) : super(key: key);

  final String title;
  final GestureTapCallback tapEvent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapEvent,
      hoverColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title,
          style: TextStyle(
              color: ColourPallete.whiteColor,
              fontWeight: FontWeight.w300,
              fontSize: 18

          ),
        ),
      ),
    );
  }
}