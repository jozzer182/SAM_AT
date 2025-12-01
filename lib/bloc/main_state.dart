part of 'main_bloc.dart';

class MainState {
  String message;
  int messageCounter;
  int errorCounter;
  Color messageColor;
  bool isLoading;
  bool isDark = false;
  Color? themeColor;
  Pdi? pdi;
  Dominio? dominio;
  Usuarios? usuarios;
  User? user;
  Mb52? mb52;
  Mb51? mb51;
  Mm60? mm60;
  Plataforma? plataforma;
  Wbe? wbe;
  Perfiles? perfiles;
  Planilla? planilla;
  // Registros? registros;
  People? people;
  // PlanillaEdit? planillaEdit;
  Inventario? inventario;
  NuevoIngreso? nuevoIngreso;
  NuevoTraslado? nuevoTraslado;
  DeudaBruta? deudaBruta;
  DeudaAlmacen? deudaAlmacen;
  DeudaOperativa? deudaOperativa;
  int dialogCounter;
  String dialogMessage;
  Lcl? lcl;
  Planillas? planillas;
  Pdis? pdis;
  Remisiones? remisiones;
  Remision? remision;
  ConciliacionesList? conciliacionesList;
  ConciliacionesReg? conciliacion;

  MainState({
    this.message = '',
    this.messageCounter = 0,
    this.errorCounter = 0,
    this.messageColor = Colors.red,
    this.isLoading = false,
    this.isDark = false,
    this.themeColor,
    this.pdi,
    this.dominio,
    this.usuarios,
    this.user,
    this.mb52,
    this.mb51,
    this.mm60,
    this.plataforma,
    this.wbe,
    this.perfiles,
    this.planilla,
    // this.registros,
    this.people,
    // this.planillaEdit,
    this.inventario,
    this.nuevoIngreso,
    this.nuevoTraslado,
    this.deudaBruta,
    this.deudaAlmacen,
    this.deudaOperativa,
    this.dialogCounter = 0,
    this.dialogMessage = '',
    this.lcl,
    this.planillas,
    this.pdis,
    this.remisiones,
    this.remision,
    this.conciliacionesList,
    this.conciliacion,
  });

  initial() {
    message = '';
    messageCounter = 0;
    errorCounter = 0;
    messageColor = Colors.red;
    dialogCounter = 0;
    dialogMessage = '';
    isLoading = false;
    isDark = false;
    themeColor = null;
    pdi = null;
    dominio = null;
    usuarios = null;
    user = null;
    mb52 = null;
    mb51 = null;
    mm60 = null;
    plataforma = null;
    wbe = null;
    perfiles = null;
    planilla = null;
    // registros = null;
    people = null;
    // planillaEdit = null;
    inventario = null;
    nuevoIngreso = null;
    nuevoTraslado = null;
    deudaBruta = null;
    deudaAlmacen = null;
    deudaOperativa = null;
    lcl = null;
    planillas = null;
    pdis = null;
    remisiones = null;
    remision = null;
    conciliacionesList = null;
    conciliacion = null;
  }

  MainState copyWith({
    String? message,
    int? messageCounter,
    int? errorCounter,
    Color? messageColor,
    bool? isLoading,
    bool? isDark,
    Color? themeColor,
    Pdi? pdi,
    Dominio? dominio,
    Usuarios? usuarios,
    User? user,
    Mb52? mb52,
    Mb51? mb51,
    Mm60? mm60,
    Plataforma? plataforma,
    Wbe? wbe,
    Perfiles? perfiles,
    Planilla? planilla,
    // Registros? registros,
    People? people,
    // PlanillaEdit? planillaEdit,
    Inventario? inventario,
    NuevoIngreso? nuevoIngreso,
    NuevoTraslado? nuevoTraslado,
    DeudaBruta? deudaBruta,
    DeudaAlmacen? deudaAlmacen,
    DeudaOperativa? deudaOperativa,
    int? dialogCounter,
    String? dialogMessage,
    Lcl? lcl,
    Planillas? planillas,
    Pdis? pdis,
    Remisiones? remisiones,
    Remision? remision,
    ConciliacionesList? conciliacionesList,
    ConciliacionesReg? conciliacion,
  }) {
    return MainState(
      message: message ?? this.message,
      messageCounter: messageCounter ?? this.messageCounter,
      errorCounter: errorCounter ?? this.errorCounter,
      messageColor: messageColor ?? this.messageColor,
      isLoading: isLoading ?? this.isLoading,
      isDark: isDark ?? this.isDark,
      themeColor: themeColor ?? this.themeColor,
      pdi: pdi ?? this.pdi,
      dominio: dominio ?? this.dominio,
      usuarios: usuarios ?? this.usuarios,
      user: user ?? this.user,
      mb52: mb52 ?? this.mb52,
      mb51: mb51 ?? this.mb51,
      mm60: mm60 ?? this.mm60,
      plataforma: plataforma ?? this.plataforma,
      wbe: wbe ?? this.wbe,
      planilla: planilla ?? this.planilla,
      perfiles: perfiles ?? this.perfiles,
      // registros: registros ?? this.registros,
      people: people ?? this.people,
      // planillaEdit: planillaEdit ?? this.planillaEdit,
      inventario: inventario ?? this.inventario,
      nuevoIngreso: nuevoIngreso ?? this.nuevoIngreso,
      nuevoTraslado: nuevoTraslado ?? this.nuevoTraslado,
      deudaBruta: deudaBruta ?? this.deudaBruta,
      deudaAlmacen: deudaAlmacen ?? this.deudaAlmacen,
      deudaOperativa: deudaOperativa ?? this.deudaOperativa,
      dialogCounter: dialogCounter ?? this.dialogCounter,
      dialogMessage: dialogMessage ?? this.dialogMessage,
      lcl: lcl ?? this.lcl,
      planillas: planillas ?? this.planillas,
      pdis: pdis ?? this.pdis,
      remisiones: remisiones ?? this.remisiones,
      remision: remision ?? this.remision,
      conciliacionesList: conciliacionesList ?? this.conciliacionesList,
      conciliacion: conciliacion ?? this.conciliacion,
    );
  }

  resetUser() {
    return MainState(
      message: message,
      messageCounter: messageCounter,
      errorCounter: errorCounter,
      dialogCounter: dialogCounter,
      dialogMessage: dialogMessage,
      messageColor: messageColor,
      isLoading: isLoading,
      isDark: isDark,
      themeColor: themeColor,
      pdi: pdi,
      dominio: dominio,
      usuarios: usuarios,
      user: null,
      mb52: null,
      mb51: null,
      mm60: mm60,
      plataforma: plataforma,
      wbe: wbe,
      perfiles: perfiles,
      planilla: planilla,
      // registros: null,
      people: people,
      // planillaEdit: planillaEdit,
      inventario: null,
      nuevoIngreso: nuevoIngreso,
      nuevoTraslado: nuevoTraslado,
      deudaBruta: null,
      deudaAlmacen: null,
      deudaOperativa: null,
      lcl: null,
      planillas: null,
      pdis: pdis,
      remisiones: null,
      remision: null,
      conciliacionesList: null,
      conciliacion: null,
    );
  }
}
