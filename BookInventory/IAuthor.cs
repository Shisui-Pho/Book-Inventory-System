/*
 * This file contains an interface that defines the basic structure of the Author model
 */
namespace BookInventory
{
    public interface IAuthor
    {
        int ID { get; }
        string Name { get; }
        string Surname { get; }
        int NumberOfPublishedBooks { get; }
    }//class
}//namespace