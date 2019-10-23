function getOS() {
  var userAgent = window.navigator.userAgent,
      platform = window.navigator.platform,
      macosPlatforms = ['Macintosh', 'MacIntel', 'MacPPC', 'Mac68K'],
      windowsPlatforms = ['Win32', 'Win64', 'Windows', 'WinCE'],
      iosPlatforms = ['iPhone', 'iPad', 'iPod'],
      os = null;

  if (macosPlatforms.indexOf(platform) !== -1) {
    os = 'Mac OS';
  } else if (iosPlatforms.indexOf(platform) !== -1) {
    os = 'iOS';
  } else if (windowsPlatforms.indexOf(platform) !== -1) {
    os = 'Windows';
  } else if (/Android/.test(userAgent)) {
    os = 'Android';
  } else if (!os && /Linux/.test(platform)) {
    os = 'Linux';
  }

  return os;
}

$(function() {
    const currentOS = getOS();
    const baseURL = "https://ronockwebapi.azurewebsites.net/api/";


    var flyerID = 'f5e21081-bdde-45e6-8448-cbc5536a5c0f';
    var files = 'https://partnerdev.blob.core.windows.net/1ad5d117-c5e4-4886-b72a-b30cb41646c9/2019/Flyers/' + flyerID + '/DeepZoom/' + flyerID + '_files/';
    var width = '1280';
    var height = '3013';
    var format = 'jpg';
    var userId = '1ad5d117-c5e4-4886-b72a-b30cb41646c9';


    // for displaying debugging information
    const debugmode = true;

    const circle_url = new Image();
    circle_url.src = './orange_circle.png';

    $.get(baseURL + "flyer/FlyerSlices?businessReferenceID="+ userId +"&flyerId=" + flyerID, function(data, status) {

        data.map((slice, i) => {
            if (slice.Points != null) {

            //=============+ Start of Workaround +================
            for(var j in slice.Points){
                var currentPoint = slice.Points[j];
                var x1 = slice.Points[j].split(", ")[0];
                var y1 = slice.Points[j].split(", ")[1];
                data[i].Points[j] = {x: x1, y: y1};
                slice.Points[j] = {x: x1, y: y1};
            }
            //=============+ End of Workaround +================

                polyLines[i] = slice.Points;

                if (debugmode) {
                    Object.keys(polyLines).forEach(function(key) {
                        if (polyLines[key].Points != null) {
                            fillPolyline(polyLines[key].Points, ctx, "rgba(255,0,255,0.5)");

                        }
                    });
                }
            }
        });

        resources = data;

    });



    var imageSource = {
        Image: {
            xmlns: "http://schemas.microsoft.com/deepzoom/2009",
            Url: files,
            Format: format,
            Overlap: "1",
            TileSize: "256",
            Size: {
                Width: width,
                Height: height
            }
        }
    };

    var currentKey = 'shape1';

    //var image = new Image();

    var defaultZoom;
    var clipped = {};
    var clips = [];
    //isMobile
    var viewer = OpenSeadragon({
        id: "seadragon-viewer",
        prefixUrl: "./openseadragon/images/",
        tileSources: imageSource,
        zoomInButton: "zoom-in",
        zoomOutButton: "zoom-out",
        animationTime: 0.4,
        springStiffness: 20,
        panHorizontal: true,
        panVertical: true,
        visibilityRatio: 1
    });

    viewer.gestureSettingsMouse.clickToZoom = false;

    //resize = function () {
    //    console.log(image);
    //    $(canvas).attr('height', image.height).attr('width', image.width);
    //};

    //$(image).on('load', function () {
    //    console.log("image loaded");
    //    console.log(image);
    //    resize();
    //});


    Function.prototype.throttle = function(milliseconds, context) {

        //prevents calls to a function before the allotted time has been reached
        var baseFunction = this,
            lastEventTimestamp = null,
            limit = milliseconds;

        return function() {
            var self = context || this,
                args = arguments,
                now = Date.now();

            if (!lastEventTimestamp || now - lastEventTimestamp >= limit) {
                lastEventTimestamp = now;
                baseFunction.apply(self, args);
            }
        };
    };


    // events
    viewer.addHandler('open', function(event) {
        console.log("viewer opened");
        //web
        viewer.viewport.fitVertically(true);
        //mobile
        viewer.viewport.fitHorizontally(true);
        defaultZoom = viewer.viewport.getZoom(true);

        viewer.viewport.minZoomLevel = defaultZoom;
        viewer.viewport.applyConstraints();

    });

    viewer.addHandler("canvas-scroll", function(event) {
        if (debugmode) {
            console.log(viewer.viewport.getZoom(true));
        }

        if (viewer.viewport.getZoom(true) > viewer.viewport.minZoomLevel) {
            viewer.panVertical = true;
        } else {
            viewer.panVertical = false;
        }
    });


    viewer.addHandler('canvas-click', function(event) {

        // The canvas-click event gives us a position in web coordinates.
        var webPoint = event.position;

        // Convert that to viewport coordinates, the lingua franca of OpenSeadragon coordinates.
        var viewportPoint = viewer.viewport.pointFromPixel(webPoint);

        // Convert from viewport coordinates to image coordinates.
        var imagePoint = viewer.viewport.viewportToImageCoordinates(viewportPoint);
        var coords = imagePoint;
        Object.keys(resources).forEach(function(key) {
            if (isPointInPoly(resources[key].Points, coords)) {

                clipped = resources[key];
                $("#slice-id").val(clipped.ResourceGuid)

                if(currentOS == 'Android'){
                    JSInterface.clipSlice(clipped.ResourceGuid);
                }else if(currentOS == 'iOS'){
                    window.webkit.messageHandlers["clipSlice"].postMessage(clipped.ResourceGuid);
                }

                //mobile
                var sliceId = $("#slice-id").val();
                var myData = {
                    sliceId: sliceId
                };

                clipped.isClipped = true;

                if (clips.indexOf(clipped) === -1) {
                    clips.push(clipped);
                }

                if (clipped.isClipped) {
                    drawCircle(clipped);
                }

            } else {
                currentKey = 'none';
            }
        });

        // Show the results.
        console.log(webPoint.toString(), viewportPoint.toString(), imagePoint.toString());
    });

    window.unclip = function unclip(sliceID) {
        Object.keys(resources).forEach(function(key) {
            if (resources[key].ResourceGuid == sliceID) {
                resources[key].isClipped = false;
                clearCanvas();
            }
        })
    }


    //viewer controls
    $("#zoom-in").css({
        "display": "",
        "position": ""
    });
    $("#zoom-out").css({
        "display": "",
        "position": ""
    });

    var canvas = document.getElementById("seadragon-viewer").firstChild.nextSibling.firstChild.firstChild,
        ctx = viewer.drawer.context,
        polyLines = {},
        resources = [];


    var overlay = viewer.canvasOverlay({
        onRedraw: function() {},
        clearBeforeRedraw: true
    });



    $(window).resize(function() {
        overlay.resize();
        this.console.log("resize");
    });

    var sliceCtx = overlay.context2d();


    function fillPolyline(lines, ctxToDrawOn, fill) {
        ctxToDrawOn.fillStyle = fill;
        ctxToDrawOn.lineWidth = 3;
        ctxToDrawOn.beginPath();
        var firstPoint = imagePixelsToViewPortPixels(lines[0].x, lines[0].y);
        ctxToDrawOn.moveTo(firstPoint.x, firstPoint.y);
        for (var i = 0; i < lines.length; i++) {
            var nextPoint = imagePixelsToViewPortPixels(lines[i].x, lines[i].y);
            ctxToDrawOn.lineTo(nextPoint.x, nextPoint.y);
        }
        ctxToDrawOn.closePath();
        ctxToDrawOn.fill();
    }

    function imagePixelsToViewPortPixels(x, y) {
        var coordinates = viewer.viewport.imageToViewportCoordinates(x, y);
        var viewerviewportPixel = viewer.viewport.pixelFromPoint(coordinates);

        return viewerviewportPixel;
    }

    function clearCanvas() {
        //blasts the canvas data and draws the clipped items (if any)
        overlay.clear();
        for (var i = 0; i < clips.length; i++) {
            if (clips[i].isClipped) {
                drawCircle(clips[i]);
            }
        }
    }


    function isPointInPoly(poly, point) {

        if (poly == null) {
            return false;
        }

        //draw vectors from mouse location to detect of a given point is within a polygon
        var x = point.x,
            y = point.y;
        var inside = false;
        for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {

            var xi = poly[i].x,
                yi = poly[i].y;
            var xj = poly[j].x,
                yj = poly[j].y;
            var intersect = ((yi > y) != (yj > y)) &&
                (x < (xj - xi) * (y - yi) / (yj - yi) + xi);

            if (intersect) {

                inside = !inside;
            }
        }
        return inside;
    }

    function processHover(e) {

        //get the original key and the mouse coordinates
        ogkey = currentKey;
        coords = e;
        var BreakException = {};
        try {
            //detect which polygon the pointer is in (if any)
            Object.keys(polyLines).forEach(function(key) {
                if (isPointInPoly(polyLines[key], coords)) {

                    currentKey = key;
                    throw BreakException;

                } else {
                    currentKey = 'none';
                }
            });
        } catch (g) {
            if (g !== BreakException) throw g;
        }

        //only if the global currentKey value has changed will we redraw
        if (currentKey != ogkey) {
            if (currentKey != 'none') {
                fillPolyline(polyLines[currentKey], sliceCtx, "rgba(255,255,255,0.5)");
                canvas.style.cursor = 'pointer';


            } else {
                clearCanvas();
                canvas.style.cursor = 'default'
            }
        }

    }

    var updateZoom = function() {

        //drawCircle
        for (var i = 0; i < clips.length; i++) {
            if (clips[i].isClipped) {
                drawCircle(clips[i]);
            }

        }

    }

    viewer.addHandler('open', function() {

        var tracker = new OpenSeadragon.MouseTracker({
            element: viewer.container,
            moveHandler: function(event) {
                var webPoint = event.position;
                var viewportPoint = viewer.viewport.pointFromPixel(webPoint);
                var imagePoint = viewer.viewport.viewportToImageCoordinates(viewportPoint);

                processHover(imagePoint);

            },
        });

        tracker.setTracking(true);

        viewer.addHandler('animation', updateZoom);
    });


    function getMinX(array) {
        return array.reduce((min, p) => p.x < min ? p.x : min, array[0].x);
    }

    function getMaxX(array) {
        return array.reduce((max, p) => p.x > max ? p.x : max, array[0].x);
    }

    function getMinY(array) {
        return array.reduce((min, p) => p.y < min ? p.y : min, array[0].y);
    }

    function getMaxY(array) {
        return array.reduce((max, p) => p.y > max ? p.y : max, array[0].y);
    }


    function drawCircle(clipped) {
        var new_clipped = [];
        for (var i = 0; i < clipped.Points.length; i++) {
            new_clipped.push(imagePixelsToViewPortPixels(clipped.Points[i].x, clipped.Points[i].y));
        }

        var minX = getMinX(new_clipped);
        var maxX = getMaxX(new_clipped);
        var minY = getMinY(new_clipped);
        var maxY = getMaxY(new_clipped);

        for (var i = 0; i < new_clipped.length; i++) {
            if (new_clipped[i].x == minX) {
                image_y = new_clipped[i].y;
            }

            if (new_clipped[i].y == maxY) {
                image_max_x = new_clipped[i].x;
            }
        }

        image_width = maxX - minX;
        image_height = maxY - minY;


        var circle_x, circle_y, circle_width, circle_height;
        circle_x = minX - 30;
        circle_width = image_width + 60;
        circle_height = image_height + 60;


        // detect if the slice is a rect or a poly
        if (new_clipped.length > 4) {
            circle_y = minY - 30;
            sliceCtx.drawImage(circle_url, circle_x, circle_y, circle_width, circle_height);
        } else {
            circle_y = image_y - 30;
            sliceCtx.drawImage(circle_url, circle_x, circle_y, circle_width, circle_height);
        }

    };


    //debugging information
    if (debugmode) {

        function findObjectCoords(mouseEvent) {
            var obj = document.getElementById("seadragon-viewer");
            var obj_left = 0;
            var obj_top = 0;
            var xpos;
            var ypos;
            while (obj.offsetParent) {
                obj_left += obj.offsetLeft;
                obj_top += obj.offsetTop;
                obj = obj.offsetParent;
            }
            if (mouseEvent) {
                //FireFox
                xpos = mouseEvent.pageX;
                ypos = mouseEvent.pageY;
            } else {
                //IE
                xpos = window.event.x + document.body.scrollLeft - 2;
                ypos = window.event.y + document.body.scrollTop - 2;
            }
            xpos -= obj_left;
            ypos -= obj_top;
            document.getElementById("objectCoords").innerHTML = xpos + ", " + ypos;
        }
        document.getElementById("seadragon-viewer").onmousemove = findObjectCoords;
    }
});