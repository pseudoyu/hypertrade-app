import 'package:flutter/material.dart';

class StartupFormPage2 extends StatefulWidget {
  const StartupFormPage2({super.key});

  @override
  StartupFormPage2State createState() => StartupFormPage2State();
}

class StartupFormPage2State extends State<StartupFormPage2> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String _name = '';
  String _startupName = '';
  String _location = 'America';
  final List<String> _selectedIndustries = [];
  final List<String> _selectedSectors = [];
  String _positionTitle = 'Founder/Co-founders';
  String _fundingRound = 'Ideation Stage';
  String _revenue = 'Pre-revenue';

  // Location Options
  final List<String> _locations = [
    'America',
    'Canada',
    'Remote',
    'Europe',
    'South Asia',
    'Latin America',
    'Southeast Asia',
    'Africa',
    'Middle East and North Africa',
    'East Asia',
    'Oceania'
  ];

  // Industry Options
  final List<String> _industries = [
    'B2B',
    'B2B-Analytics',
    'B2B-Engineering, Products and Design',
    'B2B-Finance and Accounting',
    'B2B-Human Resources',
    'B2B-Infrastructure',
    'B2B-Legal',
    'B2B-Marketing',
    'B2B-Office Management',
    'B2B-Operations',
    'B2B-Productivity',
    'B2B-Recruiting and Talent',
    'B2B-Retail',
    'B2B-Sales',
    'B2B-Security',
    'B2B-Supply Chain and Logistics',
    'Education',
    'Fintech-Asset Management',
    'Fintech-Banking and Exchange',
    'Fintech-Consumer Finance',
    'Fintech-Credit and Lending',
    'Fintech-Insurance',
    'Fintech-Payments',
    'Consumer-Apparel and Cosmetics',
    'Consumer-Electronics',
    'Consumer-Content',
    'Consumer-Food and Beverage',
    'Consumer-Gaming',
    'Consumer-Home and Personal',
    'Consumer-Job and Career Services',
    'Consumer-Social',
    'Consumer-Transportation Services',
    'Consumer-Travel, Leisure and Tourism',
    'Consumer-Virtual and Augmented Reality',
    'Healthcare-Consumer Health and Wellness',
    'Healthcare-Diagnostics',
    'Healthcare-Drug Discovery and Delivery',
    'Healthcare-IT',
    'Healthcare-Services',
    'Healthcare-Industrial Bio',
    'Healthcare-Medical Devices',
    'Healthcare-Therapeutics',
    'Real Estate and Construction',
    'Housing and Real Estate',
    'Industrials-Agriculture',
    'Industrials-Automotive',
    'Industrials-Aviation and Space',
    'Industrials-Climate',
    'Industrials-Drones',
    'Industrials-Energy',
    'Industrials-Manufacturing and Robotics',
    'Government',
    'Unspecified'
  ];

  // Sector Options
  final List<String> _sectors = [
    'FinTech (Financial Services)',
    'Artificial Intelligence (AI) and Machine Learning',
    'Internet of Things',
    'Robotics',
    'Healthcare Tech',
    'Biotech',
    'Medtech and Fitness',
    'Virtual Reality (VR, AR, XR)',
    'Edtech (Educational Technology)',
    'Blockchain, Web3 and Crypto',
    'AgriTech',
    'Ecommerce',
    'B2B Software',
    'Construction',
    'Cybersecurity',
    'Supply Chain & Logistics',
    'Travel, Leisure & Entertainment',
    'Streaming Services',
    'B2C (Business-to-consumers)',
    'Shared Mobility',
    'Delivery Services',
    'Tech Startup',
    'Real Estate',
    'Sustainability & Clean Energy',
    'Transportation',
    'Social Startups',
    'Climate Technology',
    'Mining & Material Resources'
  ];

  // Position Title Options
  final List<String> _positionTitles = [
    'Founder/Co-founders',
    'Stakeholders',
    'Investors',
    'CEO',
    'CTO',
    'CFO',
    'CMO',
    'COO',
    'CPO',
    'Product Manager',
    'Sales & Marketing',
    'Engineers',
    'Scientists',
    'Others'
  ];

  // Funding Rounds Options
  final List<String> _fundingRounds = [
    'Ideation Stage',
    'MVP',
    'Bootstrapping',
    'Debt Financing and Loans',
    'Crowdfunding',
    'Angle Round',
    'Pre-seed Round',
    'Seed',
    'Series A',
    'Series B',
    'Series C',
    'Series D',
    'IPO',
    'M&A and Exit'
  ];

  // Revenue ARR Options
  final List<String> _revenues = [
    'Pre-revenue',
    '0-50,000',
    '50,000 - 100,000',
    '100,000 - 500,000',
    '500,000 - 1,000,000',
    '1,000,000 - 5,000,000',
    '> 5,000,000'
  ];

  // final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Form'),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            _buildNameField(),
            _buildStartupNameField(),
            _buildLocationField(),
            _buildIndustriesField(),
            _buildSectorsField(),
            _buildPositionTitleField(),
            _buildFundingRoundField(),
            _buildRevenueField(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              ElevatedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: const Text('Back'),
              ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_currentPage == 7) {
                    // Submit form
                    print(_name);
                    print(_startupName);
                    print(_location);
                    print(_selectedIndustries);
                    print(_selectedSectors);
                    print(_positionTitle);
                    print(_fundingRound);
                    print(_revenue);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form Submitted!')),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                }
              },
              child: Text(_currentPage == 7 ? 'Submit' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Name',
            style: TextStyle(fontSize: 20),
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onChanged: (value) {
              _name = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStartupNameField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Startup Name',
            style: TextStyle(fontSize: 20),
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your startup name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your startup name';
              }
              return null;
            },
            onChanged: (value) {
              _startupName = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(fontSize: 20),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              hintText: 'Select your location',
            ),
            initialValue: _location,
            items: _locations.map((location) {
              return DropdownMenuItem(
                value: location,
                child: Text(location),
              );
            }).toList(),
            onChanged: (value) {
              _location = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIndustriesField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Industries',
            style: TextStyle(fontSize: 20),
          ),
          ..._industries.map((industry) {
            return CheckboxListTile(
              title: Text(industry),
              value: _selectedIndustries.contains(industry),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedIndustries.add(industry);
                  } else {
                    _selectedIndustries.remove(industry);
                  }
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectorsField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sectors',
            style: TextStyle(fontSize: 20),
          ),
          ..._sectors.map((sector) {
            return CheckboxListTile(
              title: Text(sector),
              value: _selectedSectors.contains(sector),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedSectors.add(sector);
                  } else {
                    _selectedSectors.remove(sector);
                  }
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPositionTitleField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Position Title',
            style: TextStyle(fontSize: 20),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              hintText: 'Select your position title',
            ),
            initialValue: _positionTitle,
            items: _positionTitles.map((position) {
              return DropdownMenuItem(
                value: position,
                child: Text(position),
              );
            }).toList(),
            onChanged: (value) {
              _positionTitle = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFundingRoundField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Funding Round',
            style: TextStyle(fontSize: 20),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              hintText: 'Select funding round',
            ),
            initialValue: _fundingRound,
            items: _fundingRounds.map((round) {
              return DropdownMenuItem(
                value: round,
                child: Text(round),
              );
            }).toList(),
            onChanged: (value) {
              _fundingRound = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue ARR (USD)',
            style: TextStyle(fontSize: 20),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              hintText: 'Select revenue ARR',
            ),
            initialValue: _revenue,
            items: _revenues.map((revenue) {
              return DropdownMenuItem(
                value: revenue,
                child: Text(revenue),
              );
            }).toList(),
            onChanged: (value) {
              _revenue = value!;
            },
          ),
        ],
      ),
    );
  }
}
