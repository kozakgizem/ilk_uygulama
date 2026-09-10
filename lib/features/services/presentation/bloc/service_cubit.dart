import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_services_usecase.dart';
import 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final GetServicesUseCase getServicesUseCase;

  ServiceCubit({required this.getServicesUseCase}) : super(ServiceInitial());

  Future<void> fetchServices() async {
    emit(ServiceLoading());
    try {
      final services = await getServicesUseCase();
      emit(ServiceLoaded(services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }
}