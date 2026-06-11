import 'package:bloc/bloc.dart';
import 'package:contact_app/domain/repository/app_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AppRepository _appRepository;

  AuthBloc(this._appRepository) : super(AuthState(isLoading: false,isSuccess: false)) {
    on<Login>((event, emit) async {
      emit(state.copyWith(isLoading: true,isSuccess: false));
      try{
        bool result = await _appRepository.loginAsync(event.username, event.password);
        if(result){
          await _appRepository.setLoggedIn(event.username);
          emit(state.copyWith(isLoading: false,isSuccess: true));
        }else{
          emit(state.copyWith(isLoading: false,isSuccess: false,error: "Login qilib bo'madi"));
        }
      }catch(e){
        emit(state.copyWith(isLoading: false,isSuccess: false,error: "Internet bilan muammo"));
      }
    });
    on<Register>((event, emit) async {
      emit(state.copyWith(isLoading: true,isSuccess: false));
      try{
        bool result = await _appRepository.register(event.username, event.password);
        if(result){
          await _appRepository.setLoggedIn(event.username);
          emit(state.copyWith(isLoading: false,isSuccess: true));
        }else{
          emit(state.copyWith(isLoading: false,isSuccess: false,error: "register qilib bo'madi"));
        }
      }catch(e){
        emit(state.copyWith(isLoading: false,isSuccess: false,error: "internet bilan muammo"));
      }
    });
    on<Logout>((event, emit) async {
      emit(state.copyWith(isLoading: true,isSuccess: false));
      try{
        await _appRepository.logout();
        emit(state.copyWith(isLoading: false,isSuccess: true));
      }catch(e){
      emit(state.copyWith(isLoading: false,isSuccess: false,error: "logout qilib bo'madi"));
      }
    });
    on<Unregister>((event, emit) async {
      emit(state.copyWith(isLoading: true,isSuccess: false));
      try{
        final String? user = _appRepository.getLoggedInUser();
        if(user == null){
          emit(state.copyWith(isLoading: false,error: "User topilmai"));
          return;
        }
        await _appRepository.unregister(user);
        emit(state.copyWith(isLoading: false,isSuccess: true));
      }catch(e){
        emit(state.copyWith(isLoading: false,isSuccess: false,error: "unregister qilib bo'madi"));
      }
    });
  }
}
