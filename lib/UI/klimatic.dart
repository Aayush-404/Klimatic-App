import 'dart:convert';
import 'package:klimatic_app/util/utils.dart' as util;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}
class _KlimaticState extends State<Klimatic> {
String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context){
        return new ChangeCity();
      }));
      if(results != null && results.containsKey('enter')){
        _cityEntered = results['enter'];
        //print(results['enter'].toString());
    }
  }

  void showStuff() async{
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Klimatic app'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
              icon: Icon(Icons.menu,size: 35.0,),
              onPressed:(){_goToNextScreen(context);}
          )
        ],
      ),
      body: new Stack(
        children: [
          Center(
            child: new Image.asset(
              'assets/weather.jpg',
              width: 360.0,
              //height: 1200,
              fit: BoxFit.fill,),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child:
              Text(
              '${_cityEntered ==null ? util.defaultCity : _cityEntered}',
              style: cityStyle(),),
           ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/light_rain.png',width: 200.0,),
          ),
          updateTempWidget(_cityEntered),
          // Container(
          //   alignment: Alignment.topLeft,
          //  child: updateTempWidget(_cityEntered),
          // )
        ],
      ),
    );
  }
  Future<Map> getWeather(String appId, String city) async {
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=metric';
    http.Response response;
    response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }
  Widget updateTempWidget(String city){
    return new FutureBuilder(
      future: getWeather(util.appId, city == null? util.defaultCity:city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
          //this is where we accept all JSON data , and build widgets
          if(snapshot.hasData){
            Map content = snapshot.data;
            return new Container(
              margin: const EdgeInsets.fromLTRB(30.0, 300.0, 0.0, 0.0),
              child: new Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new ListTile(
                    title: new Text(content ['main']['temp'].toString(),
                      style: TextStyle(
                        fontSize: 50.0,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity: ${content['main']['humidity'].toString()}\n"
                          "Min: ${content['main']['temp_min'].toString()} C\n"
                          "Max: ${content['main']['temp_max'].toString()} C\n",
                    style: extraData(),
                    ),
                  ),
                  ),
                ],
              ),
            );
          }else{
            return new Container();
          }
    });
  }
}

// ignore: must_be_immutable
class ChangeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: [
         ListView(
           children: [
             Image.asset(
               'assets/nibu2.jpg',
               width: 250.0,
               height: 550.0,
               fit: BoxFit.scaleDown,
             )
           ],
         ),
          new ListView(
            children: [
              new ListTile(
                title: new TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter city'
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                // ignore: deprecated_member_use
                title: FlatButton(
                  child: Text('Get Weather',style: TextStyle(color: Colors.white70),),
                  onPressed: (){
                    Navigator.pop(context,{
                      'enter': _cityFieldController.text
                    });
                  },
                  color: Colors.redAccent,
                )
              )
            ],
          )
        ],
      ),
    );
  }
}



TextStyle cityStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 25.0,
      fontWeight: FontWeight.w500);
}
TextStyle tempStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 35.0,
      fontWeight: FontWeight.bold);
}
TextStyle extraData() {
  return new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontSize: 17.0);

}

