import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';

class SimulatedChatScreen extends StatefulWidget {
  final String recipientUserId;
  final String recipientName;

  SimulatedChatScreen({
    Key? key,
    required this.recipientUserId,
    required this.recipientName,
  }) : super(key: key);

  @override
  _SimulatedChatScreenState createState() => _SimulatedChatScreenState();
}

class _SimulatedChatScreenState extends State<SimulatedChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Simulate response based on user message and service provider
  void _simulateResponse(String userMessage) {
    String simulatedResponse;

    // Custom responses for different service providers
    switch (widget.recipientUserId) {
      case 'physician':
        if (userMessage.toLowerCase().contains('fever') || userMessage.toLowerCase().contains('headache')) {
          simulatedResponse = 'As a physician, I recommend rest and plenty of fluids. If it persists, you may need a checkup.';
        } else if (userMessage.toLowerCase().contains('cold') || userMessage.toLowerCase().contains('cough')) {
          simulatedResponse = 'It sounds like you may have a cold. Stay hydrated, get plenty of rest, and consider using a humidifier. Let me know if you have any other symptoms.';
        } else if (userMessage.toLowerCase().contains('allergy') || userMessage.toLowerCase().contains('rash')) {
          simulatedResponse = 'For allergic reactions or rashes, I suggest using an over-the-counter antihistamine. If the rash is severe, consult a dermatologist.';
        } else if (userMessage.toLowerCase().contains('stomach') || userMessage.toLowerCase().contains('pain')) {
          simulatedResponse = 'Stomach pain can be caused by various issues. Make sure to stay hydrated and avoid spicy or greasy foods. If the pain persists, I recommend scheduling a visit.';
        } else if (userMessage.toLowerCase().contains('blood pressure') || userMessage.toLowerCase().contains('hypertension')) {
          simulatedResponse = 'Maintaining a healthy blood pressure is important. Make sure you\'re following a low-sodium diet and getting regular exercise. Do you have any other concerns about your blood pressure?';
        } else if (userMessage.toLowerCase().contains('fatigue') || userMessage.toLowerCase().contains('tired')) {
          simulatedResponse = 'Fatigue can be caused by various factors like stress, poor diet, or lack of sleep. Make sure you\'re getting enough rest and staying hydrated. Would you like to talk more about your daily routine?';
        } else if (userMessage.toLowerCase().contains('injury') || userMessage.toLowerCase().contains('sprain')) {
          simulatedResponse = 'For injuries like sprains, it\'s important to rest the affected area, apply ice, and keep it elevated. If the pain persists or worsens, consider seeing a doctor for further evaluation.';
        } else if (userMessage.toLowerCase().contains('vaccination') || userMessage.toLowerCase().contains('vaccine')) {
          simulatedResponse = 'Vaccinations are essential for preventing diseases. If you need a specific vaccine or booster, I recommend scheduling an appointment with your healthcare provider.';
        } else {
          simulatedResponse = 'As your physician, I am here to help. What symptoms are you experiencing?';
        }
        break;

      case 'pharmacist':
        if (userMessage.toLowerCase().contains('medication') || userMessage.toLowerCase().contains('prescription')) {
          simulatedResponse = 'I can help with your medication. Would you like to know more about dosages or possible side effects?';
        } else if (userMessage.toLowerCase().contains('side effect') || userMessage.toLowerCase().contains('reaction')) {
          simulatedResponse = 'If you are experiencing side effects from a medication, I recommend stopping the medication and contacting your doctor. Would you like information on alternatives?';
        } else if (userMessage.toLowerCase().contains('refill')) {
          simulatedResponse = 'I can assist with refilling your prescription. How long have you been on this medication, and do you need to update your prescription?';
        } else if (userMessage.toLowerCase().contains('over the counter') || userMessage.toLowerCase().contains('otc')) {
          simulatedResponse = 'For over-the-counter medications, I suggest ibuprofen or acetaminophen for pain relief, and loratadine or diphenhydramine for allergies. Would you like further assistance with OTC medications?';
        } else if (userMessage.toLowerCase().contains('dosage')) {
          simulatedResponse = 'Dosage instructions vary based on the medication. It’s important to follow your doctor’s recommendation. Would you like me to look up the recommended dosage for a specific medication?';
        } else if (userMessage.toLowerCase().contains('drug interaction')) {
          simulatedResponse = 'Drug interactions can be dangerous. Please provide the names of the medications you are taking, and I can advise on possible interactions.';
        } else if (userMessage.toLowerCase().contains('antibiotic') || userMessage.toLowerCase().contains('infection')) {
          simulatedResponse = 'Antibiotics are often prescribed for bacterial infections. Make sure to complete the full course even if you feel better. Do you have questions about the antibiotics you’re taking?';
        } else {
          simulatedResponse = 'I am your pharmacist. How can I assist you with your prescriptions or medications today?';
        }
        break;

      case 'nutritionist':
        if (userMessage.toLowerCase().contains('diet') || userMessage.toLowerCase().contains('weight loss')) {
          simulatedResponse = 'As a nutritionist, I recommend a balanced diet with proteins, fruits, and vegetables. Would you like a sample meal plan?';
        } else if (userMessage.toLowerCase().contains('meal plan') || userMessage.toLowerCase().contains('nutrition')) {
          simulatedResponse = 'I can create a personalized meal plan based on your dietary needs. Do you have any preferences or restrictions (e.g., vegan, low-carb, gluten-free)?';
        } else if (userMessage.toLowerCase().contains('calorie') || userMessage.toLowerCase().contains('caloric intake')) {
          simulatedResponse = 'For weight management, tracking your caloric intake can be important. Based on your goal, I recommend a daily intake of around 1,500-2,000 calories. Would you like help tracking this?';
        } else if (userMessage.toLowerCase().contains('supplement') || userMessage.toLowerCase().contains('vitamin')) {
          simulatedResponse = 'Vitamins and supplements can help if you are lacking certain nutrients. I recommend a multivitamin for overall health. Do you want specific advice on supplements?';
        } else if (userMessage.toLowerCase().contains('hydration') || userMessage.toLowerCase().contains('water')) {
          simulatedResponse = 'Staying hydrated is essential. Aim to drink at least 8 glasses of water per day. Would you like advice on incorporating more hydration into your diet?';
        } else if (userMessage.toLowerCase().contains('protein')) {
          simulatedResponse = 'Protein is important for muscle repair and general health. I recommend incorporating lean meats, beans, and legumes into your diet. Would you like suggestions on protein-rich foods?';
        } else if (userMessage.toLowerCase().contains('allergy') || userMessage.toLowerCase().contains('intolerance')) {
          simulatedResponse = 'Food allergies and intolerances should be taken seriously. Would you like help finding substitutes for common allergens (e.g., dairy, gluten)?';
        } else {
          simulatedResponse = 'I can assist with your dietary needs. Are you looking for weight management advice or healthy eating tips?';
        }
        break;

      case 'social_worker':
        if (userMessage.toLowerCase().contains('anxious') || userMessage.toLowerCase().contains('stress')) {
          simulatedResponse = 'I understand you’re feeling anxious. As a social worker, I’m here to support you. Let’s talk through what’s causing the stress.';
        } else if (userMessage.toLowerCase().contains('mental health') || userMessage.toLowerCase().contains('depression')) {
          simulatedResponse = 'Mental health is just as important as physical health. I encourage you to seek therapy or talk to a professional if feelings of depression persist. Would you like resources or support?';
        } else if (userMessage.toLowerCase().contains('relationship') || userMessage.toLowerCase().contains('family')) {
          simulatedResponse = 'Relationships can be challenging. I’m here to help you navigate any family or relationship issues you may be facing. How can I assist you today?';
        } else if (userMessage.toLowerCase().contains('financial stress')) {
          simulatedResponse = 'Financial stress can be overwhelming. I can help you find resources for financial aid or budgeting advice. Would you like to explore available resources?';
        } else if (userMessage.toLowerCase().contains('burnout') || userMessage.toLowerCase().contains('work stress')) {
          simulatedResponse = 'Work-related burnout is common. It’s important to set boundaries and take breaks when needed. Would you like strategies for managing burnout?';
        } else if (userMessage.toLowerCase().contains('coping') || userMessage.toLowerCase().contains('self-care')) {
          simulatedResponse = 'Coping strategies and self-care routines are crucial for maintaining mental well-being. Would you like help creating a self-care routine?';
        } else if (userMessage.toLowerCase().contains('support group') || userMessage.toLowerCase().contains('therapy')) {
          simulatedResponse = 'Support groups and therapy can provide valuable emotional support. I can help you find a support group or therapist near you. Would you like assistance with that?';
        } else {
          simulatedResponse = 'I am here for your mental and emotional support. How are you feeling today?';
        }
        break;

      default:
        simulatedResponse = 'I am here to help you. Can you tell me more about what you’re experiencing?';
    }

    // Simulate the response from the provider
    setState(() {
      _messages.add({'sender': widget.recipientName, 'message': simulatedResponse});
    });
  }

  // Handle sending a message
  void _sendMessage() {
    final userMessage = _messageController.text;

    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'User', 'message': userMessage});
    });

    _messageController.clear();

    Future.delayed(Duration(seconds: 1), () {
      _simulateResponse(userMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.recipientName}',
        style: TextStyle(color: AppColors.white),),
        backgroundColor: AppColors.appbarHeading,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'User';

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${message['message']}',
                      style: TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.white,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
