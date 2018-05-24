# Files for Exhibition @Japan Media Art Festival

## Instructions

### Setting up processing

1. Download Processing [here](https://processing.org/download/)
2. Download the repository by clicking the __"Clone or download"__ button
3. Extract the zipped files
4. The program is in the folder `DitherOSC` double click on `DitherOSC.pde` to open it in processing

### Setting up the iPad Mac connection

1. Download the [touchOSC app](https://itunes.apple.com/us/app/touchosc/id288120394?mt=8) and the [touchOSC Bridge](https://hexler.net/software/touchosc) (scroll down the page to find it!)
2. run the touchOSC Bridge app, an icon should appear on the menu bar of your computer
3. Open iTunes go to the iPad menu and choose __File Sharing__, click __Add…__ and add the `iPadToDither_01.touchosc` file __Save…__, and __Sync__ the iPad
4. Create a closed network with the Mac by clicking the wi-fi icon and then __"Create Network…"__ 
5. Choose a name for the network and leave the cahnnel setting to 11
6. Go to the wi-fi settings of the iPad and connect it to newly created network
7. Open the touchOSC app on the iPad
8. Go to options and set them as in the image, than go back to main menu
9. On the top there are three connections menu to click choose the one in the middle __TouchOSC Bridge__ click it and enter the menu.
10. Set all the options as in the image. 
11. To set the __Network Host__ go to system preferences of your Mac and choose __Network__. There you can find your IP address
12. Now a new item should appear in the menu called __FOUND HOSTS(1)__ with the name of the network or of the computer. __*Click it!*__
13. Go back to the main menu and click __LAYOUT__ and choose `iPadToDither_01` layout
14. Go back to the main menu and click __Done__
15. You should be in the layout with all the buttons and sliders like in the image. Check fort he green light in the upper right corner. If there is no light close the app by double clicking the home button of iPad and by swiping the app away.
16. Go to processing on Mac and run the `DitherOSC` program either with `cmd + r` or by clicking the run icon on the upper left corner
17. If everything went fine you should be able to control the dither with the iPad!!!

 