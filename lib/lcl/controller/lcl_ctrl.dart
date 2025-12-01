import 'package:supabase_flutter/supabase_flutter.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../resources/a_entero.dart';
import '../../resources/env_config.dart';
import '../model/lcl_model.dart';

class LclCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  LclCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Lcl lcl = Lcl();
    String url = EnvConfig.supabaseUrl;
    String key = EnvConfig.supabaseAnonKey;

    String pdi = state().user?.pdi ?? 'TEST';
    String contrato =
        state().pdi?.pdiList
            .firstWhere((element) => element.pdi == pdi)
            .contrato
            .toString() ??
        'TEST';
    try {
      final supabaseClient = SupabaseClient(url, key);
      final tableName = 'lcls_2_${contrato.toLowerCase()}';
      final dataAsListMap = await supabaseClient.from(tableName).select();

      for (var item in dataAsListMap) {
        lcl.lclList.add(LclSingle.fromMap(item));
      }
      lcl.lclListSearch = [...lcl.lclList];

      //srot by lcl desc
      lcl.lclList.sort((a, b) => aEntero(a.lcl).compareTo(aEntero(b.lcl)));
      lcl.lclList = lcl.lclListSearch.reversed.toList();

      emit(state().copyWith(lcl: lcl));
      // print('lcl: ${state().lcl?.lclList}');
    } catch (e) {
      bl.errorCarga('LCL', e);
    }
  }
}
