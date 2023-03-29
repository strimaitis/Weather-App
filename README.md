# Weather-App

## How it Works
Download the zipped file and open WeatherSearchApp > WeatherSearchApp.xcodeproj.  For running the project, make sure your simulator or device is running iOS 15.0 or higher.

## On Device
Connect your phone to your computer and, once trusting the computer, make sure the compilation target is set as your device. Compile the app and launch on your device.

## On Simulator
On a similator you'll have to ensure your location is set.  Before launching the app, make sure to check Features > Location > Custom Location from the selected simulator's menu bar

<img width="503" alt="Custom Location Selected" src="https://user-images.githubusercontent.com/33992296/228599919-2a8fe568-ecd0-480a-b592-ae6faf8f0f08.png">

Troubleshooting this will involve making sure the custom coordinates set are assocaited with a real city, so click on Custom Location and check the coordinates match a real city. You can search for your own by searching the city name and its coordinates, just make sure you enter in the right sign relative to the direction. In the example the coordinates 41.881832 N, 87,623177 W represent the windy city Chicago!

<img width="382" alt="Make sure a location is set" src="https://user-images.githubusercontent.com/33992296/228600970-08926690-3988-4e58-b4f9-84378e0f541a.png">

Once you compile and run the app, it should open automically in your simululator and present a location sharing alert!

Depending on the Xcode version being used, the simulators can have occassional problems syncing the simulated location. There are open developer tickets concerning this for using coordinate information and GPX files: [Ticket 1](https://developer.apple.com/forums/thread/112745), [Ticket 2](https://developer.apple.com/forums/thread/685994)

When no problems are presented and simulator behaves normally, aceepting location sharing will do the following.

https://user-images.githubusercontent.com/33992296/228603274-97965ad1-ae8d-4bbc-a56c-6625504a50e7.mov

## Searching

### City Doesn't Exist
Once the app has been launched on your device or a simulator, click the search icon in the top right corner to open the search page. To search for a city, type it in the search field and click the search cell below. 

If your city name is made up (ex: Houstatlantavegas, Gotham City) and more importantly **doesn't exist in America** (you'd be surprised how many cities exist in America) you can type it in and verifying you receive the following alert.

https://user-images.githubusercontent.com/33992296/228611207-374230c3-59c9-4250-9883-36d302e079bd.mov

### City Does Exist
If your city does exist in America, type it in and search for it.  It should load as a drawer overlay in the bottom of the screen. You can continue searching for new cities or preload old ones that have been previously searched.

When you go back to the home screen, the most recently searched city that **has not been preloaded before** should present as the last searched city

https://user-images.githubusercontent.com/33992296/228613815-69fc4599-153e-4015-a284-f23c3d612792.mov

### Refreshing Home Page

Since Austin was searched for last and for the first time, it shall appear as the last searched city

<img width="329" alt="Screen Shot 2023-03-29 at 10 05 23 AM" src="https://user-images.githubusercontent.com/33992296/228615796-0f69536e-b018-4ba0-ad45-93dd137bd91f.png">
