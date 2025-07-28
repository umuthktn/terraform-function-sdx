# Projenin Amacı
Bu projede, Terraform kullanarak Azure’da küçük bir Function App kurdum. Yani kod yazdım, sonra bunu Azure’a otomatik olarak deploy ettim. 
Amaç, altyapıyı elle değil kodla yönetmek ve Azure Function’un nasıl çalıştığını öğrenmekti.

# Neler Yaptım?

## 1- Azure’da bir Resource Group açtım.

## 2- Storage Account ve App Service Plan oluşturdum.

## 3- Basit bir Node.js Azure Function yazdım, gelen istekteki isim parametresine göre cevap veriyor.

## 4- Function kodunu zipleyip Terraform ile Azure’a yükledim.

## 5- CDN ayarları ve SAS token gibi bazı güvenlik önlemlerini ekledim.

Böylece hem altyapı hem kod otomatik ve kontrollü olmuş oldu.

İlk defa Terraform ile Azure’da çalışan bir Function App yapmaya çalıştım. Hem altyapı otomasyonunu hem de serverless mimariyi öğrenmek için güzel bir başlangıç oldu.
