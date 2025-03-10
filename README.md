# HikeRecommendations
This is a Shiny R Dashboard with an interactive map of hike recommendations in the Greater Vancouver Area based on my personal experience

**View the dashboard [here](https://meagangardner-hikerecommendations.share.connect.posit.cloud/)**

## Motivation

This Shiny dashboard is designed for anyone who loves the outdoors and wants to explore hiking trails in the Greater Vancouver area. It provides an interactive map displaying key trail information such as distance, elevation gain, difficulty, and estimated time to complete. Users can filter hikes by various criteria, including difficulty, distance, season, and elevation gain. The goal of this app is to offer personalized hike suggestions based on my own experiences, helping users discover suitable trails for their preferences and fitness levels.

**Please Note:** The recommendations are based on my own hiking experiences and are intended as a good starting point. However, please remember that hiking conditions can change, and it is always important to do your own research, check current trail conditions, and plan ahead before heading out on a hike!

## Key App Features
- **Interactive map:** Explore hike locations with markers that show the trail's key details.
- **Filter options:** Filter hikes based on distance, elevataion gain, difficulty, estimated completion time, and season.
- **Icons:** Users can click on the maps Icon's to get more details about the trail, including name, exact hiking distance and elevation gain, and completion time.
- **User-friendly interface:** The app is designed to be simple and intuitive, making it easy for users to find and explore hiking options.

![gif](./img/demo.gif)

## Installation Instructions

1. **Clone the repository**:
```
git clone https://github.com/meagangardner/HikeRecommendations.git
```

2. **Install the environment**:
```
conda env create --hike_recommender --file=environment.yaml
```

3. **Activate the environment**:
```
conda activate hike_recommender
```
4. **To run the app from your terminal use**:
```
Rscript src/app.R
```
5. **Access the app**:
Once the app is running, you can access it by opening a web browser and navigating to the address provided in the terminal output. By default, it should be something like `http://127.0.0.1:5030`.
