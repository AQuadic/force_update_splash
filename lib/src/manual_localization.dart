Map<String, String> getLocalizedText(String languageCode) {
  switch (languageCode) {
    case 'ar':
      return {
        "title": "تحديث متاح!",
        "message": "قم بتحديث التطبيق الآن للحصول على الميزات الجديدة.",
        "updateNow": "تحديث الآن",
        "runningAnIssue": "تواجه مشكلة؟",
        "contactUs": "تواصل معنا",
      };
    case 'es':
      return {
        "title": "¡Actualización disponible!",
        "message": "Actualice la aplicación ahora para obtener nuevas funciones.",
        "updateNow": "Actualizar ahora",
        "runningAnIssue": "Estoy enfrentando un problema?",
        "contactUs": "Contáctenos",
      };
    case 'fr':
      return {
        "title": "Mise à jour disponible!",
        "message": "Mettez à jour l'application maintenant pour obtenir de nouvelles fonctionnalités.",
        "updateNow": "Mettre à jour maintenant",
        "runningAnIssue": "Je rencontre un problème?",
        "contactUs": "Contactez nous",
      };
    case 'de':
      return {
        "title": "Update verfügbar!",
        "message": "Aktualisieren Sie die App jetzt, um neue Funktionen zu erhalten.",
        "updateNow": "Jetzt aktualisieren",
        "runningAnIssue": "Ich habe ein Problem?",
        "contactUs": "Kontaktiere uns",
      };
    default:
      return {
        "title": "Update Available!",
        "message": "Update the app now to get new features.",
        "updateNow": "Update Now",
        "runningAnIssue": "Running into an issue?",
        "contactUs": "Contact Us",
      };
  }
}