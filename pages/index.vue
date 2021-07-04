<template>
<div>
  <div class="section1">
    <v-container>
      
        <div class="sectionTitle mt-10 text-center">
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
                  <div class="valueData text-center" v-else>-</div>
                </div>
              </div>

              <div class="statisticData mt-5" style="background-color:#5c248c">
                <div>
                  <div class="titleData text-center">Confirmed</div>
                  <div class="valueData text-center" v-if="currentAttribute.Confirmed!==null">{{getThousands(currentAttribute.Confirmed)}}</div>
                  <div class="valueData text-center" v-else>-</div>
                </div>
              </div>

              <div class="statisticData mt-5" style="background-color:#4287f5">
                <div>
                  <div class="titleData text-center">Recovered</div>
                  <div class="valueData text-center" v-if="currentAttribute.Recovered!==null">{{getThousands(currentAttribute.Recovered)}}</div>
                  <div class="valueData text-center" v-else>-</div>
                </div>
              </div>

              <div class="statisticData mt-5" style="background-color:#4a4a4a">
                <div>
                  <div class="titleData text-center">Death</div>
                  <div class="valueData text-center" v-if="currentAttribute.Deaths!==null">{{getThousands(currentAttribute.Deaths)}}</div>
                  <div class="valueData text-center" v-else>-</div>
                </div>
              </div>

              <div class="statisticData mt-5" style="background-color:#ff9729">
                <div>
                  <div class="titleData text-center">Active</div>
                  <div class="valueData text-center" v-if="currentAttribute.Active!==null">{{getThousands(currentAttribute.Active)}}</div>
                  <div class="valueData text-center" v-else>-</div>
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

  <div class="section2 pt-10">
    <div style="display:flex;flex-flow:column;justify-content:center;align-items:center">
      <div class="sectionTitle2 mt-10 px-3 text-center">
        Discover Latest COVID-19 News
      </div>
      <div class="separatorGreen my-5"></div>
      <div class="px-10 text-center" style="max-width:600px">
        <div>
          <div>
            <v-autocomplete :loading="newsLoading" solo rounded :items="countryList" item-text="name" v-model="selectedCountry" return-object @change="retrieveNewsData(selectedCountry.code)"></v-autocomplete>
          </div>
        </div>
      </div>
    </div>
    <v-container>
      <v-row>
        <v-col md="6" cols="12" lg="6" xl="6" v-for="item,index in newsData.slice(0,8)" :key="index" @click="goToLink(item.url)">
          <div class="newsArea pa-3 fill-height">
            <div>
              <div class="newsTitle">{{item.title}}</div>
              <div class="newsAuthor"><b><a>{{item.source}}</a></b> | author: <b>{{item.author}}</b></div>
            </div>
            <div class="newsDescription my-3">{{item.description}}</div>
            <div>{{getDateDDMMYYYY(item.published_at)}}</div>
          </div>
        </v-col>
        <v-col cols="12">
          <div style="color:#fff" class="text-center" v-if="newsData.length==0">News not found.</div>
        </v-col>
      </v-row>
    </v-container>
  </div>

  <div class="section3 pb-10">

    <v-container>
      <v-row>
        <v-col cols="12" class="d-flex justify-center">
          <div>
          <div class="sectionTitle2 mt-10">
            Be Inspired: Covid-19 Updates
          </div>
          <div>Check out the latest inspiring post related to covid-19 from international organization</div>
          <div class="separatorGreen my-5 mx-auto"></div>
          </div>
        </v-col>
      </v-row>
      <v-row>
          <v-col cols="12" md="4" lg="4" xl="4">
            <div class="pa-5 elevation-2" style="border-radius:30px">
              <iframe style="width:100%;height:600px" src="https://www.instagram.com/p/CQvNTNQj67X/embed" frameBorder="0"></iframe>
            </div>
          </v-col>
          <v-col cols="12" md="4" lg="4" xl="4">
            <div class="pa-5 elevation-2" style="border-radius:30px">
              <iframe style="width:100%;height:600px" src="https://www.instagram.com/p/CQ3iRC-tLk0/embed" frameBorder="0"></iframe>
            </div>
          </v-col>
          <v-col cols="12" md="4" lg="4" xl="4">
            <div class="pa-5 elevation-2" style="border-radius:30px">
              <iframe style="width:100%;height:600px" src="https://www.instagram.com/p/CQ1vGmpskJv/embed" frameBorder="0"></iframe>
            </div>
          </v-col>
          <v-col cols="12" md="4" lg="4" xl="4">
            <div class="pa-5 elevation-2" style="border-radius:30px">
              <iframe style="width:100%;height:600px" src="https://www.instagram.com/p/CQ1KxZ2niwh/embed" frameBorder="0"></iframe>
            </div>
          </v-col>
          <v-col cols="12" md="4" lg="4" xl="4">
            <div class="pa-5 elevation-2" style="border-radius:30px">
              <iframe style="width:100%;height:600px" src="https://www.instagram.com/p/CQjJPHmoUxT/embed" frameBorder="0"></iframe>
            </div>
          </v-col>
          <v-col cols="12" md="4" lg="4" xl="4">
            <div class="pa-5 elevation-2" style="border-radius:30px">
              <iframe style="width:100%;height:600px" src="https://www.instagram.com/p/CQmAtiDBGYw/embed" frameBorder="0"></iframe>
            </div>
          </v-col>
      </v-row>
    </v-container>
  </div>

  <div class="section4 pa-10 text-center">
    <i>This website is under development. if you have any suggestions please email me at <b>brahmaputra1996@gmail.com</b></i>
  </div>
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
      mapserverLoading:false,
      newsData:[],
      newsLoading:false,
      selectedCountry:{
        name:'United States',
        code:'us'
      },
      countryList:[
        {
          name:'Argentine',
          code:'ar'
        },
        {
          name:'Australia',
          code:'au'
        },
        {
          name:'Austria',
          code:'at'
        },
        {
          name:'Belgium',
          code:'be'
        },
        {
          name:'Brazil',
          code:'br'
        },
        {
          name:'Bulgaria',
          code:'bg'
        },
        {
          name:'Canada',
          code:'cn'
        },
        {
          name:'Colombia',
          code:'co'
        },
        {
          name:'Czech Republic',
          code:'cz'
        },
        {
          name:'Egypt',
          code:'eg'
        },
        {
          name:'France',
          code:'fr'
        },
        {
          name:'Germany',
          code:'de'
        },
        {
          name:'Greece',
          code:'ge'
        },
        {
          name:'Hongkiong',
          code:'hk'
        },
        {
          name:'Hungary',
          code:'hu'
        },
        {
          name:'India',
          code:'in'
        },
        {
          name:'Indonesia',
          code:'id'
        },
        {
          name:'Ireland',
          code:'ie'
        },
        {
          name:'Israel',
          code:'il'
        },
        {
          name:'Italy',
          code:'it'
        },
        {
          name:'Japan',
          code:'jp'
        },
        {
          name:'Latvia',
          code:'lv'
        },
        {
          name:'Lithuania',
          code:'lt'
        },
        {
          name:'Malaysia',
          code:'my'
        },
        {
          name:'Mexico',
          code:'mx'
        },
        {
          name:'Morocco',
          code:'ma'
        },
        {
          name:'Netherlands',
          code:'nl'
        },
        {
          name:'New Zealand',
          code:'nz'
        },
        {
          name:'Nigeria',
          code:'ng'
        },
        {
          name:'Norway',
          code:'no'
        },
        {
          name:'Phillipines',
          code:'ph'
        },
        {
          name:'Poland',
          code:'pl'
        },
        {
          name:'Portugal',
          code:'pt'
        },
        {
          name:'Romania',
          code:'ro'
        },
        {
          name:'Saudi Arabia',
          code:'sa'
        },
        {
          name:'Serbia',
          code:'rs'
        },
        {
          name:'Singapore',
          code:'sg'
        },
        {
          name:'Slovakia',
          code:'sa'
        },
        {
          name:'Slovenia',
          code:'si'
        },
        {
          name:'South Africa',
          code:'za'
        },
        {
          name:'South Korea',
          code:'kr'
        },
        {
          name:'Sweden',
          code:'se'
        },
        {
          name:'Switzterland',
          code:'ch'
        },
        {
          name:'Taiwan',
          code:'tw'
        },
        {
          name:'Thailand',
          code:'th'
        },
        {
          name:'Turkey',
          code:'tr'
        },
        {
          name:'UAE',
          code:'ae'
        },
        {
          name:'Ukraine',
          code:'ua'
        },
        {
          name:'United Kingdom',
          code:'gb'
        },
        {
          name:'United States',
          code:'us'
        },
        {
          name:'Venezuela',
          code:'ve'
        },
      ]
    }
  },
  created(){
    this.retrieveNewsData('us')
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
                    basemap: {
                  portalItem: {
                    id: "8d91bd39e873417ea21673e0fee87604"
                  }
                },
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
    getDateDDMMYYYY(date) {
      const monthNames = ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"];
      const dateObj = new Date(date);
      const month = monthNames[dateObj.getMonth()];
      const day = String(dateObj.getDate()).padStart(2, '0');
      const year = dateObj.getFullYear();
      const output = month  + '\n'+ day  + ',' + year;
      return output
    },
    retrieveMapServerData(objectid){
      this.mapserverLoading = true
      axios({
        url:'https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases2_v1/FeatureServer/2/query?f=json&where=OBJECTID%3D'+objectid+'&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&returnGeodetic=false&outFields=*&returnGeometry=true&featureEncoding=esriDefault&multipatchOption=xyFootprint&maxAllowableOffset=&geometryPrecision=&outSR=&datumTransformation=&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=false&cacheHint=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&having=&resultOffset=&resultRecordCount=&returnZ=false&returnM=false&returnExceededLimitFeatures=true&quantizationParameters=&sqlFormat=none&token='
      }).then(res=>{
        console.log(res)
        this.currentAttribute = res.data.features[0].attributes
        if(this.currentAttribute.ISO3!==null){
          this.retrieveNewsData(this.selectedCountry.code)
        }
        console.log(this.currentAttribute.ISO3)
      }).finally(res=>{
        this.mapserverLoading = false
      })
    },
    retrieveNewsData(country){
      this.newsLoading=true
      axios({
        url:'http://api.mediastack.com/v1/news?access_key=bcba5256e5d15feb335b6645a81fb555&languages=en&countries='+country+'&keywords=covid'
      }).then(res=>{
        this.newsData = res.data.data
        this.newsData.forEach((item,index)=>{
          if(item.source=='lewrockwell'){
            this.newsData.splice(index,1)
          }
        })
        console.log(this.newsData)
      }).finally(res=>{
        this.newsLoading = false
      })
    },
    goToLink(url){
      window.open(url,"_blank")
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
  height:600px;
  background-color:#fff;
}

.section1 {
background: rgb(20,84,138);
background: radial-gradient(circle, rgba(20,84,138,1) 0%, rgba(32,76,134,1) 0%, rgba(0,0,0,1) 100%);
  min-height: 100vh;
  padding-bottom:100px;
}
.section2 {
background: rgb(32,32,32);
background: linear-gradient(180deg, rgba(32,32,32,1) 0%, rgba(15,14,145,1) 100%);
  min-height: 100vh;
  padding-bottom:100px;
}

.sectionTitle2 {
  font-size:2.5em;
  font-weight:900;
  display:flex;
  justify-content: center;
  letter-spacing: -1px;
  line-height:1;
  background: rgb(38,156,255);
  background: linear-gradient(58deg, rgba(38,156,255,1) 0%, rgba(235,118,255,1) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.sectionTitle {
  font-size:2.5em;
  color:#fff;
  font-weight:900;
  display:flex;
  justify-content: center;
  letter-spacing: -1px;
  line-height:1;
  background: rgb(38,156,255);
  background: linear-gradient(58deg, rgba(38,156,255,1) 0%, rgba(235,118,255,1) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
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

.separatorGreen {
  width:250px;
  height:5px;
  border-radius:10px;background: rgb(20,84,138);
background: linear-gradient(58deg, rgba(20,84,138,1) 0%, rgba(189,93,206,1) 100%);
}

.newsArea {
  &:hover {
    transform:scale(1.1);
    background: rgb(113,24,117);
    background: linear-gradient(270deg, rgba(113,24,117,1) 0%, rgba(14,45,145,1) 100%);
  }
  transition:0.3s;
  box-shadow: 2px 10px 18px 0px rgba(0,0,0,0.21);
  -webkit-box-shadow: 2px 10px 18px 0px rgba(0,0,0,0.21);
  -moz-box-shadow: 2px 10px 18px 0px rgba(0,0,0,0.21);
  border-radius:20px;
  display:flex;
  flex-flow:column wrap;
  justify-content: space-between;
  color:#fff;
  background-color:#000;
  cursor:pointer;
  }

.newsTitle {
  font-weight: bold;
  font-size:1.2em;
  line-height: 1;
}

.newsAuthor {
  font-size:0.6em;
}

.newsDescription {
  font-size:0.8em;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;  
  overflow: hidden;
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