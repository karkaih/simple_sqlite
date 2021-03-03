class Students {
  int id;

  String Name;

  String Desc;

  String Dt;

  int Stat;

  Students.test();

  Students(this.Name, this.Desc, this.Dt, this.Stat);

  Students.withId(this.id, this.Name, this.Desc, this.Dt, this.Stat);

  Map<String, dynamic> tomap() {
    // return {
    //   "id" : id ,
    //   "Name" : Name ,
    //   "Desc" : Desc ,
    //   "Dt" : Dt ,
    //   "Stat" : Stat
    //
    // };
    Map<String, dynamic> maps = Map<String, dynamic>();
    maps["id"] = this.id;
    maps["Name"] = this.Name;
    maps["Desc"] = this.Desc;
    maps["Dt"] = this.Dt;
    maps["Stat"] = this.Stat;
    return maps;
  }

  Students.fromMap(Map<String, dynamic> maps) {
    this.id = maps["id"];
    this.Name = maps["Name"];
    this.Desc = maps["Desc"];
    this.Dt = maps["Dt"];
    this.Stat = maps["Stat"];
  }
}
