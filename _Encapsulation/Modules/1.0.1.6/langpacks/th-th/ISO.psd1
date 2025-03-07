﻿ConvertFrom-StringData -StringData @'
	# th-TH
	# Thai (Thailand)

	UnpackISO                       = สร้าง ISO
	ISOLabel                        = ป้ายกำกับระดับเสียงได้รับการตั้งค่าแล้ว:
	ISOCustomize                    = ชื่อป้ายกำกับโวลุ่ม ISO
	ISO9660                         = ตรวจสอบกฎการตั้งชื่อ
	ISO9660Tips                     = ชื่อเฉพาะต้องยาวไม่เกิน 260 อักขระ ชื่อวอลุ่ม ISO ไม่เกิน 16 อักขระ และต้องไม่มี: ช่องว่างนำหน้าและต่อท้าย, \\ / : * ? & @ ! "" < > |
	ISOFolderName                   = การตั้งชื่อที่ไม่ซ้ำใครที่กำหนดเอง
	ISOAddFlagsLang                 = เพิ่มมาร์กอัปหลายภาษา
	ISOAddFlagsLangGet              = รับภาษาการติดตั้งที่รู้จัก
	ISOAddFlagsVer                  = เพิ่มแท็กหลายเวอร์ชัน
	ISOAddFlagsVerGet               = รับเวอร์ชันรูปภาพที่รู้จัก
	ISOAddEICFG                     = เพิ่มประเภทเวอร์ชัน
	ISOAddEICFGTips                 = เมื่ออาศัย EI.cfg จะเป็นเวอร์ชันเชิงพาณิชย์
	ISO9660TipsErrorSpace           = ไม่สามารถมี: ช่องว่างนำหน้าและต่อท้าย
	ISO9660TipsErrorOther           = ไม่สามารถมี: \\ / : * ? & @ ! "" < > |
	SelOSver                        = เลือกประเภทภาษา
	SelLabel                        = ชื่อรหัส
	ISOVerLabel                     = เลือกชื่อวอลุ่ม ISO
	NoSetLabel                      = ไม่ได้ตั้งค่าป้ายกำกับปริมาณ ISO ที่กำหนดเอง
	ISOLengthError                  = ป้ายกำกับปริมาณต้องไม่ยาวเกิน {0} อักขระ
	RenameFailed                    = เช่นเดียวกับไดเร็กทอรีเก่า การเปลี่ยนชื่อล้มเหลว
	ISOCreateAfter                  = สิ่งที่คุณต้องทำก่อนสร้าง ISO
	ISOCreateRear                   = สิ่งที่คุณต้องทำหลังจากสร้าง ISO
	BypassTPM                       = การตรวจสอบการติดตั้งบายพาส TPM
	Disable_BitLocker               = ปิดใช้งานการเข้ารหัสอุปกรณ์ BitLocker ระหว่างการติดตั้ง
	PublicDate                      = วันที่ออก
	PublicDateGetCurrent            = ซิงค์วันที่ปัจจุบัน
	PublicYear                      = ปี
	PublicMonth                     = ดวงจันทร์
	ISOCreateFailed                 = การสร้างล้มเหลว ไม่สามารถอ่านหรือเขียนไดเร็กทอรีได้
	ISORefreshAuto                  = รีเฟรชแท็ก ISO ทุกครั้ง
	ISOSaveTo                       = ตำแหน่งบันทึกเริ่มต้น ISO
	ISOSaveSameGlobal               = ใช้ตำแหน่งบันทึกเริ่มต้น ISO สากล
	ISOSaveSync                     = ซิงโครไนซ์ตำแหน่งใหม่โดยอัตโนมัติหลังจากเลือกดิสก์ค้นหาแหล่งที่มาของรูปภาพ
	ISOSaveSame                     = ค้นหาเส้นทางของดิสก์โดยใช้แหล่งรูปภาพ
	ISOFolderWrite                  = ตรวจสอบว่าไดเร็กทอรีสามารถอ่านและเขียนได้
	SelectAutoAvailable             = เมื่อเลือกดิสก์ที่มีอยู่โดยอัตโนมัติ
	SelectCheckAvailable            = ตรวจสอบพื้นที่ว่างที่เหลืออยู่ขั้นต่ำ
	ISOStructure                    = โครงสร้างไดเรกทอรีใหม่
	ISOOSLevel                      = เพิ่มประเภทการติดตั้ง
	ISOUniqueNameDirectory          = เพิ่มไดเร็กทอรีชื่อที่ไม่ซ้ำ
	NextDoOperate                   = อย่าสร้าง ISO
	SelCreateISO                    = สร้าง ISO ดำเนินการตามความต้องการ
	Reconstruction                  = สร้าง {0}.wim ใหม่ด้วยการบีบอัดสูงสุด
	Reconstruction_Tips_Select      = ก่อนที่จะสร้างใหม่ ระบบจะดำเนินการเมื่อไม่ได้โหลดเท่านั้น โดยจะบังคับให้เปิดใช้งานการบันทึก จากนั้นจึงยกเลิกการต่อเชื่อมไฟล์ที่เมาท์
	ReconstructionTips              = มากกว่า 520 MB แนะนำให้สร้างใหม่
	EmptyDirectory                  = ลบโฮมไดเร็กตอรี่ของแหล่งรูปภาพ
	CreateASC                       = เพิ่มลายเซ็น PGP ให้กับ ISO
	CreateASCPwd                    = รหัสผ่านใบรับรอง
	CreateASCAuthor                 = ผู้ลงนาม
	CreateASCAuthorTips             = ไม่ได้เลือกผู้ลงนาม
	CreateSHA256                    = สร้าง .SHA-256 สำหรับ ISO
	GenerateRandom                  = สร้างตัวเลขสุ่ม
	RandomNumberReset               = สร้างใหม่
'@