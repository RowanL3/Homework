import unittest

from hwFinal import *

class hwFinal_tests(unittest.TestCase):
    @unittest.skip("too slow")
    def test_hwf_1(self):
        proteins = ['A2Z669', 'B5ZC00', 'P07204_TRBM_HUMAN', 'P20840_SAG1_YEAST']
        proteins_dict = hwf_1(proteins)
        self.assertEqual(proteins_dict["A2Z669"],[])
        self.assertEqual(proteins_dict["P20840_SAG1_YEAST"],[78, 108, 134, 247, 305, 347, 363, 401, 484, 500, 613])
        self.assertEqual(proteins_dict["B5ZC00"],[84, 117, 141, 305, 394])
        self.assertEqual(proteins_dict["P07204_TRBM_HUMAN"],[46, 114, 115, 381, 408])

    def test_hwf_2(self):
        self.assertEqual(hwf_2(5, 3),19)
        self.assertEqual(hwf_2(6, 4),65)
        self.assertEqual(hwf_2(7, 5),301)

    def test_hwf_3(self):
        self.assertEqual(hwf_3(6, 1, 3),4)
        self.assertEqual(hwf_3(7, 1, 3),5)
        self.assertEqual(hwf_3(6, 2, 3),14)
        self.assertEqual(hwf_3(7, 5, 3),225)

    def test_Chinook(self):
        c = Chinook('chinook.db')
        self.assertEqual(c.get_customers()[:3], [(1, 'Lu\xeds', 'Gon\xe7alves'), (2, 'Leonie', 'K\xf6hler'), (3, 'Fran\xe7ois', 'Tremblay')])
        
        self.assertEqual(c.get_customer_invoice_count(3),7)
        
        self.assertEqual(c.get_customer_invoices(3),[(99, '2010-03-11 00:00:00', 2),(110, '2010-04-21 00:00:00', 14),(165, '2010-12-20 00:00:00', 9),(294, '2012-07-26 00:00:00', 2),(317, '2012-10-28 00:00:00', 4),(339, '2013-01-30 00:00:00', 6),(391, '2013-09-20 00:00:00', 1)])
        
        self.assertEqual(c.get_invoices(317),[(1713, 'Concerto for Cello and Orchestra in E minor, Op. 85: I. Adagio - Moderato', 0.99, 1),(1714, "Wellington's Victory or the Battle Symphony, Op.91: 2. Symphony of Triumph", 0.99, 1),(1715, 'Romeo et Juliette: No. 11 - Danse des Chevaliers', 0.99, 1),(1716, "Symphonie Fantastique, Op. 14: V. Songe d'une nuit du sabbat", 0.99, 1)])
        self.assertEqual(c.get_invoices(99),[(533, 'Pilot', 1.99, 1), (534, 'Through the Looking Glass, Pt. 1', 1.99, 1)])


        self.assertEqual(c.get_customers_who_also_bought(1713),[(13, 'Fernanda', 'Ramos')])
        self.assertEqual(c.get_customers_who_also_bought(449),[(1, 'Lu\xeds', 'Gon\xe7alves'), (30, 'Edward', 'Francis')])


if __name__ == "__main__":
    unittest.main()
