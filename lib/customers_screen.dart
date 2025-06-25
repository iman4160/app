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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to take full height if needed
      backgroundColor: Colors.transparent, // To show custom shape
      builder: (context) {
        return _CustomerForm(
          customerToEdit: customerToEdit,
          nextCustomerId: _nextCustomerId.toString(), // Pass auto-increment ID
          onSubmit: (Customer customer) {
            if (customerToEdit == null) {
              _addCustomer(customer);
            } else {
              _updateCustomer(customer);
            }
            Navigator.pop(context); // Close the bottom sheet after submission
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonFontSize = screenWidth * 0.045; // Responsive button font size
    final double tableHeaderFontSize = screenWidth * 0.038; // Responsive table header font size
    final double tableDataFontSize = screenWidth * 0.035; // Responsive table data font size
    final double iconButtonSize = screenWidth * 0.05; // Responsive size for edit/delete icons

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
                padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showCustomerFormBottomSheet(), // Register new customer
                    icon: Icon(Icons.person_add, color: textColor),
                    label: Text(
                      'Register Customer',
                      style: TextStyle(color: textColor, fontSize: buttonFontSize),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
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
                    style: TextStyle(color: hintColor, fontSize: buttonFontSize),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Allows horizontal scrolling for wide table
                  child: DataTable(
                    columnSpacing: screenWidth * 0.05, // Responsive column spacing
                    dataRowMinHeight: 50,
                    dataRowMaxHeight: 60,
                    headingRowColor: MaterialStateProperty.resolveWith((states) => accentBlue.withOpacity(0.8)), // Header color
                    dataRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey[850]), // Row background
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: tableHeaderFontSize, // Responsive font size
                    ),
                    dataTextStyle: TextStyle(
                      color: textColor,
                      fontSize: tableDataFontSize, // Responsive font size
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
                                icon: Icon(Icons.edit, color: primaryGreen, size: iconButtonSize), // Responsive icon size
                                onPressed: () => _showCustomerFormBottomSheet(customerToEdit: customer),
                                tooltip: 'Edit Customer',
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.redAccent, size: iconButtonSize), // Responsive icon size
                                onPressed: () {
                                  // Show confirmation dialog before deleting
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.grey[900], // Dark background for dialog
                                      title: Text('Delete Customer', style: TextStyle(color: textColor, fontSize: buttonFontSize)), // Responsive font size
                                      content: Text('Are you sure you want to delete ${customer.firstName} ${customer.lastName}?', style: TextStyle(color: hintColor, fontSize: tableDataFontSize)), // Responsive font size
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel', style: TextStyle(color: textColor, fontSize: tableDataFontSize)), // Responsive font size
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _deleteCustomer(customer.id);
                                            Navigator.pop(context); // Close dialog
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red, // Red for delete action
                                          ),
                                          child: Text('Delete', style: TextStyle(color: textColor, fontSize: tableDataFontSize)), // Responsive font size
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

// --- _CustomerForm StatefulWidget for handling the customer registration/edit form ---
class _CustomerForm extends StatefulWidget {
  final Customer? customerToEdit;
  final String nextCustomerId;
  final Function(Customer) onSubmit; // Callback to return the submitted customer

  const _CustomerForm({
    super.key,
    this.customerToEdit,
    required this.nextCustomerId,
    required this.onSubmit,
  });

  @override
  State<_CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<_CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  String? _selectedGender;
  DateTime? _selectedBirthDate;

  final Color primaryGreen = const Color(0xFF1b9349);
  final Color accentBlue = const Color(0xFF3753a2);
  final Color textColor = Colors.white;
  final Color hintColor = Colors.white70;
  final Color inputFillColor = Colors.white.withOpacity(0.1);

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if editing, otherwise empty
    _firstNameController = TextEditingController(text: widget.customerToEdit?.firstName);
    _middleNameController = TextEditingController(text: widget.customerToEdit?.middleName);
    _lastNameController = TextEditingController(text: widget.customerToEdit?.lastName);
    _emailController = TextEditingController(text: widget.customerToEdit?.email);
    _phoneController = TextEditingController(text: widget.customerToEdit?.phone);
    _addressController = TextEditingController(text: widget.customerToEdit?.address);

    _selectedGender = widget.customerToEdit?.gender;
    _selectedBirthDate = widget.customerToEdit?.birthDate;
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

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

  // Helper for building TextFormFields consistently
  Widget _buildTextField(
      TextEditingController controller,
      String labelText,
      IconData icon, {
        String? Function(String?)? validator,
        TextInputType keyboardType = TextInputType.text,
      }) {
    // Get screen width for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputFontSize = screenWidth * 0.045; // Responsive font size

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.025), // Responsive margin
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor, fontSize: inputFontSize),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: hintColor, fontSize: inputFontSize),
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
          errorStyle: TextStyle(color: Colors.redAccent, fontSize: screenWidth * 0.035), // Responsive error font size
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double formTitleFontSize = screenWidth * 0.06; // Responsive form title font size
    final double buttonFontSize = screenWidth * 0.045; // Responsive button font size
    final double infoFontSize = screenWidth * 0.04; // For date text etc.


    return Container(
      height: MediaQuery.of(context).size.height * 0.9, // 90% of screen height
      decoration: BoxDecoration(
        color: Colors.grey[900], // Dark background for the sheet
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05, screenWidth * 0.05, screenWidth * 0.05, MediaQuery.of(context).viewInsets.bottom + screenWidth * 0.05, // Adjust padding for keyboard
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.customerToEdit == null ? 'Register New Customer' : 'Edit Customer',
                  style: TextStyle(
                    fontSize: formTitleFontSize, // Responsive font size
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
                  margin: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: inputFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: hintColor.withOpacity(0.3)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    dropdownColor: Colors.grey[800], // Darker background for dropdown list
                    style: TextStyle(color: textColor, fontSize: infoFontSize), // Responsive font size
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(color: hintColor, fontSize: infoFontSize),
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
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Gender is required' : null,
                  ),
                ),

                // Birth Date Picker
                Container(
                  margin: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
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
                                onPrimary: Colors.white, // Text color on primary (e.g., current year, selected date number)
                                surface: accentBlue, // Background color of the picker surface
                                onSurface: textColor, // Text color on surface (e.g., day numbers, month/year headers, "Select date" label)
                              ),
                              dialogBackgroundColor: Colors.grey[900],
                              // Explicitly set TextButtonTheme for Cancel/OK buttons in the DatePicker
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white, // This makes the "Cancel" and "OK" text white
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedBirthDate = pickedDate;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Birth Date',
                        labelStyle: TextStyle(color: hintColor, fontSize: infoFontSize),
                        hintText: 'Select your birth date',
                        hintStyle: TextStyle(color: hintColor, fontSize: infoFontSize),
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
                        style: TextStyle(color: textColor, fontSize: infoFontSize),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Customer must be at least 18 years old.')),
                          );
                          return;
                        }

                        final newCustomer = Customer(
                          id: widget.customerToEdit?.id ?? widget.nextCustomerId, // Use existing ID or new
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

                        widget.onSubmit(newCustomer); // Call the callback to submit
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all required fields and select gender/birth date.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      widget.customerToEdit == null ? 'Register Customer' : 'Save Changes',
                      style: TextStyle(
                        fontSize: buttonFontSize, // Responsive font size
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
  }
}
