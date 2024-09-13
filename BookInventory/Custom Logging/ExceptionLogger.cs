/*
 *  This file contains the looger file that log all the database error messages to a textfile.
 *  The implementation uses a singleton pattern
 */
using System;
using System.IO;
namespace BookInventory
{
    public class ExceptionLogger
    {
        private readonly object _lock = new object();
        //For now am hardcoding the path
        private readonly string file = Path.Combine(Directory.GetCurrentDirectory(), "Log", "Error.log");

        private readonly static ExceptionLogger _logger = new ExceptionLogger();

        private ExceptionLogger()
        {
            if (!Directory.Exists("Log"))
                Directory.CreateDirectory("Log");
        }//ctor default

        public static ExceptionLogger GetLogger() => _logger;

        public bool LogError(Exception ex, string type = "Database error")
        {
            lock (_lock)
            {
                string error_lines_of_code = ExtactStackLines(ex.StackTrace);

                string header = $"Date : {DateTime.Now}\t Type : {type}";
                int len = header.Length;
                header += "\n".PadRight(16 + len, '=');
                using (StreamWriter wr = new StreamWriter(file, true))
                {
                    wr.WriteLine("".PadRight(16 + len, '='));
                    wr.WriteLine(header);
                    wr.WriteLine("Error message     :\n{0}\n", ex.Message);
                    wr.WriteLine("Importance lines  :\n{0}\n", error_lines_of_code);
                    wr.WriteLine("Stacktrace        :\n{0}\n", ex.StackTrace);
                    wr.WriteLine("----------------------------------End logg---------------------------------------\n\n");
                }//write to a log file
            }//end lock
            return true;
        }//LogActivity
        private string ExtactStackLines(string stacktrace)
        {
            string[] lines = stacktrace.Split(new string[] { "\n" }, StringSplitOptions.RemoveEmptyEntries);
            int len = lines.Length;

            return lines[len - 2] + "\n" + lines[len - 1];
        }//GetLastwoMessages
    }//class
}//namespace
