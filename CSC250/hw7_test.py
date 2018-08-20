from hw7 import *
import unittest

class hw7tests(unittest.TestCase):
    def setUp(self):
        pass


    def test_hw7_1(self):
        testintput = ['abandon', 'agrandize', 'aland', 'necessitate', 'barehand', 'candling', 'dandiest', 'brandies', 'wand', 'land', 'intrinsic', 'bambi', 'cram', 'apple', 'orange', 'banana', 'andesitic']

        output = ['abandon', 'agrandize', 'aland', 'barehand', 'candling', 'dandiest', 'brandies', 'wand', 'land', 'andesitic']
        
        self.assertEqual(hw7_1(testintput),output)

    def test_hw7_2(self): #Position is everything
        testintput = ['candlestick', 'heartsick', 'quick', 'quickfoot', 'unlicked', 'seasick', 'tick', 'fickleness', 'slapsticky','sunstricken']
        
        output = ['candlestick', 'heartsick', 'quick', 'seasick', 'tick'] 
        
        self.assertEqual(hw7_2(testintput),output)

    def test_hw7_3(self): #range
        testintput = ['abac', 'accede', 'adead', 'babe', 'bead', 'bebed', 'bedad', 'bedded', 'bedead', 'bedeaf', 'caba', 'caffa', 'dace', 'dade', 'daff', 'dead', 'deed', 'deface', 'faded', 'faff', 'feed', 'beam', 'buoy', 'canjac', 'chymia', 'corah', 'cupula', 'griece', 'hafter', 'idic', 'lucy', 'martyr', 'matron', 'messrs', 'mucose', 'relose', 'sonly', 'tegua', 'threap', 'towned', 'widish', 'yite']

        output = ['abac', 'accede', 'adead', 'babe', 'bead', 'bebed', 'bedad', 'bedded', 'bedead', 'bedeaf', 'caba', 'caffa', 'dace', 'dade', 'daff', 'dead', 'deed', 'deface', 'faded', 'faff', 'feed']
        
        self.assertEqual(hw7_3(testintput),output)

    def test_hw7_4(self): #n errors found
        testintput = ['1 error found', '2 errors found', '10 errors found', 'no errors found']

        output = ['1 error found', '2 errors found', '10 errors found']
        
        self.assertEqual(hw7_4(testintput),output)

    def test_hw7_5(self): #ones that start with blank space
        testintput = ['       1 hundred', '       10 fifties', '1 Contents', '       75 twenties', '   25 packages', '18 days']
        
        output = ['1 hundred', '10 fifties', '75 twenties', '25 packages']

        self.assertEqual(hw7_5(testintput),output)


    def test_hw7_6(self): #remove .tmp
        testintput = ['image_of_butterfly.jpg', 'image_of_tucson.png', 'image_0146328734.gif', 'image_823746824.png.tmp']

        output = ['image_of_butterfly.jpg', 'image_of_tucson.png', 'image_0146328734.gif']
        
        self.assertEqual(hw7_6(testintput),output)

    def test_hw7_7(self): #remove .tmp
        testintput = ['Jan 1987', '1492 was the year', 'Party like 1999 and then some more', '1000000 luft ballons']

        output = ['1987', '1492', '1999']
        
        self.assertEqual(hw7_7(testintput),output)

    def test_hw7_8(self): #remove .tmp
        testintput = ['I started with a 64x16 TRS-80 model 1', 'Commodore Pet had 40x25 resolution', 'first graphics was 256x192 with a TI-99', 'the compaq portable iii had 640x480. it was 20 lbs.']

        output = [(64, 16), (40, 25), (256, 192), (640, 480)]
        
        self.assertEqual(hw7_8(testintput),output)
      
    def test_hw7_9(self): #remove .tmp
        testintput = ['3.14159', '-255.34', '128', '1.9e10', '123,340.00', '720p']
        
        output = ['3.14159', '-255.34', '128', '1.9e10', '123,340.00']
        
        self.assertEqual(hw7_9(testintput),output)


    
if __name__ == '__main__':
    unittest.main()