//
//  ColorPicker.swift
//  Tester
//
//  Created by Adam Ress on 7/10/23.
//

import SwiftUI

struct ColorPicker: View {

    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    @Binding var showColorSwitcher: Bool

    var body: some View {

        let redStartColor = Color(red: 0, green: green, blue: blue)
        let redEndColor = Color(red: 1, green: green, blue:blue)

        let greenStartColor = Color(red: red, green: 0, blue: blue)
        let greenEndColor = Color(red: red, green: 1, blue: blue)

        let blueStartColor = Color(red: red, green: green, blue: 0)
        let blueEndColor = Color(red: red, green: green, blue: 1)

            VStack {
                
                HStack {
                    Spacer()
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.gray)
                        .scaleEffect(2)
                        .padding()
                        .padding(.horizontal)
                        .onTapGesture {
                            showColorSwitcher = false
                        }
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(red: red, green: green, blue: blue))
                    .frame(height: 70)
                    .padding(.horizontal, 20)
                    .shadow(radius: 1)
                
                ColorBar(colorStart: redStartColor, colorEnd: redEndColor,
                         colorIndex: 1, red: $red, green: $green, blue: $blue, value: red)
                .padding()


                ColorBar(colorStart: greenStartColor, colorEnd: greenEndColor,
                         colorIndex: 2, red: $red, green: $green, blue: $blue, value: green)
                .padding()

                ColorBar(colorStart: blueStartColor, colorEnd: blueEndColor,
                         colorIndex: 3, red: $red, green: $green, blue: $blue, value: blue)
                .padding()
            }
    }
}

struct ColorBar: View {

    var colorStart: Color
    var colorEnd: Color
    var colorIndex: Int
    
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double

    @State var value:Double

    var body: some View {

        let currentColor = Color(red: red, green: green, blue: blue)

        HStack() {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    LinearGradient(colors: [colorStart, colorEnd], startPoint: .leading, endPoint: .trailing)
                        .frame(height: 40)
                        .cornerRadius(50)
                        .shadow(radius: 1)
                    
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 35)
                        Circle()
                            .foregroundColor(currentColor)
                            .frame(width: 28)
                            .shadow(radius: 1)
                    }
                    .offset(x: CGFloat(value) * (geo.size.width - 35))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged({ gesture in
                                
                                updateValue(with: gesture, in: geo)
                                
                                if colorIndex == 1 {
                                    red = value
                                }
                                else if colorIndex == 2 {
                                    green = value
                                }
                                else {
                                    blue = value
                                }
                            })
                        
                    )
                }
            }
            .frame(height: 40)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 70, height: 35)
                    .shadow(radius: 1)
                    .foregroundColor(.white)
                Text(String(Int(colorValue()*255)))
            }
            
        }

    }

    func updateValue(with gesture: DragGesture.Value, in geometry:GeometryProxy) {
        let newValue = gesture.location.x / geometry.size.width
        value = min(max(Double(newValue), 0), 1)
    }


    func colorValue() -> Double {
        if colorIndex == 1 {
            return red
        }
        else if colorIndex == 2 {
            return green
        }
        else {
            return blue
        }
    }
}
