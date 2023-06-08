package simpledb;

import java.io.*;
import java.util.*;
import javax.xml.crypto.Data;
import java.nio.Buffer;

/**
 * HeapFile is an implementation of a DbFile that stores a collection of tuples
 * in no particular order. Tuples are stored on pages, each of which is a fixed
 * size, and the file is simply a collection of those pages. HeapFile works
 * closely with HeapPage. The format of HeapPages is described in the HeapPage
 * constructor.
 * 
 * @see simpledb.HeapPage#HeapPage
 * @author Sam Madden
 */
public class HeapFile implements DbFile {

    private final File file;

    private final TupleDesc tupleDesc;

    /**
     * Constructs a heap file backed by the specified file.
     * 
     * @param f
     *            the file that stores the on-disk backing store for this heap
     *            file.
     */
    public HeapFile(File f, TupleDesc td) {
        // some code goes here
        this.file = f;
        this.tupleDesc = td;
    }

    /**
     * Returns the File backing this HeapFile on disk.
     * 
     * @return the File backing this HeapFile on disk.
     */
    public File getFile() {
        // some code goes here
        return this.file;
    }

    /**
     * Returns an ID uniquely identifying this HeapFile. Implementation note:
     * you will need to generate this tableid somewhere to ensure that each
     * HeapFile has a "unique id," and that you always return the same value for
     * a particular HeapFile. We suggest hashing the absolute file name of the
     * file underlying the heapfile, i.e. f.getAbsoluteFile().hashCode().
     * 
     * @return an ID uniquely identifying this HeapFile.
     */
    public int getId() {
        // some code goes here
        // throw new UnsupportedOperationException("implement this");
        return this.file.getAbsoluteFile().hashCode();
    }

    /**
     * Returns the TupleDesc of the table stored in this DbFile.
     * 
     * @return TupleDesc of this DbFile.
     */
    public TupleDesc getTupleDesc() {
        // some code goes here
        // throw new UnsupportedOperationException("implement this");
        return this.tupleDesc;
    }

    // see DbFile.java for javadocs
    public Page readPage(PageId pid) {
        // some code goes here
        HeapPage heapPage;
        byte[] data = new byte[BufferPool.getPageSize()];
        try (RandomAccessFile raf = new RandomAccessFile(this.file, "r")) {
            raf.seek((long) pid.getPageNumber() * BufferPool.getPageSize());
            int n = raf.read(data, 0, data.length);
            if (n == -1) {
                throw new IOException("read page failed, reach the end of the file!");
            }
            heapPage = new HeapPage((HeapPageId) pid, data);
        } catch (IOException e) {
            throw new IllegalArgumentException(e);
        }
        return heapPage;
    }

    // see DbFile.java for javadocs
    public void writePage(Page page) throws IOException {
        // some code goes here
        // not necessary for lab1
    }

    /**
     * Returns the number of pages in this HeapFile.
     */
    public int numPages() {
        // some code goes here
        return (int) Math.ceil(this.file.length() * 1.0 / BufferPool.getPageSize());
    }

    // see DbFile.java for javadocs
    public ArrayList<Page> insertTuple(TransactionId tid, Tuple t)
            throws DbException, IOException, TransactionAbortedException {
        // some code goes here
        return null;
        // not necessary for lab1
    }

    // see DbFile.java for javadocs
    public ArrayList<Page> deleteTuple(TransactionId tid, Tuple t) throws DbException,
            TransactionAbortedException {
        // some code goes here
        return null;
        // not necessary for lab1
    }

    // see DbFile.java for javadocs
    public DbFileIterator iterator(TransactionId tid) {
        // some code goes here
        return new HeapFileIterator(this, tid);
    }

}

class HeapFileIterator extends AbstractDbFileIterator {

    Iterator<Tuple> it = null;
    HeapPage heapPage = null;

    final TransactionId tid;
    final HeapFile f;

    /**
     * Constructor for this iterator
     *
     * @param f   - the HeapFile containing the tuples
     * @param tid - the transaction id
     */
    public HeapFileIterator(HeapFile f, TransactionId tid) {
        this.f = f;
        this.tid = tid;
    }

    /**
     * Open this iterator by getting an iterator on the first page
     */
    public void open() throws DbException, TransactionAbortedException {
        PageId pid = new HeapPageId(this.f.getId(), 0);
        this.heapPage = (HeapPage) Database.getBufferPool().getPage(tid, pid, Permissions.READ_ONLY);
        it = this.heapPage.iterator();
    }

    /**
     * Read the next tuple either from the current page if it has more tuples or
     * from the next page by following the right sibling pointer.
     *
     * @return the next tuple, or null if none exists
     */
    @Override
    protected Tuple readNext() throws TransactionAbortedException, DbException {
        if (it != null && !it.hasNext()) {
            it = null; 
        }
        while (it == null && heapPage != null) {
            int pgNo = heapPage.pid.getPageNumber()+1;
            if (pgNo >= this.f.numPages()) {
                heapPage = null;
                break;
            }
            HeapPageId nextPageId = new HeapPageId(heapPage.pid.getTableId(), pgNo);
            heapPage = (HeapPage) Database.getBufferPool().getPage(tid, nextPageId, Permissions.READ_WRITE);
            it = heapPage.iterator();
            // if (it != null && it.hasNext()) {
            //     break;
            // }
            // it = null;
        }

        if (it == null) {
            return null;
        }
        return it.next();
    }

    /**
     * rewind this iterator back to the beginning of the tuples
     */
    public void rewind() throws DbException, TransactionAbortedException {
        close();
        open();
    }

    /**
     * close the iterator
     */
    public void close() {
        super.close();
        it = null;
        heapPage = null;
    }
}