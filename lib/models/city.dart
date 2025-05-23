class City {
  final String name;
  final String imageUrl;
  final List<String> attractions;
  final List<String> cuisine;
  final String aiTip;

  City({
    required this.name,
    required this.imageUrl,
    required this.attractions,
    required this.cuisine,
    required this.aiTip,
  });

  static List<City> getCities() {
    return [
      City(
        name: 'Delhi',
        imageUrl: 'https://images.unsplash.com/photo-1587474260584-136574528ed5?auto=format&fit=crop&w=1200&q=80',
        attractions: [
          'Red Fort',
          'India Gate',
          'Qutub Minar',
          'Lotus Temple',
          'Chandni Chowk'
        ],
        cuisine: [
          'Butter Chicken',
          'Chole Bhature',
          'Paranthe Wali Gali',
          'Dilli Ki Chaat'
        ],
        aiTip: 'Visit Chandni Chowk early morning for the best street food experience and explore the historical Red Fort.',
      ),
      City(
        name: 'Mumbai',
        imageUrl: 'https://images.unsplash.com/photo-1529253355930-ddbe423a2ac7?auto=format&fit=crop&w=1200&q=80',
        attractions: [
          'Gateway of India',
          'Marine Drive',
          'Elephanta Caves',
          'Juhu Beach',
          'Colaba Causeway'
        ],
        cuisine: [
          'Vada Pav',
          'Pav Bhaji',
          'Bombay Duck',
          'Seafood at Colaba'
        ],
        aiTip: 'Take a sunset walk at Marine Drive and try the famous Vada Pav at any local stall.',
      ),
      City(
        name: 'Bangalore',
        imageUrl: 'https://images.unsplash.com/photo-1522069169874-c58ec4b76be5?auto=format&fit=crop&w=1200&q=80',
        attractions: [
          'Lalbagh Botanical Garden',
          'Cubbon Park',
          'Bangalore Palace',
          'ISKCON Temple',
          'Commercial Street'
        ],
        cuisine: [
          'Masala Dosa',
          'Bisi Bele Bath',
          'Filter Coffee',
          'Mysore Pak'
        ],
        aiTip: 'Start your day with a traditional South Indian breakfast and visit Lalbagh Garden for a peaceful morning.',
      ),
      City(
        name: 'Kolkata',
        imageUrl: 'https://images.unsplash.com/photo-1587474260584-136574528ed5?auto=format&fit=crop&w=1200&q=80',
        attractions: [
          'Victoria Memorial',
          'Howrah Bridge',
          'Dakshineswar Temple',
          'Park Street',
          'New Market'
        ],
        cuisine: [
          'Rosogolla',
          'Kathi Rolls',
          'Fish Curry',
          'Mishti Doi'
        ],
        aiTip: 'Experience the colonial architecture at Victoria Memorial and enjoy street food at Park Street.',
      ),
      City(
        name: 'Chennai',
        imageUrl: 'https://images.unsplash.com/photo-1587474260584-136574528ed5?auto=format&fit=crop&w=1200&q=80',
        attractions: [
          'Marina Beach',
          'Kapaleeshwarar Temple',
          'Fort St. George',
          'San Thome Basilica',
          'MGR Memorial'
        ],
        cuisine: [
          'Idli Sambar',
          'Chettinad Chicken',
          'Filter Coffee',
          'Masala Dosa'
        ],
        aiTip: 'Visit Marina Beach early morning for a peaceful walk and enjoy authentic South Indian breakfast.',
      ),
    ];
  }
} 