import 'dart:collection';
import 'dart:io';

class Train {
  String StasiunKeberangkatan; // departure
  String StasiunPemberhentian; // destination
  String WaktuKeberangkatan; // departure time
  String JenisKereta; // train name
  double harga; // price

  Train(this.StasiunKeberangkatan, this.StasiunPemberhentian, this.WaktuKeberangkatan,  this.JenisKereta, this.harga);
}

class TrainSchedule {
  List<Train> schedule = [];

  void addTrain(String StasiunKeberangkatan, String StasiunPemberhentian, String WaktuKeberangkatan, String JenisKereta, double harga) {
    schedule.add(Train(StasiunKeberangkatan, StasiunPemberhentian, WaktuKeberangkatan, JenisKereta, harga));
    schedule.sort((a, b) => a.WaktuKeberangkatan.compareTo(b.WaktuKeberangkatan));
  }

  List<Train> getSchedule(
      String StasiunKeberangkatan, String StasiunPemberhentian) {
    return schedule
        .where((train) =>
            train.StasiunKeberangkatan == StasiunKeberangkatan &&
            train.StasiunPemberhentian == StasiunPemberhentian)
        .toList();
  }
}

class Ticket {
  Train train;
  List<Map<String, String>> passengers; // passengers adalah list yang berisi map yang merepresentasikan informasi penumpang tiket
  String date; // menyimpan tanggal pembelian
  double totalPrice; // menyimpan total harga tiket

  Ticket(this.train, this.passengers, this.date, this.totalPrice);
}

class TicketQueue {
  Queue<Ticket> queue = Queue<Ticket>();     

  void addTicket(Ticket ticket) {
    queue.addLast(ticket);
  }

  // memproses tiket yang ada di depan antrian
  Ticket? processTicket() {
    if (queue.isNotEmpty) {
      return queue.removeFirst();
    } else {
      return null;
    }
  }
}

// Riwayat pembelian Tiket
class TicketHistory {
  List<Ticket> history = [];

  void addHistory(Ticket ticket) {
    history.add(ticket);
  }

  // Mendapatkan tiket terakhir yang dibeli
  Ticket? getLastPurchase() {
    if (history.isNotEmpty) {
      return history.last;
    } else {
      return null;
    }
  }
}

class PassengerNode {
  String name;
  String idNumber;
  PassengerNode? next;

  PassengerNode(this.name, this.idNumber);
}
// LinkedList untuk menyimpan daftar penumpang
class PassengerLinkedList {
  // Menunjukkan ke simpul (node) pertama dalam Linked List
  // head = simpul pertama linked list
  PassengerNode? head;

  void addPassenger(String name, String idNumber) {
    var newNode = PassengerNode(name, idNumber);
    if (head == null) {
      head = newNode;
    } else {
      var current = head;
      while (current!.next != null) {
        current = current.next;
      }
      current.next = newNode;
    }
  }

  List<Map<String, String>> getPassengers() {
    var passengers = <Map<String, String>>[];
    var current = head;
    while (current != null) {
      passengers.add({'name': current.name, 'idNumber': current.idNumber});
      current = current.next;
    }
    return passengers;
  }
}

// Kelas untuk metode pembayaran
class Payment {
  bool processPayment(double amount) {
    print("Total pembayaran: Rp${amount.toStringAsFixed(2)}");
    print("Lanjutkan pembayaran? (y/n):");
    var choice = stdin.readLineSync();
    if (choice != null && choice.toLowerCase() == 'y') {
      print("Pembayaran berhasil!");
      return true;
    } else {
      print("Pembayaran dibatalkan.");
      return false;
    }
  }
}

// Node for Binary Search Tree
class TrainNode {
  Train train;
  TrainNode? left;
  TrainNode? right;

  TrainNode(this.train);
}

// Binary Search Tree for Train berdasarkan harga yang ingin dicari
class TrainBST {
  TrainNode? root;

  void addTrain(Train train) {
    root = _addTrainRec(root, train);
  }

  TrainNode _addTrainRec(TrainNode? node, Train train) {
    if (node == null) {
      return TrainNode(train);
    }

    if (train.harga < node.train.harga) {
      node.left = _addTrainRec(node.left, train);
    } else {
      node.right = _addTrainRec(node.right, train);
    }

    return node;
  }

  Train? searchTrainByPrice(double price) {
    return _searchTrainByPriceRec(root, price);
  }

  Train? _searchTrainByPriceRec(TrainNode? node, double price) {
    if (node == null) {
      return null;
    }

    if (price == node.train.harga) {
      return node.train;
    }

    if (price < node.train.harga) {
      return _searchTrainByPriceRec(node.left, price);
    } else {
      return _searchTrainByPriceRec(node.right, price);
    }
  }

  List<Train> inOrderTraversal() {
    List<Train> trains = [];
    _inOrderTraversalRec(root, trains);
    return trains;
  }

  void _inOrderTraversalRec(TrainNode? node, List<Train> trains) {
    if (node != null) {
      _inOrderTraversalRec(node.left, trains);
      trains.add(node.train);
      _inOrderTraversalRec(node.right, trains);
    }
  }
}

void main() {
  var trainSchedule = TrainSchedule();
  var ticketQueue = TicketQueue();
  var ticketHistory = TicketHistory();
  var payment = Payment();
  var bst = TrainBST();

  // Menambahkan beberapa jadwal kereta
  trainSchedule.addTrain("Banyuwangi", "Surabaya", "16:16", "Probowangi", 56000);
  trainSchedule.addTrain("Banyuwangi", "Jember", "16:00", "Probowangi", 29000);
  trainSchedule.addTrain("Jember", "Gubeng", "09:30", "Sri Tanjung", 88000);
  trainSchedule.addTrain("Banyuwangi", "Jember", "10:00", "Pandanwangi", 8000);
  trainSchedule.addTrain("Surabaya", "Yogyakarta", "17:00","Wijayakusuma", 210000);
  
  // Menambahkan kereta ke dalam BST berdasarkan harga tiket
  bst.addTrain(Train("Banyuwangi", "Surabaya", "16:16", "Probowangi", 56000));
  bst.addTrain(Train("Banyuwangi", "Jember", "16:00","Probowangi", 29000));
  bst.addTrain(Train("Jember", "Gubeng", "09:30", "Sri Tanjung", 88000));
  bst.addTrain(Train("Banyuwangi", "Jember", "10:00", "Pandanwangi", 8000));
  bst.addTrain(Train("Surabaya", "Yogyakarta", "17:00", "Wijayakusuma", 210000));


  while (true) {
    print("\nMenu Utama:");
    print("1. Lihat jadwal kereta");
    print("2. Pilih kereta dan beli tiket");
    print("3. Tampilkan tiket yang telah dibeli");
    print("4. Masukkan harga tiket yang ingin dicari");
    print("5. Keluar dari layanan");

    var choice = int.tryParse(stdin.readLineSync()!) ?? -1;

    if (choice == 1) {
      print("Masukkan stasiun keberangkatan:");
      var departure = stdin.readLineSync()!;
      print("Masukkan stasiun tujuan:");
      var destination = stdin.readLineSync()!;
      var schedule = trainSchedule.getSchedule(departure, destination);
      if (schedule.isNotEmpty) {
        print("Jadwal Kereta:");
        for (var train in schedule) {
          print("${train.JenisKereta} - ${train.WaktuKeberangkatan} - Rp${train.harga.toStringAsFixed(2)}");
        }
      } else {
        print("Tidak ada jadwal kereta yang tersedia.");
      }
    } else if (choice == 2) {
      print("Masukkan stasiun keberangkatan:");
      var departure = stdin.readLineSync()!;
      print("Masukkan stasiun tujuan:");
      var destination = stdin.readLineSync()!;
      var schedule = trainSchedule.getSchedule(departure, destination);
      if (schedule.isNotEmpty) {
        print("Jadwal Kereta:");
        for (var i = 0; i < schedule.length; i++) {
          print( "${i + 1}. ${schedule[i].JenisKereta} - ${schedule[i].WaktuKeberangkatan} - Rp${schedule[i].harga.toStringAsFixed(2)}");
        }
        print("Pilih kereta (nomor):");
        var trainChoice = int.tryParse(stdin.readLineSync()!) ?? -1;
        if (trainChoice > 0 && trainChoice <= schedule.length) {
          var selectedTrain = schedule[trainChoice - 1];

          var passengerList = PassengerLinkedList();
          print("Masukkan jumlah penumpang:");
          var numPassengers = int.tryParse(stdin.readLineSync()!) ?? 0;
          for (var i = 0; i < numPassengers; i++) {
            print("Masukkan nama penumpang:");
            var name = stdin.readLineSync()!;
            print("Masukkan nomor identitas:");
            var idNumber = stdin.readLineSync()!;
            passengerList.addPassenger(name, idNumber);
          }

          var passengers = passengerList.getPassengers();
          var totalCost = selectedTrain.harga * numPassengers;
          if (payment.processPayment(totalCost)) {
            var ticket = Ticket(selectedTrain, passengers,
                DateTime.now().toString(), totalCost);
            ticketQueue.addTicket(ticket);
            ticketHistory.addHistory(ticket);
            print("Tiket berhasil dibeli dan ditambahkan ke antrian.");
          }
        } else {
          print("Pilihan tidak valid.");
        }
      } else {
        print("Tidak ada jadwal kereta yang tersedia.");
      }
    } else if (choice == 3) {
      var lastPurchase = ticketHistory.getLastPurchase();
      if (lastPurchase != null) {
        print("Tiket Terakhir yang Dibeli:");
        print("Kereta: ${lastPurchase.train.JenisKereta}");
        print("Keberangkatan: ${lastPurchase.train.WaktuKeberangkatan}");
        print("Tanggal: ${lastPurchase.date}");
        print("Total Harga: Rp${lastPurchase.totalPrice.toStringAsFixed(2)}");
        print("Penumpang:");
        for (var passenger in lastPurchase.passengers) {
          print("${passenger['name']} - ${passenger['idNumber']}");
        }
      } else {
        print("Belum ada tiket yang dibeli.");
      }
    } else if (choice == 4) {
       print("Masukkan harga tiket yang ingin dicari:");
      var price = double.tryParse(stdin.readLineSync()!) ?? -1;
      if (price >= 0) {
        var foundTrain = bst.searchTrainByPrice(price);
        if (foundTrain != null) {
          print("Kereta ditemukan:");
          print("${foundTrain.JenisKereta} - ${foundTrain.WaktuKeberangkatan} - Rp${foundTrain.harga.toStringAsFixed(2)}");
        } else {
          print("Tidak ada kereta dengan harga tiket tersebut.");
        }
      } else {
        print("Harga tiket tidak valid.");
      }
    } else if (choice == 5) {
      print("Terima kasih telah menggunakan layanan kami.");
      break;
    } else {
      print("Opsi tidak ditemukan. Silakan coba lagi.");
    }
  }
}
