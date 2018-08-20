// from http://www.calvin.edu/~stob/data/srsatact.csv
var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

var ukDriverFatalities = [
    { month: 0, year: 1969, count: 1687 },
    { month: 1, year: 1969, count: 1508 },
    { month: 2, year: 1969, count: 1507 },
    { month: 3, year: 1969, count: 1385 },
    { month: 4, year: 1969, count: 1632 },
    { month: 5, year: 1969, count: 1511 },
    { month: 6, year: 1969, count: 1559 },
    { month: 7, year: 1969, count: 1630 },
    { month: 8, year: 1969, count: 1579 },
    { month: 9, year: 1969, count: 1653 },
    { month: 10, year: 1969, count: 2152 },
    { month: 11, year: 1969, count: 2148 },
    { month: 0, year: 1970, count: 1752 },
    { month: 1, year: 1970, count: 1765 },
    { month: 2, year: 1970, count: 1717 },
    { month: 3, year: 1970, count: 1558 },
    { month: 4, year: 1970, count: 1575 },
    { month: 5, year: 1970, count: 1520 },
    { month: 6, year: 1970, count: 1805 },
    { month: 7, year: 1970, count: 1800 },
    { month: 8, year: 1970, count: 1719 },
    { month: 9, year: 1970, count: 2008 },
    { month: 10, year: 1970, count: 2242 },
    { month: 11, year: 1970, count: 2478 },
    { month: 0, year: 1971, count: 2030 },
    { month: 1, year: 1971, count: 1655 },
    { month: 2, year: 1971, count: 1693 },
    { month: 3, year: 1971, count: 1623 },
    { month: 4, year: 1971, count: 1805 },
    { month: 5, year: 1971, count: 1746 },
    { month: 6, year: 1971, count: 1795 },
    { month: 7, year: 1971, count: 1926 },
    { month: 8, year: 1971, count: 1619 },
    { month: 9, year: 1971, count: 1992 },
    { month: 10, year: 1971, count: 2233 },
    { month: 11, year: 1971, count: 2192 },
    { month: 0, year: 1972, count: 2080 },
    { month: 1, year: 1972, count: 1768 },
    { month: 2, year: 1972, count: 1835 },
    { month: 3, year: 1972, count: 1569 },
    { month: 4, year: 1972, count: 1976 },
    { month: 5, year: 1972, count: 1853 },
    { month: 6, year: 1972, count: 1965 },
    { month: 7, year: 1972, count: 1689 },
    { month: 8, year: 1972, count: 1778 },
    { month: 9, year: 1972, count: 1976 },
    { month: 10, year: 1972, count: 2397 },
    { month: 11, year: 1972, count: 2654 },
    { month: 0, year: 1973, count: 2097 },
    { month: 1, year: 1973, count: 1963 },
    { month: 2, year: 1973, count: 1677 },
    { month: 3, year: 1973, count: 1941 },
    { month: 4, year: 1973, count: 2003 },
    { month: 5, year: 1973, count: 1813 },
    { month: 6, year: 1973, count: 2012 },
    { month: 7, year: 1973, count: 1912 },
    { month: 8, year: 1973, count: 2084 },
    { month: 9, year: 1973, count: 2080 },
    { month: 10, year: 1973, count: 2118 },
    { month: 11, year: 1973, count: 2150 },
    { month: 0, year: 1974, count: 1608 },
    { month: 1, year: 1974, count: 1503 },
    { month: 2, year: 1974, count: 1548 },
    { month: 3, year: 1974, count: 1382 },
    { month: 4, year: 1974, count: 1731 },
    { month: 5, year: 1974, count: 1798 },
    { month: 6, year: 1974, count: 1779 },
    { month: 7, year: 1974, count: 1887 },
    { month: 8, year: 1974, count: 2004 },
    { month: 9, year: 1974, count: 2077 },
    { month: 10, year: 1974, count: 2092 },
    { month: 11, year: 1974, count: 2051 },
    { month: 0, year: 1975, count: 1577 },
    { month: 1, year: 1975, count: 1356 },
    { month: 2, year: 1975, count: 1652 },
    { month: 3, year: 1975, count: 1382 },
    { month: 4, year: 1975, count: 1519 },
    { month: 5, year: 1975, count: 1421 },
    { month: 6, year: 1975, count: 1442 },
    { month: 7, year: 1975, count: 1543 },
    { month: 8, year: 1975, count: 1656 },
    { month: 9, year: 1975, count: 1561 },
    { month: 10, year: 1975, count: 1905 },
    { month: 11, year: 1975, count: 2199 },
    { month: 0, year: 1976, count: 1473 },
    { month: 1, year: 1976, count: 1655 },
    { month: 2, year: 1976, count: 1407 },
    { month: 3, year: 1976, count: 1395 },
    { month: 4, year: 1976, count: 1530 },
    { month: 5, year: 1976, count: 1309 },
    { month: 6, year: 1976, count: 1526 },
    { month: 7, year: 1976, count: 1327 },
    { month: 8, year: 1976, count: 1627 },
    { month: 9, year: 1976, count: 1748 },
    { month: 10, year: 1976, count: 1958 },
    { month: 11, year: 1976, count: 2274 },
    { month: 0, year: 1977, count: 1648 },
    { month: 1, year: 1977, count: 1401 },
    { month: 2, year: 1977, count: 1411 },
    { month: 3, year: 1977, count: 1403 },
    { month: 4, year: 1977, count: 1394 },
    { month: 5, year: 1977, count: 1520 },
    { month: 6, year: 1977, count: 1528 },
    { month: 7, year: 1977, count: 1643 },
    { month: 8, year: 1977, count: 1515 },
    { month: 9, year: 1977, count: 1685 },
    { month: 10, year: 1977, count: 2000 },
    { month: 11, year: 1977, count: 2215 },
    { month: 0, year: 1978, count: 1956 },
    { month: 1, year: 1978, count: 1462 },
    { month: 2, year: 1978, count: 1563 },
    { month: 3, year: 1978, count: 1459 },
    { month: 4, year: 1978, count: 1446 },
    { month: 5, year: 1978, count: 1622 },
    { month: 6, year: 1978, count: 1657 },
    { month: 7, year: 1978, count: 1638 },
    { month: 8, year: 1978, count: 1643 },
    { month: 9, year: 1978, count: 1683 },
    { month: 10, year: 1978, count: 2050 },
    { month: 11, year: 1978, count: 2262 },
    { month: 0, year: 1979, count: 1813 },
    { month: 1, year: 1979, count: 1445 },
    { month: 2, year: 1979, count: 1762 },
    { month: 3, year: 1979, count: 1461 },
    { month: 4, year: 1979, count: 1556 },
    { month: 5, year: 1979, count: 1431 },
    { month: 6, year: 1979, count: 1427 },
    { month: 7, year: 1979, count: 1554 },
    { month: 8, year: 1979, count: 1645 },
    { month: 9, year: 1979, count: 1653 },
    { month: 10, year: 1979, count: 2016 },
    { month: 11, year: 1979, count: 2207 },
    { month: 0, year: 1980, count: 1665 },
    { month: 1, year: 1980, count: 1361 },
    { month: 2, year: 1980, count: 1506 },
    { month: 3, year: 1980, count: 1360 },
    { month: 4, year: 1980, count: 1453 },
    { month: 5, year: 1980, count: 1522 },
    { month: 6, year: 1980, count: 1460 },
    { month: 7, year: 1980, count: 1552 },
    { month: 8, year: 1980, count: 1548 },
    { month: 9, year: 1980, count: 1827 },
    { month: 10, year: 1980, count: 1737 },
    { month: 11, year: 1980, count: 1941 },
    { month: 0, year: 1981, count: 1474 },
    { month: 1, year: 1981, count: 1458 },
    { month: 2, year: 1981, count: 1542 },
    { month: 3, year: 1981, count: 1404 },
    { month: 4, year: 1981, count: 1522 },
    { month: 5, year: 1981, count: 1385 },
    { month: 6, year: 1981, count: 1641 },
    { month: 7, year: 1981, count: 1510 },
    { month: 8, year: 1981, count: 1681 },
    { month: 9, year: 1981, count: 1938 },
    { month: 10, year: 1981, count: 1868 },
    { month: 11, year: 1981, count: 1726 },
    { month: 0, year: 1982, count: 1456 },
    { month: 1, year: 1982, count: 1445 },
    { month: 2, year: 1982, count: 1456 },
    { month: 3, year: 1982, count: 1365 },
    { month: 4, year: 1982, count: 1487 },
    { month: 5, year: 1982, count: 1558 },
    { month: 6, year: 1982, count: 1488 },
    { month: 7, year: 1982, count: 1684 },
    { month: 8, year: 1982, count: 1594 },
    { month: 9, year: 1982, count: 1850 },
    { month: 10, year: 1982, count: 1998 },
    { month: 11, year: 1982, count: 2079 },
    { month: 0, year: 1983, count: 1494 },
    { month: 1, year: 1983, count: 1057 },
    { month: 2, year: 1983, count: 1218 },
    { month: 3, year: 1983, count: 1168 },
    { month: 4, year: 1983, count: 1236 },
    { month: 5, year: 1983, count: 1076 },
    { month: 6, year: 1983, count: 1174 },
    { month: 7, year: 1983, count: 1139 },
    { month: 8, year: 1983, count: 1427 },
    { month: 9, year: 1983, count: 1487 },
    { month: 10, year: 1983, count: 1483 },
    { month: 11, year: 1983, count: 1513 },
    { month: 0, year: 1984, count: 1357 },
    { month: 1, year: 1984, count: 1165 },
    { month: 2, year: 1984, count: 1282 },
    { month: 3, year: 1984, count: 1110 },
    { month: 4, year: 1984, count: 1297 },
    { month: 5, year: 1984, count: 1185 },
    { month: 6, year: 1984, count: 1222 },
    { month: 7, year: 1984, count: 1284 },
    { month: 8, year: 1984, count: 1444 },
    { month: 9, year: 1984, count: 1575 },
    { month: 10, year: 1984, count: 1737 },
    { month: 11, year: 1984, count: 1763 }
];

// SATM,SATV,ACT,GPA
var scores = [
 { SATM:430, SATV:470, ACT:15, GPA: 2.239 },
 { SATM:560, SATV:350, ACT:16, GPA: 2.488 },
 { SATM:400, SATV:330, ACT:17, GPA: 2.982 },
 { SATM:410, SATV:450, ACT:17, GPA: 2.155 },
 { SATM:430, SATV:460, ACT:17, GPA: 2.712 },
 { SATM:430, SATV:370, ACT:18, GPA: 1.913 },
 { SATM:440, SATV:450, ACT:18, GPA: 2.953 },
 { SATM:550, SATV:410, ACT:18, GPA: 2.664 },
 { SATM:570, SATV:320, ACT:18, GPA: 2.932 },
 { SATM:370, SATV:480, ACT:19, GPA: 2.67 },
 { SATM:440, SATV:450, ACT:19, GPA: 2.08 },
 { SATM:510, SATV:520, ACT:19, GPA: 2.798 },
 { SATM:540, SATV:470, ACT:19, GPA: 2.796 },
 { SATM:490, SATV:540, ACT:20, GPA: 3.365 },
 { SATM:490, SATV:460, ACT:20, GPA: 2.913 },
 { SATM:490, SATV:500, ACT:20, GPA: 3.044 },
 { SATM:510, SATV:540, ACT:20, GPA: 2.608 },
 { SATM:530, SATV:280, ACT:20, GPA: 1.789 },
 { SATM:510, SATV:460, ACT:21, GPA: 3.202 },
 { SATM:520, SATV:480, ACT:21, GPA: 3.244 },
 { SATM:540, SATV:430, ACT:21, GPA: 3.442 },
 { SATM:560, SATV:430, ACT:21, GPA: 2.716 },
 { SATM:620, SATV:530, ACT:21, GPA: 2.208 },
 { SATM:690, SATV:350, ACT:21, GPA: 3.366 },
 { SATM:410, SATV:600, ACT:22, GPA: 3.153 },
 { SATM:470, SATV:500, ACT:22, GPA: 2.097 },
 { SATM:560, SATV:580, ACT:22, GPA: 3.316 },
 { SATM:580, SATV:490, ACT:22, GPA: 2.507 },
 { SATM:590, SATV:620, ACT:22, GPA: 2.665 },
 { SATM:600, SATV:480, ACT:22, GPA: 3.26 },
 { SATM:650, SATV:490, ACT:22, GPA: 3.409 },
 { SATM:450, SATV:530, ACT:23, GPA: 2.963 },
 { SATM:470, SATV:480, ACT:23, GPA: 2.92 },
 { SATM:480, SATV:570, ACT:23, GPA: 3.025 },
 { SATM:490, SATV:500, ACT:23, GPA: 3.465 },
 { SATM:510, SATV:540, ACT:23, GPA: 3.262 },
 { SATM:520, SATV:530, ACT:23, GPA: 2.075 },
 { SATM:520, SATV:530, ACT:23, GPA: 2.673 },
 { SATM:550, SATV:650, ACT:23, GPA: 3.657 },
 { SATM:550, SATV:590, ACT:23, GPA: 3.326 },
 { SATM:560, SATV:540, ACT:23, GPA: 3.463 },
 { SATM:560, SATV:520, ACT:23, GPA: 3.315 },
 { SATM:570, SATV:570, ACT:23, GPA: 3.183 },
 { SATM:580, SATV:550, ACT:23, GPA: 3.667 },
 { SATM:610, SATV:560, ACT:23, GPA: 3.452 },
 { SATM:610, SATV:630, ACT:23, GPA: 2.528 },
 { SATM:410, SATV:470, ACT:24, GPA: 2.496 },
 { SATM:500, SATV:630, ACT:24, GPA: 2.978 },
 { SATM:520, SATV:630, ACT:24, GPA: 3.19 },
 { SATM:520, SATV:560, ACT:24, GPA: 3.311 },
 { SATM:520, SATV:610, ACT:24, GPA: 3.039 },
 { SATM:540, SATV:560, ACT:24, GPA: 3.487 },
 { SATM:540, SATV:560, ACT:24, GPA: 1.704 },
 { SATM:550, SATV:590, ACT:24, GPA: 3.659 },
 { SATM:580, SATV:520, ACT:24, GPA: 3.441 },
 { SATM:590, SATV:500, ACT:24, GPA: 2.829 },
 { SATM:620, SATV:600, ACT:24, GPA: 3.684 },
 { SATM:630, SATV:490, ACT:24, GPA: 3.319 },
 { SATM:640, SATV:480, ACT:24, GPA: 2.607 },
 { SATM:420, SATV:440, ACT:25, GPA: 2.031 },
 { SATM:480, SATV:520, ACT:25, GPA: 3.564 },
 { SATM:490, SATV:560, ACT:25, GPA: 3.371 },
 { SATM:490, SATV:640, ACT:25, GPA: 3.672 },
 { SATM:510, SATV:520, ACT:25, GPA: 3.698 },
 { SATM:580, SATV:620, ACT:25, GPA: 3.399 },
 { SATM:600, SATV:670, ACT:25, GPA: 3.594 },
 { SATM:620, SATV:560, ACT:25, GPA: 3.146 },
 { SATM:710, SATV:600, ACT:25, GPA: 3.061 },
 { SATM:720, SATV:590, ACT:25, GPA: 3.317 },
 { SATM:730, SATV:600, ACT:25, GPA: 3.613 },
 { SATM:780, SATV:560, ACT:25, GPA: 2.852 },
 { SATM:480, SATV:530, ACT:26, GPA: 2.732 },
 { SATM:490, SATV:560, ACT:26, GPA: 3.522 },
 { SATM:520, SATV:600, ACT:26, GPA: 3.1 },
 { SATM:520, SATV:610, ACT:26, GPA: 3.471 },
 { SATM:520, SATV:640, ACT:26, GPA: 3.631 },
 { SATM:530, SATV:520, ACT:26, GPA: 2.199 },
 { SATM:530, SATV:510, ACT:26, GPA: 3.803 },
 { SATM:550, SATV:700, ACT:26, GPA: 3.48 },
 { SATM:560, SATV:610, ACT:26, GPA: 2.989 },
 { SATM:580, SATV:550, ACT:26, GPA: 3.621 },
 { SATM:580, SATV:550, ACT:26, GPA: 2.784 },
 { SATM:580, SATV:580, ACT:26, GPA: 3.485 },
 { SATM:580, SATV:660, ACT:26, GPA: 3.016 },
 { SATM:580, SATV:540, ACT:26, GPA: 3.695 },
 { SATM:590, SATV:580, ACT:26, GPA: 2.496 },
 { SATM:590, SATV:570, ACT:26, GPA: 3.638 },
 { SATM:620, SATV:570, ACT:26, GPA: 3.03 },
 { SATM:620, SATV:560, ACT:26, GPA: 3.686 },
 { SATM:630, SATV:700, ACT:26, GPA: 3.145 },
 { SATM:630, SATV:610, ACT:26, GPA: 3.222 },
 { SATM:660, SATV:560, ACT:26, GPA: 3.751 },
 { SATM:660, SATV:570, ACT:26, GPA: 3.128 },
 { SATM:690, SATV:600, ACT:26, GPA: 2.513 },
 { SATM:470, SATV:710, ACT:27, GPA: 3.625 },
 { SATM:530, SATV:640, ACT:27, GPA: 3.804 },
 { SATM:540, SATV:630, ACT:27, GPA: 3.105 },
 { SATM:540, SATV:610, ACT:27, GPA: 2.275 },
 { SATM:550, SATV:630, ACT:27, GPA: 3.479 },
 { SATM:560, SATV:520, ACT:27, GPA: 3.222 },
 { SATM:570, SATV:610, ACT:27, GPA: 3.41 },
 { SATM:580, SATV:560, ACT:27, GPA: 3.77 },
 { SATM:600, SATV:540, ACT:27, GPA: 3.646 },
 { SATM:610, SATV:540, ACT:27, GPA: 3.735 },
 { SATM:610, SATV:570, ACT:27, GPA: 3.618 },
 { SATM:610, SATV:670, ACT:27, GPA: 3.167 },
 { SATM:610, SATV:630, ACT:27, GPA: 3.015 },
 { SATM:620, SATV:570, ACT:27, GPA: 3.618 },
 { SATM:620, SATV:570, ACT:27, GPA: 3.254 },
 { SATM:620, SATV:600, ACT:27, GPA: 3.407 },
 { SATM:630, SATV:490, ACT:27, GPA: 3.327 },
 { SATM:650, SATV:600, ACT:27, GPA: 3.204 },
 { SATM:650, SATV:630, ACT:27, GPA: 3.324 },
 { SATM:650, SATV:570, ACT:27, GPA: 3.126 },
 { SATM:670, SATV:540, ACT:27, GPA: 3.58 },
 { SATM:670, SATV:570, ACT:27, GPA: 3.83 },
 { SATM:670, SATV:620, ACT:27, GPA: 3.475 },
 { SATM:670, SATV:460, ACT:27, GPA: 2.048 },
 { SATM:670, SATV:700, ACT:27, GPA: 3.83 },
 { SATM:690, SATV:580, ACT:27, GPA: 3.284 },
 { SATM:720, SATV:650, ACT:27, GPA: 3.934 },
 { SATM:720, SATV:680, ACT:27, GPA: 3.78 },
 { SATM:520, SATV:600, ACT:28, GPA: 3.413 },
 { SATM:530, SATV:560, ACT:28, GPA: 3.502 },
 { SATM:550, SATV:580, ACT:28, GPA: 3.605 },
 { SATM:550, SATV:660, ACT:28, GPA: 3.563 },
 { SATM:570, SATV:590, ACT:28, GPA: 3.127 },
 { SATM:580, SATV:650, ACT:28, GPA: 3.765 },
 { SATM:590, SATV:730, ACT:28, GPA: 3.792 },
 { SATM:590, SATV:720, ACT:28, GPA: 3.847 },
 { SATM:600, SATV:710, ACT:28, GPA: 2.453 },
 { SATM:600, SATV:590, ACT:28, GPA: 3.287 },
 { SATM:600, SATV:660, ACT:28, GPA: 2.452 },
 { SATM:600, SATV:580, ACT:28, GPA: 3.441 },
 { SATM:600, SATV:710, ACT:28, GPA: 3.821 },
 { SATM:610, SATV:530, ACT:28, GPA: 2.976 },
 { SATM:610, SATV:590, ACT:28, GPA: 3.75 },
 { SATM:610, SATV:650, ACT:28, GPA: 2.972 },
 { SATM:610, SATV:630, ACT:28, GPA: 3.647 },
 { SATM:630, SATV:620, ACT:28, GPA: 3.424 },
 { SATM:630, SATV:570, ACT:28, GPA: 3.457 },
 { SATM:660, SATV:630, ACT:28, GPA: 3.66 },
 { SATM:710, SATV:670, ACT:28, GPA: 3.877 },
 { SATM:730, SATV:590, ACT:28, GPA: 3.534 },
 { SATM:540, SATV:630, ACT:29, GPA: 3.594 },
 { SATM:570, SATV:570, ACT:29, GPA: 3.5 },
 { SATM:580, SATV:570, ACT:29, GPA: 3.575 },
 { SATM:580, SATV:620, ACT:29, GPA: 3.03 },
 { SATM:600, SATV:650, ACT:29, GPA: 3.301 },
 { SATM:610, SATV:680, ACT:29, GPA: 2.94 },
 { SATM:610, SATV:650, ACT:29, GPA: 2.738 },
 { SATM:610, SATV:660, ACT:29, GPA: 2.943 },
 { SATM:610, SATV:610, ACT:29, GPA: 2.121 },
 { SATM:620, SATV:630, ACT:29, GPA: 3.665 },
 { SATM:640, SATV:660, ACT:29, GPA: 2.864 },
 { SATM:640, SATV:620, ACT:29, GPA: 3.712 },
 { SATM:640, SATV:690, ACT:29, GPA: 3.319 },
 { SATM:640, SATV:670, ACT:29, GPA: 3.929 },
 { SATM:640, SATV:640, ACT:29, GPA: 3.838 },
 { SATM:650, SATV:630, ACT:29, GPA: 3.649 },
 { SATM:650, SATV:490, ACT:29, GPA: 3.528 },
 { SATM:650, SATV:620, ACT:29, GPA: 2.828 },
 { SATM:660, SATV:640, ACT:29, GPA: 3.464 },
 { SATM:680, SATV:680, ACT:29, GPA: 3.538 },
 { SATM:680, SATV:630, ACT:29, GPA: 3.919 },
 { SATM:690, SATV:620, ACT:29, GPA: 2.827 },
 { SATM:700, SATV:670, ACT:29, GPA: 3.677 },
 { SATM:700, SATV:610, ACT:29, GPA: 2.645 },
 { SATM:710, SATV:640, ACT:29, GPA: 3.898 },
 { SATM:710, SATV:590, ACT:29, GPA: 3.854 },
 { SATM:770, SATV:610, ACT:29, GPA: 2.01 },
 { SATM:550, SATV:650, ACT:30, GPA: 3.134 },
 { SATM:560, SATV:670, ACT:30, GPA: 3.947 },
 { SATM:570, SATV:720, ACT:30, GPA: 3.662 },
 { SATM:570, SATV:670, ACT:30, GPA: 2.983 },
 { SATM:590, SATV:640, ACT:30, GPA: 3.544 },
 { SATM:620, SATV:600, ACT:30, GPA: 2.586 },
 { SATM:640, SATV:600, ACT:30, GPA: 3.707 },
 { SATM:640, SATV:580, ACT:30, GPA: 3.768 },
 { SATM:660, SATV:710, ACT:30, GPA: 3.527 },
 { SATM:660, SATV:680, ACT:30, GPA: 3.344 },
 { SATM:670, SATV:630, ACT:30, GPA: 3.407 },
 { SATM:680, SATV:690, ACT:30, GPA: 3.406 },
 { SATM:680, SATV:670, ACT:30, GPA: 2.925 },
 { SATM:690, SATV:630, ACT:30, GPA: 3.877 },
 { SATM:700, SATV:670, ACT:30, GPA: 3.992 },
 { SATM:700, SATV:760, ACT:30, GPA: 3.975 },
 { SATM:720, SATV:700, ACT:30, GPA: 3.987 },
 { SATM:730, SATV:610, ACT:30, GPA: 3.8 },
 { SATM:730, SATV:730, ACT:30, GPA: 3.989 },
 { SATM:750, SATV:650, ACT:30, GPA: 3.33 },
 { SATM:750, SATV:650, ACT:30, GPA: 3.469 },
 { SATM:590, SATV:660, ACT:31, GPA: 3.236 },
 { SATM:600, SATV:670, ACT:31, GPA: 3.812 },
 { SATM:610, SATV:650, ACT:31, GPA: 3.593 },
 { SATM:640, SATV:710, ACT:31, GPA: 3.745 },
 { SATM:640, SATV:700, ACT:31, GPA: 3.178 },
 { SATM:640, SATV:720, ACT:31, GPA: 3.76 },
 { SATM:660, SATV:780, ACT:31, GPA: 3.737 },
 { SATM:660, SATV:710, ACT:31, GPA: 3.61 },
 { SATM:660, SATV:630, ACT:31, GPA: 3.618 },
 { SATM:660, SATV:610, ACT:31, GPA: 3.794 },
 { SATM:660, SATV:560, ACT:31, GPA: 2.857 },
 { SATM:680, SATV:700, ACT:31, GPA: 3.483 },
 { SATM:690, SATV:750, ACT:31, GPA: 3.811 },
 { SATM:690, SATV:680, ACT:31, GPA: 3.791 },
 { SATM:690, SATV:660, ACT:31, GPA: 3.813 },
 { SATM:690, SATV:630, ACT:31, GPA: 3.954 },
 { SATM:700, SATV:630, ACT:31, GPA: 3.62 },
 { SATM:700, SATV:760, ACT:31, GPA: 3.493 },
 { SATM:700, SATV:640, ACT:31, GPA: 3.912 },
 { SATM:700, SATV:680, ACT:31, GPA: 3.485 },
 { SATM:710, SATV:700, ACT:31, GPA: 3.763 },
 { SATM:720, SATV:630, ACT:31, GPA: 2.707 },
 { SATM:730, SATV:750, ACT:31, GPA: 3.947 },
 { SATM:760, SATV:590, ACT:31, GPA: 3.887 },
 { SATM:770, SATV:650, ACT:31, GPA: 3.988 },
 { SATM:620, SATV:760, ACT:32, GPA: 3.593 },
 { SATM:630, SATV:650, ACT:32, GPA: 3.598 },
 { SATM:650, SATV:720, ACT:32, GPA: 3.941 },
 { SATM:660, SATV:740, ACT:32, GPA: 2.456 },
 { SATM:660, SATV:730, ACT:32, GPA: 3.909 },
 { SATM:660, SATV:690, ACT:32, GPA: 3.909 },
 { SATM:670, SATV:650, ACT:32, GPA: 3.288 },
 { SATM:670, SATV:620, ACT:32, GPA: 3.91 },
 { SATM:690, SATV:700, ACT:32, GPA: 3.78 },
 { SATM:690, SATV:720, ACT:32, GPA: 3.851 },
 { SATM:690, SATV:680, ACT:32, GPA: 3.764 },
 { SATM:690, SATV:750, ACT:32, GPA: 3.823 },
 { SATM:690, SATV:680, ACT:32, GPA: 3.676 },
 { SATM:700, SATV:640, ACT:32, GPA: 2.721 },
 { SATM:700, SATV:700, ACT:32, GPA: 3.942 },
 { SATM:710, SATV:680, ACT:32, GPA: 4 },
 { SATM:710, SATV:750, ACT:32, GPA: 3.943 },
 { SATM:710, SATV:740, ACT:32, GPA: 2.708 },
 { SATM:730, SATV:580, ACT:32, GPA: 3.433 },
 { SATM:760, SATV:720, ACT:32, GPA: 3.784 },
 { SATM:770, SATV:670, ACT:32, GPA: 3.303 },
 { SATM:780, SATV:800, ACT:32, GPA: 3.929 },
 { SATM:800, SATV:750, ACT:32, GPA: 3.653 },
 { SATM:620, SATV:730, ACT:33, GPA: 3.916 },
 { SATM:650, SATV:690, ACT:33, GPA: 3.401 },
 { SATM:680, SATV:720, ACT:33, GPA: 3.824 },
 { SATM:690, SATV:590, ACT:33, GPA: 3.535 },
 { SATM:700, SATV:580, ACT:33, GPA: 3.898 },
 { SATM:710, SATV:730, ACT:33, GPA: 3.643 },
 { SATM:710, SATV:730, ACT:33, GPA: 3.98 },
 { SATM:710, SATV:720, ACT:33, GPA: 3.642 },
 { SATM:710, SATV:630, ACT:33, GPA: 3.874 },
 { SATM:730, SATV:690, ACT:33, GPA: 3.936 },
 { SATM:790, SATV:730, ACT:33, GPA: 3.154 },
 { SATM:800, SATV:630, ACT:33, GPA: 3.925 },
 { SATM:800, SATV:720, ACT:33, GPA: 3.888 },
 { SATM:640, SATV:730, ACT:34, GPA: 3.885 },
 { SATM:640, SATV:670, ACT:34, GPA: 3.536 },
 { SATM:670, SATV:650, ACT:34, GPA: 3.872 },
 { SATM:690, SATV:800, ACT:34, GPA: 3.894 },
 { SATM:700, SATV:800, ACT:34, GPA: 2.534 },
 { SATM:720, SATV:720, ACT:34, GPA: 3.37 },
 { SATM:740, SATV:740, ACT:34, GPA: 3.833 },
 { SATM:750, SATV:800, ACT:34, GPA: 3.944 },
 { SATM:760, SATV:750, ACT:34, GPA: 3.757 },
 { SATM:770, SATV:730, ACT:34, GPA: 3.325 },
 { SATM:790, SATV:710, ACT:34, GPA: 3.928 },
 { SATM:790, SATV:760, ACT:34, GPA: 3.889 },
 { SATM:790, SATV:660, ACT:34, GPA: 3.821 },
 { SATM:800, SATV:680, ACT:34, GPA: 3.765 },
 { SATM:700, SATV:680, ACT:35, GPA: 3.911 },
 { SATM:720, SATV:770, ACT:35, GPA: 3.981 },
 { SATM:750, SATV:730, ACT:35, GPA: 3.882 },
 { SATM:790, SATV:780, ACT:35, GPA: 3.887 }
];
