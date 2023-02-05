import 'package:flutter/material.dart';

class Service {
  final int id;
  late String name;
  late bool check;
  late int price;

  Service(
      {required this.id,
      required this.name,
      required this.check,
      required this.price});
}

List<TimeOfDay> timeRange = [
  const TimeOfDay(hour: 0, minute: 0),
  const TimeOfDay(hour: 0, minute: 30),
  const TimeOfDay(hour: 1, minute: 0),
  const TimeOfDay(hour: 1, minute: 30),
  const TimeOfDay(hour: 2, minute: 0),
  const TimeOfDay(hour: 2, minute: 30),
  const TimeOfDay(hour: 3, minute: 0),
  const TimeOfDay(hour: 3, minute: 30),
  const TimeOfDay(hour: 4, minute: 0),
  const TimeOfDay(hour: 4, minute: 30),
  const TimeOfDay(hour: 5, minute: 0),
  const TimeOfDay(hour: 5, minute: 30),
  const TimeOfDay(hour: 6, minute: 0),
  const TimeOfDay(hour: 6, minute: 30),
  const TimeOfDay(hour: 7, minute: 0),
  const TimeOfDay(hour: 7, minute: 30),
  const TimeOfDay(hour: 8, minute: 0),
  const TimeOfDay(hour: 8, minute: 30),
  const TimeOfDay(hour: 9, minute: 0),
  const TimeOfDay(hour: 9, minute: 30),
  const TimeOfDay(hour: 10, minute: 0),
  const TimeOfDay(hour: 10, minute: 30),
  const TimeOfDay(hour: 11, minute: 0),
  const TimeOfDay(hour: 11, minute: 30),
  const TimeOfDay(hour: 12, minute: 0),
  const TimeOfDay(hour: 12, minute: 30),
  const TimeOfDay(hour: 13, minute: 0),
  const TimeOfDay(hour: 13, minute: 30),
  const TimeOfDay(hour: 14, minute: 0),
  const TimeOfDay(hour: 14, minute: 30),
  const TimeOfDay(hour: 15, minute: 0),
  const TimeOfDay(hour: 15, minute: 30),
  const TimeOfDay(hour: 16, minute: 0),
  const TimeOfDay(hour: 16, minute: 30),
  const TimeOfDay(hour: 17, minute: 0),
  const TimeOfDay(hour: 17, minute: 30),
  const TimeOfDay(hour: 18, minute: 0),
  const TimeOfDay(hour: 18, minute: 30),
  const TimeOfDay(hour: 19, minute: 0),
  const TimeOfDay(hour: 19, minute: 30),
  const TimeOfDay(hour: 20, minute: 0),
  const TimeOfDay(hour: 20, minute: 30),
  const TimeOfDay(hour: 21, minute: 0),
  const TimeOfDay(hour: 21, minute: 30),
  const TimeOfDay(hour: 22, minute: 0),
  const TimeOfDay(hour: 22, minute: 30),
  const TimeOfDay(hour: 23, minute: 0),
  const TimeOfDay(hour: 23, minute: 30),
];

List<String> days = [
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday'
];

List<int> capacityList = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20
];

List subServices = [
  {
    'id': 0,
    'value': false,
    'subs': {
      'Tyre Pressure': {false: 0},
      'Oil and Coolant Levels': {false: 0},
      'Air Filter': {false: 0},
      'Headlights, Turn Signals, Brake, and Parking Lights': {false: 0},
      'Oil & Filter': {false: 0},
      'Rotate Tires': {false: 0},
      'Transmission Fluid': {false: 0},
      'Spark Plug': {false: 0},
      'Serpentine Belt': {false: 0},
      'Battery Performance': {false: 0},
      'Tyres Health': {false: 0}
    }
  },
  {
    'id': 1,
    'value': false,
    'subs': {
      'Mobil 1™': {false: 0},
      'Mobil Super™ motor oil': {false: 0},
      'Mobil Delvac™': {false: 0},
      'Mobil Super™ High Mileage': {false: 0},
      'Total Quartz 5000': {false: 0},
      'Total Quartz 5000 SL': {false: 0},
      'Total Quartz 9000': {false: 0},
      'Total Quartz 9000 Future GF5': {false: 0},
      'Total Quartz 7000': {false: 0},
      'Petromin oil 10W30': {false: 0},
      'Petromin Engine Oil A1': {false: 0},
      'Shell Helix HX5': {false: 0},
      'Shell Helix HX3': {false: 0},
      'Shell Super Plus': {false: 0},
      'Shell Helix HX7': {false: 0},
      'Shell Helix HX8': {false: 0},
      'Shell Helix Ultra': {false: 0}
    }
  },
  {
    'id': 2,
    'value': false,
    'subs': {
      'BMC Filters': {false: 0},
      'Mazda Filters': {false: 0},
      'Hyundai Filters': {false: 0},
      'Lexus Filters': {false: 0},
      'Jeep Filters': {false: 0},
      'GMC Filters': {false: 0},
      'Toyota Air Filters': {false: 0},
      'Kia Filters': {false: 0},
      'Cadillac Filters': {false: 0},
      'Ford Filters': {false: 0}
    }
  },
  {
    'id': 3,
    'value': false,
    'subs': {
      'NGK': {false: 0},
      'Bosch': {false: 0},
      'Denso': {false: 0},
      'OEM': {false: 0},
      'E3': {false: 0},
      'Motorcraft': {false: 0},
      'Roush Performance': {false: 0},
      'Mopar': {false: 0},
      'Accel': {false: 0},
      'Craftsman': {false: 0}
    }
  },
  {
    'id': 4,
    'value': false,
    'subs': {
      'BMC Wipers': {false: 0},
      'Mazda Wipers': {false: 0},
      'Hyundai Wipers': {false: 0},
      'Lexus Wipers': {false: 0},
      'Jeep Wipers': {false: 0},
      'GMC Wipers': {false: 0},
      'Toyota Wipers': {false: 0},
      'Kia Wipers': {false: 0},
      'Cadillac Wipers': {false: 0},
      'Ford Wipers': {false: 0}
    }
  },
  {
    'id': 5,
    'value': false,
    'subs': {
      'AC Zurex': {false: 0},
      'CATL': {false: 0},
      'BYD': {false: 0},
      'Panasonic': {false: 0},
      'New Earth': {false: 0},
      'SK On': {false: 0},
      'Samsung SDI': {false: 0},
      'SVOLT': {false: 0}
    }
  },
  {
    'id': 6,
    'value': false,
    'subs': {
      'Bridgestone': {false: 0},
      'JAX Tyres & Auto': {false: 0},
      'Costco': {false: 0},
      'company2': {false: 0},
      'Tyrepower': {false: 0},
      'Yokohama': {false: 0},
      'Michelin': {false: 0}
    }
  },
  {
    'id': 7,
    'value': false,
    'subs': {
      'Denso': {false: 0},
      'Delphi': {false: 0},
      'Valeo': {false: 0},
      'company2': {false: 0},
      'Marelli': {false: 0},
      'Nissens': {false: 0},
      'Griffin': {false: 0},
      'TYC': {false: 0}
    }
  },
  {
    'id': 8,
    'value': false,
    'subs': {
      'ABS Ring': {false: 0},
      'Fitting Kits': {false: 0},
      'Disc Dust Shield': {false: 0},
      'Discs': {false: 0},
      'Drums': {false: 0},
      'Pad Wear Sonsors': {false: 0},
      'Pads': {false: 0},
      'Calipars': {false: 0},
      'company2': {false: 0},
      'Brake Fluid': {false: 0},
      'Pipe Unions': {false: 0},
      'Master Cylinders': {false: 0},
      'Servos': {false: 0},
      'Vaccum Pumps': {false: 0},
      'Wheel Cylinders': {false: 0}
    }
  },
  {
    'id': 9,
    'value': false,
    'subs': {
      'HVAC Module': {false: 0},
      'Belt Driven Compressor': {false: 0},
      'Control Panel': {false: 0},
      'Electric Water Heater': {false: 0},
      'Electric Driven Compressor': {false: 0},
      'Evaporators': {false: 0},
      'Heater cores': {false: 0},
      'PTC auxiliary heaters': {false: 0},
      'Blowers': {false: 0},
      'Condensers': {false: 0},
      'Fragrancing systems': {false: 0}
    }
  },
  {
    'id': 10,
    'value': false,
    'subs': {
      'Banjo Beam': {false: 0},
      'Automotive Axles': {false: 0}
    }
  },
  {
    'id': 11,
    'value': false,
    'subs': {
      'Cosmetic Flexible Bumper': {false: 0},
      'Plastic Tab': {false: 0},
      'company2': {false: 0},
      'Flexible Patch Non-Structural Bumper': {false: 0},
      'Two-Sided Bumper': {false: 0},
      'Bondo® Repair Adhesive': {false: 0}
    }
  },
  {
    'id': 12,
    'value': false,
    'subs': {
      'Exedy': {false: 0},
      'Valeo': {false: 0},
      'Southeast Clutch': {false: 0},
      'McLeod': {false: 0},
      'SPEC': {false: 0},
      'company2': {false: 0},
      'MITSUKO': {false: 0},
      'ACDelco': {false: 0},
      'Clutchmasters': {false: 0},
      'OS GIKEN': {false: 0}
    }
  },
  {
    'id': 13,
    'value': false,
    'subs': {
      'Rivet': {false: 0},
      'Scrivet': {false: 0},
      'Grommets': {false: 0},
      'Exterior / Interior Trim Clips': {false: 0},
      'Plastic Pop': {false: 0},
      'Metal Pop': {false: 0},
      'Garnish Moudling Retainer': {false: 0},
      'Bolts & Nuts': {false: 0},
      'Bonnet Catch': {false: 0},
      'Sump Plug Washers': {false: 0},
      'company2': {false: 0},
      'Hose Joiners': {false: 0}
    }
  },
  {
    'id': 14,
    'value': false,
    'subs': {
      'Panda\'s': {false: 0},
      'BMC\'s': {false: 0},
      'Mazda\'s': {false: 0},
      'Hyundai\'s': {false: 0},
      'Lexus': {false: 0},
      'Jeep\'s': {false: 0},
      'GMC\'s': {false: 0},
      'Toyota\'s': {false: 0},
      'Kia\'s': {false: 0},
      'Cadillac\'s': {false: 0},
      'Ford\'s': {false: 0}
    }
  },
  {
    'id': 15,
    'value': false,
    'subs': {
      'GKN plc': {false: 0},
      'Dana\'s': {false: 0},
      'Yamada': {false: 0},
      'NTN': {false: 0}
    }
  },
  {
    'id': 16,
    'value': false,
    'subs': {
      'Yazaki': {false: 0},
      'Sumitomo': {false: 0},
      'Aptiv': {false: 0},
      'Motherson': {false: 0},
      'Leoni': {false: 0},
      'Lear': {false: 0},
      'Fujikura': {false: 0},
      'Kromberg & Schubert': {false: 0},
      'Yura': {false: 0},
      'Coroplast': {false: 0},
      'Renhotec': {false: 0},
      'Kyungshin': {false: 0},
      'Furukawa': {false: 0},
      'Draxlmaier': {false: 0}
    }
  },
  {
    'id': 17,
    'value': false,
    'subs': {
      'Filter Replacement': {false: 0},
      'Fuel System Cleaning': {false: 0},
      'Engine Diagnostic': {false: 0},
      'Emission Testing & SMOG Check': {false: 0}
    }
  },
  {
    'id': 18,
    'value': false,
    'subs': {
      'Good Year\'s': {false: 0},
      'Cogged': {false: 0},
      'Laminated': {false: 0},
      'Multi Ribbed': {false: 0},
      'Bando\'s': {false: 0}
    }
  },
  {
    'id': 19,
    'value': false,
    'subs': {
      'Counter Shaft / Layshaft': {false: 0},
      'Main Shaft / Output Shaft': {false: 0},
      'Bearings': {false: 0},
      'Gears': {false: 0},
      'Gear Selector Fork': {false: 0}
    }
  },
  {
    'id': 20,
    'value': false,
    'subs': {
      ' HELLA GmbH': {false: 0},
      'KOITO': {false: 0},
      ' Magneti Marelli': {false: 0},
      'OSRAM GmbH': {false: 0},
      'Valeo': {false: 0}
    }
  },
  {
    'id': 21,
    'value': false,
    'subs': {
      'Air Horn': {false: 0},
      'Electric Horn': {false: 0}
    }
  },
  {
    'id': 22,
    'value': false,
    'subs': {
      'Physical Key': {false: 0},
      'Wireless Key': {false: 0},
      'Smart Key': {false: 0}
    }
  },
  {
    'id': 23,
    'value': false,
    'subs': {
      'BMC\'s': {false: 0},
      'Mazda\'s': {false: 0},
      'Hyundai\'s': {false: 0},
      'Lexus': {false: 0},
      'Jeep\'s': {false: 0},
      'GMC\'s': {false: 0},
      'Toyota\'s': {false: 0},
      'Kia\'s': {false: 0},
      'Cadillac\'s': {false: 0},
      'Ford\'s': {false: 0}
    }
  },
  {
    'id': 24,
    'value': false,
    'subs': {
      'BMC\'s': {false: 0},
      'Mazda\'s': {false: 0},
      'Hyundai\'s': {false: 0},
      'Lexus': {false: 0},
      'Jeep\'s': {false: 0},
      'GMC\'s': {false: 0},
      'Toyota\'s': {false: 0},
      'Kia\'s': {false: 0},
      'Cadillac\'s': {false: 0},
      'Ford\'s': {false: 0}
    }
  },
];

List<Service> mainServices = [
  Service(id: 0, name: "Check Up", check: false, price: 0),
  Service(id: 1, name: "Oil Change", check: false, price: 0),
  Service(id: 2, name: "Air Filter change", check: false, price: 0),
  Service(id: 3, name: "Spark change", check: false, price: 0),
  Service(id: 4, name: "Wipers change", check: false, price: 0),
  Service(id: 5, name: "Battery change", check: false, price: 0),
  Service(id: 6, name: "Tyre(s) change", check: false, price: 0),
  Service(id: 7, name: "Radiator service and repair", check: false, price: 0),
  Service(id: 8, name: "Brake service and repair", check: false, price: 0),
  Service(id: 9, name: "Air Conditional Service", check: false, price: 0),
  Service(id: 10, name: "Axle Assay / Axle Beam", check: false, price: 0),
  Service(id: 11, name: "Bumper repair", check: false, price: 0),
  Service(id: 12, name: "Clutch repair", check: false, price: 0),
  Service(id: 13, name: "Clips repair", check: false, price: 0),
  Service(id: 14, name: "Cushion cover / Seat cover", check: false, price: 0),
  Service(id: 15, name: "Drive Shaft changing", check: false, price: 0),
  Service(
      id: 16,
      name: "Electrical wiring checking & repair",
      check: false,
      price: 0),
  Service(
      id: 17, name: "Engine repair & Overhaul service", check: false, price: 0),
  Service(id: 18, name: "Fan Belt & Parts", check: false, price: 0),
  Service(id: 19, name: "Gearbox maintenance", check: false, price: 0),
  Service(id: 20, name: "Head Light repair", check: false, price: 0),
  Service(id: 21, name: "Horn repair", check: false, price: 0),
  Service(id: 22, name: "Key / Latches and Locks", check: false, price: 0),
  Service(id: 23, name: "Lamps / Fog Lamps", check: false, price: 0),
  Service(id: 24, name: "Mirrors repair", check: false, price: 0),
];
