Use sales;

-- Viewing Tables
select * from Orders;
select * from Customers;
select * from products;

select * from regions;
select * from salesteam;
select * from storelocations;

-- Total number of orders
select count(*) from orders; -- 7991

-- Most commonly-bought Products
SELECT p.ProductName, SUM(o.OrderQuantity) AS TotalQuantity,
(SUM(UnitPrice * OrderQuantity) - SUM(UnitCost * OrderQuantity)) AS Profit
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER BY TotalQuantity DESC
LIMIT 10;

-- Accessories	956	908818.77
-- Platters	896	743189.73
-- Cocktail Glasses	879	796037.53
-- Serveware	878	786277.29
-- Rugs	855	767278.91
-- Collectibles	854	761318.88
-- Wine Storage	837	664722.41
-- Wardrobes	832	671194.72
-- Wreaths	830	659761.88
-- Dining Furniture	827	672009.47

SELECT p.ProductName, SUM((o.UnitPrice - o.UnitCost) * o.OrderQuantity) AS TotalProfit
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER BY TotalProfit DESC
LIMIT 10;

-- Accessories	908818.77
-- Cocktail Glasses	796037.53
-- Serveware	786277.29
-- Photo Frames	783599.74
-- Rugs	767278.91
-- Collectibles	761318.88
-- Bathroom Furniture	750981.44
-- Platters	743189.73
-- Table Linens	741447.88
-- Ornaments	741098.06

-- Least bought items
SELECT p.ProductName, SUM(o.OrderQuantity) AS TotalQuantity,
(SUM(UnitPrice * OrderQuantity) - SUM(UnitCost * OrderQuantity)) AS Profit
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.ProductID
ORDER BY TotalQuantity
LIMIT 10;

-- 	ProductName	TotalQuantity	Profit
-- 	Pillows	585	463878.87
-- 	Bedroom Furniture	635	530258.04
-- 	Basketball	644	628425.52
-- 	Bean Bags	652	491861.18
-- 	Wall Coverings	656	563771.91
-- 	Outdoor Furniture	658	558060.88
-- 	Vases	660	532470.97
-- 	Computers	663	530131.54
-- 	Audio	680	555693.55
-- 	Cookware	681	551261.99

-- SELECT p.ProductName, SUM((o.UnitPrice - o.UnitCost) * o.OrderQuantity) AS TotalProfit
-- FROM Orders o
-- JOIN Products p ON o.ProductID = p.ProductID
-- GROUP BY p.ProductID
-- ORDER BY TotalProfit
-- LIMIT 10;

-- Orders by channel
select count(distinct ordernumber) as OrdersByChannel, 
SUM(UnitPrice * OrderQuantity) AS TotalRevenue,
SalesChannel from Orders group by saleschannel;

-- 1375	14809907.80	Distributor
-- 3298	34040113.80	In-Store
-- 2425	24629756.10	Online
-- 893	9212948.90	Wholesale

-- AVG, MIN, MAX prices and costs
select min(unitcost), max(unitcost), avg(unitcost) from orders;

-- 68.68	5498.56	1431.911513

-- Profit
SELECT 
    SUM(UnitPrice * OrderQuantity) AS TotalRevenue,
    SUM(UnitCost * OrderQuantity) AS TotalCost,
    (SUM(UnitPrice * OrderQuantity) - SUM(UnitCost * OrderQuantity)) AS Profit
FROM Orders;

-- 82692726.60	51818068.88	30874657.72

-- AVG discount %
SELECT CONCAT(ROUND(AVG(DiscountApplied) * 100, 2), '%') AS AverageDiscount FROM Orders;

-- 11.44%

-- TOP 5 highest price items
SELECT p.ProductID, ProductName, MAX(UnitPrice) AS HighestPrice
FROM Orders o JOIN Products p ON o.ProductID = p.ProductID
GROUP BY ProductID ORDER BY HighestPrice DESC LIMIT 5;

-- 11	Ornaments	6566.00
-- 19	Vanities	6559.30
-- 10	Blankets	6559.30
-- 29	Pendants	6559.30
-- 9	Baseball	6545.90


-- Stores by region
SELECT Region, COUNT(*) as NumberOfStores FROM SalesTeam GROUP BY Region;

-- Northeast	7
-- West	7
-- South	6
-- Midwest	8

-- Stores with highest sales in each region
SELECT st.SalesTeamName, st.Region, st.StoreCount, st.TotalSalesRevenue
FROM (
    SELECT 
        st.SalesTeamID,
        st.SalesTeamName,
        st.Region,
        COUNT(o.StoreID) as StoreCount,
        SUM(o.UnitPrice * o.OrderQuantity) AS TotalSalesRevenue,
        RANK() OVER (PARTITION BY st.Region ORDER BY SUM(o.UnitPrice * o.OrderQuantity) DESC) AS rnk
    FROM Orders o JOIN SalesTeam st ON o.SalesTeamID = st.SalesTeamID
    GROUP BY st.SalesTeamID, st.SalesTeamName, st.Region
) st WHERE st.rnk = 1 ORDER BY st.TotalSalesRevenue;

-- Carl Nguyen	Midwest	314	3181160.00
-- Todd Roberts	West	340	3242525.30
-- Adam Hernandez	Northeast	302	3261359.00
-- Donald Reynolds	South	296	3346569.60

-- Customers with number of orders > 100
SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderNumber) AS TotalOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
HAVING TotalOrders > 150;

-- 1	Avon Corp	152
-- 2	WakeFern 	135
-- 3	Elorac, Corp	181
-- 4	ETUDE Ltd	167
-- 5	Procter Corp	159
-- 6	PEDIFIX, Corp	143
-- 7	New Ltd	153
-- 8	Medsep Group	142
-- 9	Ei 	171
-- 10	21st Ltd	158
-- 11	Apollo Ltd	178
-- 12	Medline 	210
-- 13	Ole Group	171
-- 14	Linde 	157
-- 15	Rochester Ltd	142
-- 16	3LAB, Ltd	135
-- 17	Pure Group	175
-- 18	Eminence Corp	186
-- 19	Qualitest 	165
-- 20	Pacific Ltd	167
-- 21	Ohio 	164
-- 22	Capweld 	140
-- 23	E. Ltd	164
-- 24	Burt's Corp	151
-- 25	Prasco Group	162
-- 26	Mylan Corp	153
-- 27	Wuxi Group	144
-- 28	Dharma Ltd	145
-- 29	Apotheca, Ltd	179
-- 30	S.S.S. Group	159
-- 31	Uriel Group	152
-- 32	OHTA'S Corp	173
-- 33	Trigen 	156
-- 34	OUR Ltd	176
-- 35	Amylin Group	145
-- 36	O.E. Ltd	156
-- 37	AuroMedics Corp	152
-- 38	Ascend Ltd	150
-- 39	Victory Ltd	176
-- 40	Select 	150
-- 41	Weimei Corp	161
-- 42	Llorens Ltd	161
-- 43	Exact-Rx, Corp	151
-- 44	Winthrop 	156
-- 45	Nipro 	156
-- 46	U.S. Ltd	157
-- 47	Niconovum Corp	168
-- 48	Fenwal, Corp	172
-- 49	Bare 	152
-- 50	Sundial 	163

-- NO Stores with no sales (distinct storeids from storelocations not in storeids from orders)

-- total sales per store vs median income
WITH totalsales(storeid, totalsale, avgsale) AS (
    SELECT storeid, SUM(unitprice * orderquantity), AVG(unitprice * orderquantity)
    FROM orders
    GROUP BY storeid
)
SELECT sl.storeid, cityname, state, medianincome, ts.totalsale AS TotalSales, ts.avgsale AS AverageSales
FROM StoreLocations sl
JOIN totalsales ts ON ts.storeid = sl.storeid;

-- 1	Birmingham	Alabama	31061	273520.80	10130.400000
-- 2	Huntsville	Alabama	48775	207840.70	9036.552174
-- 3	Mobile	Alabama	38776	109411.00	9117.583333
-- 4	Montgomery	Alabama	42927	154863.80	9109.635294
-- 5	Little Rock	Arkansas	46085	114630.30	7642.020000
-- 6	Chandler	Arizona	72695	175600.30	7024.012000
-- 7	Gilbert	Arizona	82424	189998.60	7916.608333
-- 8	Glendale	Arizona	46776	170173.30	8956.489474
-- 9	Mesa	Arizona	48809	156203.80	9762.737500
-- 10	Peoria	Arizona	65314	76768.60	8529.844444
-- 11	Phoenix	Arizona	47326	270164.10	8442.628125
-- 12	Scottsdale	Arizona	73288	282867.30	11314.692000
-- 13	Surprise	Arizona	59916	101739.50	9249.045455
-- 14	Tempe	Arizona	49012	227538.70	10342.668182
-- 15	Tucson	Arizona	37149	180477.90	9498.836842
-- 16	Anaheim	California	60752	215063.30	10753.165000
-- 17	Antioch	California	64329	318631.90	9371.526471
-- 18	Bakersfield	California	57095	159875.40	9404.435294
-- 19	Berkeley	California	66237	222962.60	9694.026087
-- 20	Burbank	California	66076	191090.70	9554.535000
-- 21	Carlsbad	California	90597	350617.70	10312.285294
-- 22	Chula Vista	California	65185	281433.50	9704.603448
-- 23	Clovis	California	62666	149671.30	11513.176923
-- 24	Concord	California	68318	246064.20	10698.443478
-- 25	Corona	California	74149	198454.00	11673.764706
-- 26	Costa Mesa	California	66459	443841.50	11680.039474
-- 27	Daly City	California	74449	221334.50	12296.361111
-- 28	Downey	California	62897	272743.60	12397.436364
-- 29	East Los Angeles	California	38766	221964.30	8220.900000
-- 30	El Cajon	California	45925	362483.40	13941.669231
-- 31	Elk Grove	California	79487	195258.10	8489.482609
-- 32	El Monte	California	38085	239913.60	13328.533333
-- 33	Escondido	California	50899	389605.00	13434.655172
-- 34	Fairfield	California	67364	179640.40	12831.457143
-- 35	Fontana	California	64824	225709.60	11285.480000
-- 36	Fremont	California	105355	271470.60	11311.275000
-- 37	Fresno	California	41531	161161.80	8058.090000
-- 38	Fullerton	California	65974	217401.60	12788.329412
-- 39	Garden Grove	California	58449	180685.60	9509.768421
-- 40	Glendale	California	52574	187258.30	9855.700000
-- 41	Hayward	California	65096	255698.80	8523.293333
-- 42	Huntington Beach	California	83252	268402.00	10323.153846
-- 43	Inglewood	California	42044	122643.50	10220.291667
-- 44	Irvine	California	92278	208329.80	13020.612500
-- 45	Jurupa Valley	California	57749	241896.80	10517.252174
-- 46	Lancaster	California	47225	238948.80	12576.252632
-- 47	Long Beach	California	52783	212979.60	8519.184000
-- 48	Los Angeles	California	50205	315261.80	12610.472000
-- 49	Modesto	California	48577	190769.10	11221.711765
-- 50	Moreno Valley	California	54590	87126.80	6702.061538
-- 51	Murrieta	California	74610	243632.10	10592.700000
-- 52	Norwalk	California	59756	135842.50	10449.423077
-- 53	Oakland	California	54618	82148.70	6319.130769
-- 54	Oceanside	California	57703	272522.50	12387.386364
-- 55	Ontario	California	54114	226768.20	11935.168421
-- 56	Orange	California	78513	232382.80	11619.140000
-- 57	Oxnard	California	60621	178333.90	8106.086364
-- 58	Palmdale	California	52392	276649.70	11065.988000
-- 59	Pasadena	California	72402	257427.40	12871.370000
-- 60	Pomona	California	49186	262184.40	9363.728571
-- 61	Rancho Cucamonga	California	77396	195827.60	10306.715789
-- 62	Rialto	California	50971	152384.80	8963.811765
-- 63	Richmond	California	55102	263551.20	10136.584615
-- 64	Riverside	California	57196	274988.10	10576.465385
-- 65	Roseville	California	75867	197944.80	8997.490909
-- 66	Sacramento	California	50739	292582.30	12190.929167
-- 67	Salinas	California	49840	97444.80	4872.240000
-- 68	San Bernardino	California	37047	179426.00	7476.083333
-- 69	San Buenaventura (Ventura)	California	66995	233629.00	11681.450000
-- 70	San Diego	California	66116	224262.40	11213.120000
-- 71	San Francisco	California	81294	202896.10	8821.569565
-- 72	San Jose	California	84647	112493.00	7030.812500
-- 73	San Mateo	California	90208	279396.70	9978.453571
-- 74	Santa Ana	California	52253	210500.60	11078.978947
-- 75	Santa Clara	California	98914	170340.80	7742.763636
-- 76	Santa Clarita	California	83554	307724.30	11397.196296
-- 77	Santa Maria	California	50433	257032.10	10281.284000
-- 78	Santa Rosa	California	61050	202165.80	10640.305263
-- 79	Simi Valley	California	90210	267738.70	13386.935000
-- 80	Stockton	California	44797	278411.80	8981.025806
-- 81	Sunnyvale	California	105401	269688.40	9631.728571
-- 82	Temecula	California	79925	315067.50	12117.980769
-- 83	Thousand Oaks	California	100946	249380.70	8312.690000
-- 84	Torrance	California	79549	336587.90	10518.371875
-- 85	Vallejo	California	57028	351783.50	12563.696429
-- 86	Victorville	California	45894	263122.40	10963.433333
-- 87	Visalia	California	52157	219967.70	8146.951852
-- 88	Vista	California	50601	336514.20	11217.140000
-- 89	West Covina	California	69189	126308.40	7429.905882
-- 90	Arvada	Colorado	69938	244523.20	9056.414815
-- 91	Aurora	Colorado	53011	231860.20	9274.408000
-- 92	Boulder	Colorado	58484	190226.40	9058.400000
-- 93	Centennial	Colorado	91941	127688.60	7511.094118
-- 94	Colorado Springs	Colorado	54527	348527.30	13941.092000
-- 95	Denver	Colorado	53637	327750.60	11301.744828
-- 96	Fort Collins	Colorado	55647	181985.40	9099.270000
-- 97	Greeley	Colorado	48813	218453.50	12136.305556
-- 98	Highlands Ranch	Colorado	108570	274914.40	12496.109091
-- 99	Lakewood	Colorado	56954	230721.20	11536.060000
-- 100	Pueblo	Colorado	34550	380117.80	15838.241667
-- 101	Thornton	Colorado	66948	218359.70	9925.440909
-- 102	Westminster	Colorado	67081	289922.40	11596.896000
-- 103	Bridgeport	Connecticut	41801	242660.60	9706.424000
-- 104	Bridgeport (Town)	Connecticut	41801	216343.00	11386.473684
-- 105	Hartford	Connecticut	30630	153731.50	6987.795455
-- 106	Hartford (Town)	Connecticut	30630	182327.10	8682.242857
-- 107	New Haven	Connecticut	37192	221301.00	11065.050000
-- 108	New Haven (Town)	Connecticut	37192	83515.50	5567.700000
-- 109	Stamford	Connecticut	79359	75629.60	6302.466667
-- 110	Stamford (Town)	Connecticut	79359	278713.30	10322.714815
-- 111	Waterbury	Connecticut	40467	194246.40	11426.258824
-- 112	Waterbury (Town)	Connecticut	40467	152358.00	7255.142857
-- 113	Washington	District of Columbia	70848	188149.40	11759.337500
-- 114	Brandon	Florida	56464	135172.50	7951.323529
-- 115	Cape Coral	Florida	50536	198447.30	10444.594737
-- 116	Clearwater	Florida	44198	268790.60	10751.624000
-- 117	Coral Springs	Florida	66430	178508.10	11900.540000
-- 118	Davie	Florida	59680	69083.70	5314.130769
-- 119	Fort Lauderdale	Florida	50778	269145.70	11701.986957
-- 120	Gainesville	Florida	31818	324112.50	9532.720588
-- 121	Hialeah	Florida	29249	278766.90	10721.803846
-- 122	Hollywood	Florida	46791	359347.80	13821.069231
-- 123	Jacksonville	Florida	46764	138288.00	8643.000000
-- 124	Lakeland	Florida	39706	253032.20	13317.484211
-- 125	Lehigh Acres	Florida	40226	324105.80	13504.408333
-- 126	Miami	Florida	31051	264087.20	12575.580952
-- 127	Miami Gardens	Florida	38253	273018.30	11870.360870
-- 128	Miramar	Florida	65282	293473.40	8893.133333
-- 129	Orlando	Florida	42318	314993.80	11666.437037
-- 130	Palm Bay	Florida	43163	247665.50	11793.595238
-- 131	Pembroke Pines	Florida	61279	252737.40	11488.063636
-- 132	Pompano Beach	Florida	41321	268562.80	8663.316129
-- 133	Port St. Lucie	Florida	49813	191285.00	9564.250000
-- 134	Spring Hill	Florida	41308	242935.30	9343.665385
-- 135	St. Petersburg	Florida	45748	345271.10	13810.844000
-- 136	Tallahassee	Florida	39681	126569.70	7031.650000
-- 137	Tampa	Florida	44185	103260.40	7943.107692
-- 138	West Palm Beach	Florida	45800	366952.30	12653.527586
-- 139	Athens	Georgia	39464	197408.80	8225.366667
-- 140	Atlanta	Georgia	47527	166133.20	7911.104762
-- 141	Augusta	Georgia	39464	190836.10	7633.444000
-- 142	Columbus	Georgia	42306	171359.20	8567.960000
-- 143	Macon	Georgia	36568	274184.10	8568.253125
-- 144	Sandy Springs	Georgia	63917	169483.20	9969.600000
-- 145	Savannah	Georgia	36466	163727.90	7442.177273
-- 146	Honolulu	Hawaii	61442	158247.30	7535.585714
-- 147	Cedar Rapids	Iowa	53581	348768.50	14532.020833
-- 148	Davenport	Iowa	47343	217354.70	8050.174074
-- 149	Des Moines	Iowa	46290	233937.20	10633.509091
-- 150	Boise City	Idaho	50323	209629.60	9982.361905
-- 151	Aurora	Illinois	63090	222433.30	10592.061905
-- 152	Aurora (Township)	Illinois	49797	257032.10	11683.277273
-- 153	Bloomingdale (Township)	Illinois	68474	312695.70	13028.987500
-- 154	Bremen	Illinois	55902	210514.00	12383.176471
-- 155	Capital	Illinois	49925	252013.80	9000.492857
-- 156	Chicago	Illinois	48522	184799.40	9726.284211
-- 157	Downers Grove (Township)	Illinois	81535	177469.60	9859.422222
-- 158	Elgin	Illinois	60499	211746.80	16288.215385
-- 159	Elgin (Township)	Illinois	63609	216765.10	10838.255000
-- 160	Hanover	Illinois	73620	175808.00	12557.714286
-- 161	Joliet	Illinois	60976	203720.20	8148.808000
-- 162	Lisle (Township)	Illinois	86610	233280.60	8972.330769
-- 163	Lyons (Township)	Illinois	66065	200115.60	10532.400000
-- 164	Maine	Illinois	65608	168786.40	11252.426667
-- 165	Milton	Illinois	84039	238164.90	12534.994737
-- 166	Naperville	Illinois	109468	389658.60	12988.620000
-- 167	Naperville (Township)	Illinois	88282	243411.00	11064.136364
-- 168	Niles (Township)	Illinois	69857	221883.90	10565.900000
-- 169	Palatine (Township)	Illinois	77545	215927.60	8996.983333
-- 170	Peoria	Illinois	45552	267182.60	12722.980952
-- 171	Peoria City	Illinois	42041	252523.00	11478.318182
-- 172	Proviso	Illinois	53281	205321.50	9777.214286
-- 173	Rockford	Illinois	38716	183526.40	7979.408696
-- 174	Rockford (Township)	Illinois	40391	178112.80	7124.512000
-- 175	Schaumburg (Township)	Illinois	74034	221569.00	13033.470588
-- 176	Springfield	Illinois	49868	179070.90	10533.582353
-- 177	Thornton (Township)	Illinois	41024	167969.00	7634.954545
-- 178	Wheeling (Township)	Illinois	73977	211894.20	8475.768000
-- 179	Worth (Township)	Illinois	54124	114543.20	7636.213333
-- 180	York	Illinois	76285	225501.90	14093.868750
-- 181	Calumet	Indiana	31332	188377.20	8562.600000
-- 182	Center	Indiana	27572	354510.40	13635.015385
-- 183	Evansville	Indiana	35785	342175.70	12220.560714
-- 184	Fort Wayne	Indiana	43774	166327.50	12794.423077
-- 185	Indianapolis	Indiana	51682	198092.20	11652.482353
-- 186	Lawrence (Township)	Indiana	50411	266861.00	10263.884615
-- 187	North	Indiana	44334	193114.10	9195.909524
-- 188	Perry	Indiana	44302	186876.40	9835.600000
-- 189	South Bend	Indiana	34523	298344.30	11933.772000
-- 190	Warren	Indiana	41504	209723.40	9118.408696
-- 191	Washington	Indiana	50615	180410.90	8590.995238
-- 192	Wayne	Indiana	32194	265963.20	13998.063158
-- 193	Wayne	Indiana	35884	236690.90	10758.677273
-- 194	Kansas City	Kansas	38749	176457.90	11028.618750
-- 195	Olathe	Kansas	77335	273721.80	14406.410526
-- 196	Overland Park	Kansas	72463	218748.30	10416.585714
-- 197	Topeka	Kansas	42250	248998.80	10826.034783
-- 198	Wichita	Kansas	45947	145309.60	7647.873684
-- 199	Lexington-Fayette	Kentucky	49778	159051.30	6627.137500
-- 200	Louisville	Kentucky	0	223016.20	8259.859259
-- 201	Baton Rouge	Louisiana	39876	203177.50	11287.638889
-- 202	Lafayette	Louisiana	46517	301747.90	13119.473913
-- 203	Metairie	Louisiana	52421	232637.40	14539.837500
-- 204	New Orleans	Louisiana	36792	212363.20	10618.160000
-- 205	Shreveport	Louisiana	38583	134723.60	9623.114286
-- 206	Boston	Massachusetts	55777	226594.00	11926.000000
-- 207	Cambridge	Massachusetts	79416	283564.10	11342.564000
-- 208	Lowell	Massachusetts	48002	239022.50	9959.270833
-- 209	Springfield	Massachusetts	34728	256094.10	11134.526087
-- 210	Worcester	Massachusetts	45472	150187.20	8343.733333
-- 211	Baltimore	Maryland	42241	276549.20	9876.757143
-- 212	Columbia	Maryland	100849	295905.50	10568.053571
-- 213	Ann Arbor	Michigan	55990	334591.30	13941.304167
-- 214	Detroit	Michigan	25764	338035.10	12072.682143
-- 215	Grand Rapids	Michigan	40355	188430.80	8192.643478
-- 216	Lansing	Michigan	35563	125068.90	10422.408333
-- 217	Sterling Heights	Michigan	60089	232711.10	10117.873913
-- 218	Warren	Michigan	43523	318424.20	15163.057143
-- 219	Minneapolis	Minnesota	51480	239297.20	9203.738462
-- 220	Rochester	Minnesota	64554	286485.30	14324.265000
-- 221	St. Paul	Minnesota	48757	221341.20	9222.550000
-- 222	Columbia	Missouri	44907	159439.90	9378.817647
-- 223	Independence	Missouri	43472	117377.30	6520.961111
-- 224	Kansas City	Missouri	45821	181616.90	9080.845000
-- 225	Springfield	Missouri	33557	224852.00	9776.173913
-- 226	St. Louis	Missouri	35599	175660.60	9758.922222
-- 227	Jackson	Mississippi	32250	178179.80	9898.877778
-- 228	Billings	Montana	51012	190320.20	7048.896296
-- 229	Cary	North Carolina	91579	364995.90	12586.065517
-- 230	Charlotte	North Carolina	53637	322946.70	11533.810714
-- 231	Durham	North Carolina	50420	252543.10	10980.134783
-- 232	Fayetteville	North Carolina	43630	237092.90	10308.386957
-- 233	Greensboro	North Carolina	41628	229166.80	9166.672000
-- 234	High Point	North Carolina	42299	208644.70	9483.850000
-- 235	Raleigh	North Carolina	55398	96754.70	6450.313333
-- 236	Wilmington	North Carolina	42128	176511.50	9290.078947
-- 237	Winston-Salem	North Carolina	39882	338758.70	14728.639130
-- 238	Fargo	North Dakota	46175	424713.00	16988.520000
-- 239	Lincoln	Nebraska	49840	191492.70	10638.483333
-- 240	Omaha	Nebraska	49896	201958.10	10629.373684
-- 241	Manchester	New Hampshire	54282	224704.60	7748.434483
-- 242	Edison	New Jersey	90515	212825.50	10641.275000
-- 243	Elizabeth	New Jersey	43568	187995.30	11058.547059
-- 244	Jersey City	New Jersey	59537	249193.10	10383.045833
-- 245	Newark	New Jersey	33139	322028.80	9471.435294
-- 246	Paterson	New Jersey	32915	305386.00	10906.642857
-- 247	Woodbridge (Township)	New Jersey	79720	311710.80	12468.432000
-- 248	Albuquerque	New Mexico	47030	262311.70	10492.468000
-- 249	Las Cruces	New Mexico	41330	259196.20	14399.788889
-- 250	Enterprise	Nevada	68137	153041.40	8502.300000
-- 251	Henderson	Nevada	63120	275122.10	13756.105000
-- 252	Las Vegas	Nevada	50202	242372.50	11541.547619
-- 253	North Las Vegas	Nevada	52511	157791.70	9861.981250
-- 254	Paradise	Nevada	43911	91441.60	7620.133333
-- 255	Reno	Nevada	47012	239980.60	9599.224000
-- 256	Spring Valley	Nevada	50192	252094.20	13268.115789
-- 257	Sunrise Manor	Nevada	39586	284482.00	11853.416667
-- 258	Amherst	New York	68294	288173.70	13098.804545
-- 259	Babylon (Town)	New York	80327	167942.20	9878.952941
-- 260	Brookhaven	New York	87040	241863.30	9674.532000
-- 261	Brooklyn	New York	32135	186755.80	9829.252632
-- 262	Buffalo	New York	31918	272663.20	9088.773333
-- 263	Hempstead (Town)	New York	94999	161047.90	7668.947619
-- 264	Huntington	New York	105451	149121.90	9941.460000
-- 265	Islip	New York	86864	187807.70	8943.223810
-- 266	Manhattan	New York	47030	133041.90	6652.095000
-- 267	New York City	New York	53373	118087.50	9083.653846
-- 268	North Hempstead	New York	104698	138602.90	7294.889474
-- 269	Oyster Bay	New York	112162	227170.20	11358.510000
-- 270	Queens	New York	42439	322725.60	11525.914286
-- 271	Ramapo	New York	66911	277420.20	13871.010000
-- 272	Rochester	New York	30960	341545.90	14231.079167
-- 273	Smithtown	New York	112693	130509.30	8700.620000
-- 274	Staten Island	New York	55039	154910.70	10327.380000
-- 275	Syracuse	New York	31881	156431.60	7110.527273
-- 276	The Bronx	New York	34299	230975.80	10042.426087
-- 277	Yonkers	New York	59049	148190.60	9261.912500
-- 278	Akron	Ohio	34512	209053.40	6968.446667
-- 279	Cincinnati	Ohio	33604	226942.40	8728.553846
-- 280	Cleveland	Ohio	26150	254050.60	13371.084211
-- 281	Columbus	Ohio	45659	189288.40	8229.930435
-- 282	Dayton	Ohio	27683	141845.70	6754.557143
-- 283	Toledo	Ohio	33687	233454.80	8646.474074
-- 284	Broken Arrow	Oklahoma	67131	490654.40	14018.697143
-- 285	Norman	Oklahoma	51491	214621.10	9755.504545
-- 286	Oklahoma City	Oklahoma	47779	253193.00	10549.708333
-- 287	Tulsa	Oklahoma	42284	206741.90	10337.095000
-- 288	Eugene	Oregon	43101	327268.20	14229.052174
-- 289	Gresham	Oregon	46956	169690.90	11312.726667
-- 290	Hillsboro	Oregon	67757	185154.50	10286.361111
-- 291	Portland	Oregon	55003	273989.80	9447.924138
-- 292	Salem	Oregon	47191	286029.70	14301.485000
-- 293	Allentown	Pennsylvania	36930	181663.80	10092.433333
-- 294	Philadelphia	Pennsylvania	38253	266378.60	12684.695238
-- 295	Pittsburgh	Pennsylvania	40715	178025.70	8477.414286
-- 296	Providence	Rhode Island	37501	195298.30	9764.915000
-- 297	Charleston	South Carolina	55546	325599.90	12523.073077
-- 298	Columbia	South Carolina	41260	202715.20	10135.760000
-- 299	North Charleston	South Carolina	39543	196651.70	8938.713636
-- 300	Sioux Falls	South Dakota	52494	154006.20	7333.628571
-- 301	Chattanooga	Tennessee	40177	167593.80	8379.690000
-- 302	Clarksville	Tennessee	46947	308441.20	13410.486957
-- 303	Knoxville	Tennessee	34226	387735.70	11749.566667
-- 304	Memphis	Tennessee	36445	170287.20	7740.327273
-- 305	Murfreesboro	Tennessee	51094	160438.20	8913.233333
-- 306	Nashville	Tennessee	41759	224202.10	9747.917391
-- 307	Abilene	Texas	43189	164572.10	8228.605000
-- 308	Amarillo	Texas	47735	286880.60	16875.329412
-- 309	Arlington	Texas	53326	209810.50	9536.840909
-- 310	Austin	Texas	57689	146086.80	8593.341176
-- 311	Beaumont	Texas	40992	142830.60	6801.457143
-- 312	Brownsville	Texas	32894	159707.90	7985.395000
-- 313	Carrollton	Texas	69368	268924.60	11692.373913
-- 314	College Station	Texas	34186	130911.30	8727.420000
-- 315	Corpus Christi	Texas	50658	191030.40	10054.231579
-- 316	Dallas	Texas	43781	213328.00	8888.666667
-- 317	Denton	Texas	49100	202299.80	11238.877778
-- 318	El Paso	Texas	42772	281132.00	12778.727273
-- 319	Fort Worth	Texas	53214	129665.10	6483.255000
-- 320	Frisco	Texas	114098	275316.40	11471.516667
-- 321	Garland	Texas	51970	178394.20	9910.788889
-- 322	Grand Prairie	Texas	56475	232503.40	9687.641667
-- 323	Houston	Texas	46187	218212.30	8728.492000
-- 324	Irving	Texas	52154	165255.50	15023.227273
-- 325	Killeen	Texas	47763	209689.90	9985.233333
-- 326	Laredo	Texas	39711	320286.80	13345.283333
-- 327	Lewisville	Texas	57267	269139.00	12233.590909
-- 328	Lubbock	Texas	44648	393129.20	13104.306667
-- 329	McAllen	Texas	44254	151379.80	8409.988889
-- 330	McKinney	Texas	81459	119769.20	5988.460000
-- 331	Mesquite	Texas	49604	243752.70	11607.271429
-- 332	Midland	Texas	69173	348400.00	13936.000000
-- 333	Odessa	Texas	59337	291965.90	12165.245833
-- 334	Pasadena	Texas	48004	151098.40	7195.161905
-- 335	Pearland	Texas	95972	251685.50	12584.275000
-- 336	Plano	Texas	83793	194621.60	9731.080000
-- 337	Richardson	Texas	72427	181710.70	7900.465217
-- 338	Round Rock	Texas	72412	149865.60	8815.623529
-- 339	San Angelo	Texas	44802	189167.80	9458.390000
-- 340	San Antonio	Texas	46744	307074.40	13351.060870
-- 341	The Woodlands	Texas	109917	226084.80	8074.457143
-- 342	Tyler	Texas	42840	228423.10	9931.439130
-- 343	Waco	Texas	33147	224785.00	7751.206897
-- 344	Wichita Falls	Texas	44543	290150.20	12615.226087
-- 345	Provo	Utah	41291	172866.70	10168.629412
-- 346	Salt Lake City	Utah	47243	153677.90	8537.661111
-- 347	West Jordan	Utah	68442	387802.70	16158.445833
-- 348	West Valley City	Utah	52534	105163.20	5842.400000
-- 349	Alexandria	Virginia	89134	235230.30	9801.262500
-- 350	Arlington	Virginia	105763	353029.70	10383.226471
-- 351	Chesapeake	Virginia	68620	184544.80	9712.884211
-- 352	Hampton	Virginia	49190	196343.50	7551.673077
-- 353	Newport News	Virginia	50077	204926.20	7881.776923
-- 354	Norfolk	Virginia	44480	146140.40	10438.600000
-- 355	Richmond	Virginia	40758	308193.30	11006.903571
-- 356	Virginia Beach	Virginia	66634	233950.60	11140.504762
-- 357	Bellevue	Washington	94638	184873.10	10874.888235
-- 358	Everett	Washington	49578	219210.60	9530.895652
-- 359	Kent	Washington	60191	248549.90	13081.573684
-- 360	Renton	Washington	64802	240784.60	11465.933333
-- 361	Seattle	Washington	70594	175050.90	8752.545000
-- 362	Spokane	Washington	42386	326022.00	12074.888889
-- 363	Tacoma	Washington	52042	224376.30	12465.350000
-- 364	Vancouver	Washington	50626	280703.20	10025.114286
-- 365	Green Bay	Wisconsin	42826	133336.70	7843.335294
-- 366	Madison	Wisconsin	54896	254499.50	8775.844828
-- 367	Milwaukee	Wisconsin	35958	272582.80	14346.463158

-- Customers with highest orders
SELECT c.CustomerName, SUM(o.OrderQuantity) AS TotalQuantity, SUM(o.OrderQuantity * o.UnitPrice) as SaleAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalQuantity DESC
LIMIT 3;

-- Medline 	970	2248332.40
-- Elorac, Corp	880	1831947.50
-- Apotheca, Ltd	828	2112221.90

-- Avg number of orders per month over the years- 2018-2020
SELECT
    MonthlyOrders.Year,
    (AVG(MonthlyOrders.OrderCountPerMonth) *1) AS AverageOrdersPerMonth
FROM (
    SELECT
        YEAR(OrderDate) AS Year,
        MONTH(OrderDate) AS Month,
        COUNT(*) AS OrderCountPerMonth
    FROM
        Orders
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate)
) AS MonthlyOrders
GROUP BY
    Year;
    
-- 2018	229.5000
-- 2019	252.5000
-- 2020	260.4167

-- Highest and lowest income stores with region
WITH RegionalSales AS (
    SELECT st.Region, SUM(o.UnitPrice * o.OrderQuantity) AS TotalRevenue
    FROM Orders o
    JOIN SalesTeam st ON o.SalesTeamID = st.SalesTeamID
    GROUP BY st.Region
)
SELECT Region, TotalRevenue
FROM RegionalSales
WHERE TotalRevenue = (SELECT MAX(TotalRevenue) FROM RegionalSales)
   OR TotalRevenue = (SELECT MIN(TotalRevenue) FROM RegionalSales);

-- South	18380699.60
-- Midwest	24013416.40

-- Sales team with highest average order value
WITH SalesTeamAverage AS (
    SELECT st.SalesTeamID, st.SalesTeamName, AVG(o.UnitPrice * o.OrderQuantity) AS AverageOrderValue
    FROM Orders o
    JOIN SalesTeam st ON o.SalesTeamID = st.SalesTeamID
    GROUP BY st.SalesTeamID
)
SELECT SalesTeamID, SalesTeamName, AverageOrderValue
FROM SalesTeamAverage
ORDER BY AverageOrderValue DESC
LIMIT 1;

-- 2	Keith Griffin	11442.510569

-- Quantity ordered by each store-
SELECT s.StoreID, s.CityName, s.StateCode, p.ProductID, SUM(o.OrderQuantity) AS TotalQuantity
FROM Orders o
JOIN StoreLocations s ON o.StoreID = s.StoreID
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY s.StoreID, p.ProductID;

-- 1	Birmingham	AL	6	2
-- 1	Birmingham	AL	8	1
-- 1	Birmingham	AL	30	3
-- 1	Birmingham	AL	35	6
-- 1	Birmingham	AL	22	12
-- 1	Birmingham	AL	43	8
-- 1	Birmingham	AL	5	7
-- 1	Birmingham	AL	16	13
-- 1	Birmingham	AL	29	7
-- 1	Birmingham	AL	28	7
-- 1	Birmingham	AL	33	10
-- 1	Birmingham	AL	41	3
-- 1	Birmingham	AL	11	5
-- 1	Birmingham	AL	7	5
-- 1	Birmingham	AL	34	2
-- 1	Birmingham	AL	27	4
-- 1	Birmingham	AL	44	9
-- 1	Birmingham	AL	19	8
-- 1	Birmingham	AL	23	8
-- 1	Birmingham	AL	3	2
-- 2	Huntsville	AL	46	1
-- 2	Huntsville	AL	1	8
-- 2	Huntsville	AL	19	7
-- 2	Huntsville	AL	13	1
-- 2	Huntsville	AL	24	19
-- 2	Huntsville	AL	28	15
-- 2	Huntsville	AL	2	4
-- 2	Huntsville	AL	15	3
-- 2	Huntsville	AL	17	1
-- 2	Huntsville	AL	26	3
-- 2	Huntsville	AL	3	7
-- 2	Huntsville	AL	7	3
-- 2	Huntsville	AL	31	4
-- 2	Huntsville	AL	34	1
-- 2	Huntsville	AL	33	2
-- 2	Huntsville	AL	20	7
-- 2	Huntsville	AL	18	6
-- 2	Huntsville	AL	10	1
-- 3	Mobile	AL	17	2
-- 3	Mobile	AL	3	4
-- 3	Mobile	AL	31	6
-- 3	Mobile	AL	42	1
-- 3	Mobile	AL	19	5
-- 3	Mobile	AL	33	4
-- 3	Mobile	AL	40	3
-- 3	Mobile	AL	34	3
-- 3	Mobile	AL	7	8
-- 3	Mobile	AL	25	3
-- 3	Mobile	AL	13	6
-- 4	Montgomery	AL	4	6
-- 4	Montgomery	AL	33	8
-- 4	Montgomery	AL	14	6
-- 4	Montgomery	AL	13	1
-- 4	Montgomery	AL	39	3
-- 4	Montgomery	AL	47	5
-- 4	Montgomery	AL	2	1
-- 4	Montgomery	AL	16	8
-- 4	Montgomery	AL	1	1
-- 4	Montgomery	AL	12	4
-- 4	Montgomery	AL	28	7
-- 4	Montgomery	AL	42	2
-- 4	Montgomery	AL	43	5
-- 4	Montgomery	AL	38	1
-- 4	Montgomery	AL	34	4
-- 4	Montgomery	AL	11	1
-- 4	Montgomery	AL	8	5
-- 5	Little Rock	AR	1	8
-- 5	Little Rock	AR	44	8
-- 5	Little Rock	AR	41	5
-- 5	Little Rock	AR	23	5
-- 5	Little Rock	AR	20	8
-- 5	Little Rock	AR	25	1
-- 5	Little Rock	AR	30	1
-- 5	Little Rock	AR	39	7
-- 5	Little Rock	AR	47	8
-- 5	Little Rock	AR	34	7
-- 5	Little Rock	AR	43	7
-- 5	Little Rock	AR	8	2
-- 5	Little Rock	AR	19	5
-- 5	Little Rock	AR	14	2
-- 6	Chandler	AZ	5	11
-- 6	Chandler	AZ	11	7
-- 6	Chandler	AZ	32	5
-- 6	Chandler	AZ	8	7
-- 6	Chandler	AZ	30	1
-- 6	Chandler	AZ	21	9
-- 6	Chandler	AZ	33	2
-- 6	Chandler	AZ	39	7
-- 6	Chandler	AZ	31	10
-- 6	Chandler	AZ	23	4
-- 6	Chandler	AZ	12	6
-- 6	Chandler	AZ	9	8
-- 6	Chandler	AZ	46	6
-- 6	Chandler	AZ	38	5
-- 6	Chandler	AZ	19	3
-- 6	Chandler	AZ	28	1
-- 6	Chandler	AZ	6	1
-- 6	Chandler	AZ	26	8
-- 6	Chandler	AZ	3	3
-- 6	Chandler	AZ	1	1
-- 7	Gilbert	AZ	36	5
-- 7	Gilbert	AZ	8	8
-- 7	Gilbert	AZ	22	17
-- 7	Gilbert	AZ	1	1
-- 7	Gilbert	AZ	9	6
-- 7	Gilbert	AZ	39	4
-- 7	Gilbert	AZ	10	3
-- 7	Gilbert	AZ	25	6
-- 7	Gilbert	AZ	16	6
-- 7	Gilbert	AZ	45	5
-- 7	Gilbert	AZ	21	1
-- 7	Gilbert	AZ	2	5
-- 7	Gilbert	AZ	6	15
-- 7	Gilbert	AZ	20	7
-- 7	Gilbert	AZ	47	3
-- 7	Gilbert	AZ	4	2
-- 7	Gilbert	AZ	17	4
-- 8	Glendale	AZ	46	4
-- 8	Glendale	AZ	25	5
-- 8	Glendale	AZ	30	4
-- 8	Glendale	AZ	27	8
-- 8	Glendale	AZ	44	8
-- 8	Glendale	AZ	40	6
-- 8	Glendale	AZ	35	3
-- 8	Glendale	AZ	7	2
-- 8	Glendale	AZ	38	5
-- 8	Glendale	AZ	2	6
-- 8	Glendale	AZ	5	7
-- 8	Glendale	AZ	33	3
-- 8	Glendale	AZ	4	4
-- 8	Glendale	AZ	41	3
-- 8	Glendale	AZ	42	6
-- 8	Glendale	AZ	37	4
-- 8	Glendale	AZ	3	6
-- 9	Mesa	AZ	28	4
-- 9	Mesa	AZ	25	8
-- 9	Mesa	AZ	36	11
-- 9	Mesa	AZ	38	4
-- 9	Mesa	AZ	10	7
-- 9	Mesa	AZ	31	4
-- 9	Mesa	AZ	3	4
-- 9	Mesa	AZ	46	6
-- 9	Mesa	AZ	9	11
-- 9	Mesa	AZ	13	2
-- 9	Mesa	AZ	5	5
-- 9	Mesa	AZ	39	8
-- 9	Mesa	AZ	17	8
-- 10	Peoria	AZ	12	6
-- 10	Peoria	AZ	7	6
-- 10	Peoria	AZ	1	6
-- 10	Peoria	AZ	33	1
-- 10	Peoria	AZ	31	2
-- 10	Peoria	AZ	39	4
-- 10	Peoria	AZ	41	2
-- 10	Peoria	AZ	11	1
-- 10	Peoria	AZ	21	8
-- 11	Phoenix	AZ	21	2
-- 11	Phoenix	AZ	17	5
-- 11	Phoenix	AZ	2	7
-- 11	Phoenix	AZ	35	6
-- 11	Phoenix	AZ	3	3
-- 11	Phoenix	AZ	42	7
-- 11	Phoenix	AZ	43	5
-- 11	Phoenix	AZ	26	2
-- 11	Phoenix	AZ	4	11
-- 11	Phoenix	AZ	25	1
-- 11	Phoenix	AZ	40	10
-- 11	Phoenix	AZ	28	1
-- 11	Phoenix	AZ	12	5
-- 11	Phoenix	AZ	41	1
-- 11	Phoenix	AZ	14	8
-- 11	Phoenix	AZ	6	3
-- 11	Phoenix	AZ	23	7
-- 11	Phoenix	AZ	37	1
-- 11	Phoenix	AZ	11	6
-- 11	Phoenix	AZ	36	1
-- 11	Phoenix	AZ	44	2
-- 11	Phoenix	AZ	33	8
-- 11	Phoenix	AZ	10	3
-- 11	Phoenix	AZ	20	7
-- 11	Phoenix	AZ	22	4
-- 12	Scottsdale	AZ	23	15
-- 12	Scottsdale	AZ	20	3
-- 12	Scottsdale	AZ	29	9
-- 12	Scottsdale	AZ	44	4
-- 12	Scottsdale	AZ	21	1
-- 12	Scottsdale	AZ	11	8
-- 12	Scottsdale	AZ	46	7
-- 12	Scottsdale	AZ	14	3
-- 12	Scottsdale	AZ	19	8
-- 12	Scottsdale	AZ	3	5
-- 12	Scottsdale	AZ	41	13
-- 12	Scottsdale	AZ	47	15
-- 12	Scottsdale	AZ	24	2
-- 12	Scottsdale	AZ	5	5
-- 12	Scottsdale	AZ	31	8
-- 12	Scottsdale	AZ	26	15
-- 12	Scottsdale	AZ	39	6
-- 13	Surprise	AZ	34	5
-- 13	Surprise	AZ	13	3
-- 13	Surprise	AZ	35	1
-- 13	Surprise	AZ	26	5
-- 13	Surprise	AZ	39	6
-- 13	Surprise	AZ	21	4
-- 13	Surprise	AZ	30	1
-- 13	Surprise	AZ	24	6
-- 13	Surprise	AZ	16	4
-- 13	Surprise	AZ	11	3
-- 13	Surprise	AZ	4	6
-- 14	Tempe	AZ	44	6
-- 14	Tempe	AZ	4	5
-- 14	Tempe	AZ	19	11
-- 14	Tempe	AZ	31	10
-- 14	Tempe	AZ	1	9
-- 14	Tempe	AZ	28	12
-- 14	Tempe	AZ	46	7
-- 14	Tempe	AZ	34	2
-- 14	Tempe	AZ	41	7
-- 14	Tempe	AZ	45	8
-- 14	Tempe	AZ	43	6
-- 14	Tempe	AZ	27	1
-- 14	Tempe	AZ	3	8
-- 14	Tempe	AZ	7	1
-- 14	Tempe	AZ	11	1
-- 15	Tucson	AZ	32	7
-- 15	Tucson	AZ	8	6
-- 15	Tucson	AZ	6	5
-- 15	Tucson	AZ	31	1
-- 15	Tucson	AZ	25	11
-- 15	Tucson	AZ	44	5
-- 15	Tucson	AZ	16	5
-- 15	Tucson	AZ	28	7
-- 15	Tucson	AZ	43	2
-- 15	Tucson	AZ	17	15
-- 15	Tucson	AZ	1	2
-- 15	Tucson	AZ	40	2
-- 15	Tucson	AZ	20	2
-- 15	Tucson	AZ	9	8
-- 15	Tucson	AZ	42	1
-- 16	Anaheim	CA	30	5
-- 16	Anaheim	CA	13	4
-- 16	Anaheim	CA	19	8
-- 16	Anaheim	CA	17	7
-- 16	Anaheim	CA	34	12
-- 16	Anaheim	CA	5	3
-- 16	Anaheim	CA	24	3
-- 16	Anaheim	CA	42	6
-- 16	Anaheim	CA	14	1
-- 16	Anaheim	CA	10	8
-- 16	Anaheim	CA	37	16
-- 16	Anaheim	CA	27	8
-- 16	Anaheim	CA	36	2
-- 16	Anaheim	CA	8	8
-- 16	Anaheim	CA	45	5
-- 16	Anaheim	CA	7	5
-- 17	Antioch	CA	1	2
-- 17	Antioch	CA	38	6
-- 17	Antioch	CA	40	11
-- 17	Antioch	CA	47	13
-- 17	Antioch	CA	8	12
-- 17	Antioch	CA	3	6
-- 17	Antioch	CA	42	4
-- 17	Antioch	CA	9	7
-- 17	Antioch	CA	31	9
-- 17	Antioch	CA	29	16
-- 17	Antioch	CA	32	1
-- 17	Antioch	CA	21	6
-- 17	Antioch	CA	39	1
-- 17	Antioch	CA	44	7
-- 17	Antioch	CA	34	7
-- 17	Antioch	CA	12	13
-- 17	Antioch	CA	43	6
-- 17	Antioch	CA	37	5
-- 17	Antioch	CA	5	5
-- 17	Antioch	CA	15	8
-- 17	Antioch	CA	36	1
-- 17	Antioch	CA	26	1
-- 17	Antioch	CA	22	2
-- 17	Antioch	CA	33	7
-- 17	Antioch	CA	30	4
-- 18	Bakersfield	CA	29	7
-- 18	Bakersfield	CA	18	7
-- 18	Bakersfield	CA	13	6
-- 18	Bakersfield	CA	25	4
-- 18	Bakersfield	CA	1	4
-- 18	Bakersfield	CA	10	4
-- 18	Bakersfield	CA	16	3
-- 18	Bakersfield	CA	38	8
-- 18	Bakersfield	CA	22	5
-- 18	Bakersfield	CA	39	6
-- 18	Bakersfield	CA	23	7
-- 18	Bakersfield	CA	7	5
-- 18	Bakersfield	CA	2	8
-- 18	Bakersfield	CA	36	3
-- 18	Bakersfield	CA	45	4
-- 18	Bakersfield	CA	11	7
-- 19	Berkeley	CA	20	8
-- 19	Berkeley	CA	21	19
-- 19	Berkeley	CA	1	3
-- 19	Berkeley	CA	15	1
-- 19	Berkeley	CA	10	7
-- 19	Berkeley	CA	28	4
-- 19	Berkeley	CA	30	1
-- 19	Berkeley	CA	35	5
-- 19	Berkeley	CA	46	2
-- 19	Berkeley	CA	24	6
-- 19	Berkeley	CA	23	10
-- 19	Berkeley	CA	2	5
-- 19	Berkeley	CA	38	7
-- 19	Berkeley	CA	41	3
-- 19	Berkeley	CA	3	7
-- 19	Berkeley	CA	31	8
-- 19	Berkeley	CA	39	8
-- 19	Berkeley	CA	42	4
-- 20	Burbank	CA	45	6
-- 20	Burbank	CA	9	11
-- 20	Burbank	CA	35	8
-- 20	Burbank	CA	25	2
-- 20	Burbank	CA	15	5
-- 20	Burbank	CA	38	7
-- 20	Burbank	CA	40	1
-- 20	Burbank	CA	8	7
-- 20	Burbank	CA	31	1
-- 20	Burbank	CA	5	1
-- 20	Burbank	CA	46	8
-- 20	Burbank	CA	41	8
-- 20	Burbank	CA	37	10
-- 20	Burbank	CA	4	8
-- 20	Burbank	CA	7	2
-- 20	Burbank	CA	17	5
-- 21	Carlsbad	CA	20	2
-- 21	Carlsbad	CA	42	2
-- 21	Carlsbad	CA	3	4
-- 21	Carlsbad	CA	9	7
-- 21	Carlsbad	CA	11	16
-- 21	Carlsbad	CA	14	6
-- 21	Carlsbad	CA	17	7
-- 21	Carlsbad	CA	16	13
-- 21	Carlsbad	CA	31	14
-- 21	Carlsbad	CA	12	8
-- 21	Carlsbad	CA	26	10
-- 21	Carlsbad	CA	4	2
-- 21	Carlsbad	CA	21	4
-- 21	Carlsbad	CA	1	7
-- 21	Carlsbad	CA	15	2
-- 21	Carlsbad	CA	24	3
-- 21	Carlsbad	CA	41	1
-- 21	Carlsbad	CA	32	7
-- 21	Carlsbad	CA	37	5
-- 21	Carlsbad	CA	43	4
-- 21	Carlsbad	CA	18	2
-- 21	Carlsbad	CA	29	5
-- 21	Carlsbad	CA	36	6
-- 21	Carlsbad	CA	5	2
-- 21	Carlsbad	CA	28	3
-- 21	Carlsbad	CA	47	5
-- 21	Carlsbad	CA	27	8
-- 22	Chula Vista	CA	44	2
-- 22	Chula Vista	CA	41	14
-- 22	Chula Vista	CA	1	4
-- 22	Chula Vista	CA	30	3
-- 22	Chula Vista	CA	22	3
-- 22	Chula Vista	CA	39	14
-- 22	Chula Vista	CA	6	8
-- 22	Chula Vista	CA	24	7
-- 22	Chula Vista	CA	42	2
-- 22	Chula Vista	CA	23	4
-- 22	Chula Vista	CA	29	5
-- 22	Chula Vista	CA	15	6
-- 22	Chula Vista	CA	31	11
-- 22	Chula Vista	CA	8	5
-- 22	Chula Vista	CA	4	5
-- 22	Chula Vista	CA	14	4
-- 22	Chula Vista	CA	33	1
-- 22	Chula Vista	CA	7	1
-- 22	Chula Vista	CA	16	5
-- 22	Chula Vista	CA	34	5
-- 22	Chula Vista	CA	27	4
-- 22	Chula Vista	CA	2	8
-- 22	Chula Vista	CA	38	5
-- 22	Chula Vista	CA	37	8
-- 23	Clovis	CA	47	11
-- 23	Clovis	CA	14	1
-- 23	Clovis	CA	6	8
-- 23	Clovis	CA	36	14
-- 23	Clovis	CA	32	1
-- 23	Clovis	CA	4	8
-- 23	Clovis	CA	40	2
-- 23	Clovis	CA	42	2
-- 23	Clovis	CA	19	3
-- 23	Clovis	CA	44	3
-- 23	Clovis	CA	22	7
-- 24	Concord	CA	34	12
-- 24	Concord	CA	30	1
-- 24	Concord	CA	12	6
-- 24	Concord	CA	40	3
-- 24	Concord	CA	41	11
-- 24	Concord	CA	20	8
-- 24	Concord	CA	36	4
-- 24	Concord	CA	33	7
-- 24	Concord	CA	18	8
-- 24	Concord	CA	32	7
-- 24	Concord	CA	2	5
-- 24	Concord	CA	13	1
-- 24	Concord	CA	37	3
-- 24	Concord	CA	23	5
-- 24	Concord	CA	47	3
-- 24	Concord	CA	22	5
-- 24	Concord	CA	16	8
-- 24	Concord	CA	46	7
-- 25	Corona	CA	40	6
-- 25	Corona	CA	37	13
-- 25	Corona	CA	38	8
-- 25	Corona	CA	4	6
-- 25	Corona	CA	13	2
-- 25	Corona	CA	30	4
-- 25	Corona	CA	23	6
-- 25	Corona	CA	41	4
-- 25	Corona	CA	39	2
-- 25	Corona	CA	29	5
-- 25	Corona	CA	28	3
-- 25	Corona	CA	10	3
-- 25	Corona	CA	33	7
-- 25	Corona	CA	11	7
-- 26	Costa Mesa	CA	26	13
-- 26	Costa Mesa	CA	39	13
-- 26	Costa Mesa	CA	4	12
-- 26	Costa Mesa	CA	17	8
-- 26	Costa Mesa	CA	25	14
-- 26	Costa Mesa	CA	23	7
-- 26	Costa Mesa	CA	7	7
-- 26	Costa Mesa	CA	40	7
-- 26	Costa Mesa	CA	32	6
-- 26	Costa Mesa	CA	6	17
-- 26	Costa Mesa	CA	44	1
-- 26	Costa Mesa	CA	8	5
-- 26	Costa Mesa	CA	22	8
-- 26	Costa Mesa	CA	3	5
-- 26	Costa Mesa	CA	24	2
-- 26	Costa Mesa	CA	47	7
-- 26	Costa Mesa	CA	16	2
-- 26	Costa Mesa	CA	21	5
-- 26	Costa Mesa	CA	20	5
-- 26	Costa Mesa	CA	38	2
-- 26	Costa Mesa	CA	1	8
-- 26	Costa Mesa	CA	33	5
-- 26	Costa Mesa	CA	9	2
-- 26	Costa Mesa	CA	31	6
-- 26	Costa Mesa	CA	42	3
-- 26	Costa Mesa	CA	45	3
-- 26	Costa Mesa	CA	28	5
-- 27	Daly City	CA	35	16
-- 27	Daly City	CA	2	7
-- 27	Daly City	CA	16	22
-- 27	Daly City	CA	33	4
-- 27	Daly City	CA	19	4
-- 27	Daly City	CA	31	3
-- 27	Daly City	CA	20	5
-- 27	Daly City	CA	15	5
-- 27	Daly City	CA	36	5
-- 27	Daly City	CA	45	1
-- 27	Daly City	CA	8	1
-- 27	Daly City	CA	10	3
-- 28	Downey	CA	43	11
-- 28	Downey	CA	31	5
-- 28	Downey	CA	35	8
-- 28	Downey	CA	9	5
-- 28	Downey	CA	41	6
-- 28	Downey	CA	22	8
-- 28	Downey	CA	47	8
-- 28	Downey	CA	29	4
-- 28	Downey	CA	2	14
-- 28	Downey	CA	18	5
-- 28	Downey	CA	45	8
-- 28	Downey	CA	12	8
-- 28	Downey	CA	21	2
-- 28	Downey	CA	23	4
-- 28	Downey	CA	20	8
-- 28	Downey	CA	42	5
-- 28	Downey	CA	11	2
-- 29	East Los Angeles	CA	2	8
-- 29	East Los Angeles	CA	28	5
-- 29	East Los Angeles	CA	12	4
-- 29	East Los Angeles	CA	5	5
-- 29	East Los Angeles	CA	45	10
-- 29	East Los Angeles	CA	25	9
-- 29	East Los Angeles	CA	41	8
-- 29	East Los Angeles	CA	4	1
-- 29	East Los Angeles	CA	29	4
-- 29	East Los Angeles	CA	35	9
-- 29	East Los Angeles	CA	34	5
-- 29	East Los Angeles	CA	6	4
-- 29	East Los Angeles	CA	16	5
-- 29	East Los Angeles	CA	22	8
-- 29	East Los Angeles	CA	33	4
-- 29	East Los Angeles	CA	20	7
-- 29	East Los Angeles	CA	24	2
-- 29	East Los Angeles	CA	19	2
-- 29	East Los Angeles	CA	36	7
-- 29	East Los Angeles	CA	10	5
-- 30	El Cajon	CA	8	2
-- 30	El Cajon	CA	16	5
-- 30	El Cajon	CA	35	2
-- 30	El Cajon	CA	30	7
-- 30	El Cajon	CA	43	10
-- 30	El Cajon	CA	24	17
-- 30	El Cajon	CA	25	7
-- 30	El Cajon	CA	7	3
-- 30	El Cajon	CA	22	2
-- 30	El Cajon	CA	19	3
-- 30	El Cajon	CA	37	2
-- 30	El Cajon	CA	21	2
-- 30	El Cajon	CA	26	5
-- 30	El Cajon	CA	44	3
-- 30	El Cajon	CA	31	7
-- 30	El Cajon	CA	17	7
-- 30	El Cajon	CA	36	6
-- 30	El Cajon	CA	12	3
-- 30	El Cajon	CA	41	8
-- 30	El Cajon	CA	27	7
-- 30	El Cajon	CA	46	2
-- 30	El Cajon	CA	13	7
-- 31	Elk Grove	CA	16	2
-- 31	Elk Grove	CA	19	4
-- 31	Elk Grove	CA	9	3
-- 31	Elk Grove	CA	27	7
-- 31	Elk Grove	CA	2	2
-- 31	Elk Grove	CA	5	2
-- 31	Elk Grove	CA	32	7
-- 31	Elk Grove	CA	4	11
-- 31	Elk Grove	CA	13	4
-- 31	Elk Grove	CA	23	7
-- 31	Elk Grove	CA	47	7
-- 31	Elk Grove	CA	28	9
-- 31	Elk Grove	CA	18	5
-- 31	Elk Grove	CA	1	4
-- 31	Elk Grove	CA	35	4
-- 31	Elk Grove	CA	46	8
-- 31	Elk Grove	CA	43	7
-- 31	Elk Grove	CA	34	6
-- 32	El Monte	CA	16	3
-- 32	El Monte	CA	46	8
-- 32	El Monte	CA	32	7
-- 32	El Monte	CA	10	7
-- 32	El Monte	CA	20	8
-- 32	El Monte	CA	29	5
-- 32	El Monte	CA	27	6
-- 32	El Monte	CA	43	12
-- 32	El Monte	CA	8	6
-- 32	El Monte	CA	38	1
-- 32	El Monte	CA	2	5
-- 32	El Monte	CA	37	7
-- 32	El Monte	CA	23	8
-- 32	El Monte	CA	11	2
-- 32	El Monte	CA	28	1
-- 33	Escondido	CA	46	11
-- 33	Escondido	CA	11	4
-- 33	Escondido	CA	43	6
-- 33	Escondido	CA	5	11
-- 33	Escondido	CA	40	3
-- 33	Escondido	CA	9	8
-- 33	Escondido	CA	17	5
-- 33	Escondido	CA	42	12
-- 33	Escondido	CA	8	1
-- 33	Escondido	CA	37	6
-- 33	Escondido	CA	16	8
-- 33	Escondido	CA	31	1
-- 33	Escondido	CA	26	7
-- 33	Escondido	CA	29	13
-- 33	Escondido	CA	47	5
-- 33	Escondido	CA	4	16
-- 33	Escondido	CA	10	8
-- 33	Escondido	CA	18	6
-- 33	Escondido	CA	14	8
-- 33	Escondido	CA	2	7
-- 33	Escondido	CA	35	6
-- 33	Escondido	CA	33	1
-- 34	Fairfield	CA	42	5
-- 34	Fairfield	CA	47	4
-- 34	Fairfield	CA	33	2
-- 34	Fairfield	CA	18	12
-- 34	Fairfield	CA	14	2
-- 34	Fairfield	CA	37	8
-- 34	Fairfield	CA	38	2
-- 34	Fairfield	CA	10	7
-- 34	Fairfield	CA	35	2
-- 34	Fairfield	CA	45	6
-- 34	Fairfield	CA	17	8
-- 34	Fairfield	CA	21	3
-- 34	Fairfield	CA	8	8
-- 35	Fontana	CA	36	3
-- 35	Fontana	CA	23	4
-- 35	Fontana	CA	18	2
-- 35	Fontana	CA	16	6
-- 35	Fontana	CA	28	2
-- 35	Fontana	CA	46	5
-- 35	Fontana	CA	2	4
-- 35	Fontana	CA	31	12
-- 35	Fontana	CA	4	4
-- 35	Fontana	CA	7	16
-- 35	Fontana	CA	42	5
-- 35	Fontana	CA	26	10
-- 35	Fontana	CA	6	3
-- 35	Fontana	CA	47	2
-- 35	Fontana	CA	13	1
-- 36	Fremont	CA	46	9
-- 36	Fremont	CA	29	7
-- 36	Fremont	CA	6	8
-- 36	Fremont	CA	9	7
-- 36	Fremont	CA	14	7
-- 36	Fremont	CA	18	14
-- 36	Fremont	CA	12	2
-- 36	Fremont	CA	35	3
-- 36	Fremont	CA	23	8
-- 36	Fremont	CA	8	1
-- 36	Fremont	CA	17	5
-- 36	Fremont	CA	26	4
-- 36	Fremont	CA	11	1
-- 36	Fremont	CA	10	5
-- 36	Fremont	CA	42	8
-- 36	Fremont	CA	27	4
-- 36	Fremont	CA	40	2
-- 36	Fremont	CA	4	2
-- 36	Fremont	CA	2	2
-- 37	Fresno	CA	18	2
-- 37	Fresno	CA	42	12
-- 37	Fresno	CA	11	8
-- 37	Fresno	CA	37	7
-- 37	Fresno	CA	17	10
-- 37	Fresno	CA	5	2
-- 37	Fresno	CA	13	4
-- 37	Fresno	CA	19	4
-- 37	Fresno	CA	40	8
-- 37	Fresno	CA	29	2
-- 37	Fresno	CA	4	9
-- 37	Fresno	CA	34	1
-- 37	Fresno	CA	7	3
-- 37	Fresno	CA	16	1
-- 37	Fresno	CA	21	7
-- 37	Fresno	CA	10	5
-- 37	Fresno	CA	23	4
-- 38	Fullerton	CA	35	3
-- 38	Fullerton	CA	29	7
-- 38	Fullerton	CA	18	3
-- 38	Fullerton	CA	17	12
-- 38	Fullerton	CA	2	9
-- 38	Fullerton	CA	8	5
-- 38	Fullerton	CA	47	5
-- 38	Fullerton	CA	5	7
-- 38	Fullerton	CA	41	3
-- 38	Fullerton	CA	37	7
-- 38	Fullerton	CA	45	7
-- 38	Fullerton	CA	20	2
-- 38	Fullerton	CA	27	5
-- 38	Fullerton	CA	46	6
-- 38	Fullerton	CA	43	5
-- 39	Garden Grove	CA	22	7
-- 39	Garden Grove	CA	41	6
-- 39	Garden Grove	CA	6	7
-- 39	Garden Grove	CA	21	13
-- 39	Garden Grove	CA	25	7
-- 39	Garden Grove	CA	15	12
-- 39	Garden Grove	CA	47	3
-- 39	Garden Grove	CA	46	7
-- 39	Garden Grove	CA	5	7
-- 39	Garden Grove	CA	24	1
-- 39	Garden Grove	CA	36	3
-- 39	Garden Grove	CA	32	4
-- 39	Garden Grove	CA	27	4
-- 39	Garden Grove	CA	30	1
-- 39	Garden Grove	CA	26	3
-- 40	Glendale	CA	2	10
-- 40	Glendale	CA	38	5
-- 40	Glendale	CA	11	1
-- 40	Glendale	CA	41	11
-- 40	Glendale	CA	36	7
-- 40	Glendale	CA	34	13
-- 40	Glendale	CA	35	3
-- 40	Glendale	CA	21	6
-- 40	Glendale	CA	39	8
-- 40	Glendale	CA	42	1
-- 40	Glendale	CA	37	2
-- 40	Glendale	CA	4	1
-- 40	Glendale	CA	47	6
-- 40	Glendale	CA	31	5
-- 41	Hayward	CA	36	5
-- 41	Hayward	CA	39	10
-- 41	Hayward	CA	15	1
-- 41	Hayward	CA	28	15
-- 41	Hayward	CA	12	5
-- 41	Hayward	CA	2	10
-- 41	Hayward	CA	30	8
-- 41	Hayward	CA	46	7
-- 41	Hayward	CA	16	7
-- 41	Hayward	CA	6	5
-- 41	Hayward	CA	32	11
-- 41	Hayward	CA	9	8
-- 41	Hayward	CA	44	8
-- 41	Hayward	CA	23	1
-- 41	Hayward	CA	22	8
-- 41	Hayward	CA	3	4
-- 41	Hayward	CA	27	11
-- 41	Hayward	CA	26	1
-- 41	Hayward	CA	4	3
-- 41	Hayward	CA	18	8
-- 41	Hayward	CA	35	7
-- 41	Hayward	CA	5	8
-- 41	Hayward	CA	31	4
-- 42	Huntington Beach	CA	46	7
-- 42	Huntington Beach	CA	45	9
-- 42	Huntington Beach	CA	20	5
-- 42	Huntington Beach	CA	4	12
-- 42	Huntington Beach	CA	42	2
-- 42	Huntington Beach	CA	11	3
-- 42	Huntington Beach	CA	21	2
-- 42	Huntington Beach	CA	43	7
-- 42	Huntington Beach	CA	9	6
-- 42	Huntington Beach	CA	14	4
-- 42	Huntington Beach	CA	12	7
-- 42	Huntington Beach	CA	26	8
-- 42	Huntington Beach	CA	22	7
-- 42	Huntington Beach	CA	16	11
-- 42	Huntington Beach	CA	38	18
-- 42	Huntington Beach	CA	34	5
-- 42	Huntington Beach	CA	8	3
-- 42	Huntington Beach	CA	47	5
-- 42	Huntington Beach	CA	35	6
-- 43	Inglewood	CA	28	5
-- 43	Inglewood	CA	18	7
-- 43	Inglewood	CA	27	11
-- 43	Inglewood	CA	7	5
-- 43	Inglewood	CA	40	7
-- 43	Inglewood	CA	14	6
-- 43	Inglewood	CA	10	6
-- 43	Inglewood	CA	16	6
-- 43	Inglewood	CA	30	1
-- 43	Inglewood	CA	8	1
-- 43	Inglewood	CA	34	4
-- 44	Irvine	CA	26	2
-- 44	Irvine	CA	31	13
-- 44	Irvine	CA	36	1
-- 44	Irvine	CA	19	7
-- 44	Irvine	CA	43	5
-- 44	Irvine	CA	12	3
-- 44	Irvine	CA	30	4
-- 44	Irvine	CA	38	5
-- 44	Irvine	CA	35	7
-- 44	Irvine	CA	7	6
-- 44	Irvine	CA	33	4
-- 44	Irvine	CA	15	1
-- 44	Irvine	CA	27	8
-- 44	Irvine	CA	32	7
-- 45	Jurupa Valley	CA	18	11
-- 45	Jurupa Valley	CA	44	2
-- 45	Jurupa Valley	CA	17	6
-- 45	Jurupa Valley	CA	33	13
-- 45	Jurupa Valley	CA	23	7
-- 45	Jurupa Valley	CA	16	12
-- 45	Jurupa Valley	CA	20	5
-- 45	Jurupa Valley	CA	1	5
-- 45	Jurupa Valley	CA	19	3
-- 45	Jurupa Valley	CA	25	6
-- 45	Jurupa Valley	CA	10	3
-- 45	Jurupa Valley	CA	45	2
-- 45	Jurupa Valley	CA	30	2
-- 45	Jurupa Valley	CA	2	14
-- 45	Jurupa Valley	CA	8	8
-- 45	Jurupa Valley	CA	38	6
-- 45	Jurupa Valley	CA	32	8
-- 46	Lancaster	CA	27	5
-- 46	Lancaster	CA	3	5
-- 46	Lancaster	CA	37	3
-- 46	Lancaster	CA	28	4
-- 46	Lancaster	CA	9	3
-- 46	Lancaster	CA	8	7
-- 46	Lancaster	CA	4	10
-- 46	Lancaster	CA	32	13
-- 46	Lancaster	CA	1	4
-- 46	Lancaster	CA	33	6
-- 46	Lancaster	CA	14	9
-- 46	Lancaster	CA	22	5
-- 46	Lancaster	CA	40	8
-- 46	Lancaster	CA	13	2
-- 47	Long Beach	CA	7	5
-- 47	Long Beach	CA	47	5
-- 47	Long Beach	CA	17	2
-- 47	Long Beach	CA	11	4
-- 47	Long Beach	CA	5	3
-- 47	Long Beach	CA	37	1
-- 47	Long Beach	CA	23	6
-- 47	Long Beach	CA	18	2
-- 47	Long Beach	CA	3	8
-- 47	Long Beach	CA	40	17
-- 47	Long Beach	CA	19	8
-- 47	Long Beach	CA	42	8
-- 47	Long Beach	CA	20	9
-- 47	Long Beach	CA	45	7
-- 47	Long Beach	CA	25	7
-- 47	Long Beach	CA	26	8
-- 47	Long Beach	CA	8	1
-- 47	Long Beach	CA	43	5
-- 47	Long Beach	CA	31	4
-- 47	Long Beach	CA	44	2
-- 47	Long Beach	CA	1	8
-- 48	Los Angeles	CA	17	8
-- 48	Los Angeles	CA	5	1
-- 48	Los Angeles	CA	39	8
-- 48	Los Angeles	CA	32	4
-- 48	Los Angeles	CA	7	4
-- 48	Los Angeles	CA	14	3
-- 48	Los Angeles	CA	31	8
-- 48	Los Angeles	CA	27	3
-- 48	Los Angeles	CA	28	5
-- 48	Los Angeles	CA	24	5
-- 48	Los Angeles	CA	16	9
-- 48	Los Angeles	CA	34	8
-- 48	Los Angeles	CA	1	3
-- 48	Los Angeles	CA	38	5
-- 48	Los Angeles	CA	41	1
-- 48	Los Angeles	CA	4	4
-- 48	Los Angeles	CA	19	6
-- 48	Los Angeles	CA	8	4
-- 48	Los Angeles	CA	21	6
-- 48	Los Angeles	CA	42	5
-- 48	Los Angeles	CA	37	4
-- 49	Modesto	CA	16	8
-- 49	Modesto	CA	20	2
-- 49	Modesto	CA	27	18
-- 49	Modesto	CA	11	4
-- 49	Modesto	CA	33	5
-- 49	Modesto	CA	41	1
-- 49	Modesto	CA	42	1
-- 49	Modesto	CA	30	3
-- 49	Modesto	CA	5	15
-- 49	Modesto	CA	9	3
-- 49	Modesto	CA	10	4
-- 49	Modesto	CA	14	5
-- 49	Modesto	CA	23	5
-- 49	Modesto	CA	28	3
-- 50	Moreno Valley	CA	1	5
-- 50	Moreno Valley	CA	19	8
-- 50	Moreno Valley	CA	27	2
-- 50	Moreno Valley	CA	25	2
-- 50	Moreno Valley	CA	18	5
-- 50	Moreno Valley	CA	32	4
-- 50	Moreno Valley	CA	45	6
-- 50	Moreno Valley	CA	23	1
-- 50	Moreno Valley	CA	2	2
-- 50	Moreno Valley	CA	17	6
-- 50	Moreno Valley	CA	14	3
-- 50	Moreno Valley	CA	21	1
-- 51	Murrieta	CA	44	6
-- 51	Murrieta	CA	23	5
-- 51	Murrieta	CA	19	6
-- 51	Murrieta	CA	34	7
-- 51	Murrieta	CA	43	8
-- 51	Murrieta	CA	38	13
-- 51	Murrieta	CA	37	3
-- 51	Murrieta	CA	6	1
-- 51	Murrieta	CA	36	6
-- 51	Murrieta	CA	20	7
-- 51	Murrieta	CA	25	8
-- 51	Murrieta	CA	26	5
-- 51	Murrieta	CA	46	13
-- 51	Murrieta	CA	16	4
-- 51	Murrieta	CA	4	2
-- 51	Murrieta	CA	18	5
-- 51	Murrieta	CA	31	2
-- 51	Murrieta	CA	32	2
-- 51	Murrieta	CA	40	5
-- 52	Norwalk	CA	8	8
-- 52	Norwalk	CA	41	5
-- 52	Norwalk	CA	21	5
-- 52	Norwalk	CA	45	8
-- 52	Norwalk	CA	10	4
-- 52	Norwalk	CA	1	4
-- 52	Norwalk	CA	9	4
-- 52	Norwalk	CA	11	6
-- 52	Norwalk	CA	47	4
-- 52	Norwalk	CA	4	6
-- 52	Norwalk	CA	30	1
-- 52	Norwalk	CA	19	4
-- 53	Oakland	CA	8	8
-- 53	Oakland	CA	17	3
-- 53	Oakland	CA	33	3
-- 53	Oakland	CA	32	3
-- 53	Oakland	CA	10	1
-- 53	Oakland	CA	15	4
-- 53	Oakland	CA	14	3
-- 53	Oakland	CA	43	5
-- 53	Oakland	CA	19	2
-- 53	Oakland	CA	36	2
-- 53	Oakland	CA	40	4
-- 54	Oceanside	CA	20	8
-- 54	Oceanside	CA	4	15
-- 54	Oceanside	CA	14	7
-- 54	Oceanside	CA	42	2
-- 54	Oceanside	CA	24	8
-- 54	Oceanside	CA	28	8
-- 54	Oceanside	CA	35	8
-- 54	Oceanside	CA	17	6
-- 54	Oceanside	CA	12	4
-- 54	Oceanside	CA	6	5
-- 54	Oceanside	CA	45	7
-- 54	Oceanside	CA	13	9
-- 54	Oceanside	CA	29	4
-- 54	Oceanside	CA	46	2
-- 54	Oceanside	CA	39	8
-- 54	Oceanside	CA	3	8
-- 54	Oceanside	CA	11	3
-- 55	Ontario	CA	43	3
-- 55	Ontario	CA	8	4
-- 55	Ontario	CA	11	1
-- 55	Ontario	CA	35	5
-- 55	Ontario	CA	33	4
-- 55	Ontario	CA	27	3
-- 55	Ontario	CA	2	8
-- 55	Ontario	CA	37	14
-- 55	Ontario	CA	13	7
-- 55	Ontario	CA	38	6
-- 55	Ontario	CA	45	5
-- 55	Ontario	CA	6	1
-- 55	Ontario	CA	9	3
-- 55	Ontario	CA	7	7
-- 55	Ontario	CA	46	8
-- 55	Ontario	CA	26	6
-- 56	Orange	CA	10	12
-- 56	Orange	CA	9	6
-- 56	Orange	CA	47	2
-- 56	Orange	CA	18	8
-- 56	Orange	CA	25	16
-- 56	Orange	CA	24	8
-- 56	Orange	CA	36	1
-- 56	Orange	CA	21	4
-- 56	Orange	CA	42	10
-- 56	Orange	CA	7	7
-- 56	Orange	CA	14	1
-- 56	Orange	CA	43	2
-- 56	Orange	CA	28	2
-- 56	Orange	CA	8	5
-- 56	Orange	CA	23	7
-- 56	Orange	CA	11	6
-- 56	Orange	CA	20	4
-- 57	Oxnard	CA	26	1
-- 57	Oxnard	CA	34	2
-- 57	Oxnard	CA	25	6
-- 57	Oxnard	CA	30	7
-- 57	Oxnard	CA	2	15
-- 57	Oxnard	CA	36	14
-- 57	Oxnard	CA	9	7
-- 57	Oxnard	CA	41	2
-- 57	Oxnard	CA	4	6
-- 57	Oxnard	CA	40	7
-- 57	Oxnard	CA	15	4
-- 57	Oxnard	CA	38	3
-- 57	Oxnard	CA	3	5
-- 57	Oxnard	CA	13	8
-- 57	Oxnard	CA	16	4
-- 57	Oxnard	CA	32	2
-- 57	Oxnard	CA	43	4
-- 57	Oxnard	CA	33	2
-- 57	Oxnard	CA	17	8
-- 58	Palmdale	CA	29	7
-- 58	Palmdale	CA	11	15
-- 58	Palmdale	CA	44	9
-- 58	Palmdale	CA	46	12
-- 58	Palmdale	CA	23	5
-- 58	Palmdale	CA	39	5
-- 58	Palmdale	CA	38	6
-- 58	Palmdale	CA	41	7
-- 58	Palmdale	CA	13	12
-- 58	Palmdale	CA	1	6
-- 58	Palmdale	CA	32	4
-- 58	Palmdale	CA	21	6
-- 58	Palmdale	CA	9	2
-- 58	Palmdale	CA	16	8
-- 58	Palmdale	CA	3	7
-- 58	Palmdale	CA	33	3
-- 58	Palmdale	CA	35	6
-- 58	Palmdale	CA	47	6
-- 58	Palmdale	CA	27	5
-- 58	Palmdale	CA	5	2
-- 58	Palmdale	CA	12	1
-- 59	Pasadena	CA	19	8
-- 59	Pasadena	CA	3	5
-- 59	Pasadena	CA	46	15
-- 59	Pasadena	CA	45	3
-- 59	Pasadena	CA	41	3
-- 59	Pasadena	CA	23	19
-- 59	Pasadena	CA	42	5
-- 59	Pasadena	CA	27	4
-- 59	Pasadena	CA	2	4
-- 59	Pasadena	CA	24	2
-- 59	Pasadena	CA	15	7
-- 59	Pasadena	CA	40	7
-- 59	Pasadena	CA	4	4
-- 59	Pasadena	CA	7	8
-- 59	Pasadena	CA	14	7
-- 59	Pasadena	CA	29	3
-- 60	Pomona	CA	46	7

-- Orders by day of the week
SELECT DAYNAME(OrderDate) AS DayOfWeek, COUNT(*) AS OrderCount
FROM Orders
GROUP BY DayOfWeek;

-- Thursday	1168
-- Friday	1112
-- Saturday	1194
-- Sunday	1158
-- Monday	1146
-- Tuesday	1114
-- Wednesday	1099

-- % contribution of each product to the total revenue
WITH TotalRevenue AS (
    SELECT SUM(UnitPrice * OrderQuantity) AS OverallRevenue
    FROM Orders
)
SELECT o.ProductID, ProductName,
       SUM(UnitPrice * OrderQuantity) AS ProductRevenue,
       (SUM(UnitPrice * OrderQuantity) / (SELECT OverallRevenue FROM TotalRevenue)) * 100 AS RevenuePercentage
FROM Orders o JOIN Products p ON o.productid = p.productid
GROUP BY o.ProductID
ORDER by RevenuePercentage DESC, o.ProductID;

-- 23	Accessories	2358788.60	2.852474
-- 40	Rugs	2130841.20	2.576818
-- 4	Serveware	2071546.20	2.505113
-- 37	Platters	2052886.70	2.482548
-- 41	Collectibles	2049958.80	2.479007
-- 5	Bathroom Furniture	2011333.30	2.432298
-- 2	Photo Frames	2005638.30	2.425411
-- 35	Table Linens	1981973.90	2.396794
-- 8	Cocktail Glasses	1976895.30	2.390652
-- 17	Furniture Cushions	1925111.00	2.328029
-- 14	Mirrors	1921372.40	2.323508
-- 11	Ornaments	1885326.40	2.279918
-- 29	Pendants	1881668.20	2.275494
-- 10	Blankets	1870921.40	2.262498
-- 38	Wardrobes	1868140.90	2.259136
-- 16	Stemware	1849923.60	2.237106
-- 12	Dining Furniture	1846178.30	2.232576
-- 46	Sculptures	1837501.80	2.222084
-- 25	TV and video	1825415.00	2.207467
-- 21	Floral	1821837.20	2.203141
-- 20	Bar Tools	1821080.10	2.202225
-- 3	Table Lamps	1813589.50	2.193167
-- 19	Vanities	1790675.50	2.165457
-- 27	Wreaths	1786441.10	2.160336
-- 24	Wall Frames	1785362.40	2.159032
-- 43	Festive	1754783.60	2.122053
-- 22	Wine Storage	1742422.10	2.107104
-- 7	Dinnerware	1727112.60	2.088591
-- 45	Home Fragrances	1709974.00	2.067865
-- 36	Clocks	1703629.10	2.060192
-- 18	Basketball	1697592.40	2.052892
-- 28	Phones	1685217.50	2.037927
-- 9	Baseball	1644092.90	1.988195
-- 13	Bakeware	1642706.00	1.986518
-- 15	Outdoor Furniture	1620314.60	1.959440
-- 26	Candles	1607028.50	1.943373
-- 31	Candleholders	1584898.40	1.916612
-- 47	Audio	1542400.30	1.865219
-- 30	Wall Coverings	1536377.00	1.857935
-- 33	Outdoor Decor	1529234.80	1.849298
-- 39	Floor Lamps	1528303.50	1.848172
-- 1	Cookware	1436687.70	1.737381
-- 6	Computers	1422322.90	1.720010
-- 32	Vases	1402685.20	1.696262
-- 34	Bedroom Furniture	1401372.00	1.694674
-- 42	Bean Bags	1334231.30	1.613481
-- 44	Pillows	1268933.10	1.534516

-- Revenue by months
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, SUM(UnitPrice * OrderQuantity) AS Sales
FROM Orders
GROUP BY Month
ORDER BY Month;

-- 2018-05	75629.60
-- 2018-06	2454752.70
-- 2018-07	2707550.40
-- 2018-08	2909421.40
-- 2018-09	2798194.70
-- 2018-10	2323720.80
-- 2018-11	2977607.30
-- 2018-12	3046617.30
-- 2019-01	3075112.40
-- 2019-02	2168568.90
-- 2019-03	2199509.50
-- 2019-04	2844987.50
-- 2019-05	2795126.10
-- 2019-06	2596987.00
-- 2019-07	2295286.00
-- 2019-08	2652918.60
-- 2019-09	2610427.20
-- 2019-10	2496795.20
-- 2019-11	3065719.00
-- 2019-12	2733352.10
-- 2020-01	3129998.80
-- 2020-02	2762182.20
-- 2020-03	2314119.70
-- 2020-04	2489539.10
-- 2020-05	2781726.10
-- 2020-06	2349087.00
-- 2020-07	3108042.90
-- 2020-08	2486758.60
-- 2020-09	2380630.60
-- 2020-10	2778717.80
-- 2020-11	2629475.30
-- 2020-12	2654164.80

-- Sales channel and top 3 products sold
WITH ProductRevenue AS (
    SELECT SalesChannel, ProductID, SUM(UnitPrice * OrderQuantity) AS TotalRevenue
    FROM Orders
    GROUP BY SalesChannel, ProductID
)
SELECT SalesChannel, ProductID, ProductName, TotalRevenue
FROM (
    SELECT SalesChannel, pr.ProductID, p.ProductName, TotalRevenue,
           DENSE_RANK() OVER (PARTITION BY SalesChannel ORDER BY TotalRevenue DESC) AS rnk
    FROM ProductRevenue pr 
    JOIN Products p ON PR.ProductID = p.ProductID
) ranked
WHERE rnk <= 3;

-- Distributor	41	Collectibles	500322.50
-- Distributor	35	Table Linens	484838.80
-- Distributor	25	TV and video	479800.40
-- In-Store	23	Accessories	1184854.80
-- In-Store	4	Serveware	962977.60
-- In-Store	17	Furniture Cushions	960116.70
-- Online	12	Dining Furniture	739807.30
-- Online	18	Basketball	696679.40
-- Online	23	Accessories	682642.90
-- Wholesale	37	Platters	314156.30
-- Wholesale	26	Candles	307255.30
-- Wholesale	4	Serveware	294974.20

-- Shipping speed
SELECT COUNT(sc.OrderNumber) AS NumberOfOrders, sc.ShippingCategory 
FROM(
SELECT OrderNumber,
CASE WHEN DATEDIFF(DeliveryDate, ShipDate) <= 3 THEN 'Fast Shipping'
WHEN DATEDIFF(DeliveryDate, ShipDate) <= 7 THEN 'Standard Shipping'
ELSE 'Slow Shipping'
END AS ShippingCategory FROM Orders) sc
GROUP BY sc.ShippingCategory
ORDER BY sc.ShippingCategory;

-- 2354	Fast Shipping
-- 2388	Slow Shipping
-- 3249	Standard Shipping

-- Three-day moving average of product's prices
SELECT ProductID, OrderDate, UnitPrice,
AVG(UnitPrice) OVER 
(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) 
AS MovingAvgUnitPrice
FROM Orders ORDER BY ProductID, OrderDate;

-- 1	2018-05-31	1038.50	1038.500000
-- 1	2018-06-02	991.60	1015.050000
-- 1	2018-06-03	261.30	763.800000
-- 1	2018-06-06	857.60	703.500000
-- 1	2018-06-09	2224.40	1114.433333
-- 1	2018-06-12	3993.20	2358.400000
-- 1	2018-06-13	5916.10	4044.566667
-- 1	2018-06-19	247.90	3385.733333
-- 1	2018-06-26	1125.60	2429.866667
-- 1	2018-07-05	2385.20	1252.900000
-- 1	2018-07-08	1092.10	1534.300000
-- 1	2018-07-13	3839.10	2438.800000
-- 1	2018-07-18	1045.20	1992.133333
-- 1	2018-07-19	3946.30	2943.533333
-- 1	2018-07-22	241.20	1744.233333
-- 1	2018-07-31	1051.90	1746.466667
-- 1	2018-08-07	1855.90	1049.666667
-- 1	2018-08-10	3966.40	2291.400000
-- 1	2018-08-17	2606.30	2809.533333
-- 1	2018-08-28	5822.30	4131.666667
-- 1	2018-09-06	4006.60	4145.066667
-- 1	2018-09-13	3832.40	4553.766667
-- 1	2018-09-20	167.50	2668.833333
-- 1	2018-09-21	884.40	1628.100000
-- 1	2018-09-24	1896.10	982.666667
-- 1	2018-09-30	2907.80	1896.100000
-- 1	2018-10-03	924.60	1909.500000
-- 1	2018-10-07	1306.50	1712.966667
-- 1	2018-10-15	924.60	1051.900000
-- 1	2018-10-15	1929.60	1386.900000
-- 1	2018-10-16	3825.70	2226.633333
-- 1	2018-10-25	201.00	1985.433333
-- 1	2018-10-25	2385.20	2137.300000
-- 1	2018-11-07	1018.40	1201.533333
-- 1	2018-11-14	2519.20	1974.266667
-- 1	2018-11-15	3859.20	2465.600000
-- 1	2018-11-22	261.30	2213.233333
-- 1	2018-11-28	3577.80	2566.100000
-- 1	2018-12-04	2224.40	2021.166667
-- 1	2018-12-09	1118.90	2307.033333
-- 1	2018-12-11	3999.90	2447.733333
-- 1	2018-12-13	2988.20	2702.333333
-- 1	2018-12-15	1085.40	2691.166667
-- 1	2018-12-18	1011.70	1695.100000
-- 1	2018-12-25	958.10	1018.400000
-- 1	2019-01-03	1118.90	1029.566667
-- 1	2019-01-08	1031.80	1036.266667
-- 1	2019-01-10	1809.00	1319.900000
-- 1	2019-01-29	1098.80	1313.200000
-- 1	2019-02-16	1011.70	1306.500000
-- 1	2019-02-17	1118.90	1076.466667
-- 1	2019-03-07	1976.50	1369.033333
-- 1	2019-03-11	2552.70	1882.700000
-- 1	2019-03-14	2458.90	2329.366667
-- 1	2019-03-16	1125.60	2045.733333
-- 1	2019-03-24	978.20	1520.900000
-- 1	2019-04-03	710.20	938.000000
-- 1	2019-04-04	1112.20	933.533333
-- 1	2019-04-18	2659.90	1494.100000
-- 1	2019-04-20	3899.40	2557.166667
-- 1	2019-05-04	1695.10	2751.466667
-- 1	2019-05-06	1259.60	2284.700000
-- 1	2019-05-08	254.60	1069.766667
-- 1	2019-05-17	1179.20	897.800000
-- 1	2019-05-25	2619.70	1351.166667
-- 1	2019-05-26	3966.40	2588.433333
-- 1	2019-05-31	1909.50	2831.866667
-- 1	2019-05-31	857.60	2244.500000
-- 1	2019-06-01	3403.60	2056.900000
-- 1	2019-06-08	3872.60	2711.266667
-- 1	2019-06-20	850.90	2709.033333
-- 1	2019-06-22	261.30	1661.600000
-- 1	2019-07-08	1118.90	743.700000
-- 1	2019-07-09	1889.40	1089.866667
-- 1	2019-07-16	3852.50	2286.933333
-- 1	2019-07-21	1822.40	2521.433333
-- 1	2019-07-27	2592.90	2755.933333
-- 1	2019-07-29	247.90	1554.400000
-- 1	2019-08-02	207.70	1016.166667
-- 1	2019-08-18	1809.00	754.866667
-- 1	2019-08-31	234.50	750.400000
-- 1	2019-09-01	2425.40	1489.633333
-- 1	2019-09-11	1145.70	1268.533333
-- 1	2019-09-14	6217.60	3262.900000
-- 1	2019-09-14	6110.40	4491.233333
-- 1	2019-09-18	857.60	4395.200000
-- 1	2019-09-28	1005.00	2657.666667
-- 1	2019-09-28	1065.30	975.966667
-- 1	2019-10-10	2626.40	1565.566667
-- 1	2019-10-15	1058.60	1583.433333
-- 1	2019-11-11	1105.50	1596.833333
-- 1	2019-11-15	3839.10	2001.066667
-- 1	2019-11-22	3182.50	2709.033333
-- 1	2019-11-23	964.80	2662.133333
-- 1	2019-11-23	5634.70	3260.666667
-- 1	2019-12-13	1078.70	2559.400000
-- 1	2019-12-18	2974.80	3229.400000
-- 1	2019-12-21	3999.90	2684.466667
-- 1	2019-12-21	6204.20	4392.966667
-- 1	2019-12-29	221.10	3475.066667
-- 1	2019-12-31	6164.00	4196.433333
-- 1	2020-01-08	1755.40	2713.500000
-- 1	2020-01-14	2505.80	3475.066667
-- 1	2020-01-15	3986.50	2749.233333
-- 1	2020-01-16	5514.10	4002.133333
-- 1	2020-01-16	5681.60	5060.733333
-- 1	2020-01-18	1058.60	4084.766667
-- 1	2020-01-31	214.40	2318.200000
-- 1	2020-02-08	3477.30	1583.433333
-- 1	2020-02-13	1085.40	1592.366667
-- 1	2020-02-15	1065.30	1876.000000
-- 1	2020-02-16	1085.40	1078.700000
-- 1	2020-02-20	1038.50	1063.066667
-- 1	2020-03-04	3256.20	1793.366667
-- 1	2020-03-09	1112.20	1802.300000
-- 1	2020-03-22	3001.60	2456.666667
-- 1	2020-03-26	6371.70	3495.166667
-- 1	2020-04-03	1145.70	3506.333333
-- 1	2020-04-05	1051.90	2856.433333
-- 1	2020-04-11	2412.00	1536.533333
-- 1	2020-04-16	2566.10	2010.000000
-- 1	2020-04-18	3021.70	2666.600000
-- 1	2020-04-19	1031.80	2206.533333
-- 1	2020-04-24	3463.90	2505.800000
-- 1	2020-04-28	1139.00	1878.233333
-- 1	2020-05-04	871.00	1824.633333
-- 1	2020-05-15	3953.00	1987.666667
-- 1	2020-06-15	201.00	1675.000000
-- 1	2020-06-16	1333.30	1829.100000
-- 1	2020-06-21	254.60	596.300000
-- 1	2020-07-08	194.30	594.066667
-- 1	2020-07-09	871.00	439.966667
-- 1	2020-07-12	3604.60	1556.633333
-- 1	2020-07-17	964.80	1813.466667
-- 1	2020-07-17	1996.60	2188.666667
-- 1	2020-07-17	790.60	1250.666667
-- 1	2020-07-19	1313.20	1366.800000
-- 1	2020-07-19	1031.80	1045.200000
-- 1	2020-07-27	1983.20	1442.733333
-- 1	2020-08-11	1045.20	1353.400000
-- 1	2020-08-12	1788.90	1605.766667
-- 1	2020-08-22	998.30	1277.466667
-- 1	2020-08-25	1132.30	1306.500000
-- 1	2020-08-27	1005.00	1045.200000
-- 1	2020-08-31	174.20	770.500000
-- 1	2020-09-04	214.40	464.533333
-- 1	2020-09-16	1051.90	480.166667
-- 1	2020-09-18	174.20	480.166667
-- 1	2020-09-22	1038.50	754.866667
-- 1	2020-09-22	2010.00	1074.233333
-- 1	2020-10-03	1031.80	1360.100000
-- 1	2020-10-18	1045.20	1362.333333
-- 1	2020-10-23	3959.70	2012.233333
-- 1	2020-11-01	3973.10	2992.666667
-- 1	2020-11-09	194.30	2709.033333
-- 1	2020-11-11	3959.70	2709.033333
-- 1	2020-11-21	2391.90	2181.966667
-- 1	2020-11-24	1112.20	2487.933333
-- 1	2020-11-29	2546.00	2016.700000
-- 1	2020-12-07	2257.90	1972.033333
-- 1	2020-12-18	3899.40	2901.100000
-- 1	2020-12-25	2485.70	2881.000000
-- 2	2018-06-03	2405.30	2405.300000
-- 2	2018-06-14	1802.30	2103.800000
-- 2	2018-06-15	2633.10	2280.233333
-- 2	2018-06-19	1293.10	1909.500000
-- 2	2018-06-21	2566.10	2164.100000
-- 2	2018-06-22	5031.70	2963.633333
-- 2	2018-07-07	3966.40	3854.733333
-- 2	2018-07-11	3061.90	4020.000000
-- 2	2018-07-11	261.30	2429.866667
-- 2	2018-07-15	3906.10	2409.766667
-- 2	2018-07-18	1909.50	2025.633333
-- 2	2018-07-21	1755.40	2523.666667
-- 2	2018-07-25	1862.60	1842.500000
-- 2	2018-07-29	971.50	1529.833333
-- 2	2018-07-31	2264.60	1699.566667
-- 2	2018-08-05	864.30	1366.800000
-- 2	2018-08-08	6117.10	3082.000000
-- 2	2018-08-09	1025.10	2668.833333
-- 2	2018-08-09	3859.20	3667.133333
-- 2	2018-08-12	1072.00	1985.433333
-- 2	2018-08-14	3242.80	2724.666667
-- 2	2018-08-15	871.00	1728.600000
-- 2	2018-08-16	3899.40	2671.066667
-- 2	2018-08-16	180.90	1650.433333
-- 2	2018-08-19	2231.10	2103.800000
-- 2	2018-08-22	1802.30	1404.766667
-- 2	2018-08-23	174.20	1402.533333
-- 2	2018-08-27	1139.00	1038.500000
-- 2	2018-09-08	1065.30	792.833333
-- 2	2018-09-20	2914.50	1706.266667
-- 2	2018-09-26	917.90	1632.566667
-- 2	2018-09-28	3269.60	2367.333333
-- 2	2018-11-01	1299.80	1829.100000
-- 2	2018-11-01	1045.20	1871.533333
-- 2	2018-11-10	1051.90	1132.300000
-- 2	2018-11-22	3912.80	2003.300000
-- 2	2018-11-24	6485.60	3816.766667
-- 2	2018-11-28	1762.10	4053.500000
-- 2	2018-12-03	2291.40	3513.033333
-- 2	2018-12-05	1842.50	1965.333333
-- 2	2018-12-10	951.40	1695.100000
-- 2	2018-12-15	897.80	1230.566667
-- 2	2018-12-17	174.20	674.466667
-- 2	2018-12-27	1775.50	949.166667
-- 2	2018-12-31	1132.30	1027.333333
-- 2	2019-01-01	6197.50	3035.100000
-- 2	2019-01-10	2860.90	3396.900000
-- 2	2019-01-12	5661.50	4906.633333
-- 2	2019-01-16	1112.20	3211.533333
-- 2	2019-01-19	2318.20	3030.633333
-- 2	2019-01-30	1065.30	1498.566667
-- 2	2019-02-09	971.50	1451.666667
-- 2	2019-02-13	3457.20	1831.333333
-- 2	2019-02-14	3879.30	2769.333333
-- 2	2019-02-23	3953.00	3763.166667
-- 2	2019-03-18	998.30	2943.533333
-- 2	2019-04-04	1031.80	1994.366667
-- 2	2019-04-14	2559.40	1529.833333
-- 2	2019-04-23	268.00	1286.400000
