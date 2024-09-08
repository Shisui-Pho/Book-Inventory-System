/*
 * This file contains an interface that defines the basic structure of the Author model
 */
namespace BookInventory
{
    public interface IAuthor
    {
        string Name { get; set; }
        string Surname { get; set; }
        int NumberOfPublishedBooks { get; }
    }//class
}//namespace