package simpledb;

import java.io.Serializable;
import java.util.*;

/**
 * TupleDesc describes the schema of a tuple.
 */
public class TupleDesc implements Serializable 
{

    private List<TDItem> field_items;

    /**
     * A help class to facilitate organizing the information of each field
     * */
    public static class TDItem implements Serializable 
	{

        private static final long serialVersionUID = 1L;

        /**
         * The type of the field
         * */
        public final Type fieldType;
        
        /**
         * The name of the field
         * */
        public final String fieldName;

        public TDItem(Type t, String n) 
		{
            this.fieldName = n;
            this.fieldType = t;
        }

        public String toString() {
            return fieldName + "(" + fieldType + ")";
        }
    }

    /**
     * @return
     *        An iterator which iterates over all the field TDItems
     *        that are included in this TupleDesc
     * */
    public Iterator<TDItem> iterator() {
        // some code goes here
        return field_items.iterator();
    }

    private static final long serialVersionUID = 1L;

    /**
     * Create a new TupleDesc with typeAr.length fields with fields of the
     * specified types, with associated named fields.
     * 
     * @param typeAr
     *            array specifying the number of and types of fields in this
     *            TupleDesc. It must contain at least one entry.
     * @param fieldAr
     *            array specifying the names of the fields. Note that names may
     *            be null.
     */
    public TupleDesc(Type[] typeAr, String[] fieldAr) 
	{
        // some code goes here
        if (fieldAr == null)
		{
            fieldAr = new String[typeAr.length];
			int i=0;
			while(i<fieldAr.length)
			{
				fieldAr[i] = "";
				i++;
			}
        }
        this.field_items = new ArrayList<>();
        if (typeAr.length == fieldAr.length) 
		{
			int j=0;
			while(j<typeAr.length)
			{
				TDItem tdi_item = new TDItem(typeAr[j], fieldAr[j]);
                this.field_items.add(tdi_item);
				j++;
			}
        }        
    }

    /**
     * Constructor. Create a new tuple desc with typeAr.length fields with
     * fields of the specified types, with anonymous (unnamed) fields.
     * 
     * @param typeAr
     *            array specifying the number of and types of fields in this
     *            TupleDesc. It must contain at least one entry.
     */
    public TupleDesc(Type[] typeAr) 
	{
        // some code goes here
        this(typeAr, null);
    }

    /**
     * @return the number of fields in this TupleDesc
     */
    public int numFields() 
	{
        // some code goes here
        return field_items.size();
    }

    /**
     * Gets the (possibly null) field name of the ith field of this TupleDesc.
     * 
     * @param i
     *            index of the field name to return. It must be a valid index.
     * @return the name of the ith field
     * @throws NoSuchElementException
     *             if i is not a valid field reference.
     */
    public String getFieldName(int i) throws NoSuchElementException 
	{
        // some code goes here
        if (i >= field_items.size() || i < 0) 
		{
            throw new NoSuchElementException("invalid index: TupleDesc getFieldName failed : " + i);
        }
        return field_items.get(i).fieldName;    
    }

    /**
     * Gets the type of the ith field of this TupleDesc.
     * 
     * @param i
     *            The index of the field to get the type of. It must be a valid
     *            index.
     * @return the type of the ith field
     * @throws NoSuchElementException
     *             if i is not a valid field reference.
     */
    public Type getFieldType(int i) throws NoSuchElementException 
	{
        // some code goes here
        if (i >= field_items.size()||i < 0) 
		{
            throw new NoSuchElementException("invalid index: TupleDesc getFieldType failed " + i);
        }
        return field_items.get(i).fieldType;    
    }

    /**
     * Find the index of the field with a given name.
     * 
     * @param name
     *            name of the field.
     * @return the index of the field that is first to have the given name.
     * @throws NoSuchElementException
     *             if no field with a matching name is found.
     */
    public int fieldNameToIndex(String name) throws NoSuchElementException 
	{
        // some code goes here
		int k=0;
		while(k<field_items.size())
		{
			TDItem tdi_item = field_items.get(k);
            if (name!=null&&name.equals(tdi_item.fieldName))
	    {
                return k;
            }
			k++;
		}
        throw new NoSuchElementException("Invalid name: TupleDesc fieldNameToIndex failed" + name);
    }

    /**
     * @return The size (in bytes) of tuples corresponding to this TupleDesc.
     *         Note that tuples from a given TupleDesc are of a fixed size.
     */
    public int getSize() 
	{
        // some code goes here
        int size_in_bytes = 0;
        TDItem tdi_item;
		tdi_item = null;
		int a=0;
		while(a<this.field_items.size())
		{
			tdi_item = this.field_items.get(a);
            size_in_bytes = size_in_bytes+tdi_item.fieldType.getLen();
			a++;
		}
        return size_in_bytes;
    }

    /**
     * Merge two TupleDescs into one, with td1.numFields + td2.numFields fields,
     * with the first td1.numFields coming from td1 and the remaining from td2.
     * 
     * @param td1
     *            The TupleDesc with the first fields of the new TupleDesc
     * @param td2
     *            The TupleDesc with the last fields of the TupleDesc
     * @return the new TupleDesc
     */
    public static TupleDesc merge(TupleDesc td1, TupleDesc td2) 
	{
        // some code goes here
        Type[] TupleDescType = new Type[td1.numFields() + td2.numFields()];
        String[] TupleDescNames = new String[td1.numFields() + td2.numFields()];
        int k;
        TDItem Tdi_Item;
		
        Tdi_Item = null;
		k=0;
        Iterator<TDItem> tdi_iterator= td1.iterator();
        while(tdi_iterator.hasNext())
		{
            Tdi_Item = tdi_iterator.next();
            TupleDescType[k] = Tdi_Item.fieldType;
            TupleDescNames[k] = Tdi_Item.fieldName;
            k++;
        }

        tdi_iterator = td2.iterator();
        while(tdi_iterator.hasNext())
		{
            Tdi_Item = tdi_iterator.next();
            TupleDescType[k] = Tdi_Item.fieldType;
            TupleDescNames[k] = Tdi_Item.fieldName;
            k++;
        }

        return new TupleDesc(TupleDescType, TupleDescNames);
    }

    /**
     * Compares the specified object with this TupleDesc for equality. Two
     * TupleDescs are considered equal if they have the same number of field_items
     * and if the i-th type in this TupleDesc is equal to the i-th type in o
     * for every i.
     * 
     * @param o
     *            the Object to be compared for equality with this TupleDesc.
     * @return true if the object is equal to this TupleDesc.
     */

    public boolean equals(Object o) 
	{
        // some code goes here
        if (!(o instanceof TupleDesc))
		{
            return false;
        }

        TupleDesc td = (TupleDesc) o;

        Iterator<TDItem> tdi_item_1;
		tdi_item_1 = this.iterator();
        Iterator<TDItem> tdi_item_2;
		tdi_item_2 = td.iterator();

        while(tdi_item_1.hasNext() && tdi_item_2.hasNext())
		{
            TDItem item1 = tdi_item_1.next();
            TDItem item2 = tdi_item_2.next();
            if (item1.fieldType.compareTo(item2.fieldType) != 0)
			{
                return false;
            }
        }
        if(tdi_item_1.hasNext() || tdi_item_2.hasNext())
		{
            return false;
        }
        return true;
    }

    public int hashCode() 
	{
        // If you want to use TupleDesc as keys for HashMap, implement this so
        // that equal objects have equals hashCode() results
        throw new UnsupportedOperationException("unimplemented");
    }

    /**
     * Returns a String describing this descriptor. It should be of the form
     * "fieldType[0](fieldName[0]), ..., fieldType[M](fieldName[M])", although
     * the exact format does not matter.
     * 
     * @return String describing this descriptor.
     */
    public String toString() 
	{
        // some code goes here
        StringBuilder obj = new StringBuilder();
        Iterator<TDItem> tdi_iterator;
        tdi_iterator = this.iterator();
        TDItem tdi_Item;
		tdi_Item = null;

        if(tdi_iterator.hasNext())
		{
            tdi_Item = tdi_iterator.next();
            obj.append(tdi_Item.fieldType.toString());
            obj.append("(").append(tdi_Item.fieldName).append(")");
        }

        while(tdi_iterator.hasNext())
		{
            tdi_Item = tdi_iterator.next();
            obj.append(", ").append(tdi_Item.fieldType.toString());
            obj.append("(").append(tdi_Item.fieldName).append(")");
        }
        return obj.toString();
        }
}
