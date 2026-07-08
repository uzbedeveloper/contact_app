import 'package:bloc/bloc.dart';
import 'package:contact_app/domain/repository/app_repository.dart';
import '../../data/source/local/model/contact.dart';

part 'contact_event.dart';

part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final AppRepository _appRepository;

  ContactBloc(this._appRepository) : super(ContactState(isLoading: false)) {
    on<LoadContacts>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final String? user = _appRepository.getLoggedInUser();
        if(user == null){
          emit(state.copyWith(isLoading: false,error: "User topilmai"));
          return;
        }
        final List<Contact> list = await _appRepository.getContactsAsync(
          user,
        );
        if (list.isEmpty) {
          emit(state.copyWith(isLoading: false));
        } else {
          emit(state.copyWith(isLoading: false, list: list));
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "Internet bilan muammo"));
      }
    });
    on<AddContact>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final String? user = _appRepository.getLoggedInUser();
        if(user == null){
          emit(state.copyWith(isLoading: false,error: "User topilmai"));
          return;
        }
        final bool result = await _appRepository.addContact(
          user,
          event.name,
          event.phone,
        );
        if (result) {
          emit(state.copyWith(isLoading: false, isOperationSuccess: true));
        } else {
          emit(
            state.copyWith(isLoading: false, error: "Kontakt qo'shib bo'lmadi"),
          );
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "Internet bilan muammo"));
      }
    });
    on<EditContact>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final String? user = _appRepository.getLoggedInUser();
        if(user == null){
          emit(state.copyWith(isLoading: false,error: "User topilmai"));
          return;
        }
        await _appRepository.updateContact(
          user,
          event.docId,
          event.name,
          event.phone,
        );
        emit(state.copyWith(isLoading: false, isOperationSuccess: true));
      } catch (e) {
        emit(
          state.copyWith(isLoading: false, error: "Kontakt yangilab bo'lmadi"),
        );
      }
    });
    on<DeleteContact>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final String? user = _appRepository.getLoggedInUser();
        if(user == null){
          emit(state.copyWith(isLoading: false, error: "User topilmadi"));
          return;
        }

        await _appRepository.deleteContact(user, event.docId);

        final List<Contact> updatedList = await _appRepository.getContactsAsync(user);

        emit(state.copyWith(
            isLoading: false,
            isOperationSuccess: true,
            list: updatedList
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "Kontakt o'chirib bo'lmadi"));
      }
    });
  }
}
