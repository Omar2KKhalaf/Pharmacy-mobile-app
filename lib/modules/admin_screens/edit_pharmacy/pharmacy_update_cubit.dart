import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacy/pharmacy_update_state.dart';

import '../../../models/pharmacy_model/pharmacy_model.dart';

class PharmacyUpdateCubit extends Cubit<PharmacyUpdateState> {
  PharmacyUpdateCubit() : super(InitialPharmacyUpdateState());

  static PharmacyUpdateCubit get(context) => BlocProvider.of(context);

  typing() {
    emit(TypingPharmacyState());
  }

  setControllers(name, address, description, phone, pharmacyModel) {
    name.text = pharmacyModel.name;
    address.text = pharmacyModel.address;
    description.text = pharmacyModel.description;
    phone.text = pharmacyModel.phone;
    emit(SetControllersPharmacyUpdateCubit());
  }

  addPharmacy(PharmacyModel pharmacyModel) async {
    String id = FirebaseFirestore.instance.collection('pharmacies').doc().id;
    pharmacyModel.pharmacyid = id;
    await FirebaseFirestore.instance
        .collection('pharmacies')
        .doc(id)
        .set(pharmacyModel.toMap())
        .then((value) {
      emit(SuccessAddPharmacyState());
    }).catchError((onError) {
      emit(ErrorPharmacyUpdateState());
    });
  }

  deletePharmacy(pharmacyId) async {
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(pharmacyId)
        .delete()
        .then((value) {
      emit(SuccessDeletePharmacyState());
    }).catchError((error) {
      emit(ErrorDeletePharmacyState());
    });
  }

  updatePharmacy(PharmacyModel pharmacyModel) async {
    Map<String, dynamic> toMap = {};
    toMap["name"] = pharmacyModel.name;
    toMap["address"] = pharmacyModel.address;
    toMap["description"] = pharmacyModel.description;
    toMap["phone"] = pharmacyModel.phone;
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(pharmacyModel.pharmacyid)
        .update(toMap)
        .then((value) {
      emit(SuccessPharmacyUpdateState());
    }).catchError((error) {
      emit(ErrorPharmacyUpdateState());
    });
  }
}
