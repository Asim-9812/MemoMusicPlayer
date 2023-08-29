# musicplayer

A basic music player with Firebase implementation.

# Domain Driven Design

This project follows DDD pattern as it enhances collaboration through shared understanding, ensures adaptable software aligned with business needs, and provides tools for structured, scalable solutions to complex problems.

# Music Player

Features : 
- Play / Pause / Skip / Previous
- Shuffle mode
- Repeat mode

# Playlist 

Displays list of music that are pulled from the firebase database.
The page also listens to the state of music in previous page and matches the state accordingly in the bottom feature for shortcuts of play / pause / skip / previous.
It also has a floatingActionButton that directs the user to uploading music page
Features : 
- Can delete the music if you like.

# Upload Music

Features :
- Add a music : (Required) Adding a name is required before adding the music.

## Packages 

# Firebase
As per project requirements all the needed packages of firebase were implemented.

# just_audio
This package was used for music player functionality for the application

# riverpod
Riverpod is a efficient and simple state manangement package and helps alot in saving the state of the music player throughout different pages
