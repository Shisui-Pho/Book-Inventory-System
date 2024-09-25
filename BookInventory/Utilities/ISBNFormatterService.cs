/*
 *  This file contains the ISBNFormatterService class that will format an string of numbers to an isbn format given the number of digit
 */
namespace BookInventory.Utilities
{
    public static class ISBNFormatterService
    {
        /// <summary>
        /// Formats an ISBN by removing spaces/hyphens and applying the appropriate ISBN-10 or ISBN-13 format.
        /// </summary>
        /// <param name="isbn">The raw ISBN string.</param>
        /// <returns>The formatted ISBN or a message if invalid.</returns>
        public static string ToISBNFormat(string isbn)
        {
            // Remove spaces and hyphens
            isbn = isbn.Replace(" ", "").Replace("-", "");

            // Format as ISBN-10: X-XXX-XXXXX-X
            if (isbn.Length == 10)
                return $"{isbn[0]}-{isbn.Substring(1, 3)}-{isbn.Substring(4, 5)}-{isbn[9]}";

            // Format as ISBN-13: XXX-X-XXX-XXXXX-X
            else if (isbn.Length == 13)
                return $"{isbn.Substring(0, 3)}-{isbn[3]}-{isbn.Substring(4, 3)}-{isbn.Substring(7, 5)}-{isbn[12]}";

            // Return the input if not valid ISBN-10 or ISBN-13
            return "Invalid ISBN length";
        }//FormatISBN
    }//class
}//namespace
