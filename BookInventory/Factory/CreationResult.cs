/*
 *  This file contains the concrete implementation of ICreationResult that will be returned to the user upon creation of the object with details
 */
namespace BookInventory
{
    public class CreationResult<T> : ICreationResult<T>
    {
        public string Message { get; private set; }

        public T Item { get; private set; }

        public bool CreationSuccessful {get; private set;}

        public CreationResult(string message, T item, bool isSuccessful)
        {
            this.Message = message;
            this.Item = item;
            this.CreationSuccessful = isSuccessful;
        }//ctor main
    }//class
}//namespace
