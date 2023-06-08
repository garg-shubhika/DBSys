package simpledb;

import java.io.*;
import java.util.*;

/**
 * The Catalog keeps track of all available tables in the database and their
 * associated schemas.
 * For now, this is a stub catalog that must be populated with tables by a
 * user program before it can be used -- eventually, this should be converted
 * to a catalog that reads a catalog table from disk.
 * 
 * @Threadsafe
 */
public class Catalog 
{
    private List<String> PK_Field_Catalog;
    private List<Integer> Table_Id;
    private List<DbFile> Db_Files;
    private List<String> Catalog_Name;
    /**
     * Constructor.
     * Creates a new, empty catalog.
     */
    public Catalog() 
	{
        // some code goes here
		this.PK_Field_Catalog = new ArrayList<>();
        this.Table_Id = new ArrayList<>();
        this.Db_Files = new ArrayList<>();
        this.Catalog_Name = new ArrayList<>();
		}

    /**
     * Add a new table to the catalog.
     * This table's contents are stored in the specified DbFile.
     * @param file the contents of the table to add;  file.getId() is the identfier of
     *    this file/tupledesc param for the calls getTupleDesc and getFile
     * @param name the name of the table -- may be an empty string.  May not be null.  If a name
     * conflict exists, use the last table to be added as the table for a given name.
     * @param pkeyField the name of the primary key field
     */
    public void addTable(DbFile file, String name, String pkeyField) 
	{
        // some code goes here
		int x=0;
		while(x<Db_Files.size())
		{
			if(file.getId()==Db_Files.get(x).getId())
			{
                this.Table_Id.set(x, file.getId());
                this.Db_Files.set(x, file);
                this.Catalog_Name.set(x, name);
                this.PK_Field_Catalog.set(x, pkeyField);
                return;
            }
			x++;
		}
		int y=0;
		while(y<Catalog_Name.size())
		{
		    if(name!=null &&name.equals(Catalog_Name.get(y)))
			{
                this.Table_Id.set(y, file.getId());
                this.Db_Files.set(y, file);
                this.Catalog_Name.set(y, name);
                this.PK_Field_Catalog.set(y, pkeyField);
                return;
            }	
			y++;
		}
        this.Table_Id.add(file.getId());
        this.Db_Files.add(file);
        this.Catalog_Name.add(name);
        this.PK_Field_Catalog.add(pkeyField);
    }

    public void addTable(DbFile file, String name) 
	{
        addTable(file, name, "");
    }

    /**
     * Add a new table to the catalog.
     * This table has tuples formatted using the specified TupleDesc and its
     * contents are stored in the specified DbFile.
     * @param file the contents of the table to add;  file.getId() is the identfier of
     *    this file/tupledesc param for the calls getTupleDesc and getFile
     */
    public void addTable(DbFile file) 
	{
        addTable(file, (UUID.randomUUID()).toString());
    }

    /**
     * Return the id of the table with a specified name,
     * @throws NoSuchElementException if the table doesn't exist
     */
    public int getTableId(String name) throws NoSuchElementException 
	{
        // some code goes here
		int k=0;
		int name_size=Catalog_Name.size();
		while(k<name_size)
		{
			if(name!=null)
			{
				if(name.equals(Catalog_Name.get(k)))
				{
					return Table_Id.get(k);
				}
			}
			k++;
		}
        throw new NoSuchElementException("Invalid name in Catalog class, function getTableId" + name);
    }    

    /**
     * Returns the tuple descriptor (schema) of the specified table
     * @param tableid The id of the table, as specified by the DbFile.getId()
     *     function passed to addTable
     * @throws NoSuchElementException if the table doesn't exist
     */
    public TupleDesc getTupleDesc(int tableid) throws NoSuchElementException 
	{
        // some code goes here
		int k=0;
		int id_size=Table_Id.size();
		while(k<id_size)
		{
			if(tableid==Table_Id.get(k))
			{
				return Db_Files.get(k).getTupleDesc();
			}
			k++;
		}
        throw new NoSuchElementException("Invalid id in Catalog class, function getTupleDesc" + tableid);
    }

    /**
     * Returns the DbFile that can be used to read the contents of the
     * specified table.
     * @param tableid The id of the table, as specified by the DbFile.getId()
     *     function passed to addTable
     */
    public DbFile getDatabaseFile(int tableid) throws NoSuchElementException 
	{
        // some code goes here
		int k=0;
		int id_size=Table_Id.size();
		while(k<id_size)
		{
			if(tableid==Table_Id.get(k))
			{
                return Db_Files.get(k);
            }
			k++;
		}
        throw new NoSuchElementException("Invalid id in Catalog class, function getDatabaseFile" + tableid);
    }

    public String getPrimaryKey(int tableid) 
	{
		int j=0;
		int id_size=Table_Id.size();
		while(j<id_size)
		{
			if(tableid==Table_Id.get(j))
			{
				return PK_Field_Catalog.get(j);
			}
			j++;
		}
		throw new NoSuchElementException("Invalid id in Catalog class, function: getPrimaryKey" + tableid);
        // some code goes here
    }

    public Iterator<Integer> tableIdIterator() 
	{
        // some code goes here
        return Table_Id.iterator();
    }

    public String getTableName(int id) 
	{
        // some code goes here
		int z=0;
		int id_size=Table_Id.size();
		while(z<id_size)
		{
			if(id==Table_Id.get(z))
			{
				return Catalog_Name.get(z);
			}
            z++;
		}
        throw new NoSuchElementException("Invalid id in Catalog class, function: getTableName" + id);
    }
    
    /** Delete all tables from the catalog */
    public void clear() 
	{
        // some code goes here
		this.PK_Field_Catalog=new ArrayList<>();
        this.Table_Id=new ArrayList<>(); 
        this.Db_Files=new ArrayList<>();   
        this.Catalog_Name=new ArrayList<>();   
    }
    
    /**
     * Reads the schema from a file and creates the appropriate tables in the database.
     * @param catalogFile
     */
    public void loadSchema(String catalogFile) {
        String line = "";
        String baseFolder=new File(new File(catalogFile).getAbsolutePath()).getParent();
        try {
            BufferedReader br = new BufferedReader(new FileReader(new File(catalogFile)));
            
            while ((line = br.readLine()) != null) {
                //assume line is of the format name (field type, field type, ...)
                String name = line.substring(0, line.indexOf("(")).trim();
                //System.out.println("TABLE NAME: " + name);
                String fields = line.substring(line.indexOf("(") + 1, line.indexOf(")")).trim();
                String[] els = fields.split(",");
                ArrayList<String> names = new ArrayList<String>();
                ArrayList<Type> types = new ArrayList<Type>();
                String primaryKey = "";
                for (String e : els) {
                    String[] els2 = e.trim().split(" ");
                    names.add(els2[0].trim());
                    if (els2[1].trim().toLowerCase().equals("int"))
                        types.add(Type.INT_TYPE);
                    else if (els2[1].trim().toLowerCase().equals("string"))
                        types.add(Type.STRING_TYPE);
                    else {
                        System.out.println("Unknown type " + els2[1]);
                        System.exit(0);
                    }
                    if (els2.length == 3) {
                        if (els2[2].trim().equals("pk"))
                            primaryKey = els2[0].trim();
                        else {
                            System.out.println("Unknown annotation " + els2[2]);
                            System.exit(0);
                        }
                    }
                }
                Type[] typeAr = types.toArray(new Type[0]);
                String[] namesAr = names.toArray(new String[0]);
                TupleDesc t = new TupleDesc(typeAr, namesAr);
                HeapFile tabHf = new HeapFile(new File(baseFolder+"/"+name + ".dat"), t);
                addTable(tabHf,name,primaryKey);
                System.out.println("Added table : " + name + " with schema " + t);
            }
        } catch (IOException e) {
            e.printStackTrace();
            System.exit(0);
        } catch (IndexOutOfBoundsException e) {
            System.out.println ("Invalid catalog entry : " + line);
            System.exit(0);
        }
    }
}

