// lib/customers_screen.dart

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:newproject/customer.dart'; // Import our Customer model

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  // GetStorage instance for local data persistence
  final GetStorage _box = GetStorage();
  // List to hold our customer data, using ValueNotifier for instant UI updates
  final ValueNotifier<List<Customer>> _customers = ValueNotifier([]);
  // Tracks the next available customer ID
  late int _nextCustomerId;

  // Custom colors for consistent theming
  final Color primaryGreen = const Color(0xFF1b9349);
  final Color accentBlue = const Color(0xFF3753a2);
  final Color textColor = Colors.white;
  final Color hintColor = Colors.white70;
  final Color inputFillColor = Colors.white.withOpacity(0.1);

  @override
  void initState() {
    super.initState();
    _loadCustomers(); // Load customers when the screen initializes
  }

  // --- Local Storage Operations ---

  // Loads customer data from GetStorage
  Future<void> _loadCustomers() async {
    // Read the list of customers. If null, default to an empty list.
    final List<dynamic>? storedData = _box.read('customers');
    List<Customer> loadedCustomers = [];

    if (storedData != null) {
      // Deserialize each map back into a Customer object
      loadedCustomers = storedData.map((e) => Customer.fromJson(e as Map<String, dynamic>)).toList();
      // Sort customers by ID to maintain auto-incremental order for ID generation
      loadedCustomers.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
      // Determine the next customer ID based on the highest existing ID
      if (loadedCustomers.isNotEmpty) {
        _nextCustomerId = int.parse(loadedCustomers.last.id) + 1;
      } else {
        _nextCustomerId = 1; // Start from 1 if no customers exist
      }
    } else {
      _nextCustomerId = 1; // Start from 1 if no data is stored
    }

    // Update the ValueNotifier to trigger UI rebuild
    _customers.value = loadedCustomers;
  }

  // Saves the current list of customers to GetStorage
  Future<void> _saveCustomers() async {
    // Serialize each Customer object into a JSON map before saving
    final List<Map<String, dynamic>> dataToStore = _customers.value.map((e) => e.toJson()).toList();
    await _box.write('customers', dataToStore);
  }

  // --- Customer Data Management ---

  // Calculates age from a given birth date
  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Adds a new customer to the list and saves
  void _addCustomer(Customer customer) {
    List<Customer> currentCustomers = List.from(_customers.value);
    currentCustomers.add(customer);
    _customers.value = currentCustomers; // Update ValueNotifier
    _saveCustomers(); // Persist changes
    _nextCustomerId++; // Increment for the next new customer
    _showSnackBar('Customer Registered Successfully!');
  }

  // Updates an existing customer in the list and saves
  void _updateCustomer(Customer updatedCustomer) {
    List<Customer> currentCustomers = _customers.value.map((c) {
      return c.id == updatedCustomer.id ? updatedCustomer : c;
    }).toList();
    _customers.value = currentCustomers; // Update ValueNotifier
    _saveCustomers(); // Persist changes
    _showSnackBar('Customer Updated Successfully!');
  }

  // Deletes a customer from the list and saves
  void _deleteCustomer(String customerId) {
    List<Customer> currentCustomers = List.from(_customers.value);
    currentCustomers.removeWhere((customer) => customer.id == customerId);
    _customers.value = currentCustomers; // Update ValueNotifier
    _saveCustomers(); // Persist changes
    _showSnackBar('Customer Deleted Successfully!');
  }

  // --- UI Helpers ---

  // Shows a temporary snackbar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Shows the form bottom sheet for registering or editing a customer
  void _showCustomerFormBottomSheet({Customer? customerToEdit}) {
    // Form controllers
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _firstNameController = TextEditingController(text: customerToEdit?.firstName);
    final TextEditingController _middleNameController = TextEditingController(text: customerToEdit?.middleName);
    final TextEditingController _lastNameController = TextEditingController(text: customerToEdit?.lastName);
    final TextEditingController _emailController = TextEditingController(text: customerToEdit?.email);
    final TextEditingController _phoneController = TextEditingController(text: customerToEdit?.phone);
    final TextEditingController _addressController = TextEditingController(text: customerToEdit?.address);

    String? _selectedGender = customerToEdit?.gender;
    DateTime? _selectedBirthDate = customerToEdit?.birthDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to take full height if needed
      backgroundColor: Colors.transparent, // To show custom shape
      builder: (context) {
        return StatefulBuilder( // Use StatefulBuilder to manage state within the bottom sheet
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9, // 90% of screen height
              decoration: BoxDecoration(
                color: Colors.grey[900], // Dark background for the sheet
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20, // Adjust padding for keyboard
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          customerToEdit == null ? 'Register New Customer' : 'Edit Customer',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // --- Form Fields ---
                        _buildTextField(_firstNameController, 'First Name', Icons.person, validator: (value) => value!.isEmpty ? 'First Name is required' : null),
                        _buildTextField(_middleNameController, 'Middle Name (Optional)', Icons.person_outline),
                        _buildTextField(_lastNameController, 'Last Name', Icons.person, validator: (value) => value!.isEmpty ? 'Last Name is required' : null),
                        _buildTextField(_emailController, 'Email', Icons.email, validator: (value) {
                          if (value!.isEmpty) return 'Email is required';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                          return null;
                        }),
                        _buildTextField(_phoneController, 'Phone', Icons.phone, validator: (value) => value!.isEmpty ? 'Phone is required' : null, keyboardType: TextInputType.phone),
                        _buildTextField(_addressController, 'Address', Icons.location_on, validator: (value) => value!.isEmpty ? 'Address is required' : null),

                        // Gender Dropdown
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: inputFillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: hintColor.withOpacity(0.3)),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedGender,
                            dropdownColor: Colors.grey[800], // Darker background for dropdown list
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              labelStyle: TextStyle(color: hintColor),
                              prefixIcon: Icon(Icons.transgender, color: primaryGreen), // Changed from male_female
                              border: InputBorder.none, // No border, as container has it
                            ),
                            items: <String>['Male', 'Female', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setModalState(() {
                                _selectedGender = newValue;
                              });
                            },
                            validator: (value) => value == null ? 'Gender is required' : null,
                          ),
                        ),

                        // Birth Date Picker
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: InkWell(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)), // Default to 18 years ago
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith( // Dark theme for date picker
                                      colorScheme: ColorScheme.dark(
                                        primary: primaryGreen, // Accent color
                                        onPrimary: Colors.white, // Text color on accent
                                        surface: accentBlue, // Background color
                                        onSurface: textColor, // Text color on background
                                      ),
                                      dialogBackgroundColor: Colors.grey[900],
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                setModalState(() {
                                  _selectedBirthDate = pickedDate;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Birth Date',
                                labelStyle: TextStyle(color: hintColor),
                                hintText: 'Select your birth date',
                                hintStyle: TextStyle(color: hintColor),
                                prefixIcon: Icon(Icons.calendar_today, color: primaryGreen),
                                filled: true,
                                fillColor: inputFillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: primaryGreen, width: 2),
                                ),
                              ),
                              child: Text(
                                _selectedBirthDate == null
                                    ? 'Select Date'
                                    : DateFormat('dd/MM/yyyy').format(_selectedBirthDate!),
                                style: TextStyle(color: textColor, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() && _selectedGender != null && _selectedBirthDate != null) {
                                final int age = _calculateAge(_selectedBirthDate!);
                                if (age < 18) {
                                  _showSnackBar('Customer must be at least 18 years old.');
                                  return;
                                }

                                final newCustomer = Customer(
                                  id: customerToEdit?.id ?? _nextCustomerId.toString(), // Use existing ID or new
                                  firstName: _firstNameController.text,
                                  middleName: _middleNameController.text.isEmpty ? null : _middleNameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  address: _addressController.text,
                                  gender: _selectedGender!,
                                  birthDate: _selectedBirthDate!,
                                  age: age,
                                );

                                if (customerToEdit == null) {
                                  _addCustomer(newCustomer);
                                } else {
                                  _updateCustomer(newCustomer);
                                }
                                Navigator.pop(context); // Close the bottom sheet
                              } else {
                                _showSnackBar('Please fill all required fields and select gender/birth date.');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              customerToEdit == null ? 'Register Customer' : 'Save Changes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // Dispose controllers when the bottom sheet is closed
      _firstNameController.dispose();
      _middleNameController.dispose();
      _lastNameController.dispose();
      _emailController.dispose();
      _phoneController.dispose();
      _addressController.dispose();
    });
  }

  // Helper for building TextFormFields consistently
  Widget _buildTextField(
      TextEditingController controller,
      String labelText,
      IconData icon, { // Changed to named optional parameters
        String? Function(String?)? validator,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(icon, color: primaryGreen),
          filled: true,
          fillColor: inputFillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryGreen, width: 2),
          ),
          errorStyle: TextStyle(color: Colors.redAccent),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          'Customers',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: accentBlue,
        centerTitle: true,
        elevation: 0,
      ),
      body: ValueListenableBuilder<List<Customer>>(
        valueListenable: _customers, // Listen to changes in _customers
        builder: (context, customersList, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showCustomerFormBottomSheet(), // Register new customer
                    icon: Icon(Icons.person_add, color: textColor),
                    label: Text(
                      'Register Customer',
                      style: TextStyle(color: textColor, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: customersList.isEmpty
                    ? Center(
                  child: Text(
                    'No customers registered yet. Click "Register Customer" to add one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: hintColor, fontSize: 16),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Allows horizontal scrolling for wide table
                  child: DataTable(
                    columnSpacing: 20, // Adjust spacing between columns
                    dataRowMinHeight: 50,
                    dataRowMaxHeight: 60,
                    headingRowColor: MaterialStateProperty.resolveWith((states) => accentBlue.withOpacity(0.8)), // Header color
                    dataRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey[850]), // Row background
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 15,
                    ),
                    dataTextStyle: TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Customer ID')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('Gender')),
                      DataColumn(label: Text('Age')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: customersList.map<DataRow>((customer) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(customer.id)),
                          DataCell(Text('${customer.firstName} ${customer.middleName != null ? '${customer.middleName} ' : ''}${customer.lastName}')),
                          DataCell(Text(customer.phone)),
                          DataCell(Text(customer.email)),
                          DataCell(Text(customer.address)),
                          DataCell(Text(customer.gender)),
                          DataCell(Text(customer.age.toString())),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: primaryGreen),
                                onPressed: () => _showCustomerFormBottomSheet(customerToEdit: customer),
                                tooltip: 'Edit Customer',
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () {
                                  // Show confirmation dialog before deleting
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.grey[900], // Dark background for dialog
                                      title: Text('Delete Customer', style: TextStyle(color: textColor)),
                                      content: Text('Are you sure you want to delete ${customer.firstName} ${customer.lastName}?', style: TextStyle(color: hintColor)),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel', style: TextStyle(color: primaryGreen)),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _deleteCustomer(customer.id);
                                            Navigator.pop(context); // Close dialog
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red, // Red for delete action
                                          ),
                                          child: Text('Delete', style: TextStyle(color: textColor)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                tooltip: 'Delete Customer',
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
