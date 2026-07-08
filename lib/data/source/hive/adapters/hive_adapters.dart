import 'package:hive_ce/hive_ce.dart';

import '../../local/model/ContactHive.dart';
import '../../local/model/UserHive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<UserHive>(),
  AdapterSpec<ContactHive>(),
])
class HiveAdapters {}
