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
        if (userMessage.toLowerCase().contains('hiv') || userMessage.toLowerCase().contains('definition') || userMessage.toLowerCase().contains('basics')) {
          simulatedResponse = 'HIV (Human Immunodeficiency Virus) is a virus that attacks the body\'s immune system. If left untreated, it can lead to AIDS (Acquired Immunodeficiency Syndrome). It\'s important to get tested and know your status.';
        } else if (userMessage.toLowerCase().contains('aids') || userMessage.toLowerCase().contains('difference between hiv and aids')) {
          simulatedResponse = 'HIV is the virus that causes AIDS. AIDS is the final stage of HIV infection, when the immune system is severely damaged and opportunistic infections occur. It is important to start treatment early to avoid progression to AIDS.';
        } else if (userMessage.toLowerCase().contains('transmission') || userMessage.toLowerCase().contains('how is hiv transmitted')) {
          simulatedResponse = 'HIV is transmitted through contact with certain bodily fluids, such as blood, semen, vaginal fluids, rectal fluids, and breast milk. It can be passed through unprotected sex, sharing needles, or from mother to child during childbirth.';
        } else if (userMessage.toLowerCase().contains('risk') || userMessage.toLowerCase().contains('risk factors') || userMessage.toLowerCase().contains('high-risk behaviors')) {
          simulatedResponse = 'High-risk behaviors for HIV transmission include unprotected sex, sharing needles, and having multiple sexual partners. Understanding these risks can help reduce your chances of contracting HIV.';
        } else if (userMessage.toLowerCase().contains('prevention') || userMessage.toLowerCase().contains('ways to prevent hiv')) {
          simulatedResponse = 'To prevent HIV, use condoms consistently, avoid sharing needles, consider taking PrEP (pre-exposure prophylaxis) if at high risk, and ensure partners are tested regularly.';
        } else if (userMessage.toLowerCase().contains('symptoms') || userMessage.toLowerCase().contains('signs of hiv')) {
          simulatedResponse = 'Early symptoms of HIV can include flu-like symptoms such as fever, chills, and muscle aches. However, some people may not experience symptoms for years. Testing is the only way to know for sure.';
        } else if (userMessage.toLowerCase().contains('testing') || userMessage.toLowerCase().contains('where to get tested')) {
          simulatedResponse = 'You can get tested for HIV at clinics, hospitals, or community health centers. There are also home testing kits available. Early testing is crucial for managing HIV effectively.';
        } else if (userMessage.toLowerCase().contains('test results') || userMessage.toLowerCase().contains('understanding results')) {
          simulatedResponse = 'A positive test means you have HIV, while a negative test means no HIV was detected. Remember, there is a window period where the virus may not show up in tests, so retesting may be necessary.';
        } else if (userMessage.toLowerCase().contains('frequency') || userMessage.toLowerCase().contains('how often to get tested')) {
          simulatedResponse = 'It\'s recommended to get tested for HIV at least once a year if you are sexually active, or more frequently if you engage in high-risk behaviors. Talk to your healthcare provider for personalized advice.';
        } else if (userMessage.toLowerCase().contains('anonymous testing') || userMessage.toLowerCase().contains('privacy')) {
          simulatedResponse = 'Anonymous testing ensures your identity is not linked to your test results. Many clinics offer this service to protect your privacy and confidentiality.';
        } else if (userMessage.toLowerCase().contains('home testing') || userMessage.toLowerCase().contains('self-testing kits')) {
          simulatedResponse = 'Home testing kits for HIV are available and are quite accurate. Be sure to follow the instructions carefully and confirm positive results with a healthcare provider.';
        } else if (userMessage.toLowerCase().contains('treatment') || userMessage.toLowerCase().contains('what is art')) {
          simulatedResponse = 'HIV treatment typically involves antiretroviral therapy (ART), which helps control the virus and maintain a healthy immune system. Starting treatment early is essential to manage the virus effectively.';
        } else if (userMessage.toLowerCase().contains('medication') || userMessage.toLowerCase().contains('how to take medications')) {
          simulatedResponse = 'It\'s important to take your HIV medications as prescribed to maintain an undetectable viral load. If you miss doses, talk to your doctor about the best steps to take.';
        } else if (userMessage.toLowerCase().contains('viral load') || userMessage.toLowerCase().contains('undetectable')) {
          simulatedResponse = 'Viral load refers to the amount of HIV in your blood. The goal of treatment is to make the viral load undetectable. If you have an undetectable viral load, you cannot transmit HIV (U=U).';
        } else if (userMessage.toLowerCase().contains('cd4 count') || userMessage.toLowerCase().contains('immune health')) {
          simulatedResponse = 'CD4 count measures the strength of your immune system. A higher CD4 count means your immune system is stronger. Regular testing helps track your immune health during treatment.';
        } else if (userMessage.toLowerCase().contains('adherence') || userMessage.toLowerCase().contains('sticking to treatment')) {
          simulatedResponse = 'Adhering to your treatment plan is crucial for managing HIV. Missing doses can make the virus harder to control, so set reminders and establish routines to stay on track.';
        } else if (userMessage.toLowerCase().contains('side effects') || userMessage.toLowerCase().contains('managing side effects')) {
          simulatedResponse = 'Common side effects of HIV medications include nausea, headaches, and fatigue. If side effects are severe or persistent, talk to your doctor about managing them or adjusting your treatment plan.';
        } else if (userMessage.toLowerCase().contains('condoms') || userMessage.toLowerCase().contains('using condoms')) {
          simulatedResponse = 'Using condoms consistently and correctly can significantly reduce the risk of HIV transmission. There are various types of condoms available for both men and women.';
        } else if (userMessage.toLowerCase().contains('prep') || userMessage.toLowerCase().contains('what is prep')) {
          simulatedResponse = 'PrEP (Pre-exposure Prophylaxis) is a medication that reduces the risk of getting HIV. It\'s recommended for people at high risk of HIV exposure. Talk to your healthcare provider about getting PrEP.';
        } else if (userMessage.toLowerCase().contains('pep') || userMessage.toLowerCase().contains('what is pep')) {
          simulatedResponse = 'PEP (Post-exposure Prophylaxis) is an emergency treatment that can prevent HIV after a potential exposure. It must be taken within 72 hours, so seek medical attention immediately if you think you\'ve been exposed.';
        } else if (userMessage.toLowerCase().contains('safer sex') || userMessage.toLowerCase().contains('safe sex practices')) {
          simulatedResponse = 'Safer sex practices, such as using condoms, reducing the number of partners, and getting regularly tested, can help reduce the risk of HIV transmission.';
        } else if (userMessage.toLowerCase().contains('can i get hiv from') || userMessage.toLowerCase().contains('casual contact')) {
          simulatedResponse = 'HIV cannot be transmitted through casual contact such as hugging, shaking hands, or sharing food. It is only spread through specific bodily fluids during high-risk activities.';
        } else if (userMessage.toLowerCase().contains('is there a cure for hiv') || userMessage.toLowerCase().contains('cure status')) {
          simulatedResponse = 'Currently, there is no cure for HIV, but ongoing research continues. With treatment, people with HIV can live long, healthy lives, and scientists are working toward finding a cure.';
        } else if (userMessage.toLowerCase().contains('how is hiv treated') || userMessage.toLowerCase().contains('managing hiv')) {
          simulatedResponse = 'HIV is treated with antiretroviral therapy (ART), which helps keep the virus under control and prevents it from damaging the immune system. Treatment is lifelong, but it can make HIV manageable.';
        } else if (userMessage.toLowerCase().contains('can hiv be prevented') || userMessage.toLowerCase().contains('prevention strategies')) {
          simulatedResponse = 'HIV can be prevented through various strategies such as consistent condom use, taking PrEP, regular testing, and avoiding sharing needles. Researchers are also working on vaccines to prevent HIV.';
        } else if (userMessage.toLowerCase().contains('followup') || userMessage.toLowerCase().contains('how often should i see a doctor')) {
          simulatedResponse = 'Regular follow-up visits are important for managing HIV. Your doctor will monitor your viral load, CD4 count, and overall health. Visits are typically every 3 to 6 months, but this may vary based on your condition.';
        } else if (userMessage.toLowerCase().contains('lab tests') || userMessage.toLowerCase().contains('importance of lab tests')) {
          simulatedResponse = 'Lab tests, such as viral load and CD4 count tests, are essential for monitoring HIV treatment progress. These tests help your doctor understand how well your treatment is working and whether adjustments are needed.';
        } else if (userMessage.toLowerCase().contains('doctor visit') || userMessage.toLowerCase().contains('scheduling visits')) {
          simulatedResponse = 'Scheduling regular doctor visits is key to managing HIV. Prepare for your visit by writing down any symptoms, side effects, or questions you may have to ensure all your concerns are addressed.';
        } else {
          simulatedResponse = 'I\'m here to help with any HIV-related questions you may have. What would you like to know?';
        }
        break;

      case 'pharmacist':
        if (userMessage.toLowerCase().contains('art') || userMessage.toLowerCase().contains('antiretroviral therapy')) {
          simulatedResponse = 'ART (Antiretroviral Therapy) is the treatment for HIV, consisting of a combination of medications that suppress the virus. Would you like more information on the types of ART available?';
        } else if (userMessage.toLowerCase().contains('hiv medications') || userMessage.toLowerCase().contains('common hiv medications')) {
          simulatedResponse = 'Common HIV medications include drugs like Tenofovir, Emtricitabine, and Dolutegravir. They work by preventing the virus from replicating. Would you like to know more about a specific medication?';
        } else if (userMessage.toLowerCase().contains('dosage') || userMessage.toLowerCase().contains('correct dosage')) {
          simulatedResponse = 'It\'s important to take your HIV medications exactly as prescribed. If you miss a dose, take it as soon as you remember, unless it\'s almost time for your next dose. Do you need guidance on a specific medication?';
        } else if (userMessage.toLowerCase().contains('side effects') || userMessage.toLowerCase().contains('managing side effects')) {
          simulatedResponse = 'Common side effects of HIV medications can include nausea, headaches, and fatigue. Managing side effects with hydration and rest can help. Would you like advice on managing a specific side effect?';
        } else if (userMessage.toLowerCase().contains('generic drugs') || userMessage.toLowerCase().contains('generic vs brand')) {
          simulatedResponse = 'Generic HIV drugs are just as effective as their brand-name counterparts but are often more affordable. Do you need information about costs or insurance coverage for generic drugs?';
        } else if (userMessage.toLowerCase().contains('adherence') || userMessage.toLowerCase().contains('taking medications on time')) {
          simulatedResponse = 'Taking your medications on time is crucial to maintaining viral suppression and preventing drug resistance. Setting daily reminders can help. Would you like some strategies for better adherence?';
        } else if (userMessage.toLowerCase().contains('missed dose') || userMessage.toLowerCase().contains('missed medication')) {
          simulatedResponse = 'If you miss a dose of your HIV medication, take it as soon as you remember, unless it\'s close to the next dose. Missing doses frequently can lead to drug resistance. Let me know if you need advice on this.';
        } else if (userMessage.toLowerCase().contains('schedule') || userMessage.toLowerCase().contains('medication schedule')) {
          simulatedResponse = 'Sticking to a consistent medication schedule is important. Many people find success with reminders or setting alarms. Would you like help setting up a medication schedule or reminder system?';
        } else if (userMessage.toLowerCase().contains('long term therapy') || userMessage.toLowerCase().contains('duration of treatment')) {
          simulatedResponse = 'HIV treatment is typically lifelong, and staying on therapy is crucial to controlling the virus. Regular follow-up visits will help ensure your treatment remains effective.';
        } else if (userMessage.toLowerCase().contains('drug resistance') || userMessage.toLowerCase().contains('avoiding drug resistance')) {
          simulatedResponse = 'Drug resistance can occur if you don’t take your medication consistently. This makes the virus harder to treat. Sticking to your ART schedule reduces the risk. Do you need more info on resistance?';
        } else if (userMessage.toLowerCase().contains('drug interactions') || userMessage.toLowerCase().contains('interactions with other medications')) {
          simulatedResponse = 'Some medications can interact with HIV drugs, including certain over-the-counter meds. Please let me know what medications you’re taking, and I can check for any possible interactions.';
        } else if (userMessage.toLowerCase().contains('supplements') || userMessage.toLowerCase().contains('vitamins')) {
          simulatedResponse = 'Certain vitamins and supplements are safe to take with HIV medications, but others can cause interactions. Let me know which supplements you\'re taking so I can check for safety.';
        } else if (userMessage.toLowerCase().contains('alcohol') || userMessage.toLowerCase().contains('alcohol consumption')) {
          simulatedResponse = 'Alcohol can interact with some HIV medications or worsen side effects like nausea. It\'s best to limit alcohol use. Do you have concerns about mixing alcohol with your treatment?';
        } else if (userMessage.toLowerCase().contains('recreational drugs') || userMessage.toLowerCase().contains('risks with recreational drugs')) {
          simulatedResponse = 'Recreational drugs can interfere with HIV medications and pose significant health risks. If you\'re concerned about interactions, let me know what substances you’re using.';
        } else if (userMessage.toLowerCase().contains('medication safety') || userMessage.toLowerCase().contains('storing medications')) {
          simulatedResponse = 'It\'s important to store HIV medications in a cool, dry place, away from light. If you’re traveling, make sure you have enough medication and a secure way to store it.';
        } else if (userMessage.toLowerCase().contains('prescription') || userMessage.toLowerCase().contains('filling prescriptions')) {
          simulatedResponse = 'I can assist with refilling your prescription or transferring it to another pharmacy. Do you need help with your prescription or have questions about the process?';
        } else if (userMessage.toLowerCase().contains('cost') || userMessage.toLowerCase().contains('insurance coverage')) {
          simulatedResponse = 'HIV medications can be expensive, but there are assistance programs available. Let me know if you need help with insurance or financial assistance for your medications.';
        } else if (userMessage.toLowerCase().contains('insurance') || userMessage.toLowerCase().contains('drug plan')) {
          simulatedResponse = 'I can help answer questions about insurance coverage for HIV medications. Are you on a plan like OHIP or another drug coverage program?';
        } else if (userMessage.toLowerCase().contains('pharmacy locations') || userMessage.toLowerCase().contains('where to get medications')) {
          simulatedResponse = 'I can help you find nearby pharmacies and their hours. Do you need assistance locating a pharmacy to fill your prescription?';
        } else if (userMessage.toLowerCase().contains('prep') || userMessage.toLowerCase().contains('prep prescription')) {
          simulatedResponse = 'PrEP (Pre-exposure Prophylaxis) is a medication that helps prevent HIV. I can help with getting a prescription and provide details about its cost and coverage. Do you have questions about starting PrEP?';
        } else if (userMessage.toLowerCase().contains('pep') || userMessage.toLowerCase().contains('emergency prevention')) {
          simulatedResponse = 'PEP (Post-exposure Prophylaxis) is an emergency treatment that can prevent HIV after potential exposure. It must be taken within 72 hours. Do you need information on how to access PEP?';
        } else if (userMessage.toLowerCase().contains('condoms') || userMessage.toLowerCase().contains('availability of condoms')) {
          simulatedResponse = 'Condoms are essential for preventing HIV transmission. Many pharmacies provide free condoms. Would you like information on where to get them?';
        } else if (userMessage.toLowerCase().contains('prevention advice') || userMessage.toLowerCase().contains('prevention strategies')) {
          simulatedResponse = 'To reduce your risk of HIV, use condoms, get tested regularly, and consider PrEP if you are at high risk. Would you like more advice on prevention strategies?';
        } else if (userMessage.toLowerCase().contains('viral load') || userMessage.toLowerCase().contains('monitoring viral load')) {
          simulatedResponse = 'Monitoring your viral load is critical to assessing how well your HIV treatment is working. Keeping your viral load undetectable is the goal of ART. Let me know if you have questions about your viral load tests.';
        } else if (userMessage.toLowerCase().contains('cd4 count') || userMessage.toLowerCase().contains('how meds affect cd4')) {
          simulatedResponse = 'Your CD4 count helps monitor the health of your immune system. HIV medications aim to maintain or increase your CD4 count. Regular tests will track your immune health.';
        } else if (userMessage.toLowerCase().contains('lab tests') || userMessage.toLowerCase().contains('labs to monitor treatment')) {
          simulatedResponse = 'Routine lab tests, such as viral load and CD4 count tests, help monitor the effectiveness of your treatment. It\'s important to do these regularly to adjust your treatment if necessary.';
        } else if (userMessage.toLowerCase().contains('immunization') || userMessage.toLowerCase().contains('vaccines for hiv patients')) {
          simulatedResponse = 'People living with HIV should stay up-to-date on vaccines such as the flu shot and pneumonia vaccines. I can help you schedule vaccinations based on your treatment plan.';
        } else if (userMessage.toLowerCase().contains('can i take') || userMessage.toLowerCase().contains('over the counter meds')) {
          simulatedResponse = 'It\'s important to consult your healthcare provider before taking over-the-counter medications like painkillers or cold medicine. Some may interact with your HIV medications.';
        } else if (userMessage.toLowerCase().contains('how do i store') || userMessage.toLowerCase().contains('medication storage')) {
          simulatedResponse = 'Store HIV medications at room temperature, away from moisture and sunlight. If you’re traveling, use a travel case and ensure you pack enough doses.';
        } else if (userMessage.toLowerCase().contains('can i switch meds') || userMessage.toLowerCase().contains('changing medications')) {
          simulatedResponse = 'If you’re considering switching medications due to side effects or other concerns, it’s important to talk to your healthcare provider first. They can help transition you to a new regimen.';
        } else if (userMessage.toLowerCase().contains('is it safe to take') || userMessage.toLowerCase().contains('antibiotics')) {
          simulatedResponse = 'If you need to take antibiotics, blood pressure meds, or diabetes meds, be sure to consult your doctor to check for interactions with your HIV medications.';
        } else if (userMessage.toLowerCase().contains('should i stop taking meds') || userMessage.toLowerCase().contains('stopping art')) {
          simulatedResponse = 'It is important not to stop taking your HIV medications without consulting your healthcare provider, as this can lead to drug resistance. Talk to your doctor if you have concerns.';
        } else if (userMessage.toLowerCase().contains('is there a cure') || userMessage.toLowerCase().contains('hiv cure research')) {
          simulatedResponse = 'Currently, there is no cure for HIV, but research is ongoing. Treatment with ART can control the virus and help you live a long, healthy life.';
        } else if (userMessage.toLowerCase().contains('local resources') || userMessage.toLowerCase().contains('nearby clinics')) {
          simulatedResponse = 'I can help you find local clinics and HIV support resources. Let me know where you are, and I\'ll assist in locating nearby services.';
        } else {
          simulatedResponse = 'I\'m your pharmacist, here to help with any HIV-related questions. How can I assist you today?';
        }
        break;


      case 'registered_dietician':
        if (userMessage.toLowerCase().contains('nutrition') || userMessage.toLowerCase().contains('healthy eating for people with hiv')) {
          simulatedResponse = 'Nutrition is crucial for people with HIV to maintain a strong immune system and overall health. A diet rich in fruits, vegetables, whole grains, and lean protein can help. Would you like tips on planning meals?';
        } else if (userMessage.toLowerCase().contains('balanced diet') || userMessage.toLowerCase().contains('food groups')) {
          simulatedResponse = 'A balanced diet includes the right mix of protein, carbohydrates, and healthy fats from all food groups. Would you like help creating a meal plan that ensures balance?';
        } else if (userMessage.toLowerCase().contains('immune support') || userMessage.toLowerCase().contains('foods to boost the immune system')) {
          simulatedResponse = 'Immune-boosting foods include those rich in antioxidants like berries, leafy greens, and nuts. Vitamin C, zinc, and probiotics are also important. Would you like more suggestions?';
        } else if (userMessage.toLowerCase().contains('calories') || userMessage.toLowerCase().contains('caloric needs for people with hiv')) {
          simulatedResponse = 'People with HIV may need more calories to maintain energy and body weight. Depending on your activity level, your caloric needs may vary. I can help you calculate your daily calorie intake.';
        } else if (userMessage.toLowerCase().contains('hydration') || userMessage.toLowerCase().contains('importance of water intake')) {
          simulatedResponse = 'Staying hydrated is especially important for people with HIV. Aim to drink at least 8-10 glasses of water a day. Would you like tips on how to stay hydrated?';
        } else if (userMessage.toLowerCase().contains('protein') || userMessage.toLowerCase().contains('protein rich foods')) {
          simulatedResponse = 'Protein is essential for maintaining muscle mass and overall health. Lean meats, beans, legumes, and tofu are great sources of protein. Would you like protein-rich recipe ideas?';
        } else if (userMessage.toLowerCase().contains('vitamins') || userMessage.toLowerCase().contains('essential vitamins')) {
          simulatedResponse = 'Vitamins such as A, C, D, and E are important for immune health. People with HIV might need supplements to meet their nutritional needs. I can guide you on the best vitamins for your health.';
        } else if (userMessage.toLowerCase().contains('nausea') || userMessage.toLowerCase().contains('foods to help with nausea')) {
          simulatedResponse = 'To manage nausea, try eating small, frequent meals and avoid spicy or greasy foods. Ginger tea and bland foods like crackers can also help. Would you like more tips on managing nausea?';
        } else if (userMessage.toLowerCase().contains('diarrhea') || userMessage.toLowerCase().contains('managing diarrhea')) {
          simulatedResponse = 'If you’re experiencing diarrhea, eating fiber-rich foods like oats and bananas can help. Staying hydrated is also essential. Would you like specific diet recommendations to manage this?';
        } else if (userMessage.toLowerCase().contains('appetite loss') || userMessage.toLowerCase().contains('increasing appetite')) {
          simulatedResponse = 'If you’re dealing with appetite loss, try eating smaller, more frequent meals, and focus on calorie-dense foods. Smoothies and shakes can also be a good option. Need help finding ways to increase your appetite?';
        } else if (userMessage.toLowerCase().contains('weight loss') || userMessage.toLowerCase().contains('preventing weight loss')) {
          simulatedResponse = 'For people with HIV, preventing unintended weight loss is important. Calorie-dense foods like avocados, nuts, and whole grains can help. Would you like to explore ways to maintain or gain weight?';
        } else if (userMessage.toLowerCase().contains('weight gain') || userMessage.toLowerCase().contains('managing weight gain')) {
          simulatedResponse = 'If you’re concerned about weight gain, focus on a balanced diet and regular physical activity. Reducing refined sugars and unhealthy fats can also help. Would you like a weight management plan?';
        } else if (userMessage.toLowerCase().contains('lipodystrophy') || userMessage.toLowerCase().contains('managing fat redistribution')) {
          simulatedResponse = 'Lipodystrophy, or fat redistribution, can be managed with a diet low in unhealthy fats and high in fiber and lean protein. I can help you with a diet plan tailored to managing these changes.';
        } else if (userMessage.toLowerCase().contains('gut health') || userMessage.toLowerCase().contains('probiotics')) {
          simulatedResponse = 'Improving gut health is key to overall well-being. Probiotics in yogurt, kefir, and fermented foods can help. Would you like advice on incorporating gut-friendly foods into your diet?';
        } else if (userMessage.toLowerCase().contains('macronutrients') || userMessage.toLowerCase().contains('protein carbohydrates fats')) {
          simulatedResponse = 'Balancing macronutrients like protein, carbs, and fats is important for energy and health. I can help you determine the right balance based on your goals. Need help with meal planning?';
        } else if (userMessage.toLowerCase().contains('micronutrients') || userMessage.toLowerCase().contains('vitamins minerals')) {
          simulatedResponse = 'Micronutrients such as iron, calcium, and vitamin D are essential for people with HIV. I can help you identify where you might need supplements or specific foods to boost these nutrients.';
        } else if (userMessage.toLowerCase().contains('antioxidants') || userMessage.toLowerCase().contains('antioxidant rich foods')) {
          simulatedResponse = 'Antioxidant-rich foods, like berries, dark leafy greens, and nuts, help protect your body from free radicals. Including these in your diet can support immune function. Need a list of foods high in antioxidants?';
        } else if (userMessage.toLowerCase().contains('omega-3') || userMessage.toLowerCase().contains('healthy fats')) {
          simulatedResponse = 'Omega-3 fatty acids are important for heart and brain health. Foods like salmon, flaxseeds, and walnuts are great sources. Would you like tips on incorporating more healthy fats into your meals?';
        } else if (userMessage.toLowerCase().contains('iron') || userMessage.toLowerCase().contains('preventing anemia')) {
          simulatedResponse = 'Iron-rich foods such as red meat, beans, and spinach can help prevent anemia, which is common in people with HIV. I can guide you on how to boost iron intake. Interested in more iron-rich food options?';
        } else if (userMessage.toLowerCase().contains('calcium') || userMessage.toLowerCase().contains('bone health')) {
          simulatedResponse = 'Calcium is essential for bone health. Dairy products, leafy greens, and fortified foods are good sources. Would you like help finding calcium-rich foods or supplements?';
        } else if (userMessage.toLowerCase().contains('vitamin d') || userMessage.toLowerCase().contains('immune function')) {
          simulatedResponse = 'Vitamin D supports the immune system and bone health. You can get it from sunlight, fortified foods, and supplements. Let me know if you need advice on vitamin D intake.';
        } else if (userMessage.toLowerCase().contains('hiv and diabetes') || userMessage.toLowerCase().contains('managing diabetes')) {
          simulatedResponse = 'Managing diabetes alongside HIV involves choosing low glycemic foods, monitoring blood sugar, and maintaining a balanced diet. I can help create a diabetes-friendly meal plan. Would you like more information?';
        } else if (userMessage.toLowerCase().contains('heart health') || userMessage.toLowerCase().contains('cholesterol')) {
          simulatedResponse = 'To maintain heart health, focus on a diet rich in whole grains, healthy fats, and vegetables while limiting saturated fats. Would you like help with heart-healthy recipes?';
        } else if (userMessage.toLowerCase().contains('kidney health') || userMessage.toLowerCase().contains('managing kidney disease')) {
          simulatedResponse = 'For kidney health, it’s important to manage sodium, potassium, and phosphorus intake. I can guide you through kidney-friendly meal planning. Do you need help with dietary suggestions?';
        } else if (userMessage.toLowerCase().contains('liver health') || userMessage.toLowerCase().contains('support liver function')) {
          simulatedResponse = 'A liver-friendly diet includes limiting alcohol, avoiding fatty foods, and eating more fruits and vegetables. I can help you design a liver-supportive meal plan. Would you like assistance?';
        } else if (userMessage.toLowerCase().contains('vegetarian') || userMessage.toLowerCase().contains('vegan')) {
          simulatedResponse = 'A plant-based diet can provide all the nutrients you need, even for people with HIV. I can help ensure you get enough protein, iron, and other essential nutrients. Need help planning your meals?';
        } else if (userMessage.toLowerCase().contains('food safety') || userMessage.toLowerCase().contains('avoiding foodborne illnesses')) {
          simulatedResponse = 'Food safety is especially important for people with HIV. Be sure to cook foods to the proper temperature and avoid raw or undercooked items. Would you like tips on safe food handling?';
        } else if (userMessage.toLowerCase().contains('raw foods') || userMessage.toLowerCase().contains('should i avoid raw foods')) {
          simulatedResponse = 'It\'s generally safer to avoid raw or undercooked foods like sushi or eggs if you have a compromised immune system. Let me know if you have questions about specific foods.';
        } else if (userMessage.toLowerCase().contains('hygiene') || userMessage.toLowerCase().contains('food hygiene')) {
          simulatedResponse = 'Good food hygiene practices, such as washing hands, cooking foods to the right temperature, and storing food properly, are crucial to prevent illness. Do you need help with specific hygiene tips?';
        } else if (userMessage.toLowerCase().contains('immune system') || userMessage.toLowerCase().contains('diet to support a compromised immune system')) {
          simulatedResponse = 'A diet rich in vitamins, antioxidants, and healthy fats can support a compromised immune system. Would you like help creating a meal plan to boost immune function?';
        } else if (userMessage.toLowerCase().contains('multivitamins') || userMessage.toLowerCase().contains('should i take a multivitamin')) {
          simulatedResponse = 'A multivitamin may help if you’re not getting enough nutrients from your diet. I can guide you on the best multivitamins for your needs. Would you like personalized advice?';
        } else if (userMessage.toLowerCase().contains('probiotics') || userMessage.toLowerCase().contains('gut health')) {
          simulatedResponse = 'Probiotics can support gut health by improving digestion and balancing gut bacteria. You can find them in yogurt, kefir, and other fermented foods. Would you like help incorporating them into your diet?';
        } else if (userMessage.toLowerCase().contains('herbal supplements') || userMessage.toLowerCase().contains('are herbal supplements safe')) {
          simulatedResponse = 'Herbal supplements can interact with HIV medications, so it’s important to consult your doctor before taking them. I can provide advice on which supplements are safe. Need help with this?';
        } else if (userMessage.toLowerCase().contains('omega-3') || userMessage.toLowerCase().contains('fish oil supplements')) {
          simulatedResponse = 'Omega-3 fatty acids, found in fish oil and flaxseed, are good for heart health and reducing inflammation. Would you like tips on adding more omega-3s to your diet?';
        } else if (userMessage.toLowerCase().contains('weight maintenance') || userMessage.toLowerCase().contains('how to maintain weight')) {
          simulatedResponse = 'Maintaining a healthy weight can be challenging with HIV. I recommend a balanced diet and regular monitoring of your caloric intake. Would you like personalized weight maintenance advice?';
        } else if (userMessage.toLowerCase().contains('weight loss') || userMessage.toLowerCase().contains('losing weight safely')) {
          simulatedResponse = 'If you’re looking to lose weight safely, focus on a diet rich in whole foods, combined with regular exercise. Reducing sugary and processed foods can also help. Would you like a weight loss plan?';
        } else if (userMessage.toLowerCase().contains('muscle mass') || userMessage.toLowerCase().contains('maintaining muscle mass')) {
          simulatedResponse = 'Maintaining muscle mass is important, especially for people with HIV. A diet high in protein, paired with regular strength exercises, can help. Would you like tips on muscle-building foods?';
        } else if (userMessage.toLowerCase().contains('exercise') || userMessage.toLowerCase().contains('benefits of exercise')) {
          simulatedResponse = 'Exercise, paired with proper nutrition, is key for managing health with HIV. Regular activity improves mood, strength, and overall wellness. Would you like advice on combining nutrition and exercise?';
        } else if (userMessage.toLowerCase().contains('pre-workout nutrition') || userMessage.toLowerCase().contains('foods before exercise')) {
          simulatedResponse = 'Pre-workout nutrition should include a mix of carbs and protein to fuel your body. Bananas, oatmeal, and smoothies are great options. Would you like more suggestions for pre-workout snacks?';
        } else if (userMessage.toLowerCase().contains('post-workout nutrition') || userMessage.toLowerCase().contains('recovery foods')) {
          simulatedResponse = 'After a workout, your body needs protein for muscle repair and carbs to restore energy. Eggs, Greek yogurt, and protein shakes are great recovery foods. Need more post-workout meal ideas?';
        } else if (userMessage.toLowerCase().contains('can i eat') || userMessage.toLowerCase().contains('foods to avoid')) {
          simulatedResponse = 'Certain foods may interact with medications or worsen symptoms. It’s best to avoid raw eggs, unpasteurized dairy, and undercooked meats. Let me know if you have specific food questions.';
        } else if (userMessage.toLowerCase().contains('what should i eat if') || userMessage.toLowerCase().contains('managing symptoms')) {
          simulatedResponse = 'Your diet can help manage symptoms like nausea or diarrhea. Small, frequent meals and bland foods can help. Would you like specific food suggestions for your symptoms?';
        } else if (userMessage.toLowerCase().contains('how much should i eat') || userMessage.toLowerCase().contains('portion sizes')) {
          simulatedResponse = 'Portion sizes and meal frequency depend on your individual needs. I can help you calculate the right portions based on your health goals. Would you like help with meal planning?';
        } else if (userMessage.toLowerCase().contains('is it safe to take') || userMessage.toLowerCase().contains('supplements with hiv meds')) {
          simulatedResponse = 'Some supplements can interact with HIV medications, so it’s important to consult your healthcare provider before starting any. Would you like information on safe supplements?';
        } else if (userMessage.toLowerCase().contains('dietitian help') || userMessage.toLowerCase().contains('nutrition questions')) {
          simulatedResponse = 'I can answer your nutrition questions or connect you with a registered dietitian for more personalized advice. What would you like to discuss?';
        } else if (userMessage.toLowerCase().contains('meal plans') || userMessage.toLowerCase().contains('personalized meal plans')) {
          simulatedResponse = 'I can help create a personalized meal plan based on your preferences and nutritional needs. Do you have any specific dietary restrictions or goals?';
        } else if (userMessage.toLowerCase().contains('local resources') || userMessage.toLowerCase().contains('community food programs')) {
          simulatedResponse = 'There are many local resources available for nutrition support, including food banks and community kitchens. Let me know your location, and I can provide information on nearby services.';
        } else {
          simulatedResponse = 'I\'m here to help with your nutrition and meal planning needs. What would you like to know?';
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
