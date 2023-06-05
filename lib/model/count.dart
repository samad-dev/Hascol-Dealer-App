class Counts {
  double? stop;
  double? idle;
  double? inactive;
  double? running;
  double? total;
  double? nodata;

  Counts(
      {this.stop,
        this.idle,
        this.inactive,
        this.running,
        this.total,
        this.nodata,
        });

  Counts.fromJson(Map<String, dynamic> json) {
    stop = double.parse(json['stop']);
    idle = double.parse(json['idle']);
    inactive = double.parse(json['inactive']);
    running = double.parse(json['running']);
    total = double.parse(json['total']);
    nodata = double.parse(json['nodata']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stop'] = this.stop;
    data['idle'] = this.idle;
    data['inactive'] = this.inactive;
    data['running'] = this.running;
    data['total'] = this.total;
    data['nodata'] = this.nodata;
    return data;
  }
}