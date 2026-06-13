// Sealed class บังคับให้ผลลัพธ์มีแค่ 2 ทางเลือก: สำเร็จ (Success) หรือ ล้มเหลว (Failure)
sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends Result<T> {
  final String userMessage;   // ข้อความสำหรับเด้ง SnackBar
  final Object? debugError;   // ข้อความ Error จริงๆ สำหรับเก็บ Log
  final StackTrace? stack;    // บันทึกตำแหน่งบรรทัดโค้ดที่พัง
  
  Failure(this.userMessage, [this.debugError, this.stack]);
}
