
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")

local Ghostline = {}
Ghostline.__index = Ghostline
Ghostline.Version = "2.4.0"
Ghostline.Flags = {}
Ghostline.Windows = {}
Ghostline.ConfigFolder = "Ghostline"
Ghostline.AnimSpeed = 1
Ghostline.MaxNotifications = 5
Ghostline._notifs = {}
Ghostline.Language = "en"
Ghostline.Languages = {}
Ghostline.LanguageNames = {}
Ghostline.LanguageOrder = {}
Ghostline._langBound = {}
Ghostline._langHooks = {}

Ghostline.Languages.en = {
	search = "Search...",
	none = "None",
	no_results = "No results",
	tab_label = "Tab",
	dark = "Dark",
	light = "Light",
	theme = "Theme",
	theme_tip = "Color + dark / light mode",
	settings = "Settings",
	appearance = "Appearance",
	interface = "Interface",
	ui_scale = "Interface size",
	ui_scale_tip = "Scales the whole interface (useful on tablet and mobile)",
	glass = "Glass opacity",
	anim_speed = "Animation speed",
	blur = "Background blur",
	compact = "Compact sidebar",
	compact_tip = "Automatic on small screens",
	toggle_key = "Show / hide",
	language = "Language",
	profile = "Profile",
	show_avatar = "Show avatar",
	show_name = "Show username",
	streamer = "Streamer mode",
	streamer_long = "Streamer mode (hides username)",
	configs = "Configurations",
	cfg_name = "Name",
	cfg_existing = "Existing",
	save = "Save",
	load = "Load",
	delete = "Delete",
	export_cfg = "Copy configuration",
	import_cfg = "Import configuration",
	import_ph = "Paste configuration here",
	auto_save = "Auto save",
	auto_save_tip = "Saves on every change (uses the name above)",
	cfg_saved = "Configuration saved",
	cfg_loaded = "Configuration loaded",
	cfg_deleted = "Configuration deleted",
	cfg_exported = "Configuration copied to clipboard",
	cfg_imported = "Configuration imported",
	failed = "Failed",
	tips = "Tips",
	tips_body = "Right-click (or long-press) a setting: reset.\nDouble-click a slider: default value.\nCtrl+K: global search.",
	perf = "Performance mode",
	perf_tip = "Disables decorative effects and blur",
	guest = "Guest",
	yes = "Yes",
	no = "No",
	user_id = "User ID",
	roblox_premium = "Roblox Premium",
	account_age = "Account age",
	days = "%d days",
	session = "Session",
	performance = "Performance",
	privacy = "PRIVACY",
	profile_hidden = "Profile hidden",
	err_fs = "File system unavailable",
	err_missing = "Configuration not found",
	err_corrupt = "Configuration corrupted",
	err_theme = "Unknown theme: %s",
	err_callback = "Callback error: %s",
	err_lang = "Unknown language: %s",
	theme_Red = "Red",
	theme_Pink = "Pink",
	theme_Purple = "Purple",
	theme_Blue = "Blue",
	theme_Green = "Green",
	theme_Yellow = "Yellow",
	theme_Black = "Black",
}
Ghostline.Languages.fr = {
	search = "Rechercher...",
	none = "Aucun",
	no_results = "Aucun résultat",
	tab_label = "Onglet",
	dark = "Sombre",
	light = "Clair",
	theme = "Thème",
	theme_tip = "Couleur + mode sombre / clair",
	settings = "Réglages",
	appearance = "Apparence",
	interface = "Interface",
	ui_scale = "Taille de l'interface",
	ui_scale_tip = "Agrandit ou réduit toute l'interface (utile sur tablette et mobile)",
	glass = "Opacité du verre",
	anim_speed = "Vitesse des animations",
	blur = "Flou d'arrière-plan",
	compact = "Barre latérale compacte",
	compact_tip = "Automatique sur petit écran",
	toggle_key = "Afficher / masquer",
	language = "Langue",
	profile = "Profil",
	show_avatar = "Afficher l'avatar",
	show_name = "Afficher le pseudo",
	streamer = "Mode streamer",
	streamer_long = "Mode streamer (masque le pseudo)",
	configs = "Configurations",
	cfg_name = "Nom",
	cfg_existing = "Existantes",
	save = "Sauvegarder",
	load = "Charger",
	delete = "Supprimer",
	export_cfg = "Copier la configuration",
	import_cfg = "Importer une configuration",
	import_ph = "Colle la configuration ici",
	auto_save = "Sauvegarde automatique",
	auto_save_tip = "Enregistre à chaque changement (le nom ci-dessus est utilisé)",
	cfg_saved = "Configuration sauvegardée",
	cfg_loaded = "Configuration chargée",
	cfg_deleted = "Configuration supprimée",
	cfg_exported = "Configuration copiée dans le presse-papiers",
	cfg_imported = "Configuration importée",
	failed = "Échec",
	tips = "Astuces",
	tips_body = "Clic droit (ou appui long) sur un réglage : remise à zéro.\nDouble-clic sur un slider : valeur par défaut.\nCtrl+K : recherche globale.",
	perf = "Mode performance",
	perf_tip = "Désactive les effets décoratifs et le flou",
	guest = "Invité",
	yes = "Oui",
	no = "Non",
	user_id = "ID utilisateur",
	roblox_premium = "Roblox Premium",
	account_age = "Âge du compte",
	days = "%d jours",
	session = "Session",
	performance = "Performance",
	privacy = "CONFIDENTIALITÉ",
	profile_hidden = "Profil masqué",
	err_fs = "Système de fichiers indisponible",
	err_missing = "Configuration introuvable",
	err_corrupt = "Configuration corrompue",
	err_theme = "Thème inconnu : %s",
	err_callback = "Erreur de callback : %s",
	err_lang = "Langue inconnue : %s",
	theme_Red = "Rouge",
	theme_Pink = "Rose",
	theme_Purple = "Violet",
	theme_Blue = "Bleu",
	theme_Green = "Vert",
	theme_Yellow = "Jaune",
	theme_Black = "Noir",
}
Ghostline.Languages.de = {
	search = "Suchen...",
	none = "Keine",
	no_results = "Keine Ergebnisse",
	tab_label = "Tab",
	dark = "Dunkel",
	light = "Hell",
	theme = "Design",
	theme_tip = "Farbe + dunkler / heller Modus",
	settings = "Einstellungen",
	appearance = "Aussehen",
	interface = "Oberfläche",
	ui_scale = "Oberflächengröße",
	ui_scale_tip = "Skaliert die gesamte Oberfläche (nützlich auf Tablet und Handy)",
	glass = "Glas-Deckkraft",
	anim_speed = "Animationsgeschwindigkeit",
	blur = "Hintergrundunschärfe",
	compact = "Kompakte Seitenleiste",
	compact_tip = "Automatisch auf kleinen Bildschirmen",
	toggle_key = "Ein- / ausblenden",
	language = "Sprache",
	profile = "Profil",
	show_avatar = "Avatar anzeigen",
	show_name = "Benutzernamen anzeigen",
	streamer = "Streamer-Modus",
	streamer_long = "Streamer-Modus (versteckt den Namen)",
	configs = "Konfigurationen",
	cfg_name = "Name",
	cfg_existing = "Vorhandene",
	save = "Speichern",
	load = "Laden",
	delete = "Löschen",
	export_cfg = "Konfiguration kopieren",
	import_cfg = "Konfiguration importieren",
	import_ph = "Konfiguration hier einfügen",
	auto_save = "Automatisch speichern",
	auto_save_tip = "Speichert bei jeder Änderung (verwendet den obigen Namen)",
	cfg_saved = "Konfiguration gespeichert",
	cfg_loaded = "Konfiguration geladen",
	cfg_deleted = "Konfiguration gelöscht",
	cfg_exported = "Konfiguration in die Zwischenablage kopiert",
	cfg_imported = "Konfiguration importiert",
	failed = "Fehlgeschlagen",
	tips = "Tipps",
	tips_body = "Rechtsklick (oder langes Drücken) auf eine Einstellung: zurücksetzen.\nDoppelklick auf einen Slider: Standardwert.\nStrg+K: globale Suche.",
	perf = "Leistungsmodus",
	perf_tip = "Deaktiviert Dekoeffekte und Unschärfe",
	guest = "Gast",
	yes = "Ja",
	no = "Nein",
	user_id = "Benutzer-ID",
	roblox_premium = "Roblox Premium",
	account_age = "Kontoalter",
	days = "%d Tage",
	session = "Sitzung",
	performance = "Leistung",
	privacy = "DATENSCHUTZ",
	profile_hidden = "Profil ausgeblendet",
	err_fs = "Dateisystem nicht verfügbar",
	err_missing = "Konfiguration nicht gefunden",
	err_corrupt = "Konfiguration beschädigt",
	err_theme = "Unbekanntes Design: %s",
	err_callback = "Callback-Fehler: %s",
	err_lang = "Unbekannte Sprache: %s",
	theme_Red = "Rot",
	theme_Pink = "Rosa",
	theme_Purple = "Violett",
	theme_Blue = "Blau",
	theme_Green = "Grün",
	theme_Yellow = "Gelb",
	theme_Black = "Schwarz",
}
Ghostline.Languages.es = {
	search = "Buscar...",
	none = "Ninguno",
	no_results = "Sin resultados",
	tab_label = "Pestaña",
	dark = "Oscuro",
	light = "Claro",
	theme = "Tema",
	theme_tip = "Color + modo oscuro / claro",
	settings = "Ajustes",
	appearance = "Apariencia",
	interface = "Interfaz",
	ui_scale = "Tamaño de la interfaz",
	ui_scale_tip = "Escala toda la interfaz (útil en tableta y móvil)",
	glass = "Opacidad del cristal",
	anim_speed = "Velocidad de animación",
	blur = "Desenfoque de fondo",
	compact = "Barra lateral compacta",
	compact_tip = "Automático en pantallas pequeñas",
	toggle_key = "Mostrar / ocultar",
	language = "Idioma",
	profile = "Perfil",
	show_avatar = "Mostrar avatar",
	show_name = "Mostrar nombre de usuario",
	streamer = "Modo streamer",
	streamer_long = "Modo streamer (oculta el nombre)",
	configs = "Configuraciones",
	cfg_name = "Nombre",
	cfg_existing = "Existentes",
	save = "Guardar",
	load = "Cargar",
	delete = "Eliminar",
	export_cfg = "Copiar configuración",
	import_cfg = "Importar configuración",
	import_ph = "Pega la configuración aquí",
	auto_save = "Guardado automático",
	auto_save_tip = "Guarda en cada cambio (usa el nombre de arriba)",
	cfg_saved = "Configuración guardada",
	cfg_loaded = "Configuración cargada",
	cfg_deleted = "Configuración eliminada",
	cfg_exported = "Configuración copiada al portapapeles",
	cfg_imported = "Configuración importada",
	failed = "Error",
	tips = "Consejos",
	tips_body = "Clic derecho (o pulsación larga) en un ajuste: restablecer.\nDoble clic en un slider: valor por defecto.\nCtrl+K: búsqueda global.",
	perf = "Modo rendimiento",
	perf_tip = "Desactiva los efectos decorativos y el desenfoque",
	guest = "Invitado",
	yes = "Sí",
	no = "No",
	user_id = "ID de usuario",
	roblox_premium = "Roblox Premium",
	account_age = "Antigüedad de la cuenta",
	days = "%d días",
	session = "Sesión",
	performance = "Rendimiento",
	privacy = "PRIVACIDAD",
	profile_hidden = "Perfil oculto",
	err_fs = "Sistema de archivos no disponible",
	err_missing = "Configuración no encontrada",
	err_corrupt = "Configuración dañada",
	err_theme = "Tema desconocido: %s",
	err_callback = "Error de callback: %s",
	err_lang = "Idioma desconocido: %s",
	theme_Red = "Rojo",
	theme_Pink = "Rosa",
	theme_Purple = "Morado",
	theme_Blue = "Azul",
	theme_Green = "Verde",
	theme_Yellow = "Amarillo",
	theme_Black = "Negro",
}
Ghostline.Languages.it = {
	search = "Cerca...",
	none = "Nessuno",
	no_results = "Nessun risultato",
	tab_label = "Scheda",
	dark = "Scuro",
	light = "Chiaro",
	theme = "Tema",
	theme_tip = "Colore + modalità scura / chiara",
	settings = "Impostazioni",
	appearance = "Aspetto",
	interface = "Interfaccia",
	ui_scale = "Dimensione interfaccia",
	ui_scale_tip = "Ridimensiona tutta l'interfaccia (utile su tablet e cellulare)",
	glass = "Opacità del vetro",
	anim_speed = "Velocità animazioni",
	blur = "Sfocatura sfondo",
	compact = "Barra laterale compatta",
	compact_tip = "Automatico su schermi piccoli",
	toggle_key = "Mostra / nascondi",
	language = "Lingua",
	profile = "Profilo",
	show_avatar = "Mostra avatar",
	show_name = "Mostra nome utente",
	streamer = "Modalità streamer",
	streamer_long = "Modalità streamer (nasconde il nome)",
	configs = "Configurazioni",
	cfg_name = "Nome",
	cfg_existing = "Esistenti",
	save = "Salva",
	load = "Carica",
	delete = "Elimina",
	export_cfg = "Copia configurazione",
	import_cfg = "Importa configurazione",
	import_ph = "Incolla la configurazione qui",
	auto_save = "Salvataggio automatico",
	auto_save_tip = "Salva a ogni modifica (usa il nome sopra)",
	cfg_saved = "Configurazione salvata",
	cfg_loaded = "Configurazione caricata",
	cfg_deleted = "Configurazione eliminata",
	cfg_exported = "Configurazione copiata negli appunti",
	cfg_imported = "Configurazione importata",
	failed = "Errore",
	tips = "Suggerimenti",
	tips_body = "Clic destro (o pressione lunga) su un'impostazione: ripristina.\nDoppio clic su uno slider: valore predefinito.\nCtrl+K: ricerca globale.",
	perf = "Modalità prestazioni",
	perf_tip = "Disattiva effetti decorativi e sfocatura",
	guest = "Ospite",
	yes = "Sì",
	no = "No",
	user_id = "ID utente",
	roblox_premium = "Roblox Premium",
	account_age = "Età dell'account",
	days = "%d giorni",
	session = "Sessione",
	performance = "Prestazioni",
	privacy = "PRIVACY",
	profile_hidden = "Profilo nascosto",
	err_fs = "File system non disponibile",
	err_missing = "Configurazione non trovata",
	err_corrupt = "Configurazione danneggiata",
	err_theme = "Tema sconosciuto: %s",
	err_callback = "Errore callback: %s",
	err_lang = "Lingua sconosciuta: %s",
	theme_Red = "Rosso",
	theme_Pink = "Rosa",
	theme_Purple = "Viola",
	theme_Blue = "Blu",
	theme_Green = "Verde",
	theme_Yellow = "Giallo",
	theme_Black = "Nero",
}
Ghostline.Languages.pt = {
	search = "Pesquisar...",
	none = "Nenhum",
	no_results = "Sem resultados",
	tab_label = "Aba",
	dark = "Escuro",
	light = "Claro",
	theme = "Tema",
	theme_tip = "Cor + modo escuro / claro",
	settings = "Configurações",
	appearance = "Aparência",
	interface = "Interface",
	ui_scale = "Tamanho da interface",
	ui_scale_tip = "Redimensiona toda a interface (útil em tablet e celular)",
	glass = "Opacidade do vidro",
	anim_speed = "Velocidade das animações",
	blur = "Desfoque de fundo",
	compact = "Barra lateral compacta",
	compact_tip = "Automático em telas pequenas",
	toggle_key = "Mostrar / ocultar",
	language = "Idioma",
	profile = "Perfil",
	show_avatar = "Mostrar avatar",
	show_name = "Mostrar nome de usuário",
	streamer = "Modo streamer",
	streamer_long = "Modo streamer (oculta o nome)",
	configs = "Configurações",
	cfg_name = "Nome",
	cfg_existing = "Existentes",
	save = "Salvar",
	load = "Carregar",
	delete = "Excluir",
	export_cfg = "Copiar configuração",
	import_cfg = "Importar configuração",
	import_ph = "Cole a configuração aqui",
	auto_save = "Salvamento automático",
	auto_save_tip = "Salva a cada alteração (usa o nome acima)",
	cfg_saved = "Configuração salva",
	cfg_loaded = "Configuração carregada",
	cfg_deleted = "Configuração excluída",
	cfg_exported = "Configuração copiada para a área de transferência",
	cfg_imported = "Configuração importada",
	failed = "Falhou",
	tips = "Dicas",
	tips_body = "Clique direito (ou toque longo) em uma opção: redefinir.\nDuplo clique em um slider: valor padrão.\nCtrl+K: pesquisa global.",
	perf = "Modo desempenho",
	perf_tip = "Desativa efeitos decorativos e desfoque",
	guest = "Convidado",
	yes = "Sim",
	no = "Não",
	user_id = "ID do usuário",
	roblox_premium = "Roblox Premium",
	account_age = "Idade da conta",
	days = "%d dias",
	session = "Sessão",
	performance = "Desempenho",
	privacy = "PRIVACIDADE",
	profile_hidden = "Perfil oculto",
	err_fs = "Sistema de arquivos indisponível",
	err_missing = "Configuração não encontrada",
	err_corrupt = "Configuração corrompida",
	err_theme = "Tema desconhecido: %s",
	err_callback = "Erro de callback: %s",
	err_lang = "Idioma desconhecido: %s",
	theme_Red = "Vermelho",
	theme_Pink = "Rosa",
	theme_Purple = "Roxo",
	theme_Blue = "Azul",
	theme_Green = "Verde",
	theme_Yellow = "Amarelo",
	theme_Black = "Preto",
}
Ghostline.Languages.nl = {
	search = "Zoeken...",
	none = "Geen",
	no_results = "Geen resultaten",
	tab_label = "Tabblad",
	dark = "Donker",
	light = "Licht",
	theme = "Thema",
	theme_tip = "Kleur + donkere / lichte modus",
	settings = "Instellingen",
	appearance = "Uiterlijk",
	interface = "Interface",
	ui_scale = "Interfacegrootte",
	ui_scale_tip = "Schaalt de hele interface (handig op tablet en mobiel)",
	glass = "Glasdekking",
	anim_speed = "Animatiesnelheid",
	blur = "Achtergrondvervaging",
	compact = "Compacte zijbalk",
	compact_tip = "Automatisch op kleine schermen",
	toggle_key = "Tonen / verbergen",
	language = "Taal",
	profile = "Profiel",
	show_avatar = "Avatar tonen",
	show_name = "Gebruikersnaam tonen",
	streamer = "Streamermodus",
	streamer_long = "Streamermodus (verbergt de naam)",
	configs = "Configuraties",
	cfg_name = "Naam",
	cfg_existing = "Bestaande",
	save = "Opslaan",
	load = "Laden",
	delete = "Verwijderen",
	export_cfg = "Configuratie kopiëren",
	import_cfg = "Configuratie importeren",
	import_ph = "Plak de configuratie hier",
	auto_save = "Automatisch opslaan",
	auto_save_tip = "Slaat bij elke wijziging op (gebruikt de naam hierboven)",
	cfg_saved = "Configuratie opgeslagen",
	cfg_loaded = "Configuratie geladen",
	cfg_deleted = "Configuratie verwijderd",
	cfg_exported = "Configuratie naar klembord gekopieerd",
	cfg_imported = "Configuratie geïmporteerd",
	failed = "Mislukt",
	tips = "Tips",
	tips_body = "Rechtsklik (of lang indrukken) op een instelling: resetten.\nDubbelklik op een slider: standaardwaarde.\nCtrl+K: globaal zoeken.",
	perf = "Prestatiemodus",
	perf_tip = "Schakelt decoratieve effecten en vervaging uit",
	guest = "Gast",
	yes = "Ja",
	no = "Nee",
	user_id = "Gebruikers-ID",
	roblox_premium = "Roblox Premium",
	account_age = "Accountleeftijd",
	days = "%d dagen",
	session = "Sessie",
	performance = "Prestaties",
	privacy = "PRIVACY",
	profile_hidden = "Profiel verborgen",
	err_fs = "Bestandssysteem niet beschikbaar",
	err_missing = "Configuratie niet gevonden",
	err_corrupt = "Configuratie beschadigd",
	err_theme = "Onbekend thema: %s",
	err_callback = "Callback-fout: %s",
	err_lang = "Onbekende taal: %s",
	theme_Red = "Rood",
	theme_Pink = "Roze",
	theme_Purple = "Paars",
	theme_Blue = "Blauw",
	theme_Green = "Groen",
	theme_Yellow = "Geel",
	theme_Black = "Zwart",
}
Ghostline.Languages.pl = {
	search = "Szukaj...",
	none = "Brak",
	no_results = "Brak wyników",
	tab_label = "Karta",
	dark = "Ciemny",
	light = "Jasny",
	theme = "Motyw",
	theme_tip = "Kolor + tryb ciemny / jasny",
	settings = "Ustawienia",
	appearance = "Wygląd",
	interface = "Interfejs",
	ui_scale = "Rozmiar interfejsu",
	ui_scale_tip = "Skaluje cały interfejs (przydatne na tablecie i telefonie)",
	glass = "Przezroczystość szkła",
	anim_speed = "Szybkość animacji",
	blur = "Rozmycie tła",
	compact = "Kompaktowy pasek boczny",
	compact_tip = "Automatycznie na małych ekranach",
	toggle_key = "Pokaż / ukryj",
	language = "Język",
	profile = "Profil",
	show_avatar = "Pokaż awatar",
	show_name = "Pokaż nazwę użytkownika",
	streamer = "Tryb streamera",
	streamer_long = "Tryb streamera (ukrywa nazwę)",
	configs = "Konfiguracje",
	cfg_name = "Nazwa",
	cfg_existing = "Istniejące",
	save = "Zapisz",
	load = "Wczytaj",
	delete = "Usuń",
	export_cfg = "Kopiuj konfigurację",
	import_cfg = "Importuj konfigurację",
	import_ph = "Wklej konfigurację tutaj",
	auto_save = "Autozapis",
	auto_save_tip = "Zapisuje przy każdej zmianie (używa nazwy powyżej)",
	cfg_saved = "Konfiguracja zapisana",
	cfg_loaded = "Konfiguracja wczytana",
	cfg_deleted = "Konfiguracja usunięta",
	cfg_exported = "Konfiguracja skopiowana do schowka",
	cfg_imported = "Konfiguracja zaimportowana",
	failed = "Niepowodzenie",
	tips = "Wskazówki",
	tips_body = "Prawy przycisk (lub długie przytrzymanie) na ustawieniu: reset.\nDwukrotne kliknięcie suwaka: wartość domyślna.\nCtrl+K: wyszukiwanie globalne.",
	perf = "Tryb wydajności",
	perf_tip = "Wyłącza efekty dekoracyjne i rozmycie",
	guest = "Gość",
	yes = "Tak",
	no = "Nie",
	user_id = "ID użytkownika",
	roblox_premium = "Roblox Premium",
	account_age = "Wiek konta",
	days = "%d dni",
	session = "Sesja",
	performance = "Wydajność",
	privacy = "PRYWATNOŚĆ",
	profile_hidden = "Profil ukryty",
	err_fs = "System plików niedostępny",
	err_missing = "Nie znaleziono konfiguracji",
	err_corrupt = "Konfiguracja uszkodzona",
	err_theme = "Nieznany motyw: %s",
	err_callback = "Błąd callbacku: %s",
	err_lang = "Nieznany język: %s",
	theme_Red = "Czerwony",
	theme_Pink = "Różowy",
	theme_Purple = "Fioletowy",
	theme_Blue = "Niebieski",
	theme_Green = "Zielony",
	theme_Yellow = "Żółty",
	theme_Black = "Czarny",
}
Ghostline.Languages.tr = {
	search = "Ara...",
	none = "Yok",
	no_results = "Sonuç yok",
	tab_label = "Sekme",
	dark = "Koyu",
	light = "Açık",
	theme = "Tema",
	theme_tip = "Renk + koyu / açık mod",
	settings = "Ayarlar",
	appearance = "Görünüm",
	interface = "Arayüz",
	ui_scale = "Arayüz boyutu",
	ui_scale_tip = "Tüm arayüzü ölçekler (tablet ve telefonda kullanışlı)",
	glass = "Cam opaklığı",
	anim_speed = "Animasyon hızı",
	blur = "Arka plan bulanıklığı",
	compact = "Kompakt kenar çubuğu",
	compact_tip = "Küçük ekranlarda otomatik",
	toggle_key = "Göster / gizle",
	language = "Dil",
	profile = "Profil",
	show_avatar = "Avatarı göster",
	show_name = "Kullanıcı adını göster",
	streamer = "Yayıncı modu",
	streamer_long = "Yayıncı modu (adı gizler)",
	configs = "Yapılandırmalar",
	cfg_name = "Ad",
	cfg_existing = "Mevcut",
	save = "Kaydet",
	load = "Yükle",
	delete = "Sil",
	export_cfg = "Yapılandırmayı kopyala",
	import_cfg = "Yapılandırmayı içe aktar",
	import_ph = "Yapılandırmayı buraya yapıştır",
	auto_save = "Otomatik kaydet",
	auto_save_tip = "Her değişiklikte kaydeder (yukarıdaki adı kullanır)",
	cfg_saved = "Yapılandırma kaydedildi",
	cfg_loaded = "Yapılandırma yüklendi",
	cfg_deleted = "Yapılandırma silindi",
	cfg_exported = "Yapılandırma panoya kopyalandı",
	cfg_imported = "Yapılandırma içe aktarıldı",
	failed = "Başarısız",
	tips = "İpuçları",
	tips_body = "Bir ayara sağ tık (veya uzun basış): sıfırla.\nKaydırıcıya çift tık: varsayılan değer.\nCtrl+K: genel arama.",
	perf = "Performans modu",
	perf_tip = "Dekoratif efektleri ve bulanıklığı kapatır",
	guest = "Misafir",
	yes = "Evet",
	no = "Hayır",
	user_id = "Kullanıcı kimliği",
	roblox_premium = "Roblox Premium",
	account_age = "Hesap yaşı",
	days = "%d gün",
	session = "Oturum",
	performance = "Performans",
	privacy = "GİZLİLİK",
	profile_hidden = "Profil gizli",
	err_fs = "Dosya sistemi kullanılamıyor",
	err_missing = "Yapılandırma bulunamadı",
	err_corrupt = "Yapılandırma bozuk",
	err_theme = "Bilinmeyen tema: %s",
	err_callback = "Callback hatası: %s",
	err_lang = "Bilinmeyen dil: %s",
	theme_Red = "Kırmızı",
	theme_Pink = "Pembe",
	theme_Purple = "Mor",
	theme_Blue = "Mavi",
	theme_Green = "Yeşil",
	theme_Yellow = "Sarı",
	theme_Black = "Siyah",
}

Ghostline.LanguageNames = {
	en = "English",
	fr = "Français",
	de = "Deutsch",
	es = "Español",
	it = "Italiano",
	pt = "Português",
	nl = "Nederlands",
	pl = "Polski",
	tr = "Türkçe",
}
Ghostline.LanguageOrder = { "en", "fr", "de", "es", "it", "pt", "nl", "pl", "tr" }
Ghostline.LanguageAliases = {
	english = "en", french = "fr", francais = "fr", ["français"] = "fr", german = "de", deutsch = "de",
	spanish = "es", espanol = "es", ["español"] = "es", italian = "it", italiano = "it",
	portuguese = "pt", portugues = "pt", ["português"] = "pt", dutch = "nl", nederlands = "nl",
	polish = "pl", polski = "pl", turkish = "tr", turkce = "tr", ["türkçe"] = "tr",
}
Ghostline.ThemeAliases = {
	["rouge"] = "Red",
	["rot"] = "Red",
	["rojo"] = "Red",
	["rosso"] = "Red",
	["vermelho"] = "Red",
	["rood"] = "Red",
	["czerwony"] = "Red",
	["kirmizi"] = "Red",
	["kırmızı"] = "Red",
	["rose"] = "Pink",
	["rosa"] = "Pink",
	["roze"] = "Pink",
	["różowy"] = "Pink",
	["rozowy"] = "Pink",
	["pembe"] = "Pink",
	["violet"] = "Purple",
	["violett"] = "Purple",
	["morado"] = "Purple",
	["viola"] = "Purple",
	["roxo"] = "Purple",
	["paars"] = "Purple",
	["fioletowy"] = "Purple",
	["mor"] = "Purple",
	["bleu"] = "Blue",
	["blau"] = "Blue",
	["azul"] = "Blue",
	["blu"] = "Blue",
	["blauw"] = "Blue",
	["niebieski"] = "Blue",
	["mavi"] = "Blue",
	["vert"] = "Green",
	["grün"] = "Green",
	["grun"] = "Green",
	["gruen"] = "Green",
	["verde"] = "Green",
	["groen"] = "Green",
	["zielony"] = "Green",
	["yesil"] = "Green",
	["yeşil"] = "Green",
	["jaune"] = "Yellow",
	["gelb"] = "Yellow",
	["amarillo"] = "Yellow",
	["giallo"] = "Yellow",
	["amarelo"] = "Yellow",
	["geel"] = "Yellow",
	["żółty"] = "Yellow",
	["zolty"] = "Yellow",
	["sari"] = "Yellow",
	["sarı"] = "Yellow",
	["noir"] = "Black",
	["schwarz"] = "Black",
	["negro"] = "Black",
	["nero"] = "Black",
	["preto"] = "Black",
	["zwart"] = "Black",
	["czarny"] = "Black",
	["siyah"] = "Black",
}
Ghostline.ModeAliases = {
	dark = "dark", sombre = "dark", dunkel = "dark", oscuro = "dark", scuro = "dark", escuro = "dark",
	donker = "dark", ciemny = "dark", koyu = "dark",
	light = "light", clair = "light", hell = "light", claro = "light", chiaro = "light", licht = "light",
	jasny = "light", acik = "light", ["açık"] = "light",
}

local function L(key, ...)
	local lang = Ghostline.Languages[Ghostline.Language]
	local str = (lang and lang[key]) or Ghostline.Languages.en[key] or key
	if select("#", ...) > 0 then
		local ok, out = pcall(string.format, str, ...)
		if ok then
			return out
		end
	end
	return str
end
Ghostline.L = L

function Ghostline.Loc(key, ...)
	return { __loc = true, Key = key, Args = { ... } }
end
local Loc = Ghostline.Loc

local function isSpec(v)
	if type(v) ~= "table" then
		return false
	end
	if v.__loc then
		return true
	end
	for code in pairs(Ghostline.Languages) do
		if v[code] ~= nil then
			return true
		end
	end
	return false
end

local function resolveText(v)
	if type(v) ~= "table" then
		return v
	end
	if v.__loc then
		return L(v.Key, table.unpack(v.Args))
	end
	return v[Ghostline.Language] or v.en or select(2, next(v)) or ""
end

local function resolveLang(code)
	if code == nil then
		return nil
	end
	local low = string.lower(tostring(code))
	if low == "auto" then
		local ok, id = pcall(function()
			return LocalizationService.RobloxLocaleId
		end)
		low = ok and string.lower(tostring(id)) or "en"
	end
	if Ghostline.Languages[low] then
		return low
	end
	if Ghostline.LanguageAliases[low] then
		return Ghostline.LanguageAliases[low]
	end
	for c, n in pairs(Ghostline.LanguageNames) do
		if string.lower(n) == low then
			return c
		end
	end
	local short = string.sub(low, 1, 2)
	if Ghostline.Languages[short] then
		return short
	end
	return nil
end

local function resolveTheme(name)
	if name == nil then
		return nil
	end
	if Ghostline.Themes[name] then
		return name
	end
	local low = string.lower(tostring(name))
	for k in pairs(Ghostline.Themes) do
		if string.lower(k) == low then
			return k
		end
	end
	return Ghostline.ThemeAliases[low]
end

local function resolveMode(m)
	if m == nil then
		return nil
	end
	return Ghostline.ModeAliases[string.lower(tostring(m))]
end

local function bindFn(inst, fn)
	table.insert(Ghostline._langBound, { inst = inst, fn = fn })
	fn()
end

local function bindText(inst, prop, spec, upper)
	bindFn(inst, function()
		local t = resolveText(spec)
		inst[prop] = upper and string.upper(t) or t
	end)
end

function Ghostline:SetLanguage(code)
	local resolved = resolveLang(code)
	if not resolved then
		return false, L("err_lang", tostring(code))
	end
	Ghostline.Language = resolved
	local list = Ghostline._langBound
	for i = #list, 1, -1 do
		local e = list[i]
		if e.inst.Parent == nil then
			table.remove(list, i)
		else
			pcall(e.fn)
		end
	end
	for i = #Ghostline._langHooks, 1, -1 do
		local ok, keep = pcall(Ghostline._langHooks[i], resolved)
		if not ok or keep == false then
			table.remove(Ghostline._langHooks, i)
		end
	end
	return true
end

function Ghostline:OnLanguageChanged(fn)
	table.insert(Ghostline._langHooks, fn)
	return {
		Disconnect = function()
			local i = table.find(Ghostline._langHooks, fn)
			if i then
				table.remove(Ghostline._langHooks, i)
			end
		end,
	}
end

function Ghostline:AddLanguage(code, name, dict)
	code = string.lower(code)
	Ghostline.Languages[code] = dict or {}
	Ghostline.LanguageNames[code] = name or code
	if not table.find(Ghostline.LanguageOrder, code) then
		table.insert(Ghostline.LanguageOrder, code)
	end
end

function Ghostline:GetLanguages()
	local list = {}
	for _, code in ipairs(Ghostline.LanguageOrder) do
		table.insert(list, { Code = code, Name = Ghostline.LanguageNames[code] or code })
	end
	return list
end

function Ghostline:Translate(key, ...)
	return L(key, ...)
end

function Ghostline:ThemeLabel(key)
	local k = "theme_" .. tostring(key)
	local lang = Ghostline.Languages[Ghostline.Language]
	return (lang and lang[k]) or Ghostline.Languages.en[k] or tostring(key)
end

Ghostline.Theme = {
	BackgroundPrimary = Color3.fromRGB(14, 6, 8),
	BackgroundSecondary = Color3.fromRGB(28, 9, 13),
	GlassTint = Color3.fromRGB(52, 12, 22),
	AccentGlow = Color3.fromRGB(255, 45, 85),
	AccentDeep = Color3.fromRGB(150, 8, 40),
	AccentSoft = Color3.fromRGB(255, 120, 140),
	Text = Color3.fromRGB(250, 240, 242),
	SubText = Color3.fromRGB(175, 145, 150),
	Border = Color3.fromRGB(95, 25, 42),
	Success = Color3.fromRGB(70, 220, 130),
	Warning = Color3.fromRGB(255, 190, 60),
	Error = Color3.fromRGB(255, 70, 70),
}
local Theme = Ghostline.Theme

Ghostline.DefaultPalette = {}
for _, k in ipairs({ "BackgroundPrimary", "BackgroundSecondary", "GlassTint", "AccentGlow", "AccentDeep", "AccentSoft", "Text", "SubText", "Border" }) do
	Ghostline.DefaultPalette[k] = Theme[k]
end

local BaseStyle = {
	Layout = "Side",
	Header = 48,
	Size = Vector2.new(640, 430),
	Sidebar = 146,
	WindowRadius = 20,
	PanelRadius = 18,
	SidebarRadius = 14,
	TabRadius = 10,
	RowRadius = 10,
	SectionRadius = 12,
	NotifRadius = 14,
	MainAlpha = 0.1,
	RowAlpha = 0.4,
	RowHoverAlpha = 0.25,
	SidebarAlpha = 0.5,
	TabActiveAlpha = 0.5,
	MainGradient = true,
	RowGradient = true,
	RowHoverStroke = true,
	TabFlat = false,
	Orbs = true,
	Sheen = true,
	SpinStroke = true,
	AccentBar = true,
	TitleGradient = true,
	Indicator = true,
	Toggle = "Pill",
	LauncherText = "G",
}
Ghostline.Styles = { Ghostline = BaseStyle }
Ghostline.StyleOrder = { "Ghostline" }

function Ghostline:AddStyle(name, def)
	Ghostline.Styles[name] = setmetatable(def or {}, { __index = BaseStyle })
	if not table.find(Ghostline.StyleOrder, name) then
		table.insert(Ghostline.StyleOrder, name)
	end
end

Ghostline:AddStyle("Rayfield", {
	Layout = "Top",
	Header = 44,
	Size = Vector2.new(580, 410),
	WindowRadius = 10,
	PanelRadius = 10,
	SidebarRadius = 8,
	TabRadius = 7,
	RowRadius = 6,
	SectionRadius = 8,
	NotifRadius = 8,
	MainAlpha = 0,
	RowAlpha = 0,
	RowHoverAlpha = 0,
	SidebarAlpha = 0,
	TabActiveAlpha = 0,
	MainGradient = false,
	RowGradient = false,
	RowHoverStroke = false,
	TabFlat = true,
	Orbs = false,
	Sheen = false,
	SpinStroke = false,
	AccentBar = false,
	TitleGradient = false,
	Indicator = false,
	Toggle = "Pill",
	LauncherText = "R",
	Palette = {
		BackgroundPrimary = Color3.fromRGB(25, 25, 25),
		BackgroundSecondary = Color3.fromRGB(32, 32, 32),
		GlassTint = Color3.fromRGB(40, 40, 40),
		Border = Color3.fromRGB(56, 56, 56),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(160, 160, 160),
		AccentGlow = Color3.fromRGB(0, 146, 214),
		AccentDeep = Color3.fromRGB(0, 108, 162),
		AccentSoft = Color3.fromRGB(96, 184, 242),
	},
})

Ghostline:AddStyle("Orion", {
	Layout = "Side",
	Header = 44,
	Size = Vector2.new(620, 410),
	Sidebar = 150,
	WindowRadius = 8,
	PanelRadius = 8,
	SidebarRadius = 6,
	TabRadius = 5,
	RowRadius = 5,
	SectionRadius = 6,
	NotifRadius = 6,
	MainAlpha = 0,
	RowAlpha = 0,
	RowHoverAlpha = 0,
	SidebarAlpha = 0,
	TabActiveAlpha = 0.35,
	MainGradient = false,
	RowGradient = false,
	RowHoverStroke = true,
	TabFlat = true,
	Orbs = false,
	Sheen = false,
	SpinStroke = false,
	AccentBar = false,
	TitleGradient = false,
	Indicator = true,
	Toggle = "Box",
	LauncherText = "O",
	Palette = {
		BackgroundPrimary = Color3.fromRGB(21, 21, 26),
		BackgroundSecondary = Color3.fromRGB(29, 29, 36),
		GlassTint = Color3.fromRGB(37, 37, 46),
		Border = Color3.fromRGB(62, 62, 76),
		Text = Color3.fromRGB(238, 238, 244),
		SubText = Color3.fromRGB(148, 148, 162),
		AccentGlow = Color3.fromRGB(9, 99, 195),
		AccentDeep = Color3.fromRGB(6, 70, 140),
		AccentSoft = Color3.fromRGB(80, 150, 235),
	},
})

local EASE = Enum.EasingStyle
local DIR = Enum.EasingDirection
local WHITE = Color3.new(1, 1, 1)
local BLACK = Color3.new(0, 0, 0)
local IS_TOUCH = UserInputService.TouchEnabled
local function TH(h)
	return IS_TOUCH and (h + 6) or h
end

local function Tween(obj, time, props, style, dir)
	local t = TweenService:Create(obj, TweenInfo.new((time or 0.3) / (Ghostline.AnimSpeed or 1), style or EASE.Quart, dir or DIR.Out), props)
	t:Play()
	return t
end

local function To(obj, animated, time, props, style, dir)
	if animated then
		return Tween(obj, time, props, style, dir)
	end
	for k, v in pairs(props) do
		obj[k] = v
	end
end

local function New(class, props, children)
	local inst = Instance.new(class)
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then
			parent = v
		else
			inst[k] = v
		end
	end
	for _, c in ipairs(children or {}) do
		c.Parent = inst
	end
	if parent then
		inst.Parent = parent
	end
	return inst
end

local function Corner(parent, radius)
	return New("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent })
end

local function Stroke(parent, color, thickness, transparency)
	return New("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

local function Gradient(parent, stops, rotation, transparency)
	local keys = {}
	for _, s in ipairs(stops) do
		table.insert(keys, ColorSequenceKeypoint.new(s[1], s[2]))
	end
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(keys)
	g.Rotation = rotation or 0
	if transparency then
		local tk = {}
		for _, s in ipairs(transparency) do
			table.insert(tk, NumberSequenceKeypoint.new(s[1], s[2]))
		end
		g.Transparency = NumberSequence.new(tk)
	end
	g.Parent = parent
	return g
end

local function TextLabel(props)
	local p = {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = "",
		BorderSizePixel = 0,
	}
	for k, v in pairs(props) do
		p[k] = v
	end
	return New("TextLabel", p)
end

local function safe(cb, ...)
	if type(cb) ~= "function" then
		return
	end
	local ok, err = pcall(cb, ...)
	if not ok then
		warn("[Ghostline] " .. L("err_callback", tostring(err)))
	end
end

local function Ripple(parent, x, y)
	local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.4
	local c = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(x - parent.AbsolutePosition.X, y - parent.AbsolutePosition.Y),
		Size = UDim2.fromOffset(0, 0),
		BackgroundColor3 = Theme.AccentSoft,
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		Parent = parent,
	})
	Corner(c, 999)
	Tween(c, 0.55, { Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1 })
	task.delay(0.6, function()
		c:Destroy()
	end)
end

local function MountGui(gui)
	local ok = pcall(function()
		if gethui then
			gui.Parent = gethui()
		else
			gui.Parent = CoreGui
		end
	end)
	if not ok or not gui.Parent then
		gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
end

local function MakeDrag(Window, hit, onMove, onEnd, onStart)
	local dragging = false
	local locked
	local function isPointer(input)
		return input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
	end
	Window._track(hit.InputBegan, function(input)
		if isPointer(input) then
			dragging = true

			locked = hit:FindFirstAncestorWhichIsA("ScrollingFrame")
			if locked then
				locked.ScrollingEnabled = false
			end
			if onStart then
				onStart(input.Position)
			end
			onMove(input.Position)
		end
	end)
	Window._track(UserInputService.InputChanged, function(input)
		if
			dragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			onMove(input.Position)
		end
	end)
	Window._track(UserInputService.InputEnded, function(input)
		if dragging and isPointer(input) then
			dragging = false
			if locked then
				locked.ScrollingEnabled = true
				locked = nil
			end
			if onEnd then
				onEnd()
			end
		end
	end)
end

local function toHex(c)
	return string.format("#%02X%02X%02X", math.round(c.R * 255), math.round(c.G * 255), math.round(c.B * 255))
end

do
	local function killOld(container)
		pcall(function()
			local old = container:FindFirstChild("GhostlineLiquidUI")
			if old then
				old:Destroy()
			end
		end)
	end
	killOld(CoreGui)
	pcall(function()
		if gethui then
			killOld(gethui())
		end
	end)
	if Players.LocalPlayer then
		local pg = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if pg then
			killOld(pg)
		end
	end
end

local ScreenGui = New("ScreenGui", {
	Name = "GhostlineLiquidUI",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
})
MountGui(ScreenGui)

local NotifHolder = New("Frame", {
	Name = "Notifications",
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -16, 1, -16),
	Size = UDim2.new(0, 320, 1, -32),
	Parent = ScreenGui,
})
New("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	Padding = UDim.new(0, 10),
	Parent = NotifHolder,
})

local Tooltip = New("TextLabel", {
	BackgroundColor3 = Theme.BackgroundPrimary,
	BackgroundTransparency = 1,
	TextTransparency = 1,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextColor3 = Theme.Text,
	TextWrapped = true,
	AutomaticSize = Enum.AutomaticSize.XY,
	Size = UDim2.fromOffset(0, 0),
	Visible = false,
	ZIndex = 200,
	BorderSizePixel = 0,
	Text = "",
	Parent = ScreenGui,
})
Corner(Tooltip, 8)
local tipStroke = Stroke(Tooltip, Theme.AccentGlow, 1, 1)
New("UIPadding", {
	PaddingLeft = UDim.new(0, 8),
	PaddingRight = UDim.new(0, 8),
	PaddingTop = UDim.new(0, 5),
	PaddingBottom = UDim.new(0, 5),
	Parent = Tooltip,
})
New("UISizeConstraint", { MaxSize = Vector2.new(260, 400), Parent = Tooltip })
local tipConn, tipToken = nil, 0

function Ghostline:ShowTooltip(text)
	tipToken += 1
	Tooltip.Text = text
	Tooltip.Visible = true
	Tween(Tooltip, 0.2, { BackgroundTransparency = 0.05, TextTransparency = 0 })
	Tween(tipStroke, 0.2, { Transparency = 0.3 })
	if tipConn then
		tipConn:Disconnect()
	end
	tipConn = RunService.RenderStepped:Connect(function()
		local m = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
		local a = ScreenGui.AbsoluteSize
		local sz = Tooltip.AbsoluteSize
		Tooltip.Position = UDim2.fromOffset(math.min(m.X + 14, a.X - sz.X - 6), math.min(m.Y + 18, a.Y - sz.Y - 6))
	end)
end

function Ghostline:HideTooltip()
	tipToken += 1
	local token = tipToken
	Tween(Tooltip, 0.15, { BackgroundTransparency = 1, TextTransparency = 1 })
	Tween(tipStroke, 0.15, { Transparency = 1 })
	task.delay(0.17, function()
		if token == tipToken then
			Tooltip.Visible = false
			if tipConn then
				tipConn:Disconnect()
				tipConn = nil
			end
		end
	end)
end

function Ghostline:Notify(cfg)
	cfg = cfg or {}
	local title = cfg.Title or "Ghostline"
	local content = cfg.Content or ""
	local duration = cfg.Time or cfg.Duration or 4
	local kinds = {
		Info = Theme.AccentGlow,
		Success = Theme.Success,
		Warning = Theme.Warning,
		Error = Theme.Error,
	}
	local color = kinds[cfg.Type or "Info"] or Theme.AccentGlow
	local NS = Ghostline.ActiveStyle or Ghostline.Styles.Ghostline

	local textH = TextService:GetTextSize(content, 12, Enum.Font.Gotham, Vector2.new(270, 1000)).Y
	local height = 40 + textH + 22

	local Wrapper = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Parent = NotifHolder,
	})
	local Card = New("TextButton", {
		Size = UDim2.new(1, 0, 0, height),
		Position = UDim2.new(1, 80, 0, 0),
		BackgroundColor3 = NS.RowGradient and WHITE or Theme.BackgroundSecondary,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		ClipsDescendants = true,
		Parent = Wrapper,
	})
	Corner(Card, NS.NotifRadius)
	if NS.RowGradient then
		Gradient(Card, { { 0, Theme.GlassTint }, { 1, Theme.BackgroundPrimary } }, 45)
	end
	local stroke = Stroke(Card, color, 1.2, 0.35)

	local accent = New("Frame", {
		Position = UDim2.new(0, 6, 0, 10),
		Size = UDim2.new(0, 3, 1, -20),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = Card,
	})
	Corner(accent, 2)
	TextLabel({
		Size = UDim2.new(1, -30, 0, 20),
		Position = UDim2.new(0, 18, 0, 8),
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		Parent = Card,
	})
	TextLabel({
		Size = UDim2.new(1, -30, 0, textH),
		Position = UDim2.new(0, 18, 0, 30),
		Text = content,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = Theme.SubText,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = Card,
	})
	local barBack = New("Frame", {
		Size = UDim2.new(1, -28, 0, 3),
		Position = UDim2.new(0, 14, 1, -8),
		BackgroundTransparency = 1,
		Parent = Card,
	})
	local bar = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		Parent = barBack,
	})
	Corner(bar, 2)
	Gradient(bar, { { 0, Theme.AccentDeep }, { 1, color } }, 0)

	Tween(Wrapper, 0.4, { Size = UDim2.new(1, 0, 0, height) })
	Tween(Card, 0.6, { Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.12 }, EASE.Exponential)
	Tween(bar, duration, { Size = UDim2.new(0, 0, 1, 0) }, EASE.Linear)

	local closed = false
	local list = Ghostline._notifs
	local entry
	local function close()
		if closed then
			return
		end
		closed = true
		local at = table.find(list, entry)
		if at then
			table.remove(list, at)
		end
		Tween(Card, 0.45, { Position = UDim2.new(1, 80, 0, 0), BackgroundTransparency = 1 }, EASE.Exponential, DIR.In)
		Tween(stroke, 0.3, { Transparency = 1 })
		task.wait(0.3)
		Tween(Wrapper, 0.3, { Size = UDim2.new(1, 0, 0, 0) })
		task.wait(0.32)
		Wrapper:Destroy()
	end
	entry = function()
		task.spawn(close)
	end
	table.insert(list, entry)
	while #list > Ghostline.MaxNotifications do
		local oldest = table.remove(list, 1)
		oldest()
	end
	Card.MouseButton1Click:Connect(function()
		safe(cfg.Callback)
		task.spawn(close)
	end)
	task.delay(duration, function()
		task.spawn(close)
	end)
end

function Ghostline:MakeNotification(cfg)
	return Ghostline:Notify(cfg)
end

local function hasFS()
	return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

local function encode(obj)
	local v = obj.Value
	if obj.Kind == "Color" then
		return { r = v.R, g = v.G, b = v.B }
	elseif obj.Kind == "Keybind" then
		return v and v.Name or "Unknown"
	end
	return v
end

local function decode(obj, data)
	if obj.Kind == "Color" and type(data) == "table" then
		return Color3.new(data.r or 1, data.g or 1, data.b or 1)
	elseif obj.Kind == "Keybind" then
		local ok, key = pcall(function()
			return Enum.KeyCode[data]
		end)
		return ok and key or Enum.KeyCode.Unknown
	end
	return data
end

function Ghostline:SaveConfig(name)
	if not hasFS() then
		return false, L("err_fs")
	end
	name = name or "default"
	local data = {}
	for flag, obj in pairs(Ghostline.Flags) do
		data[flag] = encode(obj)
	end
	pcall(makefolder, Ghostline.ConfigFolder)
	return pcall(writefile, Ghostline.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
end

function Ghostline:LoadConfig(name)
	if not hasFS() then
		return false, L("err_fs")
	end
	name = name or "default"
	local path = Ghostline.ConfigFolder .. "/" .. name .. ".json"
	if not isfile(path) then
		return false, L("err_missing")
	end
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(path))
	end)
	if not ok then
		return false, L("err_corrupt")
	end
	for flag, value in pairs(data) do
		local obj = Ghostline.Flags[flag]
		if obj and obj.Set then
			Ghostline._loading = true
			pcall(obj.Set, obj, decode(obj, value))
			Ghostline._loading = false
		end
	end
	return true
end

Ghostline.Themes = {
	Red = Color3.fromRGB(255, 45, 85),
	Pink = Color3.fromRGB(255, 92, 170),
	Purple = Color3.fromRGB(160, 92, 255),
	Blue = Color3.fromRGB(56, 140, 255),
	Green = Color3.fromRGB(46, 214, 120),
	Yellow = Color3.fromRGB(255, 200, 40),
	Black = Color3.fromRGB(34, 34, 42),
}
Ghostline.ThemeOrder = { "Red", "Pink", "Purple", "Blue", "Green", "Yellow", "Black" }
Ghostline.CurrentTheme = "Red"
Ghostline.CurrentMode = "dark"
Ghostline._themeHooks = {}
Ghostline._themeGen = 0

local PALETTE_KEYS = {
	"BackgroundPrimary", "BackgroundSecondary", "GlassTint", "AccentGlow", "AccentDeep",
	"AccentSoft", "Text", "SubText", "Border",
}

local function ckey(c)
	return string.format("%.4f,%.4f,%.4f", c.R, c.G, c.B)
end

local function buildPalette(base, mode)
	local h, s, v = base:ToHSV()
	local c = Color3.fromHSV
	if mode == "light" then
		return {
			BackgroundPrimary = c(h, s * 0.05, 0.985),
			BackgroundSecondary = c(h, s * 0.12, 0.93),
			GlassTint = c(h, s * 0.26, 0.975),
			Border = c(h, s * 0.32, 0.80),
			Text = c(h, s * 0.45, 0.13),
			SubText = c(h, s * 0.35, 0.40),
			AccentGlow = c(h, s, v * 0.95),
			AccentDeep = c(h, s * 0.9, v * 0.78),
			AccentSoft = c(h, s, v * 0.6),
		}
	end
	return {
		BackgroundPrimary = c(h, math.min(1, s * 0.75), 0.06),
		BackgroundSecondary = c(h, math.min(1, s * 0.8), 0.115),
		GlassTint = c(h, math.min(1, s * 0.78), 0.21),
		Border = c(h, math.min(1, s * 0.62), 0.37),
		Text = c(h, s * 0.05, 0.98),
		SubText = c(h, s * 0.22, 0.70),
		AccentGlow = c(h, s, math.max(v, 0.95)),
		AccentDeep = c(h, s, math.clamp(v * 0.62, 0.32, 1)),
		AccentSoft = c(h, s * 0.5, 1),
	}
end

local function recolor(map, newSet, animate)
	for _, d in ipairs(ScreenGui:GetDescendants()) do
		local function fix(prop)
			local k = ckey(d[prop])
			if not animate and newSet[k] then
				return
			end
			local n = map[k]
			if n then
				if animate then
					Tween(d, 0.45, { [prop] = n }, EASE.Quad)
				else
					d[prop] = n
				end
			end
		end
		if d:IsA("GuiObject") then
			if not d:GetAttribute("GLFixed") then
				fix("BackgroundColor3")
			end
			if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
				fix("TextColor3")
			end
			if d:IsA("TextBox") then
				fix("PlaceholderColor3")
			end
			if d:IsA("ImageLabel") or d:IsA("ImageButton") then
				fix("ImageColor3")
			end
			if d:IsA("ScrollingFrame") then
				fix("ScrollBarImageColor3")
			end
		elseif d:IsA("UIStroke") then
			fix("Color")
		elseif d:IsA("UIGradient") then
			local changed, keys = false, {}
			for i, kp in ipairs(d.Color.Keypoints) do
				local n = map[ckey(kp.Value)]
				if n and (animate or not newSet[ckey(kp.Value)]) then
					changed = true
				else
					n = nil
				end
				keys[i] = ColorSequenceKeypoint.new(kp.Time, n or kp.Value)
			end
			if changed then
				d.Color = ColorSequence.new(keys)
			end
		end
	end
end

local function applyPalette(pal)
	Ghostline._themeGen += 1
	local gen = Ghostline._themeGen
	local map, newSet = {}, {}
	for _, k in ipairs(PALETTE_KEYS) do
		map[ckey(Theme[k])] = pal[k]
		newSet[ckey(pal[k])] = true
	end
	for _, k in ipairs(PALETTE_KEYS) do
		Theme[k] = pal[k]
	end
	recolor(map, newSet, true)

	task.delay(0.7, function()
		if Ghostline._themeGen == gen then
			recolor(map, newSet, false)
		end
	end)
end

function Ghostline:AddTheme(name, color)
	if not Ghostline.Themes[name] then
		table.insert(Ghostline.ThemeOrder, name)
	end
	Ghostline.Themes[name] = color
end

function Ghostline:SetTheme(name, mode)
	local requested = name
	name = resolveTheme(name or Ghostline.CurrentTheme)
	local base = name and Ghostline.Themes[name]
	if not base then
		return false, L("err_theme", tostring(requested))
	end
	mode = resolveMode(mode) or Ghostline.CurrentMode
	Ghostline.CurrentTheme, Ghostline.CurrentMode = name, mode
	applyPalette(buildPalette(base, mode))
	for i = #Ghostline._themeHooks, 1, -1 do
		local ok, keep = pcall(Ghostline._themeHooks[i])
		if not ok or keep == false then
			table.remove(Ghostline._themeHooks, i)
		end
	end
	return true
end

function Ghostline:SetMode(mode)
	return Ghostline:SetTheme(Ghostline.CurrentTheme, mode)
end

function Ghostline:ToggleMode()
	return Ghostline:SetMode(Ghostline.CurrentMode == "dark" and "light" or "dark")
end

function Ghostline:ExportConfig()
	local data = {}
	for flag, obj in pairs(Ghostline.Flags) do
		data[flag] = encode(obj)
	end
	return HttpService:JSONEncode(data)
end

function Ghostline:ImportConfig(json)
	local ok, data = pcall(function()
		return HttpService:JSONDecode(json)
	end)
	if not ok or type(data) ~= "table" then
		return false, L("err_corrupt")
	end
	for flag, value in pairs(data) do
		local obj = Ghostline.Flags[flag]
		if obj and obj.Set then
			Ghostline._loading = true
			pcall(obj.Set, obj, decode(obj, value))
			Ghostline._loading = false
		end
	end
	return true
end

function Ghostline:DeleteConfig(name)
	if type(delfile) ~= "function" or not hasFS() then
		return false, L("err_fs")
	end
	local path = Ghostline.ConfigFolder .. "/" .. (name or "default") .. ".json"
	if not isfile(path) then
		return false, L("err_missing")
	end
	return pcall(delfile, path)
end

function Ghostline:GetFlag(flag)
	local obj = Ghostline.Flags[flag]
	if not obj then
		return nil
	end
	if obj.Get then
		return obj:Get()
	end
	return obj.Value
end

function Ghostline:SetFlag(flag, value, silent)
	local obj = Ghostline.Flags[flag]
	if obj and obj.Set then
		obj:Set(value, silent)
		return true
	end
	return false
end

function Ghostline:EnableAutoSave(name, delay)
	Ghostline._auto = { Name = name or "autosave", Delay = delay or 2, Token = 0 }
end

function Ghostline:_markDirty()
	local a = Ghostline._auto
	if not a or Ghostline._loading then
		return
	end
	a.Token += 1
	local token = a.Token
	task.delay(a.Delay, function()
		if Ghostline._auto == a and a.Token == token then
			Ghostline:SaveConfig(a.Name)
		end
	end)
end

function Ghostline:ListConfigs()
	local list = {}
	if type(listfiles) ~= "function" then
		return list
	end
	local ok, files = pcall(listfiles, Ghostline.ConfigFolder)
	if not ok or type(files) ~= "table" then
		return list
	end
	for _, f in ipairs(files) do
		local n = tostring(f):match("([^/\\]+)%.json$")
		if n then
			table.insert(list, n)
		end
	end
	table.sort(list)
	return list
end

local function BuildElements(Target, Container, Tab, Window)
	local order = 0
	local S = Window.S
	local function nextOrder()
		order += 1
		return order
	end

	local function Row(height, name, class)
		local isBtn = class == "TextButton"
		local row = New(class or "Frame", {
			Size = UDim2.new(1, 0, 0, height),
			BackgroundColor3 = S.RowGradient and WHITE or Theme.BackgroundSecondary,
			BackgroundTransparency = S.RowAlpha,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			LayoutOrder = nextOrder(),
			Parent = Container,
		})
		if isBtn then
			row.Text = ""
			row.AutoButtonColor = false
		end
		Corner(row, S.RowRadius)
		if S.RowGradient then
			Gradient(row, { { 0, Theme.GlassTint }, { 1, Theme.BackgroundSecondary } }, 25)
		end
		local stroke = Stroke(row, Theme.Border, 1, 0.5)
		row.MouseEnter:Connect(function()
			if S.RowHoverStroke then
				Tween(stroke, 0.25, { Color = Theme.AccentGlow, Transparency = 0.15 })
			end
			if S.RowGradient then
				Tween(row, 0.25, { BackgroundTransparency = S.RowHoverAlpha })
			else
				Tween(row, 0.25, { BackgroundColor3 = Theme.GlassTint })
			end
		end)
		row.MouseLeave:Connect(function()
			if S.RowHoverStroke then
				Tween(stroke, 0.25, { Color = Theme.Border, Transparency = 0.5 })
			end
			if S.RowGradient then
				Tween(row, 0.25, { BackgroundTransparency = S.RowAlpha })
			else
				Tween(row, 0.25, { BackgroundColor3 = Theme.BackgroundSecondary })
			end
		end)
		table.insert(Tab._elements, { Frame = row, Name = string.lower(name or ""), Label = name or "", Stroke = stroke, Tab = Tab })
		return row, stroke
	end

	local function Finish(cfg, obj)
		local row = obj.Instance
		if cfg.Flag and obj.Set then
			local raw = obj.Set
			obj.Set = function(self, v, silent)
				raw(self, v, silent)
				if not silent then
					Ghostline:_markDirty()
				end
			end
		end
		if cfg.Flag then
			Ghostline.Flags[cfg.Flag] = obj
		end
		function obj:Destroy()
			if obj.Instance then
				obj.Instance:Destroy()
			end
		end
		function obj:SetVisible(v)
			if obj.Instance then
				obj.Instance.Visible = v and true or false
			end
		end
		function obj:SetLocked(v)
			v = v and true or false
			obj._locked = v
			local inst = obj.Instance
			if not inst then
				return
			end
			local shield = inst:FindFirstChild("GL_Lock")
			if v and not shield then
				shield = New("TextButton", {
					Name = "GL_Lock",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Theme.BackgroundPrimary,
					BackgroundTransparency = 0.45,
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Active = true,
					ZIndex = 20,
					Parent = inst,
				})
				Corner(shield, S.RowRadius)
			elseif shield then
				shield.Visible = v
			end
		end
		if cfg.Locked then
			obj:SetLocked(true)
		end
		if cfg.Visible == false then
			obj:SetVisible(false)
		end

		if row and cfg.Tooltip and not IS_TOUCH then
			row.MouseEnter:Connect(function()
				Ghostline:ShowTooltip(cfg.Tooltip)
			end)
			row.MouseLeave:Connect(function()
				Ghostline:HideTooltip()
			end)
		end

		if row and obj.Set and obj.Kind and obj.Kind ~= "Progress" then
			local default = obj.Value
			if type(default) == "table" then
				default = table.clone(default)
			end
			local function doReset()
				if obj._locked then
					return
				end
				local v = default
				if type(v) == "table" then
					v = table.clone(v)
				end
				obj:Set(v)
				local st = row:FindFirstChildOfClass("UIStroke")
				if st then
					Tween(st, 0.15, { Color = Theme.AccentSoft, Transparency = 0, Thickness = 2.5 })
					task.delay(0.35, function()
						Tween(st, 0.4, { Color = Theme.Border, Transparency = 0.5, Thickness = 1 })
					end)
				end
			end
			local lastTap = 0
			row.InputBegan:Connect(function(input)
				local t = input.UserInputType
				if t == Enum.UserInputType.MouseButton2 then
					doReset()
				elseif obj.Kind == "Slider" then
					if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
						if os.clock() - lastTap < 0.35 then
							lastTap = 0
							doReset()
						else
							lastTap = os.clock()
						end
					end
				elseif t == Enum.UserInputType.Touch then
					local start = input.Position
					task.delay(0.7, function()
						if
							input.UserInputState ~= Enum.UserInputState.End
							and input.UserInputState ~= Enum.UserInputState.Cancel
							and (input.Position - start).Magnitude < 10
						then
							doReset()
						end
					end)
				end
			end)
		end
		return obj
	end

	function Target:MakeLabel(text)
		local lbl = TextLabel({
			Size = UDim2.new(1, 0, 0, 22),
			Text = text or "",
			TextColor3 = Theme.SubText,
			TextSize = 12,
			LayoutOrder = nextOrder(),
			Parent = Container,
		})
		New("UIPadding", { PaddingLeft = UDim.new(0, 4), Parent = lbl })
		local obj = { Instance = lbl }
		function obj:Set(t)
			lbl.Text = t
		end
		return obj
	end

	function Target:MakeParagraph(cfg)
		local row = Row(0, cfg.Title)
		row.AutomaticSize = Enum.AutomaticSize.Y
		New("UIPadding", {
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			Parent = row,
		})
		New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = row })
		local title = TextLabel({
			Size = UDim2.new(1, 0, 0, 16),
			Text = cfg.Title or "",
			Font = Enum.Font.GothamBold,
			LayoutOrder = 1,
			Parent = row,
		})
		local body = TextLabel({
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = cfg.Content or "",
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Theme.SubText,
			TextWrapped = true,
			LayoutOrder = 2,
			Parent = row,
		})
		local obj = { Instance = row }
		function obj:Set(t, c)
			title.Text = t or title.Text
			body.Text = c or body.Text
		end
		return obj
	end

	function Target:MakeDivider()
		local d = New("Frame", {
			Size = UDim2.new(1, 0, 0, 2),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			LayoutOrder = nextOrder(),
			Parent = Container,
		})
		Gradient(d, { { 0, Theme.BackgroundPrimary }, { 0.5, Theme.AccentGlow }, { 1, Theme.BackgroundPrimary } }, 0)
		return { Instance = d }
	end

	function Target:MakeButton(cfg)
		local name = cfg.Name or "Button"
		local row = Row(TH(38), name, "TextButton")
		local fill = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = row,
		})
		Gradient(fill, { { 0, Theme.AccentDeep }, { 1, Theme.AccentGlow } }, 0)
		Corner(fill, S.RowRadius)
		local lbl = TextLabel({
			Size = UDim2.new(1, 0, 1, 0),
			Text = name,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = row,
		})
		row.MouseEnter:Connect(function()
			Tween(fill, 0.3, { BackgroundTransparency = 0.7 })
		end)
		row.MouseLeave:Connect(function()
			Tween(fill, 0.3, { BackgroundTransparency = 1 })
		end)
		row.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				Ripple(row, input.Position.X, input.Position.Y)
				Tween(fill, 0.1, { BackgroundTransparency = 0.35 })
			end
		end)
		row.MouseButton1Click:Connect(function()
			Tween(fill, 0.3, { BackgroundTransparency = 0.7 })
			safe(cfg.Callback)
		end)
		local obj = { Instance = row }
		function obj:SetText(t)
			lbl.Text = t
		end
		return Finish(cfg, obj)
	end

	function Target:MakeToggle(cfg)
		local name = cfg.Name or "Toggle"
		local row = Row(TH(38), name, "TextButton")
		TextLabel({ Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = row })
		local apply
		if S.Toggle == "Box" then
			local box = New("Frame", {
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(1, -36, 0.5, -12),
				BackgroundColor3 = Theme.BackgroundPrimary,
				BorderSizePixel = 0,
				Parent = row,
			})
			Corner(box, 5)
			local boxStroke = Stroke(box, Theme.Border, 1.2, 0.1)
			local boxFill = New("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Theme.AccentGlow,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = box,
			})
			Corner(boxFill, 5)
			local legShort = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, -3.5, 0.5, 2.5),
				Size = UDim2.new(0, 3, 0, 7),
				Rotation = -45,
				BackgroundColor3 = WHITE,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = box,
			})
			Corner(legShort, 1)
			local legLong = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 3, 0.5, -0.5),
				Size = UDim2.new(0, 3, 0, 13),
				Rotation = 45,
				BackgroundColor3 = WHITE,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = box,
			})
			Corner(legLong, 1)
			apply = function(v)
				Tween(boxFill, 0.25, { BackgroundTransparency = v and 0 or 1 })
				Tween(legShort, 0.25, { BackgroundTransparency = v and 0 or 1 })
				Tween(legLong, 0.25, { BackgroundTransparency = v and 0 or 1 })
				Tween(boxStroke, 0.25, { Color = v and Theme.AccentGlow or Theme.Border })
			end
		else
			local track = New("Frame", {
				Size = UDim2.new(0, 44, 0, 22),
				Position = UDim2.new(1, -56, 0.5, -11),
				BackgroundColor3 = Theme.BackgroundPrimary,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = row,
			})
			Corner(track, 11)
			Stroke(track, Theme.Border, 1, 0.3)
			local onFill = New("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = WHITE,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = track,
			})
			Corner(onFill, 11)
			Gradient(onFill, { { 0, Theme.AccentDeep }, { 1, Theme.AccentGlow } }, 0)
			local knob = New("Frame", {
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0, 3, 0.5, -8),
				BackgroundColor3 = Theme.Text,
				BorderSizePixel = 0,
				Parent = track,
			})
			Corner(knob, 8)
			apply = function(v)
				Tween(onFill, 0.3, { BackgroundTransparency = v and 0 or 1 })
				Tween(knob, 0.4, { Position = v and UDim2.new(0, 25, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) }, EASE.Back)
			end
		end

		local obj = { Value = false, Instance = row, Kind = "Toggle" }
		function obj:Set(v, silent)
			v = v and true or false
			obj.Value = v
			apply(v)
			if not silent then
				safe(cfg.Callback, v)
			end
		end
		function obj:Get()
			return obj.Value
		end
		row.MouseButton1Click:Connect(function()
			obj:Set(not obj.Value)
		end)
		obj:Set(cfg.Default or false, true)
		return Finish(cfg, obj)
	end

	function Target:MakeCheckbox(cfg)
		local name = cfg.Name or "Checkbox"
		local row = Row(TH(38), name, "TextButton")
		TextLabel({ Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = row })
		local box = New("Frame", {
			Size = UDim2.new(0, 22, 0, 22),
			Position = UDim2.new(1, -34, 0.5, -11),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(box, 6)
		local boxStroke = Stroke(box, Theme.Border, 1.5, 0.1)
		local fill = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = box,
		})
		Corner(fill, 4)
		Gradient(fill, { { 0, Theme.AccentDeep }, { 1, Theme.AccentGlow } }, 45)

		local obj = { Value = false, Instance = row, Kind = "Checkbox" }
		function obj:Set(v, silent)
			v = v and true or false
			obj.Value = v
			Tween(fill, 0.35, { Size = v and UDim2.new(1, -8, 1, -8) or UDim2.new(0, 0, 0, 0) }, EASE.Back)
			Tween(boxStroke, 0.3, { Color = v and Theme.AccentGlow or Theme.Border })
			if not silent then
				safe(cfg.Callback, v)
			end
		end
		function obj:Get()
			return obj.Value
		end
		row.MouseButton1Click:Connect(function()
			obj:Set(not obj.Value)
		end)
		obj:Set(cfg.Default or false, true)
		return Finish(cfg, obj)
	end

	function Target:MakeSlider(cfg)
		local name = cfg.Name or "Slider"
		local min, max = cfg.Min or 0, cfg.Max or 100
		local inc = cfg.Increment or 1
		local suffix = cfg.Suffix or ""
		local frac = tostring(inc):split(".")[2] or ""
		local decimals = #frac

		local row = Row(54, name)
		TextLabel({ Size = UDim2.new(0.6, 0, 0, 20), Position = UDim2.new(0, 12, 0, 7), Text = name, Parent = row })
		local valueLbl = TextLabel({
			Size = UDim2.new(0.4, -24, 0, 20),
			Position = UDim2.new(0.6, 12, 0, 7),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextColor3 = Theme.AccentSoft,
			Parent = row,
		})
		local track = New("Frame", {
			Size = UDim2.new(1, -24, 0, 6),
			Position = UDim2.new(0, 12, 0, 36),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(track, 3)
		local fill = New("Frame", {
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = track,
		})
		Corner(fill, 3)
		Gradient(fill, { { 0, Theme.AccentDeep }, { 1, Theme.AccentGlow } }, 0)
		local knob = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(0, 14, 0, 14),
			BackgroundColor3 = Theme.Text,
			BorderSizePixel = 0,
			ZIndex = 2,
			Parent = track,
		})
		Corner(knob, 9)
		Stroke(knob, Theme.AccentGlow, 2, 0)
		local hit = New("TextButton", {
			Size = UDim2.new(1, -16, 0, IS_TOUCH and 38 or 26),
			Position = UDim2.new(0, 8, 0, IS_TOUCH and 16 or 26),
			BackgroundTransparency = 1,
			Text = "",
			Parent = row,
		})

		local function snap(v)
			v = math.clamp(math.floor(v / inc + 0.5) * inc, min, max)
			return tonumber(string.format("%." .. decimals .. "f", v))
		end

		local obj = { Value = min, Instance = row, Kind = "Slider" }
		function obj:Set(v, silent)
			v = snap(v)
			obj.Value = v
			local a = (max == min) and 0 or (v - min) / (max - min)
			valueLbl.Text = tostring(v) .. suffix
			Tween(fill, 0.12, { Size = UDim2.new(a, 0, 1, 0) })
			Tween(knob, 0.12, { Position = UDim2.new(a, 0, 0.5, 0) })
			if not silent then
				safe(cfg.Callback, v)
			end
		end
		function obj:Get()
			return obj.Value
		end

		MakeDrag(Window, hit, function(pos)
			local a = math.clamp((pos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			local s = snap(min + a * (max - min))
			if s ~= obj.Value then
				obj:Set(s)
			end
		end, function()
			Tween(knob, 0.2, { Size = UDim2.new(0, 14, 0, 14) })
		end, function()
			Tween(knob, 0.25, { Size = UDim2.new(0, 18, 0, 18) }, EASE.Back)
		end)

		obj:Set(cfg.Default or min, true)
		return Finish(cfg, obj)
	end

	function Target:MakeProgressBar(cfg)
		local name = cfg.Name or "Progress"
		local row = Row(46, name)
		TextLabel({ Size = UDim2.new(0.6, 0, 0, 20), Position = UDim2.new(0, 12, 0, 6), Text = name, Parent = row })
		local pct = TextLabel({
			Size = UDim2.new(0.4, -24, 0, 20),
			Position = UDim2.new(0.6, 12, 0, 6),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextColor3 = Theme.AccentSoft,
			Parent = row,
		})
		local track = New("Frame", {
			Size = UDim2.new(1, -24, 0, 6),
			Position = UDim2.new(0, 12, 0, 32),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = row,
		})
		Corner(track, 3)
		local fill = New("Frame", {
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = track,
		})
		Corner(fill, 3)
		local g = Gradient(fill, { { 0, Theme.AccentDeep }, { 0.5, Theme.AccentGlow }, { 1, Theme.AccentDeep } }, 0)
		TweenService:Create(g, TweenInfo.new(1.6, EASE.Linear, DIR.Out, -1), { Offset = Vector2.new(1, 0) }):Play()
		g.Offset = Vector2.new(-1, 0)

		local obj = { Value = 0, Instance = row, Kind = "Progress" }
		function obj:Set(a)
			a = math.clamp(a or 0, 0, 1)
			obj.Value = a
			pct.Text = math.floor(a * 100) .. "%"
			Tween(fill, 0.4, { Size = UDim2.new(a, 0, 1, 0) })
		end
		obj:Set(cfg.Default or 0)
		return Finish(cfg, obj)
	end

	function Target:MakeTextbox(cfg)
		local name = cfg.Name or "Textbox"
		local row = Row(TH(38), name)
		TextLabel({ Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = row })
		local box = New("TextBox", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Size = UDim2.new(0.42, 0, 0, 26),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BackgroundTransparency = 0.2,
			Text = cfg.Default or "",
			PlaceholderText = cfg.Placeholder or "...",
			PlaceholderColor3 = Theme.SubText,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			ClearTextOnFocus = cfg.ClearOnFocus or false,
			ClipsDescendants = true,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(box, 7)
		local bs = Stroke(box, Theme.Border, 1, 0.4)
		box.Focused:Connect(function()
			Tween(bs, 0.25, { Color = Theme.AccentGlow, Transparency = 0 })
		end)
		local obj = { Value = box.Text, Instance = row, Kind = "Textbox" }
		box.FocusLost:Connect(function()
			Tween(bs, 0.25, { Color = Theme.Border, Transparency = 0.4 })
			obj.Value = box.Text
			safe(cfg.Callback, box.Text)
		end)
		function obj:Set(t, silent)
			box.Text = tostring(t)
			obj.Value = box.Text
			if not silent then
				safe(cfg.Callback, box.Text)
			end
		end
		return Finish(cfg, obj)
	end

	function Target:MakeDropdown(cfg)
		local name = cfg.Name or "Dropdown"
		local multi = cfg.Multi or false
		local options = cfg.Options or {}

		local row = Row(38, name)
		local header = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundTransparency = 1,
			Text = "",
			Parent = row,
		})
		TextLabel({ Size = UDim2.new(0.5, 0, 0, 38), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = header })
		local valueLbl = TextLabel({
			Size = UDim2.new(0.5, -40, 0, 38),
			Position = UDim2.new(0.5, 0, 0, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextColor3 = Theme.AccentSoft,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = header,
		})
		local arrow = TextLabel({
			Size = UDim2.new(0, 20, 0, 38),
			Position = UDim2.new(1, -28, 0, 0),
			Text = ">",
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = Enum.Font.GothamBold,
			TextColor3 = Theme.AccentGlow,
			Parent = header,
		})
		local list = New("ScrollingFrame", {
			Position = UDim2.new(0, 8, 0, 44),
			Size = UDim2.new(1, -16, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Theme.AccentGlow,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Parent = row,
		})
		New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })

		local obj = { Options = options, Value = multi and {} or nil, Instance = row, Kind = "Dropdown" }
		local open = false
		local buttons = {}

		local function listHeight()
			return #options > 0 and (math.min(#options, 5) * 32 - 4) or 0
		end
		local function rowHeight()
			return open and (38 + 6 + listHeight() + 8) or 38
		end
		local function isSelected(opt)
			if multi then
				return table.find(obj.Value, opt) ~= nil
			end
			return obj.Value == opt
		end
		local function updateLabel()
			if multi then
				valueLbl.Text = #obj.Value == 0 and L("none") or table.concat(obj.Value, ", ")
			else
				valueLbl.Text = obj.Value ~= nil and tostring(obj.Value) or L("none")
			end
		end
		table.insert(Ghostline._langBound, { inst = valueLbl, fn = updateLabel })
		local function paint()
			for opt, b in pairs(buttons) do
				local sel = isSelected(opt)
				Tween(b, 0.2, {
					BackgroundTransparency = sel and 0.35 or 0.85,
					TextColor3 = sel and Theme.Text or Theme.SubText,
				})
			end
		end
		local function setOpen(state)
			open = state
			Tween(row, 0.4, { Size = UDim2.new(1, 0, 0, rowHeight()) }, EASE.Quart)
			Tween(list, 0.4, { Size = UDim2.new(1, -16, 0, listHeight()) }, EASE.Quart)
			Tween(arrow, 0.3, { Rotation = state and 90 or 0 })
		end

		function obj:Set(v, silent)
			if multi then
				obj.Value = type(v) == "table" and table.clone(v) or (v ~= nil and { v } or {})
			else
				obj.Value = v
			end
			updateLabel()
			paint()
			if not silent then
				safe(cfg.Callback, obj.Value)
			end
		end
		function obj:Get()
			return obj.Value
		end

		local function pick(opt)
			if multi then
				local new = table.clone(obj.Value)
				local i = table.find(new, opt)
				if i then
					table.remove(new, i)
				else
					table.insert(new, opt)
				end
				obj:Set(new)
			else
				obj:Set(opt)
				setOpen(false)
			end
		end

		function obj:Refresh(newOptions)
			options = newOptions or {}
			obj.Options = options
			for _, b in pairs(buttons) do
				b:Destroy()
			end
			buttons = {}
			for i, raw in ipairs(options) do
				local opt = tostring(raw)
				local b = New("TextButton", {
					Size = UDim2.new(1, -4, 0, 28),
					BackgroundColor3 = Theme.AccentDeep,
					BackgroundTransparency = 0.85,
					Text = opt,
					Font = Enum.Font.GothamMedium,
					TextSize = 12,
					TextColor3 = Theme.SubText,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					LayoutOrder = i,
					Parent = list,
				})
				Corner(b, 7)
				b.MouseEnter:Connect(function()
					if not isSelected(opt) then
						Tween(b, 0.2, { BackgroundTransparency = 0.6 })
					end
				end)
				b.MouseLeave:Connect(function()
					if not isSelected(opt) then
						Tween(b, 0.2, { BackgroundTransparency = 0.85 })
					end
				end)
				b.MouseButton1Click:Connect(function()
					pick(opt)
				end)
				buttons[opt] = b
			end
			if open then
				setOpen(true)
			end
			paint()
		end

		header.MouseButton1Click:Connect(function()
			setOpen(not open)
		end)

		obj:Refresh(options)
		obj:Set(cfg.Default or (multi and {} or nil), true)
		return Finish(cfg, obj)
	end

	function Target:MakeKeybind(cfg)
		local name = cfg.Name or "Keybind"
		local mode = cfg.Mode or "Press"
		local row = Row(TH(38), name)
		TextLabel({ Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = row })
		local bind = New("TextButton", {
			Size = UDim2.new(0, 90, 0, 26),
			Position = UDim2.new(1, -100, 0.5, -13),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BackgroundTransparency = 0.2,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextColor3 = Theme.AccentGlow,
			AutoButtonColor = false,
			Text = "",
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(bind, 7)
		local bs = Stroke(bind, Theme.Border, 1, 0.4)

		local unknown = Enum.KeyCode.Unknown
		local obj = { Value = cfg.Default or unknown, Instance = row, Kind = "Keybind" }
		local binding = false

		function obj:Set(key, silent)
			obj.Value = key or unknown
			bind.Text = obj.Value == unknown and "None" or obj.Value.Name
			if not silent then
				safe(cfg.Changed, obj.Value)
			end
		end
		function obj:Get()
			return obj.Value
		end

		bind.MouseButton1Click:Connect(function()
			binding = true
			Window.Binding = true
			bind.Text = "..."
			Tween(bs, 0.2, { Color = Theme.AccentGlow, Transparency = 0 })
		end)

		Window._track(UserInputService.InputBegan, function(input, gpe)
			if binding then
				if input.UserInputType == Enum.UserInputType.Keyboard then
					binding = false
					task.defer(function()
						Window.Binding = false
					end)
					if input.KeyCode == Enum.KeyCode.Escape then
						obj:Set(obj.Value, true)
					elseif input.KeyCode == Enum.KeyCode.Backspace then
						obj:Set(unknown)
					else
						obj:Set(input.KeyCode)
					end
					Tween(bs, 0.25, { Color = Theme.Border, Transparency = 0.4 })
				end
				return
			end
			if gpe or obj.Value == unknown then
				return
			end
			if input.KeyCode == obj.Value then
				if mode == "Hold" then
					safe(cfg.Callback, true)
				else
					safe(cfg.Callback)
				end
			end
		end)
		Window._track(UserInputService.InputEnded, function(input)
			if mode == "Hold" and obj.Value ~= unknown and input.KeyCode == obj.Value then
				safe(cfg.Callback, false)
			end
		end)

		obj:Set(obj.Value, true)
		return Finish(cfg, obj)
	end

	function Target:MakeColorPicker(cfg)
		local name = cfg.Name or "Color"
		local row = Row(38, name)
		local header = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundTransparency = 1,
			Text = "",
			Parent = row,
		})
		TextLabel({ Size = UDim2.new(0.6, 0, 0, 38), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = header })
		local preview = New("Frame", {
			Size = UDim2.new(0, 44, 0, 22),
			Position = UDim2.new(1, -56, 0, 8),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = header,
		})
		Corner(preview, 7)
		Stroke(preview, Theme.Text, 1, 0.7)

		local h, s, v = (cfg.Default or Theme.AccentGlow):ToHSV()

		local sv = New("Frame", {
			Position = UDim2.new(0, 12, 0, 46),
			Size = UDim2.new(1, -48, 0, 110),
			BackgroundColor3 = Color3.fromHSV(h, 1, 1),
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(sv, 6)
		local whiteOv = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = sv,
		})
		Corner(whiteOv, 6)
		Gradient(whiteOv, { { 0, WHITE }, { 1, WHITE } }, 0, { { 0, 0 }, { 1, 1 } })
		local blackOv = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = BLACK,
			BorderSizePixel = 0,
			Parent = sv,
		})
		Corner(blackOv, 6)
		Gradient(blackOv, { { 0, BLACK }, { 1, BLACK } }, 90, { { 0, 1 }, { 1, 0 } })
		local svCursor = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 12, 0, 12),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = sv,
		})
		Corner(svCursor, 6)
		Stroke(svCursor, WHITE, 2, 0)

		local hue = New("Frame", {
			Position = UDim2.new(1, -28, 0, 46),
			Size = UDim2.new(0, 16, 0, 110),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(hue, 6)
		Gradient(hue, {
			{ 0, Color3.fromRGB(255, 0, 0) },
			{ 1 / 6, Color3.fromRGB(255, 255, 0) },
			{ 2 / 6, Color3.fromRGB(0, 255, 0) },
			{ 3 / 6, Color3.fromRGB(0, 255, 255) },
			{ 4 / 6, Color3.fromRGB(0, 0, 255) },
			{ 5 / 6, Color3.fromRGB(255, 0, 255) },
			{ 1, Color3.fromRGB(255, 0, 0) },
		}, 90)
		local hueCursor = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 6, 0, 5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = hue,
		})
		Corner(hueCursor, 3)
		Stroke(hueCursor, WHITE, 2, 0)

		local hex = New("TextBox", {
			Position = UDim2.new(0, 12, 0, 164),
			Size = UDim2.new(1, -24, 0, 24),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BackgroundTransparency = 0.2,
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamMedium,
			TextSize = 12,
			ClearTextOnFocus = false,
			BorderSizePixel = 0,
			Text = "",
			Parent = row,
		})
		Corner(hex, 7)
		Stroke(hex, Theme.Border, 1, 0.4)

		local obj = { Value = Color3.fromHSV(h, s, v), Instance = row, Kind = "Color" }
		local open = false

		local function apply(silent)
			local color = Color3.fromHSV(h, s, v)
			obj.Value = color
			sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			preview.BackgroundColor3 = color
			svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
			hueCursor.Position = UDim2.new(0.5, 0, h, 0)
			hex.Text = toHex(color)
			if not silent then
				safe(cfg.Callback, color)
			end
		end
		function obj:Set(color, silent)
			h, s, v = color:ToHSV()
			apply(silent)
		end
		function obj:Get()
			return obj.Value
		end

		MakeDrag(Window, sv, function(pos)
			s = math.clamp((pos.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
			v = 1 - math.clamp((pos.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
			apply()
		end)
		MakeDrag(Window, hue, function(pos)
			h = math.clamp((pos.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 1)
			apply()
		end)
		hex.FocusLost:Connect(function()
			local r, g, b = hex.Text:match("^#?(%x%x)(%x%x)(%x%x)$")
			if r then
				obj:Set(Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)))
			else
				hex.Text = toHex(obj.Value)
			end
		end)
		header.MouseButton1Click:Connect(function()
			open = not open
			Tween(row, 0.45, { Size = UDim2.new(1, 0, 0, open and 198 or 38) }, EASE.Quart)
		end)

		apply(true)
		return Finish(cfg, obj)
	end

	function Target:MakeThemePicker(cfg)
		cfg = cfg or {}
		local name = cfg.Name or L("theme")
		local size = IS_TOUCH and 34 or 28
		local row = Row(92, name)
		TextLabel({ Size = UDim2.new(0.4, 0, 0, 38), Position = UDim2.new(0, 12, 0, 0), Text = name, Parent = row })

		local seg = New("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -10, 0, 6),
			Size = UDim2.new(0, 140, 0, 26),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BackgroundTransparency = 0.2,
			BorderSizePixel = 0,
			Parent = row,
		})
		Corner(seg, 13)
		local pill = New("Frame", {
			Position = UDim2.new(0, 3, 0, 3),
			Size = UDim2.new(0.5, -3, 1, -6),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = seg,
		})
		Corner(pill, 10)
		Gradient(pill, { { 0, Theme.AccentDeep }, { 1, Theme.AccentGlow } }, 0)
		local function segBtn(text, x)
			return New("TextButton", {
				Size = UDim2.new(0.5, 0, 1, 0),
				Position = UDim2.new(x, 0, 0, 0),
				BackgroundTransparency = 1,
				Text = text,
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextColor3 = Theme.SubText,
				AutoButtonColor = false,
				Parent = seg,
			})
		end
		local darkBtn, lightBtn = segBtn(L("dark"), 0), segBtn(L("light"), 0.5)
		bindText(darkBtn, "Text", Loc("dark"))
		bindText(lightBtn, "Text", Loc("light"))

		local holder = New("Frame", {
			Position = UDim2.new(0, 8, 0, 44),
			Size = UDim2.new(1, -16, 0, 40),
			BackgroundTransparency = 1,
			Parent = row,
		})
		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 9),
			Parent = holder,
		})

		local obj = { Value = { Theme = Ghostline.CurrentTheme, Mode = Ghostline.CurrentMode }, Instance = row, Kind = "Theme" }
		local swatches = {}
		for i, tname in ipairs(Ghostline.ThemeOrder) do
			local sw = New("TextButton", {
				Size = UDim2.fromOffset(size, size),
				BackgroundColor3 = Ghostline.Themes[tname],
				Text = "",
				AutoButtonColor = false,
				BorderSizePixel = 0,
				LayoutOrder = i,
				Parent = holder,
			})
			sw:SetAttribute("GLFixed", true)
			Corner(sw, 999)
			local ring = Stroke(sw, Theme.Border, 1, 0.3)
			swatches[tname] = { btn = sw, ring = ring }
			sw.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Ripple(sw, input.Position.X, input.Position.Y)
				end
			end)
			sw.MouseButton1Click:Connect(function()
				obj:Set({ Theme = tname })
			end)
		end

		local function paint(animated)
			local cur, mode = Ghostline.CurrentTheme, Ghostline.CurrentMode
			for tname, sp in pairs(swatches) do
				local sel = tname == cur
				To(sp.ring, animated, 0.3, {
					Color = sel and Theme.Text or Theme.Border,
					Thickness = sel and 2.5 or 1,
					Transparency = sel and 0 or 0.3,
				})
				To(sp.btn, animated, 0.35, { Size = UDim2.fromOffset(sel and size + 6 or size, sel and size + 6 or size) }, EASE.Back)
			end
			To(pill, animated, 0.4, { Position = mode == "light" and UDim2.new(0.5, 0, 0, 3) or UDim2.new(0, 3, 0, 3) }, EASE.Back)
			To(darkBtn, animated, 0.3, { TextColor3 = mode == "dark" and Theme.Text or Theme.SubText })
			To(lightBtn, animated, 0.3, { TextColor3 = mode == "light" and Theme.Text or Theme.SubText })
		end

		function obj:Set(v, silent)
			v = type(v) == "table" and v or {}
			Ghostline:SetTheme(v.Theme or Ghostline.CurrentTheme, v.Mode or Ghostline.CurrentMode)
			obj.Value = { Theme = Ghostline.CurrentTheme, Mode = Ghostline.CurrentMode }
			paint(true)
			if not silent then
				safe(cfg.Callback, obj.Value)
			end
		end
		function obj:Get()
			return obj.Value
		end
		darkBtn.MouseButton1Click:Connect(function()
			obj:Set({ Mode = "dark" })
		end)
		lightBtn.MouseButton1Click:Connect(function()
			obj:Set({ Mode = "light" })
		end)
		table.insert(Ghostline._themeHooks, function()
			if not row.Parent then
				return false
			end
			obj.Value = { Theme = Ghostline.CurrentTheme, Mode = Ghostline.CurrentMode }
			paint(true)
		end)
		paint(false)
		return Finish(cfg, obj)
	end

	function Target:MakeSection(cfg)
		cfg = type(cfg) == "string" and { Name = cfg } or (cfg or {})
		local open = cfg.Open ~= false
		local sec = New("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BackgroundTransparency = 0.55,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			LayoutOrder = nextOrder(),
			Parent = Container,
		})
		Corner(sec, S.SectionRadius)
		Stroke(sec, Theme.AccentDeep, 1, 0.4)
		local head = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundTransparency = 1,
			Text = "",
			Parent = sec,
		})
		local title = TextLabel({
			Size = UDim2.new(1, -40, 1, 0),
			Position = UDim2.new(0, 14, 0, 0),
			Text = string.upper(cfg.Name or "Section"),
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextColor3 = Theme.AccentSoft,
			Parent = head,
		})
		Gradient(title, { { 0, Theme.AccentSoft }, { 1, Theme.AccentGlow } }, 0)
		local arrow = TextLabel({
			Size = UDim2.new(0, 20, 1, 0),
			Position = UDim2.new(1, -28, 0, 0),
			Text = ">",
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = Enum.Font.GothamBold,
			TextColor3 = Theme.AccentGlow,
			Rotation = open and 90 or 0,
			Parent = head,
		})
		local inner = New("Frame", {
			Position = UDim2.new(0, 8, 0, 38),
			Size = UDim2.new(1, -16, 0, 0),
			BackgroundTransparency = 1,
			Parent = sec,
		})
		local layout = New("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = inner,
		})
		local function height()
			return open and (34 + 4 + layout.AbsoluteContentSize.Y + 8) or 34
		end
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			inner.Size = UDim2.new(1, -16, 0, layout.AbsoluteContentSize.Y)
			sec.Size = UDim2.new(1, 0, 0, height())
		end)
		head.MouseButton1Click:Connect(function()
			open = not open
			Tween(sec, 0.4, { Size = UDim2.new(1, 0, 0, height()) }, EASE.Quart)
			Tween(arrow, 0.3, { Rotation = open and 90 or 0 })
		end)

		local Section = { Instance = sec }
		BuildElements(Section, inner, Tab, Window)
		return Section
	end

	function Target:MakeLanguagePicker(cfg)
		cfg = cfg or {}
		local names, byName = {}, {}
		for _, code in ipairs(Ghostline.LanguageOrder) do
			local n = Ghostline.LanguageNames[code] or code
			table.insert(names, n)
			byName[n] = code
		end
		local dd
		dd = Target:MakeDropdown({
			Name = cfg.Name or Loc("language"),
			Options = names,
			Default = Ghostline.LanguageNames[Ghostline.Language] or Ghostline.Language,
			Flag = cfg.Flag,
			Tooltip = cfg.Tooltip,
			Callback = function(v)
				local code = byName[v]
				if code and code ~= Ghostline.Language then
					Ghostline:SetLanguage(code)
				end
				safe(cfg.Callback, code)
			end,
		})
		Ghostline:OnLanguageChanged(function(code)
			if not (dd.Instance and dd.Instance.Parent) then
				return false
			end
			dd:Set(Ghostline.LanguageNames[code] or code, true)
		end)
		return dd
	end

	local LOC_FIELDS = { "Name", "Title", "Content", "Placeholder", "Tooltip" }
	local LOC_FNS = {
		"MakeLabel", "MakeParagraph", "MakeButton", "MakeToggle", "MakeCheckbox", "MakeSlider",
		"MakeProgressBar", "MakeTextbox", "MakeDropdown", "MakeKeybind", "MakeColorPicker",
		"MakeThemePicker", "MakeSection",
	}

	local function bindSpecs(obj, cfg, specs)
		local root = obj.Instance
		if not root then
			return
		end
		for field, spec in pairs(specs) do
			if field == "Tooltip" then
				bindFn(root, function()
					cfg.Tooltip = resolveText(spec)
				end)
			elseif field == "__label" then
				bindText(root, "Text", spec)
			elseif field == "Placeholder" then
				for _, d in ipairs(root:GetDescendants()) do
					if d:IsA("TextBox") and d.PlaceholderText == cfg.Placeholder then
						bindText(d, "PlaceholderText", spec)
						break
					end
				end
			else
				local current = cfg[field]
				local up = string.upper(current)
				local pool = root:GetDescendants()
				table.insert(pool, 1, root)
				for _, d in ipairs(pool) do
					if (d:IsA("TextLabel") or d:IsA("TextButton")) and (d.Text == current or d.Text == up) then
						local isUp = d.Text == up and current ~= up
						bindFn(d, function()
							local t = resolveText(spec)
							d.Text = isUp and string.upper(t) or t
							if field == "Name" or field == "Title" then
								for _, e in ipairs(Tab._elements) do
									if e.Frame == root then
										e.Name = string.lower(t)
										e.Label = t
									end
								end
							end
						end)
						break
					end
				end
			end
		end
	end

	for _, fname in ipairs(LOC_FNS) do
		local orig = Target[fname]
		if orig then
			Target[fname] = function(self, cfg, ...)
				local specs
				if fname == "MakeLabel" or (fname == "MakeSection" and isSpec(cfg)) then
					if isSpec(cfg) then
						if fname == "MakeLabel" then
							specs = { __label = cfg }
							cfg = resolveText(cfg)
						else
							specs = { Name = cfg }
							cfg = { Name = resolveText(cfg) }
						end
					end
				elseif type(cfg) == "table" then
					if fname == "MakeThemePicker" and cfg.Name == nil then
						cfg = table.clone(cfg)
						cfg.Name = Loc("theme")
					end
					for _, f in ipairs(LOC_FIELDS) do
						if isSpec(cfg[f]) then
							if not specs then
								specs = {}
								cfg = table.clone(cfg)
							end
							specs[f] = cfg[f]
							cfg[f] = resolveText(specs[f])
						end
					end
				elseif cfg == nil and fname == "MakeThemePicker" then
					cfg = { Name = Loc("theme") }
					specs = { Name = cfg.Name }
					cfg = { Name = resolveText(specs.Name) }
				end
				local obj = orig(self, cfg, ...)
				if specs and obj then
					bindSpecs(obj, type(cfg) == "table" and cfg or {}, specs)
				end
				return obj
			end
		end
	end
end

local GOLD1 = Color3.fromRGB(255, 214, 102)
local GOLD2 = Color3.fromRGB(255, 150, 40)

local function toSeq(stops)
	local keys = {}
	for _, s in ipairs(stops) do
		table.insert(keys, ColorSequenceKeypoint.new(s[1], s[2]))
	end
	return ColorSequence.new(keys)
end

local function fuzzyScore(q, s)
	if q == "" then
		return 1
	end
	local i = string.find(s, q, 1, true)
	if i then
		return 1000 - i
	end
	local qi, last, score = 1, 0, 0
	for si = 1, #s do
		if string.sub(s, si, si) == string.sub(q, qi, qi) then
			score += 10 - math.min(9, si - last - 1)
			last = si
			qi += 1
			if qi > #q then
				return score
			end
		end
	end
	return nil
end

local function formatTime(sec)
	sec = math.floor(sec)
	return string.format("%02d:%02d:%02d", sec // 3600, (sec % 3600) // 60, sec % 60)
end

function Ghostline.new(cfg)
	cfg = cfg or {}
	if cfg.Language then
		Ghostline:SetLanguage(cfg.Language)
	end
	local S = Ghostline.Styles.Ghostline
	if cfg.Style then
		local want = string.lower(tostring(cfg.Style))
		for n, def in pairs(Ghostline.Styles) do
			if string.lower(n) == want then
				S = def
				break
			end
		end
	end
	local isTop = S.Layout == "Top"
	local lightReq = resolveMode(cfg.Mode) == "light"
	if S.Palette and not lightReq then
		local pal = table.clone(S.Palette)
		local accent = cfg.Theme and Ghostline.Themes[resolveTheme(cfg.Theme) or ""]
		if accent then
			local ap = buildPalette(accent, "dark")
			pal.AccentGlow, pal.AccentDeep, pal.AccentSoft = ap.AccentGlow, ap.AccentDeep, ap.AccentSoft
		end
		applyPalette(pal)
		Ghostline._stylePalette = true
	elseif cfg.Theme or cfg.Mode then
		Ghostline:SetTheme(cfg.Theme or Ghostline.CurrentTheme, cfg.Mode or Ghostline.CurrentMode)
		Ghostline._stylePalette = false
	elseif Ghostline._stylePalette then
		applyPalette(Ghostline.DefaultPalette)
		Ghostline._stylePalette = false
	end
	Ghostline.ActiveStyle = S
	local player = Players.LocalPlayer
	local Window = {
		Tabs = {},
		CurrentTab = nil,
		Visible = true,
		Minimized = false,
		Binding = false,
		Compact = false,
		CompactMode = cfg.Compact,
		UserScale = 1,
		ToggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift,
		S = S,
		DesiredSize = cfg.Size or S.Size or Vector2.new(640, 430),
		Destroyed = false,
		_conns = {},
	}
	local title = cfg.Name or "Ghostline OS"
	local subtitle = cfg.Subtitle
	local HEADER = S.Header or 48
	local startClock = os.clock()

	function Window._track(signal, fn)
		local c = signal:Connect(fn)
		table.insert(Window._conns, c)
		return c
	end
	local track = Window._track

	local pc = cfg.Profile or {}
	local Profile = {
		Avatar = pc.ShowAvatar ~= false,
		Name = pc.ShowName ~= false,
		Streamer = pc.Streamer or false,
		Premium = pc.Premium or false,
		PremiumLabel = pc.PremiumLabel or "PREMIUM",
		FreeLabel = pc.FreeLabel or "FREE",
		DisplayName = pc.DisplayName or (player and player.DisplayName) or L("guest"),
		Username = pc.Username or (player and player.Name) or "guest",
		UserId = (player and player.UserId) or 0,
		Image = pc.Image,
	}
	Window.Profile = Profile
	local avatarLoaded = false
	local grads = {}
	local painters = {}
	local refreshProfile, refreshPanel, applySidebar

	local function ringStops()
		if Profile.Premium then
			return { { 0, GOLD1 }, { 0.5, GOLD2 }, { 1, GOLD1 } }
		end
		return { { 0, Theme.AccentDeep }, { 0.5, Theme.AccentGlow }, { 1, Theme.AccentDeep } }
	end
	local function paintGradients()
		for _, g in ipairs(grads) do
			g.Color = toSeq(ringStops())
		end
	end
	local function shownName()
		if Profile.Streamer then
			return "••••••"
		end
		return Profile.DisplayName
	end

	local Blur
	pcall(function()
		Blur = Lighting:FindFirstChild("GhostlineBlur") or New("BlurEffect", { Name = "GhostlineBlur", Size = 0, Parent = Lighting })
	end)
	Window.BlurOn = cfg.Blur ~= false and Blur ~= nil
	local function applyBlur()
		if Blur and Blur.Parent then
			local on = Window.BlurOn and Window.Visible and not Window.Destroyed
			Tween(Blur, 0.5, { Size = on and (cfg.BlurSize or 14) or 0 })
		end
	end

	local Root = New("Frame", {
		Name = "Window",
		Size = UDim2.fromOffset(640, 430),
		Position = UDim2.new(0.5, -320, 0.5, -215),
		BackgroundTransparency = 1,
		Parent = ScreenGui,
	})
	local Holder = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = Root,
	})
	local Scale = New("UIScale", { Scale = 0.05, Parent = Holder })

	local Main = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = S.MainGradient and WHITE or Theme.BackgroundPrimary,
		BackgroundTransparency = S.MainAlpha,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Active = true,
		Parent = Holder,
	})
	Corner(Main, S.WindowRadius)
	if S.MainGradient then
		Gradient(Main, {
			{ 0, Theme.BackgroundSecondary },
			{ 0.5, Theme.BackgroundPrimary },
			{ 1, Theme.GlassTint },
		}, 135)
	end

	local fxTweens, fxFrames, fxGrads = {}, {}, {}
	local fxStroke
	if S.SpinStroke then
		local MainStroke = Stroke(Main, WHITE, 1.6, 0.05)
		fxStroke = MainStroke
		local strokeGrad = Gradient(MainStroke, {
			{ 0, Theme.AccentDeep },
			{ 0.25, Theme.AccentGlow },
			{ 0.5, Theme.AccentDeep },
			{ 0.75, Theme.AccentGlow },
			{ 1, Theme.AccentDeep },
		}, 0)
		local spin = TweenService:Create(strokeGrad, TweenInfo.new(6, EASE.Linear, DIR.Out, -1), { Rotation = 360 })
		spin:Play()
		table.insert(fxTweens, spin)
		table.insert(fxGrads, strokeGrad)
	else
		Stroke(Main, Theme.Border, 1, 0.1)
	end

	if S.Orbs then
		local orbs = {
			{ size = 240, color = Theme.AccentGlow, from = UDim2.new(0, -60, 0, -40), to = UDim2.new(0, 60, 0, 70), t = 7, tr = 0.86 },
			{ size = 200, color = Theme.AccentDeep, from = UDim2.new(1, -170, 1, -150), to = UDim2.new(1, -280, 1, -220), t = 9, tr = 0.78 },
			{ size = 150, color = Theme.AccentSoft, from = UDim2.new(0.5, 0, 0, 60), to = UDim2.new(0.62, 50, 0, 150), t = 11, tr = 0.9 },
		}
		for _, o in ipairs(orbs) do
			local orb = New("Frame", {
				Size = UDim2.fromOffset(o.size, o.size),
				Position = o.from,
				BackgroundColor3 = o.color,
				BackgroundTransparency = o.tr,
				BorderSizePixel = 0,
				Parent = Main,
			})
			Corner(orb, 999)
			local drift = TweenService:Create(orb, TweenInfo.new(o.t, EASE.Sine, DIR.InOut, -1, true), { Position = o.to })
			drift:Play()
			table.insert(fxTweens, drift)
			table.insert(fxFrames, orb)
		end
	end

	if S.Sheen then
		local sheen = New("Frame", {
			Size = UDim2.new(1, 0, 0, 70),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = Main,
		})
		Corner(sheen, S.WindowRadius)
		Gradient(sheen, { { 0, WHITE }, { 1, WHITE } }, 90, { { 0, 0.9 }, { 1, 1 } })
		table.insert(fxFrames, sheen)
		New("Frame", {
			Position = UDim2.new(0, 14, 0, 0),
			Size = UDim2.new(1, -28, 0, 1),
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 0.7,
			BorderSizePixel = 0,
			Parent = Main,
		})
	end

	local Header = New("Frame", {
		Size = UDim2.new(1, 0, 0, HEADER),
		BackgroundTransparency = 1,
		Parent = Main,
	})
	local titleLbl = TextLabel({
		Size = UDim2.new(1, -250, 0, subtitle and 22 or HEADER),
		Position = UDim2.new(0, 18, 0, subtitle and 6 or 0),
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = Header,
	})
	if S.TitleGradient then
		Gradient(titleLbl, { { 0, Theme.Text }, { 1, Theme.AccentSoft } }, 0)
	end
	local subLbl
	if subtitle then
		subLbl = TextLabel({
			Size = UDim2.new(1, -250, 0, 14),
			Position = UDim2.new(0, 18, 0, 26),
			Text = subtitle,
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextColor3 = Theme.SubText,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = Header,
		})
	end

	local function HeaderButton(text, offsetX, hoverColor)
		local b = New("TextButton", {
			Size = UDim2.new(0, IS_TOUCH and 34 or 28, 0, IS_TOUCH and 34 or 28),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, offsetX, 0.5, 0),
			BackgroundColor3 = hoverColor,
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = Theme.SubText,
			Font = Enum.Font.GothamBold,
			TextSize = 16,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = Header,
		})
		Corner(b, 8)
		b.MouseEnter:Connect(function()
			Tween(b, 0.2, { BackgroundTransparency = 0.5, TextColor3 = Theme.Text })
		end)
		b.MouseLeave:Connect(function()
			Tween(b, 0.2, { BackgroundTransparency = 1, TextColor3 = Theme.SubText })
		end)
		return b
	end
	local CloseBtn = HeaderButton("×", -8, Theme.Error)
	local MinBtn = HeaderButton("—", IS_TOUCH and -46 or -40, Theme.AccentDeep)

	local function baseSearchW()
		return Window.Compact and 118 or 150
	end
	local Search = New("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, (IS_TOUCH and -88 or -76) - (isTop and 46 or 0), 0.5, 0),
		Size = UDim2.new(0, 150, 0, 28),
		BackgroundColor3 = Theme.BackgroundPrimary,
		BackgroundTransparency = 0.3,
		PlaceholderText = L("search"),
		PlaceholderColor3 = Theme.SubText,
		Text = "",
		TextColor3 = Theme.Text,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
		BorderSizePixel = 0,
		Parent = Header,
	})
	Corner(Search, 8)
	bindText(Search, "PlaceholderText", Loc("search"))
	local searchStroke = Stroke(Search, Theme.Border, 1, 0.4)
	Search.Focused:Connect(function()
		Tween(searchStroke, 0.25, { Color = Theme.AccentGlow, Transparency = 0 })
		Tween(Search, 0.35, { Size = UDim2.new(0, math.min(240, Root.Size.X.Offset - (isTop and 160 or 110)), 0, 28) }, EASE.Quart)
	end)
	Search.FocusLost:Connect(function()
		Tween(searchStroke, 0.25, { Color = Theme.Border, Transparency = 0.4 })
		Tween(Search, 0.35, { Size = UDim2.new(0, baseSearchW(), 0, 28) }, EASE.Quart)
	end)

	if S.AccentBar then
		local AccentBar = New("Frame", {
			Size = UDim2.new(1, 0, 0, 2),
			Position = UDim2.new(0, 0, 0, HEADER),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			Parent = Main,
		})
		local barGrad = Gradient(AccentBar, {
			{ 0, Theme.BackgroundPrimary },
			{ 0.35, Theme.AccentDeep },
			{ 0.5, Theme.AccentGlow },
			{ 0.65, Theme.AccentDeep },
			{ 1, Theme.BackgroundPrimary },
		}, 0)
		barGrad.Offset = Vector2.new(-0.5, 0)
		TweenService:Create(barGrad, TweenInfo.new(2.5, EASE.Sine, DIR.InOut, -1, true), { Offset = Vector2.new(0.5, 0) }):Play()
	else
		New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, HEADER + 1),
			BackgroundColor3 = Theme.Border,
			BorderSizePixel = 0,
			Parent = Main,
		})
	end

	local Body = New("Frame", {
		Position = UDim2.new(0, 0, 0, HEADER + 2),
		Size = UDim2.new(1, 0, 1, -(HEADER + 2)),
		BackgroundTransparency = 1,
		Parent = Main,
	})
	local Sidebar = New("Frame", {
		Position = UDim2.new(0, isTop and 10 or 8, 0, 6),
		Size = isTop and UDim2.new(1, -20, 0, 34) or UDim2.new(0, S.Sidebar, 1, -14),
		BackgroundColor3 = Theme.BackgroundSecondary,
		BackgroundTransparency = S.SidebarAlpha,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = Body,
	})
	Corner(Sidebar, S.SidebarRadius)
	Stroke(Sidebar, Theme.Border, 1, 0.6)

	local TabList = New("ScrollingFrame", {
		Position = isTop and UDim2.new(0, 4, 0, 0) or UDim2.new(0, 0, 0, 8),
		Size = isTop and UDim2.new(1, -8, 1, 0) or UDim2.new(1, 0, 1, -74),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = isTop and Enum.AutomaticSize.X or Enum.AutomaticSize.Y,
		ScrollingDirection = isTop and Enum.ScrollingDirection.X or Enum.ScrollingDirection.Y,
		Parent = Sidebar,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, isTop and 6 or 8),
		FillDirection = isTop and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = isTop and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
		VerticalAlignment = isTop and Enum.VerticalAlignment.Center or Enum.VerticalAlignment.Top,
		Parent = TabList,
	})
	New("UIPadding", { PaddingTop = UDim.new(0, isTop and 0 or 4), Parent = TabList })

	local Indicator = New("Frame", {
		Size = UDim2.new(0, 3, 0, 20),
		Position = UDim2.new(0, 3, 0, 20),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		Visible = false,
		Parent = Sidebar,
	})
	Corner(Indicator, 2)
	Gradient(Indicator, { { 0, Theme.AccentSoft }, { 1, Theme.AccentGlow } }, 90)

	local ContentArea = New("Frame", {
		Position = isTop and UDim2.new(0, 0, 0, 44) or UDim2.new(0, 160, 0, 0),
		Size = isTop and UDim2.new(1, 0, 1, -44) or UDim2.new(1, -160, 1, 0),
		BackgroundTransparency = 1,
		Parent = Body,
	})

	local function BuildAvatar(parent, px, thickness)
		local holder = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(px, px),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BorderSizePixel = 0,
			Parent = parent,
		})
		Corner(holder, 999)
		local ring = Stroke(holder, WHITE, thickness, 0)
		local grad = Gradient(ring, ringStops(), 0)
		table.insert(grads, grad)
		TweenService:Create(grad, TweenInfo.new(4, EASE.Linear, DIR.Out, -1), { Rotation = 360 }):Play()
		local img = New("ImageLabel", {
			Position = UDim2.new(0, 3, 0, 3),
			Size = UDim2.new(1, -6, 1, -6),
			BackgroundTransparency = 1,
			ImageTransparency = 1,
			ScaleType = Enum.ScaleType.Crop,
			Parent = holder,
		})
		Corner(img, 999)
		return holder, ring, img
	end

	local ProfileCard = New("TextButton", {
		AnchorPoint = isTop and Vector2.new(1, 0.5) or Vector2.new(0, 0),
		Position = isTop and UDim2.new(1, IS_TOUCH and -88 or -76, 0.5, 0) or UDim2.new(0, 6, 1, -58),
		Size = isTop and UDim2.new(0, 40, 0, 30) or UDim2.new(1, -12, 0, 52),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.35,
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = isTop and Header or Sidebar,
	})
	Corner(ProfileCard, isTop and 8 or 12)
	Gradient(ProfileCard, { { 0, Theme.GlassTint }, { 1, Theme.BackgroundSecondary } }, 25)
	local cardStroke = Stroke(ProfileCard, Theme.Border, 1, 0.45)
	ProfileCard.MouseEnter:Connect(function()
		Tween(cardStroke, 0.25, { Color = Theme.AccentGlow, Transparency = 0.1 })
		Tween(ProfileCard, 0.25, { BackgroundTransparency = 0.2 })
	end)
	ProfileCard.MouseLeave:Connect(function()
		Tween(cardStroke, 0.25, { Color = Theme.Border, Transparency = 0.45 })
		Tween(ProfileCard, 0.25, { BackgroundTransparency = 0.35 })
	end)
	ProfileCard.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Ripple(ProfileCard, input.Position.X, input.Position.Y)
		end
	end)

	local AV = isTop and 22 or 36
	local cardHolder, cardRing, cardImg = BuildAvatar(ProfileCard, AV, 2)
	cardHolder.Position = UDim2.new(0, isTop and 20 or 26, 0.5, 0)
	local cardName = TextLabel({
		Size = UDim2.new(1, -58, 0, 16),
		Position = UDim2.new(0, 52, 0, 9),
		Text = "",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = ProfileCard,
	})
	local cardStatus = TextLabel({
		Size = UDim2.new(1, -58, 0, 14),
		Position = UDim2.new(0, 52, 0, 27),
		Text = "",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = WHITE,
		Parent = ProfileCard,
	})
	local statusGrad = Gradient(cardStatus, { { 0, Theme.SubText }, { 1, Theme.SubText } }, 0)
	local hiddenLbl = TextLabel({
		Size = UDim2.new(1, 0, 1, 0),
		Text = L("profile_hidden"),
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTransparency = 1,
		Parent = ProfileCard,
	})

	local Dim = New("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = BLACK,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Visible = false,
		ZIndex = 20,
		BorderSizePixel = 0,
		Parent = Main,
	})
	local Panel = New("Frame", {
		Size = UDim2.fromOffset(100, 50),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.03,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 21,
		Parent = Main,
	})
	Corner(Panel, S.PanelRadius)
	Gradient(Panel, { { 0, Theme.GlassTint }, { 1, Theme.BackgroundPrimary } }, 135)
	local panelStroke = Stroke(Panel, WHITE, 1.6, 0.05)
	local panelGrad = Gradient(panelStroke, ringStops(), 0)
	table.insert(grads, panelGrad)
	TweenService:Create(panelGrad, TweenInfo.new(4, EASE.Linear, DIR.Out, -1), { Rotation = 360 }):Play()

	local PScroll = New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.AccentGlow,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = Panel,
	})
	New("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Parent = PScroll,
	})
	New("UIPadding", { PaddingTop = UDim.new(0, 18), PaddingBottom = UDim.new(0, 16), Parent = PScroll })

	local PanelClose = New("TextButton", {
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -38, 0, 8),
		BackgroundColor3 = Theme.AccentDeep,
		BackgroundTransparency = 1,
		Text = "×",
		TextColor3 = Theme.SubText,
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Parent = Panel,
	})
	Corner(PanelClose, 9)
	PanelClose.MouseEnter:Connect(function()
		Tween(PanelClose, 0.2, { BackgroundTransparency = 0.4, TextColor3 = Theme.Text })
	end)
	PanelClose.MouseLeave:Connect(function()
		Tween(PanelClose, 0.2, { BackgroundTransparency = 1, TextColor3 = Theme.SubText })
	end)

	local avatarWrap = New("Frame", {
		Size = UDim2.new(0, 112, 0, 112),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Parent = PScroll,
	})
	local panelHolder, panelRing, panelImg = BuildAvatar(avatarWrap, 100, 3)
	panelHolder.Position = UDim2.new(0.5, 0, 0.5, 0)

	local panelName = TextLabel({
		Size = UDim2.new(1, -32, 0, 24),
		Text = "",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		LayoutOrder = 2,
		Parent = PScroll,
	})
	local panelUser = TextLabel({
		Size = UDim2.new(1, -32, 0, 16),
		Text = "",
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Center,
		LayoutOrder = 3,
		Parent = PScroll,
	})
	local badge = New("Frame", {
		Size = UDim2.new(0, 130, 0, 26),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		LayoutOrder = 4,
		Parent = PScroll,
	})
	Corner(badge, 13)
	local badgeGrad = Gradient(badge, { { 0, Theme.GlassTint }, { 1, Theme.BackgroundSecondary } }, 0)
	local badgeStroke = Stroke(badge, Theme.Border, 1, 0.3)
	local badgeText = TextLabel({
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = badge,
	})

	local function InfoRow(order, label, value)
		local r = New("Frame", {
			Size = UDim2.new(1, -32, 0, 28),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BackgroundTransparency = 0.45,
			BorderSizePixel = 0,
			LayoutOrder = order,
			Parent = PScroll,
		})
		Corner(r, 8)
		local nameLbl = TextLabel({
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			Text = resolveText(label),
			TextSize = 12,
			TextColor3 = Theme.SubText,
			Parent = r,
		})
		bindText(nameLbl, "Text", label)
		return TextLabel({
			Size = UDim2.new(0.5, -20, 1, 0),
			Position = UDim2.new(0.5, 10, 0, 0),
			Text = value,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = r,
		})
	end
	local robloxPremium = false
	local accountAge = 0
	pcall(function()
		robloxPremium = player.MembershipType == Enum.MembershipType.Premium
		accountAge = player.AccountAge
	end)
	InfoRow(5, Loc("user_id"), tostring(Profile.UserId))
	local premVal = InfoRow(6, Loc("roblox_premium"), "")
	bindFn(premVal, function()
		premVal.Text = robloxPremium and L("yes") or L("no")
	end)
	local ageVal = InfoRow(7, Loc("account_age"), "")
	bindFn(ageVal, function()
		ageVal.Text = L("days", accountAge)
	end)
	local sessVal = InfoRow(8, Loc("session"), "00:00:00")
	local netVal = InfoRow(9, Loc("performance"), "-- fps · -- ms")

	TextLabel({
		Size = UDim2.new(1, -32, 0, 18),
		Name = "GL_Privacy",
		Text = L("privacy"),
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = Theme.AccentSoft,
		LayoutOrder = 10,
		Parent = PScroll,
	})

	local function MiniSwitch(order, text, get, set)
		local row = New("TextButton", {
			Size = UDim2.new(1, -32, 0, IS_TOUCH and 40 or 34),
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 0.4,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			LayoutOrder = order,
			Parent = PScroll,
		})
		Corner(row, 10)
		Gradient(row, { { 0, Theme.GlassTint }, { 1, Theme.BackgroundSecondary } }, 25)
		local st = Stroke(row, Theme.Border, 1, 0.5)
		row.MouseEnter:Connect(function()
			Tween(st, 0.25, { Color = Theme.AccentGlow, Transparency = 0.15 })
		end)
		row.MouseLeave:Connect(function()
			Tween(st, 0.25, { Color = Theme.Border, Transparency = 0.5 })
		end)
		bindText(TextLabel({ Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0), Text = resolveText(text), Parent = row }), "Text", text)
		local sw = New("Frame", {
			Size = UDim2.new(0, 44, 0, 22),
			Position = UDim2.new(1, -56, 0.5, -11),
			BackgroundColor3 = Theme.BackgroundPrimary,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = row,
		})
		Corner(sw, 11)
		Stroke(sw, Theme.Border, 1, 0.3)
		local onFill = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = sw,
		})
		Gradient(onFill, { { 0, Theme.AccentDeep }, { 1, Theme.AccentGlow } }, 0)
		local knob = New("Frame", {
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0, 3, 0.5, -8),
			BackgroundColor3 = Theme.Text,
			BorderSizePixel = 0,
			Parent = sw,
		})
		Corner(knob, 8)
		local function paint(animated)
			local v = get()
			To(onFill, animated, 0.3, { BackgroundTransparency = v and 0 or 1 })
			To(knob, animated, 0.4, { Position = v and UDim2.new(0, 25, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) }, EASE.Back)
		end
		row.MouseButton1Click:Connect(function()
			set(not get())
		end)
		table.insert(painters, paint)
		paint(false)
	end
	bindText(PScroll:FindFirstChild("GL_Privacy"), "Text", Loc("privacy"))
	MiniSwitch(11, Loc("show_avatar"), function()
		return Profile.Avatar
	end, function(v)
		Window:SetProfileVisibility(v, nil)
	end)
	MiniSwitch(12, Loc("show_name"), function()
		return Profile.Name
	end, function(v)
		Window:SetProfileVisibility(nil, v)
	end)
	MiniSwitch(13, Loc("streamer_long"), function()
		return Profile.Streamer
	end, function(v)
		Window:SetStreamer(v)
	end)
	TextLabel({
		Size = UDim2.new(1, -32, 0, 16),
		Text = "Ghostline v" .. Ghostline.Version,
		Font = Enum.Font.Gotham,
		TextSize = 10,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Center,
		LayoutOrder = 20,
		Parent = PScroll,
	})

	function refreshPanel()
		panelName.Text = shownName()
		panelUser.Text = Profile.Streamer and "@••••••" or ("@" .. Profile.Username)
		badgeText.Text = Profile.Premium and Profile.PremiumLabel or Profile.FreeLabel
		if Profile.Premium then
			badgeGrad.Color = toSeq({ { 0, GOLD1 }, { 1, GOLD2 } })
			badgeText.TextColor3 = Color3.fromRGB(45, 22, 0)
			badgeStroke.Color = GOLD1
		else
			badgeGrad.Color = toSeq({ { 0, Theme.GlassTint }, { 1, Theme.BackgroundSecondary } })
			badgeText.TextColor3 = Theme.SubText
			badgeStroke.Color = Theme.Border
		end
	end

	function refreshProfile(animated)
		local compact = Window.Compact or isTop
		local showA = Profile.Avatar
		local showN = Profile.Name and not compact
		local textX = showA and 52 or 12
		To(cardHolder, animated, 0.45, {
			Size = showA and UDim2.fromOffset(AV, AV) or UDim2.fromOffset(0, 0),
			Position = UDim2.new(0, isTop and 20 or (compact and 22 or 26), 0.5, 0),
		}, EASE.Back)
		To(cardRing, animated, 0.3, { Transparency = showA and 0 or 1 })
		To(cardImg, animated, 0.4, { ImageTransparency = (showA and avatarLoaded) and 0 or 1 })
		To(cardName, animated, 0.3, { TextTransparency = showN and 0 or 1, Position = UDim2.new(0, textX, 0, 9) })
		To(cardStatus, animated, 0.3, { TextTransparency = showN and 0 or 1, Position = UDim2.new(0, textX, 0, 27) })
		hiddenLbl.Text = compact and "..." or L("profile_hidden")
		To(hiddenLbl, animated, 0.3, { TextTransparency = ((not showA) and (not showN)) and 0 or 1 })
		cardName.Text = shownName()
		cardStatus.Text = Profile.Premium and Profile.PremiumLabel or Profile.FreeLabel
		statusGrad.Color = toSeq(Profile.Premium and { { 0, GOLD1 }, { 1, GOLD2 } } or { { 0, Theme.SubText }, { 1, Theme.SubText } })
		paintGradients()
		refreshPanel()
		for _, p in ipairs(painters) do
			p(animated)
		end
		if Window._sync then
			Window._sync()
		end
	end

	local function setAvatarImage(img)
		cardImg.Image = img
		panelImg.Image = img
		avatarLoaded = true
		To(panelImg, true, 0.5, { ImageTransparency = 0 })
		refreshProfile(true)
	end
	task.spawn(function()
		if Profile.Image then
			setAvatarImage(Profile.Image)
			return
		end
		if not player then
			return
		end
		local ok, img = pcall(function()
			return (Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420))
		end)
		if ok and img and not Window.Destroyed then
			setAvatarImage(img)
		end
	end)

	local panelOpen = false
	local function cardRect()
		local s = Scale.Scale
		local ap = ProfileCard.AbsolutePosition - Main.AbsolutePosition
		return UDim2.fromOffset(ap.X / s, ap.Y / s), UDim2.fromOffset(ProfileCard.AbsoluteSize.X / s, ProfileCard.AbsoluteSize.Y / s)
	end

	function Window:OpenProfile()
		if panelOpen or Window.Minimized or Window.Destroyed then
			return
		end
		panelOpen = true
		local pos, sz = cardRect()
		Panel.Position = pos
		Panel.Size = sz
		Panel.Visible = true
		Dim.Visible = true
		PScroll.CanvasPosition = Vector2.new(0, 0)
		local s = Scale.Scale
		local w = math.min(340, Main.AbsoluteSize.X / s - 24)
		local h = math.min(420, Main.AbsoluteSize.Y / s - 24)
		Tween(Dim, 0.35, { BackgroundTransparency = 0.5 })
		Tween(Panel, 0.6, { Position = UDim2.new(0.5, -w / 2, 0.5, -h / 2), Size = UDim2.fromOffset(w, h) }, EASE.Exponential)

		local frames = 0
		local hb = RunService.Heartbeat:Connect(function()
			frames += 1
		end)
		task.spawn(function()
			while panelOpen and not Window.Destroyed do
				sessVal.Text = formatTime(os.clock() - startClock)
				local t0 = os.clock()
				task.wait(0.5)
				local fps = frames / math.max(os.clock() - t0, 0.001)
				frames = 0
				local ping = 0
				pcall(function()
					ping = math.floor(player:GetNetworkPing() * 2000)
				end)
				netVal.Text = string.format("%d fps · %d ms", math.floor(fps + 0.5), ping)
			end
			hb:Disconnect()
		end)
	end

	function Window:CloseProfile()
		if not panelOpen then
			return
		end
		panelOpen = false
		local pos, sz = cardRect()
		Tween(Dim, 0.3, { BackgroundTransparency = 1 })
		Tween(Panel, 0.45, { Position = pos, Size = sz }, EASE.Exponential, DIR.In)
		task.delay(0.47, function()
			if not panelOpen then
				Panel.Visible = false
				Dim.Visible = false
			end
		end)
	end

	ProfileCard.MouseButton1Click:Connect(function()
		Window:OpenProfile()
	end)
	Dim.MouseButton1Click:Connect(function()
		Window:CloseProfile()
	end)
	PanelClose.MouseButton1Click:Connect(function()
		Window:CloseProfile()
	end)

	function Window:SetProfileVisibility(avatar, name)
		if avatar ~= nil then
			Profile.Avatar = avatar
		end
		if name ~= nil then
			Profile.Name = name
		end
		refreshProfile(true)
	end
	function Window:SetStreamer(v)
		Profile.Streamer = v and true or false
		refreshProfile(true)
	end
	function Window:SetPremium(v, label)
		Profile.Premium = v and true or false
		if label then
			if Profile.Premium then
				Profile.PremiumLabel = label
			else
				Profile.FreeLabel = label
			end
		end
		refreshProfile(true)
	end
	function Window:SetProfile(t)
		for k, v in pairs(t or {}) do
			Profile[k] = v
		end
		if t and t.Image then
			setAvatarImage(t.Image)
		else
			refreshProfile(true)
		end
	end

	local Results = New("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, HEADER + 6),
		Size = UDim2.new(0, 280, 0, 0),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.03,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 10,
		Parent = Main,
	})
	Corner(Results, 14)
	Gradient(Results, { { 0, Theme.GlassTint }, { 1, Theme.BackgroundPrimary } }, 135)
	Stroke(Results, Theme.AccentGlow, 1.2, 0.3)
	local ResultsList = New("ScrollingFrame", {
		Position = UDim2.new(0, 6, 0, 6),
		Size = UDim2.new(1, -12, 1, -12),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.AccentGlow,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = Results,
	})
	New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = ResultsList })
	local resultsOpen = false
	local function hideResults()
		if not resultsOpen then
			return
		end
		resultsOpen = false
		Tween(Results, 0.25, { Size = UDim2.new(0, Results.Size.X.Offset, 0, 0) })
		task.delay(0.27, function()
			if not resultsOpen then
				Results.Visible = false
			end
		end)
	end

	local function jumpTo(f)
		Search:ReleaseFocus()
		Search.Text = ""
		hideResults()
		Window:SelectTab(f.tab)
		local e = f.entry
		if e then
			task.delay(0.5, function()
				if Window.Destroyed or not e.Frame.Parent then
					return
				end
				local c = f.tab._container
				local y = (e.Frame.AbsolutePosition.Y - c.AbsolutePosition.Y) / Scale.Scale + c.CanvasPosition.Y
				Tween(c, 0.5, { CanvasPosition = Vector2.new(0, math.max(0, y - 12)) }, EASE.Quart)
				local st = e.Stroke
				if st then
					Tween(st, 0.2, { Color = WHITE, Transparency = 0, Thickness = 3 })
					task.delay(0.9, function()
						Tween(st, 0.5, { Color = Theme.Border, Transparency = 0.5, Thickness = 1 })
					end)
				end
			end)
		end
	end

	local function refreshResults()
		local q = string.lower(Search.Text)
		if q == "" then
			hideResults()
			return
		end
		local found = {}
		for _, t in ipairs(Window.Tabs) do
			local sc = fuzzyScore(q, string.lower(t.Name))
			if sc then
				table.insert(found, { score = sc + 5, label = t.Name, sub = L("tab_label"), tab = t })
			end
			for _, e in ipairs(t._elements) do
				local s2 = fuzzyScore(q, e.Name)
				if s2 then
					table.insert(found, { score = s2, label = e.Label, sub = t.Name, tab = t, entry = e })
				end
			end
		end
		table.sort(found, function(a, b)
			return a.score > b.score
		end)
		for _, c in ipairs(ResultsList:GetChildren()) do
			if c:IsA("GuiObject") then
				c:Destroy()
			end
		end
		local count = math.min(#found, 12)
		if count == 0 then
			TextLabel({
				Size = UDim2.new(1, 0, 0, 30),
				Text = L("no_results"),
				TextColor3 = Theme.SubText,
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = ResultsList,
			})
			count = 1
		else
			for i = 1, count do
				local f = found[i]
				local b = New("TextButton", {
					Size = UDim2.new(1, -4, 0, 32),
					BackgroundColor3 = Theme.AccentDeep,
					BackgroundTransparency = 0.85,
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					LayoutOrder = i,
					Parent = ResultsList,
				})
				Corner(b, 8)
				TextLabel({
					Size = UDim2.new(0.62, -8, 1, 0),
					Position = UDim2.new(0, 10, 0, 0),
					Text = f.label,
					TextSize = 12,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = b,
				})
				TextLabel({
					Size = UDim2.new(0.38, -12, 1, 0),
					Position = UDim2.new(0.62, 0, 0, 0),
					Text = f.sub,
					TextSize = 11,
					TextColor3 = Theme.SubText,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = b,
				})
				b.MouseEnter:Connect(function()
					Tween(b, 0.2, { BackgroundTransparency = 0.55 })
				end)
				b.MouseLeave:Connect(function()
					Tween(b, 0.2, { BackgroundTransparency = 0.85 })
				end)
				b.Activated:Connect(function()
					jumpTo(f)
				end)
			end
		end
		local h = math.min(count, 6) * 36 + 12
		local w = math.min(300, Root.Size.X.Offset - 24)
		Results.Visible = true
		resultsOpen = true
		Tween(Results, 0.35, { Size = UDim2.new(0, w, 0, h) }, EASE.Quart)
	end
	track(Search:GetPropertyChangedSignal("Text"), refreshResults)
	Search.FocusLost:Connect(function()
		task.delay(0.5, function()
			if not Search:IsFocused() then
				hideResults()
			end
		end)
	end)

	local Resize = New("TextButton", {
		Size = UDim2.new(0, IS_TOUCH and 30 or 20, 0, IS_TOUCH and 30 or 20),
		Position = UDim2.new(1, IS_TOUCH and -32 or -22, 1, IS_TOUCH and -32 or -22),
		BackgroundTransparency = 1,
		Text = "",
		Parent = Main,
	})
	local resizeDot = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 2, 0.5, 2),
		Size = UDim2.new(0, 7, 0, 7),
		BackgroundColor3 = Theme.AccentGlow,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = Resize,
	})
	Corner(resizeDot, 4)
	Resize.MouseEnter:Connect(function()
		Tween(resizeDot, 0.2, { BackgroundTransparency = 0, Size = UDim2.new(0, 10, 0, 10) })
	end)
	Resize.MouseLeave:Connect(function()
		Tween(resizeDot, 0.2, { BackgroundTransparency = 0.5, Size = UDim2.new(0, 7, 0, 7) })
	end)
	MakeDrag(Window, Resize, function(pos)
		if Window.Minimized then
			return
		end
		local nx = math.clamp((pos.X - Root.AbsolutePosition.X) / Window.UserScale + 8, 320, 900)
		local ny = math.clamp((pos.Y - Root.AbsolutePosition.Y) / Window.UserScale + 8, 280, 700)
		Window.DesiredSize = Vector2.new(nx, ny)
		Window:Relayout(true)
	end)

	local dragStart, startPos
	MakeDrag(Window, Header, function(pos)
		if not dragStart then
			return
		end
		local d = pos - dragStart
		Tween(Root, 0.1, {
			Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y),
		})
	end, function()
		dragStart = nil
	end, function(pos)
		dragStart = pos
		startPos = Root.Position
	end)

	local function applyTab(t)
		local compact = Window.Compact and not isTop
		t._lbl.Visible = not compact
		if t._icon then
			t._icon.Position = compact and UDim2.new(0.5, -9, 0.5, -9) or UDim2.new(0, isTop and 8 or 12, 0.5, -9)
		end
		t._letter.Visible = compact and not t._icon
	end

	function applySidebar(animated)
		if not isTop then
			local sb = Window.Compact and 56 or S.Sidebar
			To(Sidebar, animated, 0.45, { Size = UDim2.new(0, sb, 1, -14) }, EASE.Quart)
			To(ContentArea, animated, 0.45, {
				Position = UDim2.new(0, sb + 14, 0, 0),
				Size = UDim2.new(1, -(sb + 14), 1, 0),
			}, EASE.Quart)
		end
		for _, t in ipairs(Window.Tabs) do
			applyTab(t)
		end
		refreshProfile(animated)
	end

	function Window:Relayout(keepPos)
		local a = ScreenGui.AbsoluteSize
		if a.X < 10 or a.Y < 10 then
			a = Vector2.new(1280, 720)
		end
		local s = Window.UserScale
		local maxW, maxH = a.X * 0.96 / s, a.Y * 0.94 / s
		local w = math.min(math.max(Window.DesiredSize.X, 320), maxW)
		local h = math.min(math.max(Window.DesiredSize.Y, 280), maxH)
		Root.Size = UDim2.fromOffset(w, h)
		if not keepPos then
			Root.Position = UDim2.new(0.5, -w / 2, 0.5, -h / 2)
		end
		local compact
		if Window.CompactMode ~= nil then
			compact = Window.CompactMode
		else
			compact = w < 560
		end
		local first = not Window._laidOut
		if compact ~= Window.Compact or first then
			Window.Compact = compact
			Window._laidOut = true
			applySidebar(not first)
		end
		local reserve = baseSearchW() + (isTop and 150 or 104)
		titleLbl.Size = UDim2.new(1, -reserve, 0, subtitle and 22 or HEADER)
		if subLbl then
			subLbl.Size = UDim2.new(1, -reserve, 0, 14)
		end
		if not Search:IsFocused() then
			Search.Size = UDim2.new(0, baseSearchW(), 0, 28)
		end
	end
	track(ScreenGui:GetPropertyChangedSignal("AbsoluteSize"), function()
		Window:Relayout(false)
	end)

	function Window:Center()
		local w, h = Root.Size.X.Offset, Root.Size.Y.Offset
		Tween(Root, 0.5, { Position = UDim2.new(0.5, -w / 2, 0.5, -h / 2) }, EASE.Exponential)
	end
	function Window:SetCompact(v)
		Window.CompactMode = v
		Window:Relayout(true)
	end
	function Window:SetUserScale(v)
		Window.UserScale = math.clamp(v, 0.6, 1.5)
		Window:Relayout(true)
		if Window.Visible then
			Tween(Scale, 0.4, { Scale = Window.UserScale }, EASE.Back)
		end
	end
	function Window:SetGlass(a)
		Tween(Main, 0.3, { BackgroundTransparency = math.clamp(a, 0, 0.9) })
	end
	function Window:SetBlur(on)
		Window.BlurOn = (on and Blur ~= nil) and true or false
		applyBlur()
	end

	local function moveIndicator(tab, instant)
		if isTop or not S.Indicator then
			return
		end
		local y = 8 + 4 + (tab._index - 1) * 44 - TabList.CanvasPosition.Y + 8
		if not Indicator.Visible then
			Indicator.Position = UDim2.new(0, 3, 0, y)
			Indicator.Visible = true
		elseif instant then
			Indicator.Position = UDim2.new(0, 3, 0, y)
		else
			Tween(Indicator, 0.45, { Position = UDim2.new(0, 3, 0, y) }, EASE.Back)
		end
	end
	track(TabList:GetPropertyChangedSignal("CanvasPosition"), function()
		if Window.CurrentTab then
			moveIndicator(Window.CurrentTab, true)
		end
	end)

	function Window:SelectTab(tab)
		if type(tab) == "string" then
			for _, t in ipairs(Window.Tabs) do
				if t.Name == tab then
					tab = t
					break
				end
			end
		end
		if type(tab) ~= "table" or Window.CurrentTab == tab then
			return
		end
		Window.CurrentTab = tab
		for _, t in ipairs(Window.Tabs) do
			local active = t == tab
			Tween(t._btn, 0.3, { BackgroundTransparency = active and S.TabActiveAlpha or 1 })
			Tween(t._lbl, 0.3, { TextColor3 = active and Theme.Text or Theme.SubText })
			Tween(t._letter, 0.3, { TextColor3 = active and Theme.Text or Theme.SubText })
			if t._icon then
				Tween(t._icon, 0.3, { ImageColor3 = active and Theme.AccentGlow or Theme.SubText })
			end
			if not active then
				t._container.Visible = false
			end
		end
		tab._container.Position = UDim2.new(0, 10, 0, 26)
		tab._container.Visible = true
		Tween(tab._container, 0.45, { Position = UDim2.new(0, 10, 0, 8) }, EASE.Quart)
		moveIndicator(tab)
		Search.Text = ""
	end

	function Window:MakeTab(tcfg)
		local tabSpec
		if isSpec(tcfg) then
			tabSpec = tcfg
			tcfg = { Name = resolveText(tcfg) }
		elseif type(tcfg) == "table" and isSpec(tcfg.Name) then
			tabSpec = tcfg.Name
			tcfg = table.clone(tcfg)
			tcfg.Name = resolveText(tabSpec)
		end
		tcfg = type(tcfg) == "string" and { Name = tcfg } or (tcfg or {})
		local tabName = tcfg.Name or "Tab"
		local Tab = { Name = tabName, _elements = {} }
		table.insert(Window.Tabs, Tab)
		Tab._index = #Window.Tabs

		local tabW = 0
		if isTop then
			tabW = TextService:GetTextSize(tabName, 13, Enum.Font.GothamMedium, Vector2.new(400, 30)).X + (tcfg.Icon and 48 or 28)
		end
		local btn = New("TextButton", {
			Size = isTop and UDim2.new(0, tabW, 0, 26) or UDim2.new(1, -16, 0, 36),
			BackgroundColor3 = S.TabFlat and Theme.GlassTint or Theme.AccentDeep,
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			LayoutOrder = Tab._index,
			ClipsDescendants = true,
			Parent = TabList,
		})
		Corner(btn, S.TabRadius)
		if not S.TabFlat then
			Gradient(btn, { { 0, Theme.AccentGlow }, { 1, Theme.AccentDeep } }, 0)
		end
		local hasIcon = tcfg.Icon ~= nil
		if hasIcon then
			Tab._icon = New("ImageLabel", {
				Size = UDim2.new(0, 18, 0, 18),
				Position = UDim2.new(0, isTop and 8 or 12, 0.5, -9),
				BackgroundTransparency = 1,
				Image = tcfg.Icon,
				ImageColor3 = Theme.SubText,
				Parent = btn,
			})
		end
		local lbl = TextLabel({
			Size = isTop and UDim2.new(1, hasIcon and -30 or 0, 1, 0) or UDim2.new(1, hasIcon and -40 or -16, 1, 0),
			Position = isTop and UDim2.new(0, hasIcon and 30 or 0, 0, 0) or UDim2.new(0, hasIcon and 36 or 14, 0, 0),
			TextXAlignment = isTop and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
			Text = tabName,
			TextColor3 = Theme.SubText,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = btn,
		})
		local letter = TextLabel({
			Size = UDim2.new(1, 0, 1, 0),
			Text = string.upper(string.sub(tabName, 1, 1)),
			Font = Enum.Font.GothamBold,
			TextSize = 16,
			TextColor3 = Theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Center,
			Visible = false,
			Parent = btn,
		})
		Tab._btn, Tab._lbl, Tab._letter = btn, lbl, letter
		if tabSpec then
			bindFn(lbl, function()
				local t = resolveText(tabSpec)
				Tab.Name = t
				lbl.Text = t
				letter.Text = string.upper(string.sub(t, 1, 1))
				if isTop then
					local w = TextService:GetTextSize(t, 13, Enum.Font.GothamMedium, Vector2.new(400, 30)).X
					btn.Size = UDim2.new(0, w + (tcfg.Icon and 48 or 28), 0, 26)
				end
			end)
		end

		local Container = New("ScrollingFrame", {
			Size = UDim2.new(1, -20, 1, -16),
			Position = UDim2.new(0, 10, 0, 8),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = IS_TOUCH and 5 or 3,
			ScrollBarImageColor3 = Theme.AccentGlow,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			ClipsDescendants = true,
			Parent = ContentArea,
		})
		New("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Container })
		New("UIPadding", {
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 6),
			Parent = Container,
		})
		Tab._container = Container

		btn.MouseEnter:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(btn, 0.25, { BackgroundTransparency = 0.8 })
			end
		end)
		btn.MouseLeave:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(btn, 0.25, { BackgroundTransparency = 1 })
			end
		end)
		btn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Ripple(btn, input.Position.X, input.Position.Y)
			end
		end)
		btn.MouseButton1Click:Connect(function()
			Window:SelectTab(Tab)
		end)

		applyTab(Tab)
		BuildElements(Tab, Container, Tab, Window)

		if #Window.Tabs == 1 then
			Window:SelectTab(Tab)
		end
		return Tab
	end
	Window.CreateTab = Window.MakeTab

	function Window:SetPerformanceMode(on)
		on = on and true or false
		Window.Performance = on
		for _, tw in ipairs(fxTweens) do
			if on then
				tw:Pause()
			else
				tw:Play()
			end
		end
		for _, f in ipairs(fxFrames) do
			f.Visible = not on
		end
		for _, g in ipairs(fxGrads) do
			g.Enabled = not on
		end
		if fxStroke then
			fxStroke.Color = on and Theme.AccentDeep or WHITE
		end
		if on then
			Window._blurBefore = Window.BlurOn
			Window:SetBlur(false)
		elseif Window._blurBefore ~= nil then
			Window:SetBlur(Window._blurBefore)
			Window._blurBefore = nil
		end
	end

	function Window:SetLanguage(code)
		return Ghostline:SetLanguage(code)
	end

	function Window:MakeSettingsTab(scfg)
		scfg = scfg or {}
		local tab = Window:MakeTab({ Name = scfg.Name or Loc("settings"), Icon = scfg.Icon })

		local look = tab:MakeSection({ Name = Loc("appearance") })
		look:MakeThemePicker({ Name = Loc("theme"), Flag = "gl_theme", Tooltip = Loc("theme_tip") })
		look:MakeLanguagePicker({ Flag = "gl_language" })

		local ui = tab:MakeSection({ Name = Loc("interface") })
		ui:MakeSlider({
			Name = Loc("ui_scale"), Min = 70, Max = 130, Default = 100, Increment = 5, Suffix = "%",
			Flag = "gl_scale", Tooltip = Loc("ui_scale_tip"),
			Callback = function(v)
				Window:SetUserScale(v / 100)
			end,
		})
		ui:MakeSlider({
			Name = Loc("glass"), Min = 0, Max = 60, Default = math.floor(S.MainAlpha * 100 + 0.5), Suffix = "%", Flag = "gl_glass",
			Callback = function(v)
				Window:SetGlass(v / 100)
			end,
		})
		ui:MakeSlider({
			Name = Loc("anim_speed"), Min = 50, Max = 200, Default = 100, Increment = 10, Suffix = "%",
			Flag = "gl_speed", Tooltip = "100% = normal. Plus haut = plus rapide",
			Callback = function(v)
				Ghostline.AnimSpeed = v / 100
			end,
		})
		ui:MakeToggle({
			Name = Loc("blur"), Default = Window.BlurOn, Flag = "gl_blur",
			Callback = function(v)
				Window:SetBlur(v)
			end,
		})
		if not isTop then
			ui:MakeToggle({
				Name = Loc("compact"), Default = Window.Compact, Flag = "gl_compact",
				Tooltip = Loc("compact_tip"),
				Callback = function(v)
					Window:SetCompact(v)
				end,
			})
		end
		ui:MakeKeybind({
			Name = Loc("toggle_key"), Default = Window.ToggleKey,
			Changed = function(k)
				if k ~= Enum.KeyCode.Unknown then
					Window.ToggleKey = k
				end
			end,
		})

		ui:MakeToggle({
			Name = Loc("perf"), Tooltip = Loc("perf_tip"), Default = Window.Performance or false, Flag = "gl_perf",
			Callback = function(v)
				Window:SetPerformanceMode(v)
			end,
		})

		local pf = tab:MakeSection({ Name = Loc("profile") })
		local tA = pf:MakeToggle({
			Name = Loc("show_avatar"), Default = Profile.Avatar, Flag = "gl_show_avatar",
			Callback = function(v)
				Window:SetProfileVisibility(v, nil)
			end,
		})
		local tN = pf:MakeToggle({
			Name = Loc("show_name"), Default = Profile.Name, Flag = "gl_show_name",
			Callback = function(v)
				Window:SetProfileVisibility(nil, v)
			end,
		})
		local tS = pf:MakeToggle({
			Name = Loc("streamer"), Default = Profile.Streamer, Flag = "gl_streamer",
			Tooltip = "Masque ton pseudo partout dans l'interface",
			Callback = function(v)
				Window:SetStreamer(v)
			end,
		})
		Window._sync = function()
			tA:Set(Profile.Avatar, true)
			tN:Set(Profile.Name, true)
			tS:Set(Profile.Streamer, true)
		end

		local cf = tab:MakeSection({ Name = Loc("configs") })
		local cfgName = "default"
		local list
		cf:MakeTextbox({
			Name = Loc("cfg_name"), Default = cfgName, Placeholder = "default",
			Callback = function(t)
				cfgName = (t ~= "" and t) or "default"
			end,
		})
		list = cf:MakeDropdown({
			Name = Loc("cfg_existing"), Options = Ghostline:ListConfigs(),
			Callback = function(v)
				if v then
					cfgName = v
				end
			end,
		})
		cf:MakeButton({
			Name = Loc("save"),
			Callback = function()
				local ok, err = Ghostline:SaveConfig(cfgName)
				Ghostline:Notify({
					Title = ok and L("cfg_saved") or L("failed"), Content = ok and cfgName or tostring(err),
					Type = ok and "Success" or "Error",
				})
				list:Refresh(Ghostline:ListConfigs())
			end,
		})
		cf:MakeButton({
			Name = Loc("load"),
			Callback = function()
				local ok, err = Ghostline:LoadConfig(cfgName)
				Ghostline:Notify({
					Title = ok and L("cfg_loaded") or L("failed"), Content = ok and cfgName or tostring(err),
					Type = ok and "Success" or "Error",
				})
			end,
		})
		cf:MakeButton({
			Name = Loc("delete"),
			Callback = function()
				local ok, err = Ghostline:DeleteConfig(cfgName)
				Ghostline:Notify({
					Title = ok and L("cfg_deleted") or L("failed"), Content = ok and cfgName or tostring(err),
					Type = ok and "Success" or "Error",
				})
				list:Refresh(Ghostline:ListConfigs())
			end,
		})
		cf:MakeButton({
			Name = Loc("export_cfg"),
			Callback = function()
				local ok = type(setclipboard) == "function" and pcall(setclipboard, Ghostline:ExportConfig())
				Ghostline:Notify({
					Title = ok and L("cfg_exported") or L("failed"), Content = cfgName,
					Type = ok and "Success" or "Error",
				})
			end,
		})
		cf:MakeTextbox({
			Name = Loc("import_cfg"), Placeholder = Loc("import_ph"),
			Callback = function(t)
				if t == "" then
					return
				end
				local ok, err = Ghostline:ImportConfig(t)
				Ghostline:Notify({
					Title = ok and L("cfg_imported") or L("failed"), Content = ok and cfgName or tostring(err),
					Type = ok and "Success" or "Error",
				})
			end,
		})
		cf:MakeToggle({
			Name = Loc("auto_save"),
			Tooltip = Loc("auto_save_tip"),
			Callback = function(v)
				if v then
					Ghostline:EnableAutoSave(cfgName)
				else
					Ghostline._auto = nil
				end
			end,
		})
		tab:MakeParagraph({
			Title = Loc("tips"),
			Content = Loc("tips_body"),
		})
		return tab
	end

	local Launcher, ring
	if cfg.Launcher == true or (cfg.Launcher == nil and IS_TOUCH) then
		Launcher = New("TextButton", {
			Size = UDim2.fromOffset(52, 52),
			Position = UDim2.new(0, 12, 0.5, -26),
			BackgroundColor3 = WHITE,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ZIndex = 50,
			Parent = ScreenGui,
		})
		Corner(Launcher, 999)
		Gradient(Launcher, { { 0, Theme.AccentGlow }, { 1, Theme.AccentDeep } }, 45)
		Stroke(Launcher, Theme.Text, 1.5, 0.6)
		TextLabel({
			Size = UDim2.new(1, 0, 1, 0),
			Text = S.LauncherText or "G",
			Font = Enum.Font.GothamBold,
			TextSize = 24,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = Launcher,
		})
		ring = New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = false,
			ZIndex = 49,
			Parent = Launcher,
		})
		Corner(ring, 999)
		local ringStroke = Stroke(ring, Theme.AccentGlow, 2, 0)
		local pulse = TweenInfo.new(1.8, EASE.Quad, DIR.Out, -1)
		TweenService:Create(ring, pulse, { Size = UDim2.new(1.7, 0, 1.7, 0) }):Play()
		TweenService:Create(ringStroke, pulse, { Transparency = 1 }):Play()

		local moved, dstart, spos = false, nil, nil
		MakeDrag(Window, Launcher, function(pos)
			if not dstart then
				return
			end
			local d = pos - dstart
			if d.Magnitude > 8 then
				moved = true
			end
			if moved then
				Launcher.Position = UDim2.new(spos.X.Scale, spos.X.Offset + d.X, spos.Y.Scale, spos.Y.Offset + d.Y)
			end
		end, function()
			dstart = nil
			if not moved then
				Window:Toggle()
			else
				local a = ScreenGui.AbsoluteSize
				local x = Launcher.AbsolutePosition.X
				local tx = (x + 26 < a.X / 2) and 8 or (a.X - 60)
				local ty = math.clamp(Launcher.AbsolutePosition.Y, 8, a.Y - 60)
				Tween(Launcher, 0.5, { Position = UDim2.fromOffset(tx, ty) }, EASE.Back)
			end
		end, function(pos)
			dstart = pos
			spos = Launcher.Position
			moved = false
		end)
	end

	function Window:Toggle(state)
		if state == nil then
			state = not Window.Visible
		end
		Window.Visible = state
		if state then
			Root.Visible = true
			Tween(Scale, 0.55, { Scale = Window.UserScale }, EASE.Back)
		else
			Window:CloseProfile()
			Search:ReleaseFocus()
			Tween(Scale, 0.3, { Scale = 0.05 }, EASE.Quart, DIR.In)
			task.delay(0.3, function()
				if not Window.Visible then
					Root.Visible = false
				end
			end)
		end
		applyBlur()
		if ring then
			ring.Visible = not state
		end
	end

	function Window:Minimize(state)
		if state == nil then
			state = not Window.Minimized
		end
		if state then
			Window:CloseProfile()
		end
		Window.Minimized = state
		if state then
			Tween(Main, 0.45, { Size = UDim2.new(1, 0, 0, HEADER + 2) }, EASE.Exponential)
			Resize.Visible = false
			task.delay(0.3, function()
				if Window.Minimized then
					Body.Visible = false
				end
			end)
		else
			Body.Visible = true
			Resize.Visible = true
			Tween(Main, 0.5, { Size = UDim2.new(1, 0, 1, 0) }, EASE.Exponential)
		end
	end

	function Window:Destroy()
		if Window.Destroyed then
			return
		end
		Window.Destroyed = true
		panelOpen = false
		for _, c in ipairs(Window._conns) do
			c:Disconnect()
		end
		Window._conns = {}
		Tween(Scale, 0.35, { Scale = 0.05 }, EASE.Quart, DIR.In)
		local i = table.find(Ghostline.Windows, Window)
		if i then
			table.remove(Ghostline.Windows, i)
		end
		if Blur and Blur.Parent then
			Tween(Blur, 0.4, { Size = 0 })
			if #Ghostline.Windows == 0 then
				task.delay(0.5, function()
					if Blur.Parent then
						Blur:Destroy()
					end
				end)
			end
		end
		if Launcher then
			Launcher:Destroy()
		end
		task.delay(0.4, function()
			Root:Destroy()
		end)
	end

	function Window:Notify(ncfg)
		Ghostline:Notify(ncfg)
	end

	CloseBtn.MouseButton1Click:Connect(function()
		Window:Destroy()
	end)
	MinBtn.MouseButton1Click:Connect(function()
		Window:Minimize()
	end)

	track(UserInputService.InputBegan, function(input, gpe)
		if Window.Binding then
			return
		end
		if input.KeyCode == Enum.KeyCode.Escape then
			if panelOpen then
				Window:CloseProfile()
			end
			return
		end
		if gpe then
			return
		end
		if input.KeyCode == Window.ToggleKey then
			Window:Toggle()
		elseif
			input.KeyCode == Enum.KeyCode.K
			and Window.Visible
			and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl))
		then
			task.defer(function()
				task.wait()
				Search:CaptureFocus()
			end)
		end
	end)

	table.insert(Ghostline.Windows, Window)
	Window:Relayout(false)
	refreshProfile(false)

	Tween(Scale, 0.8, { Scale = Window.UserScale }, EASE.Back)
	applyBlur()

	if cfg.Performance then
		Window:SetPerformanceMode(true)
	end
	return Window
end

Ghostline.CreateWindow = Ghostline.new

function Ghostline:Destroy()
	for _, w in ipairs(table.clone(Ghostline.Windows)) do
		w:Destroy()
	end
	task.delay(0.6, function()
		ScreenGui:Destroy()
	end)
end

return Ghostline
