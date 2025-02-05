# SimCar_MATLAB

This repository contains an automobile simulator using the 14 degree of freedom math model. It was programmed in MATLAB/SIMULINK R2024B and simulates the suspension, the Ackerman steering, the four wheels movement, the forces and the velocities of the chassis. The tire force's model is the Dugoff model.

A longitudinal control was programmed using ADRC to follow a given velocity. On the other hand, the lateral control was done using the 'Backstepping' method and a LSTM network. The network was trained with Python and the Keras and TensorFlow libraries.

Different experiments were done at different speeds. Check the video:
[![Lateral and longitudinal control of a car using ADRC, Backstepping and LSTM network](https://img.youtube.com/vi/fLt50IwuVks/maxresdefault.jpg)](https://youtu.be/fLt50IwuVks?si=QsyGZ5c47B4sSL6V)

All the details of the software can be found in the next ~~[link](https://github.com/sherlock-gmo)~~

Please cite as:
```bibtex
@phdthesis{Gonzalez2025,
	author    = {Gonz{\'{a}}lez-Miranda O.},
	title     = {Sistema de conducci{\'{o}}n autom{\'{a}}tica para el veh{\'{i}}culo AutoMINY},
	address = {Ciudad de M{\'{e}}xico},
	year      = {2025},
	school = {CINVESTAV},
	pages     = {146},
	type = {Tesis doctoral}
	#note       = {Disponible en \url{https://repositorio.cinvestav.mx/handle/cinvestav/2261}},
}
```




