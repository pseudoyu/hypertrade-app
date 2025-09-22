import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_app/provider/onboard_provider.dart';
import 'package:hyper_app/widgets/custom_dropdown_field.dart';
import 'package:hyper_app/widgets/custom_multi_checkbox_filed.dart';
import 'package:hyper_app/widgets/custom_text_from_field.dart';
import 'package:hyper_app/widgets/loading.dart';
import 'package:provider/provider.dart';

class StartupFormPage extends StatefulWidget {
  const StartupFormPage({super.key});

  @override
  StartupFormPageState createState() => StartupFormPageState();
}

class StartupFormPageState extends State<StartupFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String _name = '';
  String _startupName = '';
  String _location = 'America';
  List<String> _selectedIndustries = [];
  List<String> _selectedSectors = [];
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
    'Bootstrapping 自费',
    'Debt Financing and Loans',
    'Crowdfunding 众筹',
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

  @override
  Widget build(BuildContext context) {
    final onboardProvider = Provider.of<OnboardProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Form'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Basic Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Name Field
                CustomTextFormField(
                  labelText: 'Your Name',
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.person, color: Colors.blue),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),

                // Startup Name Field
                CustomTextFormField(
                  labelText: 'Startup Name',
                  hintText: 'Enter your startup name',
                  prefixIcon: const Icon(Icons.business, color: Colors.blue),
                  onChanged: (value) {
                    setState(() {
                      _startupName = value;
                    });
                  },
                ),

                // Location Dropdown
                CustomDropdownButtonFormField(
                  labelText: 'Location',
                  prefixIcon: Icons.location_on,
                  value: _location,
                  items: _locations,
                  onChanged: (value) {
                    setState(() {
                      _location = value!;
                    });
                  },
                ),

                // Position Title Dropdown
                CustomDropdownButtonFormField(
                  labelText: 'Position Title',
                  prefixIcon:
                      Icons.work, // Using 'work' icon for Position Title
                  value: _positionTitle,
                  items: _positionTitles,
                  onChanged: (value) {
                    setState(() {
                      _positionTitle = value!;
                    });
                  },
                ),

                // Funding Round Dropdown
                CustomDropdownButtonFormField(
                  labelText: 'Funding Round',
                  prefixIcon: Icons
                      .monetization_on, // Using 'monetization_on' icon for Funding Round
                  value: _fundingRound,
                  items: _fundingRounds,
                  onChanged: (value) {
                    setState(() {
                      _fundingRound = value!;
                    });
                  },
                ),

                // Revenue ARR Dropdown
                CustomDropdownButtonFormField(
                  labelText: 'Revenue ARR (USD)',
                  prefixIcon: Icons
                      .attach_money, // Using 'attach_money' icon for Revenue ARR
                  value: _revenue,
                  items: _revenues,
                  onChanged: (value) {
                    setState(() {
                      _revenue = value!;
                    });
                  },
                ),

                // Industry Multiselect
                MultiSelectCheckboxList(
                  title: 'Select your Industry', // 传入 title 参数
                  items: _industries,
                  selectedItems: _selectedIndustries,
                  onSelectionChanged: (selectedItems) {
                    setState(() {
                      _selectedIndustries = selectedItems;
                    });
                  },
                ),

                // Sector Multiselect
                MultiSelectCheckboxList(
                  title: 'Select your Sector',
                  items: _sectors,
                  selectedItems: _selectedSectors,
                  onSelectionChanged: (selectedItems) {
                    setState(() {
                      _selectedSectors = selectedItems;
                    });
                  },
                ),

                // Submit Button
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _selectedIndustries.isNotEmpty &&
                            _selectedSectors.isNotEmpty) {
                          await onboardProvider
                              .updateUserInfo(
                            name: _name,
                            companyName: _startupName,
                            location: _location,
                            stage: _fundingRound,
                            revenue: _revenue,
                            industry: _selectedIndustries.join(';'),
                            category: _selectedSectors.join(';'),
                          )
                              .then((_) {
                            if (onboardProvider.isRequestError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing failed')),
                              );
                            } else {
                              // Show a snackbar with a success message
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                duration: const Duration(seconds: 1),
                                content: AwesomeSnackbarContent(
                                  title: 'Submitting Successful!',
                                  message: 'You have been login successfully.',
                                  contentType: ContentType.success,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);

                              // 使用 Future.delayed 来延迟导航
                              Future.delayed(const Duration(seconds: 3), () {
                                context.go('/');
                                // context.goNamed('/');
                              });
                            }
                          });
                        } else {
                          // Form data is valid
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please fill out the form completely')),
                          );
                        }
                      },
                      child: onboardProvider.isLoading
                          ? const LoadingWidget()
                          : const Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
