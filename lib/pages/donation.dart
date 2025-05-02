import 'package:flutter/material.dart';
import '../widgets/drawer.dart' as prefix;
import '../widgets/footer.dart' as prefix;
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';
import '../pages/home.dart' as home;
import '../widgets/appbar.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationState();
}

class _DonationState extends State<DonationPage> {
  bool isSwitched = true;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedPaymentMethod = 'Credit Card';
  String _selectedCurrency = 'USD';
  final List<String> _paymentMethods = ['Credit Card', 'PayPal', 'Bank Transfer'];
  final List<Map<String, dynamic>> _currencies = [
    {'code': 'EUR', 'symbol': '€'},
    {'code': 'USD', 'symbol': '\$'}
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Container _searchField() {
    double appBarHeight = AppBar().preferredSize.height;
    // double appBarWidth = AppBar().preferredSize.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: appBarHeight / 2, 
      width: appBarHeight * 4 ,

      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 10.0),
            ),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {},
            );
          });
        },
      ),
    );
  }

  Widget _buildDonationForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 176, 221, 252),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Make a Donation',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: _currencies
                          .firstWhere((c) => c['code'] == _selectedCurrency)['symbol'],
                      prefixStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter an amount';
                      if (double.tryParse(value) == null) return 'Please enter a valid number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCurrency,
                  items: _currencies.map((currency) {
                    return DropdownMenuItem<String>(
                      value: currency['code'],
                      child: Text(currency['code']),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCurrency = value!),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              children: [10, 20, 50, 100].map((amount) {
                return ElevatedButton(
                  onPressed: () {
                    _amountController.text = amount.toString();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 176, 233),
                  ),
                  child: Text(
                      '${_currencies.firstWhere((c) => c['code'] == _selectedCurrency)['symbol']}$amount'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              items: _paymentMethods.map((method) {
                IconData icon;
                switch (method) {
                  case 'Credit Card':
                    icon = Icons.credit_card;
                    break;
                  case 'PayPal':
                    icon = Icons.paypal;
                    break;
                  case 'Bank Transfer':
                    icon = Icons.account_balance;
                    break;
                  default:
                    icon = Icons.attach_money;
                }
                return DropdownMenuItem(
                  value: method,
                  child: Row(
                    children: [
                      Icon(icon),
                      const SizedBox(width: 8),
                      Text(method),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
              decoration: InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Leave your message here (optional)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Message ...',
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Thank You!'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thank you for your donation!',
                            ),
                            if (_messageController.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Your message: ${_messageController.text}',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                    _formKey.currentState!.reset();
                    _messageController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('Donate', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(
        onTitleTapped: () {
          // Add navigation logic if needed
          Navigator.push(context, MaterialPageRoute(builder: (context) => home.HomePage()));
        },
      ),
      drawer: const prefix.NavigationDrawer(location: 'Donation'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _buildDonationForm(context),
            ),
          ),
          const prefix.Footer(),
        ],
      ),
    );
  }
}