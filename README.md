# SIMulation of Semi-Autonomous Locomotion And Behavior with Integrated Mapping (SIMSALABIM)

A tool designed for simulating the behavior of runners in a semi-autonomous way, with some randomness or variability built in to mimic real-world conditions. Includes a visualisation component that allows users to observe the simulated behavior in real-time or replay recorded simulations.

This serves as a complete replacement for the stations. Telraam can be directly connected to the build in webservers.

### The Data

- Provides you with 7 stations. They open a webserver on ports 6000 to 6006. The only supported path is /detections/<index>.
- Simulates batons (at the moment 5) that move around the track.
- Detections are generated based on some parameters that add randomness, runner variety, team variety, ...


### The visuals

- A minimalistic track is shown with stations and batons. Only simple geometric shapes are used.
- A UI shows info about the batons and detections.


### Next up

- TODO Document used calculations and available parameters.
- TODO Add option to disable stations. Add parameters rssi fluctuations based on variating distance to the stations and variating orientation of the actual baton the runner carries.
