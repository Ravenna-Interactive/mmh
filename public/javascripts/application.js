// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


Map = Class.create({
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
      hunt_map:this
    });
    
    this.rename_form = new Element('div', {id:'waypoint_rename_form'});
    this.rename_form.insert('<input type="text" value="" >\
    <a class="submit" href="#">Ok</a>\
    <a class="cancel" href="#">Cancel</a>');
    
    this.waypoint_list = settings.waypoint_list;
    if (this.waypoint_list) {
      
      var ok = this.rename_form.select('.submit').first();
      var cancel = this.rename_form.select('.cancel').first();
      var current_waypoint;
      var waypoint_list_item;
      var field = this.rename_form.select('input').first();
      this.renameCancel = (function(){
        this.rename_form.remove();
        this.ignore_shortcuts = false;
        Event.stopObserving(ok);
        Event.stopObserving(cancel);
      }).bind(this);
      
      this.renameSubmit = (function(){
        current_waypoint.attributes.name = field.getValue();
        waypoint_list_item.select('.name').first().update(current_waypoint.attributes.name);
        current_waypoint.save();
        this.rename_form.remove();
        this.ignore_shortcuts = true;
        Event.stopObserving(ok);
        Event.stopObserving(cancel);
      }).bind(this);
      
      
      this.waypoint_list.observe('click', (function(e){
        console.log("List clicked!");
        waypoint_list_item = e.target.hasClassName('waypoint') ? e.target : e.target.up('.waypoint');
        if (e.target != waypoint_list_item) {
          // doing something
          if (e.target.hasClassName('rename')) {
            // embed the rename form inside the waypoint element
            current_waypoint = this.waypoints.detect(function(w){
              return "waypoint_" + w.attributes.id == waypoint_list_item.identify();
            }, this);
            waypoint_list_item.insert(this.rename_form);
            field.focus();
            this.ignore_shortcuts = true;
            field.setValue(current_waypoint.attributes.name);
            field.select();
            
            cancel.observe('click', this.renameCancel);
            ok.observe('click', this.renameSubmit);
            
          };
        }else{
          //highlight the target
        }
        e.preventDefault();
      }).bind(this));
    };
    
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
    new Ajax.Request('/maps/' + this.id + '.json', {
      method: 'get',
      onSuccess:(function(response){
        this.attributes = response.responseJSON.map;
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
    var previous = null;
    this.waypoints = this.attributes.waypoints.collect(function(waypoint){
      var waypoint = new Waypoint({
        attributes: waypoint,
        hunt_map: this,
        map:this.map,
        position: new google.maps.LatLng(waypoint.lat, waypoint.lng)
      });
      if (previous){
        previous.next = waypoint;
        waypoint.previous = previous;
      }
      
      this.bounds.extend(waypoint.getPosition());
      waypoint.moveListenerObject = google.maps.event.addListener(waypoint.marker, 'position_changed', this.resetPath.bind(this));
      previous = waypoint;
      return waypoint;
    }, this);
    this.resetPath();
    this.fitMap()
  },
  startAddWayPoint:function(){
    this.infoWindow.close();
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
      hunt_map:this,
      map:this.map,
      position:latLng
    });
    
    waypoint.save();
    var last = this.lastWaypoint();
    if (last){
      last.setNext(waypoint);
    }
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
  },
  lastWaypoint:function(){
    return this.waypoints[this.waypoints.length-1];
  }
})

Waypoint = Class.create({
  initialize:function(settings){
    settings = Object.extend( { attributes: {} }, settings );
    this.attributes = settings.attributes;
    this.settings = settings;
    this.hunt_map = settings.hunt_map;
    this.map = settings.map
    
    var marker_image = new google.maps.MarkerImage('/images/marker.png')
    
    this.marker = new google.maps.Marker({
      map:this.map,
      icon:marker_image,
      position:settings.position,
      draggable:true
    });
    if (this.map) {
      this.marker.setAnimation(google.maps.Animation.DROP);        
    };
    this.positionListener = google.maps.event.addListener(this.marker, 'dragend', this.updatePosition.bind(this))
    this.clickListener = google.maps.event.addListener(this.marker, 'click', this.displayInfo.bind(this));
  },
  updatePosition:function(){
    if (this.hasNext()) {
      this.calculateDistances();
    };
    this.save();
    if (this.hasPrevious()) {
      this.previous.calculateDistances();
      this.previous.save();
    };
  },
  save:function(){
    var path, method, success;
    if (this.attributes.id) {
      path = "/waypoints/" + this.attributes.id + '.json';
      method = "PUT";
    }else{
      path = '/maps/' + this.hunt_map.id + '/waypoints.json';
      method = "POST";
      success = (function(response){
        Object.extend(this.attributes, response.responseJSON.waypoint);
        this.displayInfo();
        
        // now add the item to the list
        this.hunt_map.waypoint_list.insert(WaypointTemplate.evaluate(this.attributes));
        
      }).bind(this);
    }
    var pos = this.getPosition();
    this.attributes.lat = pos.lat();
    this.attributes.lng = pos.lng();
    
    var body = ['lat','lng','name', 'position', 'heading', 'distance'].inject({}, function(body, att){
      body['waypoint['+att+']'] = this.attributes[att];
      return body;
    }, this);
    
    
    new Ajax.Request(path, {
      method:method,
      parameters: body,
      onSuccess:success
    })
  },
  setNext:function(next){
    if (next == this.next) { return };
    this.next = next;
    if (next) next.previous = this;
    this.calculateDistances();
    
    this.save();
  },
  hasNext:function(){
    return this.next;
  },
  setPrevious:function(previous){
    this.previous = previous;
    if (previous) previous.next = this;
  },
  hasPrevious:function(){
    return this.previous;
  },
  setPosition:function(ll){
    this.marker.setPosition(ll);
  },
  getPosition:function(){
    return this.marker.getPosition();
  },
  calculateDistances:function(){
    if (this.hasNext()) {
      var distance = google.maps.geometry.spherical.computeDistanceBetween(this.getPosition(), this.next.getPosition());
      var heading = google.maps.geometry.spherical.computeHeading(this.getPosition(), this.next.getPosition());
      this.attributes.distance = distance;
      this.attributes.heading = heading;
    }else{
      this.attributes.distance = null;
      this.attributes.heading = null;
    }
    
    var waypoint;
    if(waypoint = this.getListItem()){
      if (this.hasNext()) {
        waypoint.select('.name').first().update(this.attributes.name);
        waypoint.select('.next_waypoint').first().update('\
        Next <span class="distance">' + FormatDistance(this.attributes.distance) + ' meters</span>\
        <span class="heading">' + FormatHeading(this.attributes.heading) + '</span>\
        ');
        
      }else{
        waypoint.select('.next_waypoint').first().update('Final Waypoint');
      }
    }
    
  },
  destroy:function(){
    
    // fix up the linked list
    if (this.previous) this.previous.setNext(this.next);
    
    this.marker.setMap(null);
    new Ajax.Request("/waypoints/" + this.attributes.id + '.json', {
      method:'delete'
    });
    
    this.getListItem().remove();
  },
  getListItem:function(){
    return $('waypoint_' + this.attributes.id);
  },
  displayInfo:function(){
    var content = new Element('div');
    var trash = new Element('a', {href:'#'});
    trash.insert('delete');
    var info = "<strong>" + this.attributes.name + "</strong>";
    if (this.hasNext()) {
      info = info + "<br/>Distance to next: <strong>" + FormatDistance(this.attributes.distance) + " meters</strong>";
      info = info + "<br/>Heading to next: <strong>" + FormatHeading(this.attributes.heading) + "&deg;</strong>";
    };
    content.insert(info);
    content.insert(trash);
    trash.observe('click', (function(e){ e.preventDefault(); this.hunt_map.removeWaypoint(this) }).bind(this));
    this.hunt_map.infoWindow.setContent(content);
    this.hunt_map.infoWindow.open(this.map, this.marker);
  }
})

var WaypointTemplate = new Template(
  '<div class="waypoint" id="waypoint_#{id}">\
    <div class="name">#{name}</div>\
    <div class="next_waypoint">\
      Final Waypoint\
    </div>\
    <div class="waypoint_options">\
      <a class="rename" href="#{url}">Rename</a>\
    </div>\
  </div>'
);

function FormatHeading(h){
  if (h < 0) h = h + 360;
  var formatted = Math.round(h);
  var ranges = [
    [-23, 23, 'N'],
    [23, 68, 'NE'],
    [68, 113, 'E'],
    [113, 157, 'SE'],
    [157, 203, 'S'],
    [203, 248, 'SW'],
    [248, 293, 'W'],
    [293, 338, 'NW'],
    [338, 360, 'N']  
  ];
  var range = ranges.detect(function(r){
    return h >= r[0] && h <= r[1];
  });
  if(!range) return;
  var heading = range[2];
  
  return formatted + "&deg;" + heading;
}

function FormatDistance(d){
  d = Math.round(d*10)/10;
  return d;
}