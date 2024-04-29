class Queries {
  static String getAll = """
  query getAll {
    getAll {
      date
      calendars {
        title
      }
    }
  }
  """;
  static String getDate = """
  query getDate(\$date: String!) {
    getDate(date: \$date) {
      calendars {
        id
        title
        start
        end
        description
      }
    }
  }
  """;
  static String addCalendar = """
  mutation AddCalendar(\$date: String!, \$calendarId: ID!, \$title: String!, \$start: String!, \$end: String!, \$description: String!) {
    addCalendar(date: \$date, id: \$calendarId, title: \$title, start: \$start, end: \$end, description: \$description)
  }
  """;
  static String removeCalendar = """
  mutation RemoveCalendar(\$date: String!, \$calendarId: ID!) {
    removeCalendar(date: \$date, id: \$calendarId)
  }
  """;
  static String updateCalendar = """
  mutation UpdateCalendar(\$date: String!, \$calendarId: ID!, \$title: String!, \$start: String!, \$end: String!, \$description: String!) {
    updateCalendar(date: \$date, id: \$calendarId, title: \$title, start: \$start, end: \$end, description: \$description)
  }
  """;
}
