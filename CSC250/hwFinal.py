import re
import sqlite3
from urllib.request import urlopen

def hwf_1(proteins):
    return_dict = dict()
    for protein in proteins:
        return_dict[protein] = list()
        protein_url = "http://www.uniprot.org/uniprot/{0}.fasta".format(protein)
        with urlopen(protein_url) as protein_fasta:
            protein_text = protein_fasta.read().decode('utf-8')
            protein_data = "".join(protein_text.split("\n")[1:])
            glycos_re = re.compile(r'(?=(N[^P][ST][^P]))')
            for match in glycos_re.finditer(protein_data):
                return_dict[protein].append(match.start()) 
    return return_dict

hwf_2 = lambda n, k: k*hwf_2(n - 2, k) + hwf_2(n - 1, k) if n > 2 else 1

def hwf_3(n, k, m):
    if n > 1:
        inc = k * hwf_3(n - 2, k, m) + hwf_3(n - 1, k, m)

    if n <= 0:
        return 0
    elif n == 1:
        return 1
    elif n <= m:
        return inc
    elif n == m + 1:
        return inc - 1
    else:
        return inc - k * hwf_3(n - (m + 1), k, m)

class Chinook:
    def __init__(self,dbname):
        self.conn = sqlite3.connect(dbname)
        self.cursor = self.conn.cursor()
    def get_customers(self):
        self.cursor.execute("""SELECT CustomerId, FirstName, LastName FROM customers;""")
        return list(self.cursor.fetchall())
    def get_customer_invoice_count(self, CustomerId):
        self.cursor.execute("""SELECT count(*) FROM invoices WHERE CustomerId = {0}""".format(CustomerId))
        return self.cursor.fetchall()[0][0]
    def get_customer_invoices(self, CustomerId):
        self.cursor.execute("""SELECT invoices.InvoiceId, invoices.InvoiceDate, (SELECT count(*) FROM invoice_items WHERE invoice_items.invoiceid = invoices.invoiceid) AS ItemCount FROM invoices WHERE invoices.CustomerId = {0};""".format(CustomerId))
        return self.cursor.fetchall()
    def get_invoices(self,invoiceid):
        self.cursor.execute("""SELECT invoice_items.InvoiceLineId,tracks.Name,invoice_items.UnitPrice,invoice_items.Quantity FROM invoice_items INNER JOIN tracks on invoice_items.TrackId = tracks.TrackId WHERE invoice_items.InvoiceId = {0};""".format(invoiceid))
        return self.cursor.fetchall()
    def get_customers_who_also_bought(self,trackid):
        self.cursor.execute("""SELECT invoices.CustomerId, customers.FirstName, customers.LastName  From invoice_items INNER JOIN invoices ON invoice_items.InvoiceId = invoices.InvoiceId INNER JOIN customers ON customers.CustomerId = invoices.CustomerId WHERE invoice_items.TrackId = {0};""".format(trackid))
        return self.cursor.fetchall()




