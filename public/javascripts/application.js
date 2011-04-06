// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Hunt = Class.create({
  initialize:function(id, settings){
    settings = Object.extend( { }, settings );
    this.id = id;
    this.settings = settings;
    this.map = settings.map;
    this.waypoints = [];
    this.path = new google.maps.Polyline({
      map: this.map,
      clickable:false,
      strokeOpacity:0.5
    });
    this.next_path = new google.maps.Polyline({
      clickable:false,
      strokeOpacity:0.25
    });
    this.next_waypoint =  new Waypoint({
      map:null
    });
    
    this.clickListener = this.clickListener.bind(this);
    this.dblclickListener = this.dblclickListener.bind(this);
    this.trackMouse = this.trackMouse.bind(this);
    this.editing = false;
    this.load();
    this.bounds = new google.maps.LatLngBounds();
    this.trackMouseObject = google.maps.event.addListener(this.map, 'mousemove', this.trackMouse);
    this.infoWindow = new google.maps.InfoWindow();
  },
  load:function(){
    new Ajax.Request('/hunts/' + this.id + '.json', {
      method: 'get',
      onSuccess:(function(response){
        this.attributes = response.responseJSON.hunt;
        if(this.attributes.waypoints.length > 0) this.setupWaypoints();
      }).bind(this)
    });
  },
  fitMap:function(){
    this.map.fitBounds(this.bounds);
  },
  closeWindow:function(){
    this.infoWindow.close();
  },
  setupWaypoints:function(){
    this.waypoints = this.attributes.waypoints.collect(function(waypoint){
      var waypoint = new Waypoint({
        attributes: waypoint,
        map: this.map,
        hunt: this,
        position: new google.maps.LatLng(waypoint.lat, waypoint.lng)
      });
      this.bounds.extend(waypoint.getPosition());
      waypoint.moveListenerObject = google.maps.event.addListener(waypoint.marker, 'position_changed', this.resetPath.bind(this));
      return waypoint;
    }, this);
    this.resetPath();
    this.fitMap()
  },
  startAddWayPoint:function(){
    this.clickListenerObject = google.maps.event.addListener(this.map, 'click', this.clickListener);
    this.dblclickListnerObject = google.maps.event.addListener(this.map, 'dblclick', this.dblclickListener);
    this.editing = true;
    this.next_path.setMap(this.map);
    this.next_waypoint.marker.setMap(this.map);
    google.maps.event.trigger(this.next_waypoint.marker, 'mousedown');
    
  },
  endAddWayPoint:function(){
    this.next_path.setMap(null);
    this.next_waypoint.marker.setMap(null);
    google.maps.event.removeListener(this.clickListenerObject);
    google.maps.event.removeListener(this.dblclickListnerObject);
    //google.maps.event.removeListener(this.trackMouseObject);
    this.editing = false;
    this.next_waypoint.marker.setMap(null);
    last_marker = this.waypoints[this.waypoints.length-1].marker;
  },
  addWaypoint:function(latLng){
    var waypoint =  new Waypoint({
      map:this.map,
      hunt:this,
      position:latLng
    });
    waypoint.save();
    this.waypoints.push(waypoint);
    this.bounds.extend(latLng);
    this.updatePath(latLng);
    waypoint.moveListenerObject = google.maps.event.addListener(waypoint.marker, 'position_changed', this.resetPath.bind(this));
    if (this.editing) {
      this.endAddWayPoint();        
    };
  },
  removeWaypoint:function(waypoint){
    waypoint.destroy();
    google.maps.event.removeListener(waypoint.moveListenerObject);
    this.waypoints = this.waypoints.reject(function(w){
      var same = (w == waypoint);
      return w == waypoint;
    });
    //rebuild bound
    this.resetPath();
  },
  resetPath:function(){
    this.path.setPath(this.waypointPath());
  },
  updatePath:function(latLng){
    this.path.getPath().push(latLng);
    this.next_path.setPath([latLng]);
  },
  clickListener:function(e){
    if(!this.click_timer){
      this.click_timer = setTimeout((function(){
        this.addWaypoint(e.latLng);
        this.click_timer = null;
      }).bind(this), 200);
    }
  },
  dblclickListener:function(){
    if (this.click_timer) {
      clearTimeout(this.click_timer);
      this.click_timer = null;
    };
  },
  trackMouse:function(e){
    this.next_waypoint.setPosition(e.latLng);
    if (this.waypoints.length == 0) { return };
    var path = [this.path.getPath().getAt(this.path.getPath().getLength()-1), e.latLng];
    this.next_path.setPath(path);
  },
  waypointPath:function(){
    return this.waypoints.collect(function(waypoint){
      return waypoint.getPosition();
    });
  }
})

Waypoint = Class.create({
  initialize:function(settings){
    settings = Object.extend( { attributes: {} }, settings );
    this.attributes = settings.attributes;
    this.settings = settings;
    this.hunt = settings.hunt;
    this.map = settings.map;
    
    var marker_image = new google.maps.MarkerImage('/images/marker.png')
    
    this.marker = new google.maps.Marker({
      map:this.map,
      icon:marker_image,
      position:settings.position,
      draggable:true
    });
    if (this.hunt) {
      this.marker.setAnimation(google.maps.Animation.DROP);        
    };
    this.positionListener = google.maps.event.addListener(this.marker, 'dragend', this.save.bind(this))
    this.clickListener = google.maps.event.addListener(this.marker, 'click', this.displayInfo.bind(this));
  },
  save:function(){
    var path, method;
    if (this.attributes.id) {
      path = "/waypoints/" + this.attributes.id + '.json';
      method = "PUT";
    }else{
      path = '/hunts/' + this.hunt.id + '/waypoints.json';
      method = "POST";
    }
    var pos = this.getPosition();
    this.attributes.lat = pos.lat();
    this.attributes.lng = pos.lng();
    
    var body = ['lat','lng','name', 'position'].inject({}, function(body, att){
      body['waypoint['+att+']'] = this.attributes[att];
      return body;
    }, this);
    
    
    new Ajax.Request(path, {
      method:method,
      parameters: body,
      onSuccess:(function(response){
        Object.extend(this.attributes, response.responseJSON.waypoint);
        this.displayInfo();
      }).bind(this)
    })
  },
  setPosition:function(ll){
    this.marker.setPosition(ll);
  },
  getPosition:function(){
    return this.marker.getPosition();
  },
  destroy:function(){
    this.marker.setMap(null);
    new Ajax.Request("/waypoints/" + this.attributes.id + '.json', {
      method:'delete',
      onSuccess:function(){
      }
    });
  },
  displayInfo:function(){
    var content = new Element('div');
    var trash = new Element('a', {href:'#'});
    trash.insert('delete');
    content.insert( "<strong>" + this.attributes.name + "</strong>" );
    content.insert(trash);
    trash.observe('click', (function(e){ e.preventDefault(); this.hunt.removeWaypoint(this) }).bind(this));
    this.hunt.infoWindow.setContent(content);
    this.hunt.infoWindow.open(this.map, this.marker);
  }
})
