
String asignarEmoji(String estatus) {
  switch (estatus) {
    case 'vencido':
      return '❌'; // Emoji para vencido
    case 'urgente':
      return '⚠️'; // Emoji para urgente
    case 'proximo':
      return '🟡'; // Emoji para próximo
    case 'corriente':
      return '✅'; // Emoji para activo
    default:
      return ''; // Emoji por defecto si no coincide con ningún caso
  }
}