def clothesfromtemperature(celsius):
    
    if celsius > 20:
        print("No jacket needed!")
    elif 15 < celsius <= 20:
        print("Wear a light jacket")
    elif 12 < celsius <= 15:
        print("Wear a medium thickness jacket!")
    elif 5 < celsius <= 12:
        print("Wear a thick jacket!")
    else:  # Covers celsius <= 5
        print("Oof! It's a chilly one! Wear a thick jacket, hat, winter trousers, thick socks, gloves and scarf!")

Wind = int(input("Input wind strength category:" ))

if 0 < Wind <= 3:
	print ("Minimal wind, no wind protection needed beyond base insulation - if necessary!")
elif 4 < Wind <= 8:
	print("Mildly windy, maybe a very light jacket, depending on temperature- pack one just in case!")
elif 8 < Wind <= 15:
	print("The wind will be more noticeable now! May be chillier as a result, especially if raining or cloudy as well! Wear a light jacket or thin jumper.")
elif 15 < Wind <= 25:
	print("It’s getting blustery now! Wrap up! Wear a windproof jacket, a light extra layer, potentially a scarf or at least a hat- if its also chilly, a thick jacket and gloves.")
elif 25 < Wind <= 40:
	print("Its getting seriously windy now, like youre in some Edgar Allan Poe poem and youve got to traverse the muddy marshes to deliver a letter on horseback… It will be hard to walk against the direction of the wind, avoid cycling if you can- things may blow around outdoors, secure your things, wear a hat with a chinstrap, balaclava, gloves, additional insulation- thick fleece, winter trousers, thick socks")
elif 40 < Wind <= 60: 
	print("Winds are between 40-60 MPH, youll need a very sturdy windproof coat with extra layers, warm hat, gloves and a scarf are essential to prevent windchill- these winds can get dangerous for travel so be careful.")
elif 60 < Wind <= 74:
	print("Winds are between 60-74 MPH, youll need a sturdy high quality insulated windproof coat with extra multiple layers, sturdy boots, full protective gear for heads, hand and face- its best to avoid being outside if possible.")
else:
	print("Storm/hurricane- incredibly dangerous, over 75 MPH, threat to human life, seek shelter immediately and avoid going outside.") 

Rain = int(input("Input rain strength category:"))

if Rain <= 0:
	print ("No rain today, no need for a raincoat")
elif 0 < Rain <= 2.5:
	print("Barely noticeable but can make you damp overtime- wear a water-resistant windbreaker and/or light raincoat, waterproof/water resistant shoes, a compact umbrella and/or a water-resistant hat.")
elif 2.5 < Rain <= 7.5:
	print("Noticeable- might soak your clothes for extended periods, fully waterproof jacket with a hood, waterproof trousers if walking/cycling for a while, water resistant hat, waterproof shoes/boots and quick-drying synthetic or wool base layers- avoid cotton, light gloves- adjust based on temperature")
elif 7.5 < Rain <= 14:
    print("Torrential Downpour! Fully waterproof jacket with sealed seams, waterproof trousers, waterproof hat, waterproof shoes/boots, waterproof gloves, pack a change of clothes, avoid cotton, pack a waterproof bag for electronics and valuables.")
else:
	print("Dangerous conditions- over 14mm of rain, flooding, seek shelter, avoid going outside, wear full waterproof gear, pack a survival kit, stay safe!")
	
Sunshine_heat = int(input)("Input sunshine/heat strength category:")

if Sunshine_heat <=10: 
    print("")
elif 10 < Sunshine_heat <= 20:
    print("Mild sun, wear a hat, sunglasses, sunscreen on exposed skin, light clothing, stay hydrated")
elif 20 < Sunshine_heat <= 30:
    print("Warm sun, wear a hat, sunglasses with UV protection, sunscreen on exposed skin, breathable light-coloured clothing, stay hydrated, seek shade")
else: 
    print("Hot sun, wear a wide-brimmed hat, sunglasses with UV protection, sunscreen on exposed skin, breathable light-coloured clothing, stay hydrated, seek shade, avoid being outside during peak sun hours, avoid strenuous exercise, avoid alcohol and caffeine, avoid heavy meals, avoid dark clothing, avoid being in a car for long periods of time, avoid being in direct sunlight")
	
Frost = int(input("Input frost strength category:"))
    
if Frost > 1:
	print("")
elif -2 < Frost < 0:
    print("Thin Ice forming overnight- slippery surfaces possible, but manageable- insulated jacket, thin gloves and a hat, shoes with a decent grip, avoid cycling, drive carefully")
elif -7 > Frost < -3:
    print("Moderate Frost- Walking and cycling become hazardous, wear an insulated winter coat, thermal socks, waterproof boots with a good grip, gloves, hat, scarf, avoid cycling, drive carefully, avoid being outside for long periods of time")
else:
    print("Risk of frostbite- wear a heavy insulated jacket, thermal base layers (trousers and chest), insulated boots, thick insulated gloves, balaclava, layered approach to trap body heat effectively, avoid going out for too long if possible.")

UV = int(input("Input UV strength category:"))

if UV <= 0:
    print("No UV today, no need for sunscreen")
elif 0 < UV <= 2:
      print("Low sun, wear regular clothing, maybe sunglasses, possibly sunscreen just in case")
elif 3 < UV <= 6:
    print("Moderate sun, wear a hat, sunglasses, sunscreen on exposed skin applied regularly, light clothing, stay hydrated")
elif 6 < UV <= 8:
    print("High sun, wear a wide-brimmed hat, sunglasses with UV protection, sunscreen on exposed skin, breathable light-coloured clothing, stay hydrated, seek shade")
elif 8 < UV < 10:
    print("Very high sun, wear a wide-brimmed hat, sunglasses with UV protection, sunscreen on exposed skin, breathable light-coloured clothing, stay hydrated, seek shade, avoid being outside during peak sun hours, avoid strenuous exercise, avoid alcohol and caffeine, avoid heavy meals, avoid dark clothing, avoid being in a car for long periods of time, avoid being in direct sunlight")
else:
    print("Extreme sun, wear a wide-brimmed hat, sunglasses with UV protection, sunscreen on exposed skin, breathable light-coloured clothing, stay hydrated, seek shade, avoid being outside during peak sun hours, avoid strenuous exercise, avoid alcohol and caffeine, avoid heavy meals, avoid dark clothing, avoid being in a car for long periods of time, avoid being in direct sunlight, avoid being outside for long periods of time")