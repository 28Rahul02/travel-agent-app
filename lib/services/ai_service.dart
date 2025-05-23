class AIService {
  Future<String> getTravelTip(String city) async {
    // Simulating API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock AI responses for each city
    final Map<String, String> cityTips = {
      'Delhi': 'Visit Chandni Chowk early morning for the best street food experience and explore the historical Red Fort.',
      'Mumbai': 'Take a sunset walk at Marine Drive and try the famous Vada Pav at any local stall.',
      'Bangalore': 'Start your day with a traditional South Indian breakfast and visit Lalbagh Garden for a peaceful morning.',
      'Kolkata': 'Experience the colonial architecture at Victoria Memorial and enjoy street food at Park Street.',
      'Chennai': 'Visit Marina Beach early morning for a peaceful walk and enjoy authentic South Indian breakfast.',
    };

    return cityTips[city] ?? 'Explore the local culture and cuisine of $city!';
  }
} 