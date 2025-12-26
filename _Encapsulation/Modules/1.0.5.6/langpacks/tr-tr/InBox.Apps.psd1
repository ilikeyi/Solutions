ConvertFrom-StringData -StringData @'
	# tr-TR
	# Turkish (Turkey)

	AdvAppsDetailed                 = Rapor oluştur
	AdvAppsDetailedTips             = Bölge etiketine göre arama yapın, yerel dil deneyimi paketleri mevcut olduğunda daha fazla ayrıntı edinin ve bir rapor dosyası oluşturun: *.CSV.
	ProcessSources                  = Işleme kaynağı
	InboxAppsManager                = Gelen kutusu uygulaması
	InboxAppsMatchDel               = Eşleşen kurallara göre sil
	InboxAppsOfflineDel             = Sağlanan bir uygulamayı silme
	InboxAppsClear                  = Yüklü tüm ön uygulamaların kaldırılmasını zorunlu kıl ( InBox Apps )
	InBox_Apps_Match                = InBox Apps nı Eşleştir
	InBox_Apps_Check                = Bağımlılık paketlerini kontrol edin
	InBox_Apps_Check_Tips           = Kurallara göre seçilen tüm kurulum öğelerini edinin ve bağımlı kurulum öğelerinin seçilip seçilmediğini doğrulayın.
	LocalExperiencePack             = Yerel Dil Deneyimi Paketleri
	LEPBrandNew                     = Yeni bir şekilde tavsiye edilir
	UWPAutoMissingPacker            = Tüm disklerdeki eksik paketleri otomatik olarak ara
	UWPAutoMissingPackerSupport     = X64 mimarisinde eksik paketlerin kurulması gerekmektedir.
	UWPAutoMissingPackerNotSupport  = Yalnızca x64 mimarisi desteklendiğinde kullanılan x64 olmayan mimari.
	UWPEdition                      = Windows sürümü benzersiz tanımlayıcısı
	Optimize_Appx_Package           = Aynı dosyaları sabit bağlantılarla değiştirerek Appx paketlerinin sağlanmasını optimize edin
	Optimize_ing                    = Optimize etme
	Remove_Appx_Tips                = Göstermek:\n\nBirinci adım: Yerel dil deneyimi paketlerini ( LXPs ) ekleyin Bu adım, Microsoft tarafından resmi olarak yayımlanan ilgili pakete karşılık gelmelidir. Buraya gidin ve indirin:\n       Windows 10 çoklu oturum görüntülerine dil paketleri ekleme\n       https://learn.microsoft.com/tr-tr/azure/virtual-desktop/language-packs\n\n       Windows 11 Enterprise görüntülerine dil ekleme\n       https://learn.microsoft.com/tr-tr/azure/virtual-desktop/windows-11-language-packs\n\nAdım 2: *_InboxApps.iso dosyasını açın veya bağlayın ve mimariye göre dizini seçin;\n\n3. Adım: Microsoft en son yerel dil deneyimi paketini ( LXPs ) resmi olarak yayınlamadıysa bu adımı atlayın: lütfen Microsoft'un resmi duyurusuna bakın:\n       1. Yerel dil deneyimi paketlerine ( LXPs ) karşılık gelir;\n       2. Kümülatif güncellemelere karşılık gelir. \n\nÖnceden yüklenmiş uygulamalar ( InBox Apps ) tek dillidir ve çoklu dil elde etmek için yeniden yüklenmeleri gerekir. \n\n1. Geliştirici sürümü ile başlangıç sürümü arasında seçim yapabilirsiniz;\n    Geliştirici sürümü, örneğin sürüm numarası: \n    Windows 11 seri\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    İlk sürüm, bilinen ilk sürüm: \n    Windows 11 seri\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 seri\n    Windows 10 22H2, Build 19045.2006\n\n    önemli:\n      a. Lütfen her sürüm güncellendiğinde görüntüyü yeniden oluşturun. Örneğin, 21H1'den 22H2'ye geçerken diğer uyumluluk sorunlarından kaçınmak için lütfen eski görüntüyü temel alarak güncelleme yapmayın.\n      b. Bu düzenleme, bazı OEM üreticileri tarafından paketleyicilere çeşitli şekillerde açıkça iletilmiştir ve yinelenen sürümlerden doğrudan yükseltmelere izin verilmemektedir.\n      Anahtar Kelimeler: yineleme, çapraz sürüm, toplu güncelleme.\n\n2. Dil paketini yükledikten sonra toplu güncelleme eklemelisiniz, çünkü toplu güncelleme eklenmeden önce bileşende herhangi bir değişiklik olmayacaktır. Toplu güncelleme yüklenene kadar yeni değişiklikler meydana gelmeyecektir. Örneğin, bileşen durumu: silinecek, eskimiş;\n\n3. Toplu güncellemeler içeren bir sürüm kullanırken, yine de sonuçta tekrar toplu güncellemeler eklemeniz gerekir; bu, tekrarlanan bir işlemdir;\n\n4. Bu nedenle üretim sırasında toplu güncellemelerin olmadığı bir sürümü kullanmanız, ardından son adımda toplu güncellemeleri eklemeniz önerilir. \n\nBir dizin seçtikten sonra arama kriterleri: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = Çıkarma işleminden sonra, bağlı ISO açılacaktır. Kurallar: 
	ImportCleanDuplicate            = Yinelenen dosyaları temizleme
	ForceRemovaAllUWP               = Yerel dil deneyimi paketi ( LXPs ) ekleme işlemini atlayın, diğer işlemleri gerçekleştirin
	LEPSkipAddEnglish               = Kurulum sırasında en-US eklemesinin atlanması tavsiye edilir.
	LEPSkipAddEnglishTips           = Varsayılan İngilizce dil paketinin eklenmesine gerek yoktur.
	License                         = Sertifika
	IsLicense                       = Sertifikaya sahip
	NoLicense                       = Sertifika yok
	CurrentIsNVeriosn               = N versiyon serisi
	CurrentNoIsNVersion             = Tamamen işlevsel sürüm
	LXPsWaitAddUpdate               = Güncellenecek
	LXPsWaitAdd                     = Eklenecek
	LXPsWaitAssign                  = Tahsis edilecek
	LXPsWaitRemove                  = Silinecek
	LXPsAddDelTipsView              = Yeni ipuçları var, şimdi kontrol edin
	LXPsAddDelTipsGlobal            = Artık istem yok, global ile senkronize et
	LXPsAddDelTips                  = Bir daha sorma
	Instl_Dependency_Package        = InBox Apps nı yüklerken bağımlı paketlerin otomatik olarak birleştirilmesine izin ver
	Instl_Dependency_Package_Tips   = Eklenecek uygulamanın bağımlı paketleri olduğunda kurallara göre otomatik olarak eşleşecek ve gerekli bağımlı paketleri otomatik olarak birleştirme işlevini tamamlayacaktır.
	Instl_Dependency_Package_Match  = Bağımlılık paketlerini birleştirme
	Instl_Dependency_Package_Group  = Kombinasyon
	InBoxAppsErrorNoSave            = Bir hatayla karşılaşırken kurtarılmasına izin verilmez
	InBoxAppsErrorTips              = Hatalar var, eşleşen {0} öğe ile karşılaşılan öğe başarısız oldu
	InBoxAppsErrorNo                = Eşleşmede hata bulunmadı
'@