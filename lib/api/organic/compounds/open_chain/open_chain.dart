import 'package:quimify_client/api/organic/components/group.dart';
import 'package:quimify_client/api/organic/components/substituent.dart';
import 'package:quimify_client/api/organic/organic.dart';

abstract class OpenChain extends Organic {
  bool isDone();

  int getFreeBondCount();

  List<Group> getBondableGroups();

  OpenChain bondSubstituent(Substituent substituent);

  OpenChain bondGroup(Group function);

  bool canBondCarbon();

  void bondCarbon();

  String getStructure();

  OpenChain getCopy();
}
