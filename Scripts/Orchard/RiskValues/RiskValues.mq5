//+------------------------------------------------------------------+
/**=
 *
 * Disclaimer and Licence
 *
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * All trading involves risk. You should have received the risk warnings
 * and terms of use in the README.MD file distributed with this software.
 * See the README.MD file for more information and before using this software.
 *
 **/
//|                                                  PointValues.mq4 |
//|                               Copyright 2012-2020, Orchard Forex |
//|                                     https://www.orchardforex.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012-2020, Orchard Forex"
#property link "https://www.orchardforex.com"
#property version "1.00"
#property strict

//
//	Compatibility Functions
//
#ifdef __MQL4__
string BaseCurrency() { return ( AccountCurrency() ); }
double Point( string symbol ) { return ( MarketInfo( symbol, MODE_POINT ) ); }
double TickSize( string symbol ) { return ( MarketInfo( symbol, MODE_TICKSIZE ) ); }
double TickValue( string symbol ) { return ( MarketInfo( symbol, MODE_TICKVALUE ) ); }
#endif
#ifdef __MQL5__
string BaseCurrency() { return ( AccountInfoString( ACCOUNT_CURRENCY ) ); }
double Point( string symbol ) { return ( SymbolInfoDouble( symbol, SYMBOL_POINT ) ); }
double TickSize( string symbol ) { return ( SymbolInfoDouble( symbol, SYMBOL_TRADE_TICK_SIZE ) ); }
double TickValue( string symbol ) { return ( SymbolInfoDouble( symbol, SYMBOL_TRADE_TICK_VALUE ) ); }
#endif

void OnStart() {

   Test( "EURJPY" );
   Test( "EURGBP" );
   Test( "AUDNZD" );
   Test( "XAUUSD" );
}

void Test( string symbol ) {

   PrintFormat( "Base currency is %s", BaseCurrency() );
   PrintFormat( "Testing for symbol %s", symbol );

   double pointValue = PointValue( symbol );

   PrintFormat( "ValuePerPoint for %s is %f", symbol, pointValue );

   //	Situation 1, fixed lots and stop loss points, how much is at risk
   double riskPoints = 75; //	0.075 for EURJPY, 0.00075 for EURGBP and AUDNZD
   double riskLots   = 0.60;
   double riskAmount = pointValue * riskLots * riskPoints;
   PrintFormat( "Risk amount for %s trading %f lots with risk of %f points is %f",
                symbol, riskLots, riskPoints, riskAmount );

   //	Situation 2, fixed lots and risk amount, how many points to set stop loss
   riskLots   = 0.60;
   riskAmount = 100;
   riskPoints = riskAmount / ( pointValue * riskLots );
   PrintFormat( "Risk points for %s trading %f lots placing %f at risk is %f",
                symbol, riskLots, riskAmount, riskPoints );

   //	Situation 3, fixed risk amount and stop loss, how many lots to trade
   riskAmount = 100;
   riskPoints = 50;
   riskLots   = riskAmount / ( pointValue * riskPoints );
   PrintFormat( "Risk lots for %s value %f and stop loss at %f points is %f",
                symbol, riskAmount, riskPoints, riskLots );
}

double PointValue( string symbol ) {

   double tickSize      = TickSize( symbol );
   double tickValue     = TickValue( symbol );
   double point         = Point( symbol );
   double ticksPerPoint = tickSize / point;
   double pointValue    = tickValue / ticksPerPoint;

   PrintFormat( "tickSize=%f, tickValue=%f, point=%f, ticksPerPoint=%f, pointValue=%f",
                tickSize, tickValue, point, ticksPerPoint, pointValue );

   return ( pointValue );
}
