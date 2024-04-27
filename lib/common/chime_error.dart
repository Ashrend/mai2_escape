enum ChimeErrorId {
  none("None"),
  readerSetupFail("ReaderSetupFail"),
  readerAccessFail("二维码可能已过期，请刷新重试"),
  readerIncompatible("ReaderIncompatible"),
  dBResolveFail("DBResolveFail"),
  dBAccessTimeout("DBAccessTimeout"),
  dBAccessFail("DBAccessFail"),
  aimeIdInvalid("AimeIdInvalid"),
  noBoardInfo("NoBoardInfo"),
  lockBanSystemUser("LockBanSystemUser"),
  lockBanSystem("LockBanSystem"),
  lockBanUser("LockBanUser"),
  lockBan("LockBan"),
  lockSystem("LockSystem"),
  lockUser("LockUser");

  final String value;

  const ChimeErrorId(this.value);
}

class ChimeError {
  final int id;

  ChimeError(this.id);

  @override
  String toString() {
    if (id < 0 || id >= ChimeErrorId.values.length) {
      return "未知错误";
    }
    ChimeErrorId errorId = ChimeErrorId.values[id];
    return errorId.value;
  }
}
