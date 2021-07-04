<template>
  <div class="section1">
    <v-container>
      
        <div class="sectionTitle mt-10">
          COVID-19 Information Center
        </div>

        <div class="sectionSubtitle text-center mt-2">
          Follow the latest information about Covid-19 on this page<br/>curated from various trusted sources
        </div>

        
        <div class="dataSourceLogo mt-5">
          <div>
            <img src="~assets/img/un.png"/>
          </div>
          <div>
            <img src="~assets/img/who.png"/>
          </div>
          <div>
            <img src="~assets/img/cnbc.png"/>
          </div>
        </div>
        
        <div style="color:#fff;font-size:0.6em" class="text-center mt-5 mb-2">Project Purpose: Contest on Freelancer.com</div>

        <div class="mapArea">
          <div class="sidebarInfo  elevation-5 px-3 pb-3">

            <v-expand-transition>
              <div class="mt-3" v-if="currentAttribute.Country_Region==undefined">
                Click on any marker to retrieve the country data.
              </div>
            </v-expand-transition>

            <div v-if="currentAttribute.Country_Region!=undefined&&mapserverLoading" class="text-center">
              <v-progress-linear indeterminate color="cyan"></v-progress-linear>
            </div>

            <div class="mt-3" v-if="currentAttribute.Country_Region!=undefined">
            
              <div class="country text-center" v-if="currentAttribute.Country_Region!==null">{{currentAttribute.Country_Region}}</div>
              
              <v-divider></v-divider>

              <div class="latestUpdate" v-if="currentAttribute.Last_Update!==null">Last Update: <b>{{getDate(currentAttribute.Last_Update)}}</b></div>
              <v-divider></v-divider>
              <div class="dataSource">Data Source: <br/> <b><a href="https://covid-19-data.unstatshub.org/datasets/1cb306b5331945548745a5ccd290188e_2/about" target="_blank">United Nation Statistics</a></b></div>

              <div class="statisticData mt-5" style="background-color:#e84f61">
                <div>
                  <div class="titleData text-center">Mortality Rate</div>
                  <div class="valueData text-center" v-if="currentAttribute.Mortality_Rate!==null">{{currentAttribute.Mortality_Rate.toFixed(2)}}</div>
                  <div class="valueData text-center" v-else="currentAttribute.Mortality_Rate!==null">-</div>
                </div>
              </div>

              <div class="statisticData mt-5" style="background-color:#5c248c">
                <div>
                  <div class="titleData text-center">Confirmed</div>
                  <div class="valueData text-center" v-if="currentAttribute.Confirmed!==null">{{getThousands(currentAttribute.Confirmed)}}</div>
                  <div class="valueData text-center" v-else="currentAttribute.Confirmed!==null">-</div>
                </div>
              </div>

              <div class="statisticData mt-5" style="background-color:#4287f5">
                <div>
                  <div class="titleData text-center">Recovered</div>
                  <div class="valueData text-center" v-if="currentAttribute.Recovered!==null">{{getThousands(currentAttribute.Recovered)}}</div>
                  <div class="valueData text-center" v-else="currentAttribute.Recovered!==null">-</div>
                </div>
              </div>

              <div class="statisticData mt-5" style="background-color:#4a4a4a">
                <div>
                  <div class="titleData text-center">Death</div>
                  <div class="valueData text-center" v-if="currentAttribute.Deaths!==null">{{getThousands(currentAttribute.Deaths)}}</div>
                  <div class="valueData text-center" v-else="currentAttribute.Deaths!==null">-</div>
                </div>
              </div>

              <div class="statisticData mt-5" style="background-color:#ff9729">
                <div>
                  <div class="titleData text-center">Active</div>
                  <div class="valueData text-center" v-if="currentAttribute.Active!==null">{{getThousands(currentAttribute.Active)}}</div>
                  <div class="valueData text-center" v-else="currentAttribute.Active!==null">-</div>
                </div>
              </div>

            </div>
            

          </div>
          <div class="mapContainer d-flex fill-height">
            <div id="map">
            </div>
          </div>
        </div>
    </v-container>
  </div>

</template>

<script>
import { loadModules } from 'esri-loader';
import { loadCss } from 'esri-loader';
import axios from 'axios'

export default {
  data(){
    return {
      map:{},
      mapView:{},
      graphicMarker:{},
      geoJSONlayer:{},
      currentAttribute:{},
      mapserverLoading:false
    }
  },
  mounted(){
    this.createMap()
  },
  methods:{
    createMap(){
           loadModules(['esri/views/MapView','esri/Map', 'esri/WebMap', 'esri/Graphic','esri/layers/GraphicsLayer','esri/layers/MapImageLayer','esri/widgets/Search','esri/tasks/Locator', 'esri/geometry/support/webMercatorUtils', 'esri/widgets/Legend', 'esri/widgets/BasemapGallery', 'esri/config','esri/core/urlUtils', 'esri/widgets/AreaMeasurement2D','esri/widgets/DistanceMeasurement2D', 'esri/widgets/ScaleBar','esri/widgets/Sketch','esri/widgets/Bookmarks',
            "esri/widgets/Expand","esri/layers/GeoJSONLayer","esri/layers/FeatureLayer","esri/geometry/Extent"])
            .then(([MapView, Map, WebMap, Graphic, GraphicsLayer, MapImageLayer, Search, Locator, webMercatorUtils, Legend, BasemapGallery, esriConfig, urlUtils, AreaMeasurement2D, DistanceMeasurement2D, ScaleBar,Sketch,Bookmarks,Expand,GeoJSONLayer,FeatureLayer,Extent]) => {
          
                loadCss()

                //set map
                this.map = new Map({
                    basemap: "osm" // Basemap layer service
                });
                
                //set view
                this.mapView = new MapView({
                    map: this.map,
                    center: [75.807637, 2.472323], // Longitude, latitude
                    zoom: 3, // Zoom level
                    container: "map" // Div element
                });

                
                 //Demografi Layer
                 let rendererDemografi = {
                    type: "simple",  // autocasts as new SimpleRenderer()
                    symbol: {
                      type: "simple-marker",  // autocasts as new SimpleFillSymbol()
                      color: "#911414",
                      size:20,
                      outline: {  // autocasts as new SimpleLineSymbol()
                        width: 2,
                        color: "red"
                      }
                    },
                    
                  };

                rendererDemografi.visualVariables = [{
                    type: "opacity",
                    field: ["Mortality_Rate"],
                    stops: [
                      { value: 0, opacity: 0.2, label: "< 0-10000" },
                      { value: 1.5, opacity: 0.5, label: "10000 - 2000" },
                      { value: 3, opacity: 0.8, label: "> 20000" },
                      { value: 4.5, opacity: 1, label: "> 20000" }
                    ]
                }];
                
                this.geoJSONlayer = new GeoJSONLayer({
                  url: "/geojson/un-covid.geojson",
                  copyright: "United Nation",
                  renderer:rendererDemografi,
                  outFields:["*"],
                });

                this.map.add(this.geoJSONlayer)

                
                 //create marker
                var symbol = {
                    type: "picture-marker", // autocasts as new PictureMarkerSymbol()
                    url: "/icons/marker.png",
                    width: "30px",
                    height: "75px",
                };
                
                //create graphic, contain marker
                this.graphicMarker = new Graphic({
                    symbol: symbol
                });

                //add graphic to layer 
                this.mapView.graphics.add(this.graphicMarker);//remove all graphics (marker)
                
              this.mapView.on("click", (event) => {
                 this.mapView.hitTest(event).then(({ results }) => {
                   
                  results.forEach((item,index)=>{
                    if(item.graphic.attributes==null){
                      results.splice(index,1)
                    }
                  })

                  results.forEach((item,index)=>{

                  if(item.graphic.attributes.OBJECTID!==undefined){
                    this.graphicMarker.geometry = event.mapPoint
                    this.retrieveMapServerData(item.graphic.attributes.OBJECTID)
                    }
                  })

                 })
              })
          })
    },
    getThousands(x){
          return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
      
    },
    getDate(date){
      var d = new Date();
      d.setTime(date);
      return d
    },
    retrieveMapServerData(objectid){
      this.mapserverLoading = true
      axios({
        url:'https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases2_v1/FeatureServer/2/query?f=json&where=OBJECTID%3D'+objectid+'&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&returnGeodetic=false&outFields=*&returnGeometry=true&featureEncoding=esriDefault&multipatchOption=xyFootprint&maxAllowableOffset=&geometryPrecision=&outSR=&datumTransformation=&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=false&cacheHint=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&having=&resultOffset=&resultRecordCount=&returnZ=false&returnM=false&returnExceededLimitFeatures=true&quantizationParameters=&sqlFormat=none&token='
      }).then(res=>{
        console.log(res)
        this.currentAttribute = res.data.features[0].attributes
        console.log(this.currentAttribute)
      }).finally(res=>{
        this.mapserverLoading = false
      })
    }
  }
}
</script>

<style lang="scss">
#map {
    width:100%;
    height:100% !important;
}

.mapContainer {
    width:100%;
    height:600px;
}
.mapArea {
  position:relative;
  border-radius: 30px;
  overflow: hidden;
}

.section1 {
background: rgb(20,84,138);
background: radial-gradient(circle, rgba(20,84,138,1) 0%, rgba(32,76,134,1) 0%, rgba(0,0,0,1) 100%);
  min-height: 100vh;
}

.sectionTitle {
  font-size:2.5em;
  color:#fff;
  font-weight:900;
  display:flex;
  justify-content: center;
  letter-spacing: -1px;
  line-height:1;
}

.sectionSubtitle {
  font-size:1.5em;
  color:#fff;
  font-weight:300;
  display:flex;
  justify-content: center;
  letter-spacing: -1px;
  line-height:1;
}

.dataSourceLogo {
  display:flex;
  align-items: center;
  justify-content: center;
  div {
    width:150px;
    padding:10px;
    background-color:#fff;
    border-radius:10px;
    display:flex;
    align-items: center;
    justify-content: center;
    margin:10px;
    opacity:0.8;
    transition:0.3s;
    cursor:pointer;
    &:hover {
      opacity:1;
      transform:scale(1.1);
    }
    img {
      width:100%;
    }
  }
}

.sidebarInfo {
  font-size:0.8em;
  position:absolute;
  background-color:#fff;
  left:0;
  top:0;
  height:100%;
  width:200px;
  z-index:501;
  overflow-y:auto;
}
.country {
  font-weight: 900;
  font-size:1.5em;
}

.latestUpdate {
  padding:5px;
  color:#e8a34f;
  border-radius:10px;
  font-size:0.9em;
}
.dataSource {
  padding:5px;
  color:#000;
  border-radius:10px;
  font-size:0.9em;
}

.statisticData {
  width:100%;
  height:80px;
  color:#fff;
  border-radius:10px;
  display:flex;
  align-items: center;
  justify-content: center;
  .titleData {
  font-size:0.9em;
  }
  .valueData {
    font-size:2em;
    font-weight: bold;
  }
}

/* width */
::-webkit-scrollbar {
  width: 5px;
}

/* Track */
::-webkit-scrollbar-track {
  background: #f1f1f1; 
}
 
/* Handle */
::-webkit-scrollbar-thumb {
  background: #e3e3e3; 
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: #969695; 
}
</style>