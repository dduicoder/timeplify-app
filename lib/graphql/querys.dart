Map querys = {
  "getAll": """
  query getAll {
    getAll {
      date
      calendars {
        title
      }
    }
  }
  """,
  "getDate": """
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
  """,
  "addCalendar": """
  mutation AddCalendar(\$date: String!, \$calendarId: ID!, \$title: String!, \$start: String!, \$end: String!, \$description: String!) {
    addCalendar(date: \$date, id: \$calendarId, title: \$title, start: \$start, end: \$end, description: \$description) {
      title
    }
  }
  """,
};
