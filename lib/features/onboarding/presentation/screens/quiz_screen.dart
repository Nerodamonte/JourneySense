import 'package:flutter/material.dart';
import 'package:journey_sense/features/home/presentation/screens/home_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentStep = 0;

  // Question 1: Journey type
  String? _selectedJourneyType;
  final _customJourneyController = TextEditingController();

  // Question 2: Travel frequency
  String? _selectedFrequency;
  final _customFrequencyController = TextEditingController();

  // Question 3: Planning duration
  String? _selectedPlanningDuration;
  final _customPlanningController = TextEditingController();

  final List<Map<String, dynamic>> _journeyTypes = [
    {
      'icon': Icons.terrain,
      'title': 'Adventure',
      'subtitle': 'Thrilling experiences',
    },
    {
      'icon': Icons.spa,
      'title': 'Relaxation',
      'subtitle': 'Peace and tranquility',
    },
    {
      'icon': Icons.museum,
      'title': 'Culture',
      'subtitle': 'History and heritage',
    },
    {
      'icon': Icons.restaurant,
      'title': 'Food',
      'subtitle': 'Culinary adventures',
    },
  ];

  final List<String> _frequencies = [
    'Thường xuyên',
    'Rất nhiều',
    'Hiếm khi',
    'Không đi',
  ];

  final List<String> _planningDurations = [
    '1 tiếng',
    '5 tiếng',
    '1 ngày',
    'Nhiều ngày',
  ];

  @override
  void dispose() {
    _customJourneyController.dispose();
    _customFrequencyController.dispose();
    _customPlanningController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      // TODO: Submit quiz answers
      _submitQuiz();
    }
  }

  void _submitQuiz() {
    print(
      'Journey Type: ${_selectedJourneyType ?? _customJourneyController.text}',
    );
    print(
      'Frequency: ${_selectedFrequency ?? _customFrequencyController.text}',
    );
    print(
      'Planning Duration: ${_selectedPlanningDuration ?? _customPlanningController.text}',
    );

    // Navigate to Home Screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  bool _canContinue() {
    switch (_currentStep) {
      case 0:
        return _selectedJourneyType != null ||
            _customJourneyController.text.isNotEmpty;
      case 1:
        return _selectedFrequency != null ||
            _customFrequencyController.text.isNotEmpty;
      case 2:
        return _selectedPlanningDuration != null ||
            _customPlanningController.text.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A574),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.flight_takeoff,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Journey Sense',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Progress indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentStep ? 40 : 30,
                        height: 4,
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? const Color(0xFFD4A574)
                              : const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step ${_currentStep + 1} of 3',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildStepContent(),
              ),
            ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _canContinue() ? _nextStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC0C0C0),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(
                      0xFFC0C0C0,
                    ).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentStep < 2 ? 'Continue' : 'Finish',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildQuestion1();
      case 1:
        return _buildQuestion2();
      case 2:
        return _buildQuestion3();
      default:
        return const SizedBox();
    }
  }

  // Question 1: Journey Type
  Widget _buildQuestion1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What kind of journeys do you enjoy the most?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select the option that resonates with you',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // Options
        ...List.generate(_journeyTypes.length, (index) {
          final journey = _journeyTypes[index];
          final isSelected = _selectedJourneyType == journey['title'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedJourneyType = journey['title'];
                _customJourneyController.clear();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD4A574)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0E8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      journey['icon'],
                      color: const Color(0xFFD4A574),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          journey['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          journey['subtitle'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 16),

        // Custom input
        TextField(
          controller: _customJourneyController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _selectedJourneyType = null;
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Or type your own...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  // Question 2: Travel Frequency
  Widget _buildQuestion2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bạn có thường xuyên đi du lịch hay không?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Chọn mức độ phù hợp với bạn',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // Options
        ...List.generate(_frequencies.length, (index) {
          final frequency = _frequencies[index];
          final isSelected = _selectedFrequency == frequency;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFrequency = frequency;
                _customFrequencyController.clear();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD4A574)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? const Color(0xFFD4A574) : Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    frequency,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 16),

        // Custom input
        TextField(
          controller: _customFrequencyController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _selectedFrequency = null;
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Hoặc nhập câu trả lời của bạn...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  // Question 3: Planning Duration
  Widget _buildQuestion3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bạn thường lập kế hoạch trong bao lâu?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Thời gian bạn dành để lên kế hoạch cho chuyến đi',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // Options
        ...List.generate(_planningDurations.length, (index) {
          final duration = _planningDurations[index];
          final isSelected = _selectedPlanningDuration == duration;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPlanningDuration = duration;
                _customPlanningController.clear();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD4A574)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? const Color(0xFFD4A574) : Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 16),

        // Custom input
        TextField(
          controller: _customPlanningController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _selectedPlanningDuration = null;
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Hoặc nhập thời gian của bạn...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
