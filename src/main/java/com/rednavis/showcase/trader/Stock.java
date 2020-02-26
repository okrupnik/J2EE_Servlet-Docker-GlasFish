package com.rednavis.showcase.trader;

import java.io.Serializable;

public class Stock implements Serializable {

  private String symbol;
  private double price;

  public Stock(String symbol, double price) {
    this.symbol = symbol;
    this.price = price;
  }

  // Methods to return the private values of this object
  public double getPrice() {
    return price;
  }

  public void setPrice(double newPrice) {
    price = newPrice;
  }

  public String getSymbol() {
    return symbol;
  }

  public String toString() {
    return "Stock:  " + symbol + "  " + price;
  }
}
