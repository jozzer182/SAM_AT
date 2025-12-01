import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../conciliaciones/model/conciliaciones_reg_model.dart';
import '../../planilla/model/planilla_model.dart';

class PlanillasController {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;

  PlanillasController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get planillasConConciliacion async {
    List<ConciliacionesReg> conciliaciones = state().conciliacionesList!.list;
    if (state().planillas!.planillasList.length == state().planillas!.planillasListSearch.length) {
      state().planillas!.planillasListSearch = state().planillas!.planillasList
          .where(
            (e) => conciliaciones
                .map((el) => el.planilla)
                .contains(e.cabecera.pedido),
          )
          .toList();
    } else {
      state().planillas!.planillasListSearch = [...state().planillas!.planillasList];
    }
    emit(state().copyWith());
  }

  buscar(String value) {
    state().planillas!.planillasListSearch = [...state().planillas!.planillasList];
    state().planillas!.planillasListSearch = state().planillas!.planillasList
        .where(
          (Planilla e) => e.toList().any(
                (el) => el.toLowerCase().contains(
                      value.toLowerCase(),
                    ),
              ),
        )
        .toList();
    emit(state().copyWith());
  }
}
