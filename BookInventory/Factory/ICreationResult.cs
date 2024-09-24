/*
 *  This file contains the interface Creational Result class that will be returned to the user upon creation of the object with details
 */
namespace BookInventory
{
    // <summary>
    /// Provides the result of an object creation process.
    /// </summary>
    /// <typeparam name="T">The type of object that was created.</typeparam>
    public interface ICreationResult<T>
    {
        /// <summary>
        /// Gets the message describing the result of the creation process.
        /// </summary>
        string Message { get; }

        /// <summary>
        /// Gets the object that was created, if the creation was successful.
        /// </summary>
        T Item { get; }

        /// <summary>
        /// Indicates whether the object creation was successful.
        /// </summary>
        bool CreationSuccessful { get; }
    }//namespace
}//namespace
