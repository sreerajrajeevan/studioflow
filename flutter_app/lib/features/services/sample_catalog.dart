import '../../domain/models.dart';

/// SAMPLE service catalog. Since Task 1.7 this is the first-run SEED for
/// the Drift catalog (and the in-memory fallback while the database
/// loads) — clearly labelled sample data, replaced by owner-managed data
/// in the catalog task. Prices are the demo prices (INR → paise).
abstract final class SampleCatalog {
  static const categories = <String>['Hair', 'Beard', 'Facial'];

  static const services = <ServiceItem>[
    // Hair
    ServiceItem(
      id: 'svc_haircut',
      name: 'Haircut',
      category: 'Hair',
      pricePaise: 30000,
      durationMinutes: 30,
    ),
    ServiceItem(
      id: 'svc_hair_wash',
      name: 'Hair Wash',
      category: 'Hair',
      pricePaise: 20000,
      durationMinutes: 15,
    ),
    ServiceItem(
      id: 'svc_hair_spa',
      name: 'Hair Spa',
      category: 'Hair',
      pricePaise: 90000,
      durationMinutes: 45,
    ),
    ServiceItem(
      id: 'svc_hair_colour',
      name: 'Hair Colour',
      category: 'Hair',
      pricePaise: 150000,
      durationMinutes: 60,
    ),
    // Beard
    ServiceItem(
      id: 'svc_beard_trim',
      name: 'Beard Trim',
      category: 'Beard',
      pricePaise: 15000,
      durationMinutes: 15,
    ),
    ServiceItem(
      id: 'svc_clean_shave',
      name: 'Clean Shave',
      category: 'Beard',
      pricePaise: 12000,
      durationMinutes: 15,
    ),
    ServiceItem(
      id: 'svc_beard_styling',
      name: 'Beard Styling',
      category: 'Beard',
      pricePaise: 20000,
      durationMinutes: 20,
    ),
    // Facial
    ServiceItem(
      id: 'svc_facial',
      name: 'Facial',
      category: 'Facial',
      pricePaise: 60000,
      durationMinutes: 40,
    ),
    ServiceItem(
      id: 'svc_gold_facial',
      name: 'Gold Facial',
      category: 'Facial',
      pricePaise: 120000,
      durationMinutes: 60,
    ),
    ServiceItem(
      id: 'svc_head_massage',
      name: 'Head Massage',
      category: 'Facial',
      pricePaise: 35000,
      durationMinutes: 25,
    ),
  ];

  static List<ServiceItem> byCategory(String? category, String query) {
    final q = query.trim().toLowerCase();
    return services.where((s) {
      if (!s.isActive) return false;
      if (category != null && s.category != category) return false;
      if (q.isNotEmpty && !s.name.toLowerCase().contains(q)) return false;
      return true;
    }).toList();
  }
}

/// SAMPLE staff for attendance/employees/payroll prototypes.
abstract final class SampleStaff {
  static const employees = <Employee>[
    Employee(
      id: 'emp_1',
      name: 'Arun Kumar',
      role: 'Senior Stylist',
      salaryType: SalaryType.monthly,
      monthlySalaryPaise: 2800000,
    ),
    Employee(
      id: 'emp_2',
      name: 'Vijay Menon',
      role: 'Stylist',
      salaryType: SalaryType.monthly,
      monthlySalaryPaise: 2200000,
    ),
    Employee(
      id: 'emp_3',
      name: 'Rahul Nair',
      role: 'Stylist',
      salaryType: SalaryType.monthly,
      monthlySalaryPaise: 2000000,
    ),
    Employee(
      id: 'emp_4',
      name: 'Deepak Raj',
      role: 'Assistant',
      salaryType: SalaryType.monthly,
      monthlySalaryPaise: 1400000,
    ),
    Employee(
      id: 'emp_5',
      name: 'Sanjay Pillai',
      role: 'Assistant',
      salaryType: SalaryType.daily,
      monthlySalaryPaise: 0,
    ),
  ];
}
