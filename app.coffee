# Background

backgroundColorLayer = new Layer
	x:0, y:0, width:750, height:1334, backgroundColor:"#000"
backgroundLayer = new Layer
	x:0, y:0, width:750, height:1334, image:"images/image1.PNG"
photoPlaceholderLayer = new Layer
		x:0, y:127, width:750, height:562, backgroundColor: "#3C3C3C"

# Photo Viewer

photoViewerScroll = new ScrollComponent({
	width: Screen.width, 
	height: Screen.height - 1
})

photoViewerScroll.contentInset = {
	bottom: 600
}

photoViewerScroll.content.backgroundColor = "rgba(0,0,0,0)"
photoViewerScroll.scrollHorizontal = false

urlArray = ["images/IS5ee67u5c6pwx1000000000.jpg",
			"images/IS5ixv67gq1mkx1000000000.jpg",
			"images/IS9d8kq31v68kx1000000000.jpg", 
			"images/IS9toj5hzt4xkx1000000000.jpg", 
			"images/IS995jkuxs2mlx1000000000.jpg", 
			"images/IS17688xwmyakx1000000000.jpg",
			"images/ISd4g74rix78lx1000000000.jpg",
			"images/ISdoz7pdky9jkx1000000000.jpg", 
			"images/IShf7v2121bjlx1000000000.jpg",
			"images/IShjaw8a53f5kx1000000000.jpg",
			"images/IShzqvnn32dukx1000000000.jpg",
			"images/ISlaijmxm5g5lx1000000000.jpg",
			"images/IShf7v2121bjlx1000000000.jpg",
			"images/IShjaw8a53f5kx1000000000.jpg",
			"images/IShzqvnn32dukx1000000000.jpg",
			"images/ISlaijmxm5g5lx1000000000.jpg",
			"images/ISlu1k7ko6igkx1000000000.jpg",
			"images/ISpl97l769jglx1000000000.jpg",
			"images/ISppc8rg9bn2kx1000000000.jpg",
			"images/ISt04wpqseqdkx1000000000.jpg",
			"images/IStgkv44rdo2lx1000000000.jpg",
			"images/ISxbvjo0citokx1000000000.jpg",
			"images/IS9toj5hzt4xkx1000000000.jpg", 
			"images/IShzqvnn32dukx1000000000.jpg",
			"images/ISlaijmxm5g5lx1000000000.jpg",
			"images/IShf7v2121bjlx1000000000.jpg",
			"images/IShjaw8a53f5kx1000000000.jpg",
			"images/IShzqvnn32dukx1000000000.jpg",
			"images/ISlaijmxm5g5lx1000000000.jpg",
			"images/ISlu1k7ko6igkx1000000000.jpg",
			"images/ISpl97l769jglx1000000000.jpg",
			"images/ISppc8rg9bn2kx1000000000.jpg",
			"images/ISt04wpqseqdkx1000000000.jpg",
			"images/IStgkv44rdo2lx1000000000.jpg",
			"images/ISxbvjo0citokx1000000000.jpg",
			"images/IS9toj5hzt4xkx1000000000.jpg", 
			]

photoArray = []

for url in urlArray
	photoLayer = new Layer
		x:0, y:127, width:750, height:562, image:url
	photoArray.push photoLayer

for photoLayer, index in photoArray
	photoLayer.superLayer = photoViewerScroll.content
	if index > 0
		previousPhoto = photoArray[index - 1]
		photoLayer.y = previousPhoto.y + previousPhoto.height + 20

photoArray[1].opacity = 0
photoArray[2].opacity = 0
photoArray[1].scale = 0.98
photoArray[2].scale = 0.98

# Photo Strip

photoStripWidth = 50

photoStripWrapper = new Layer({
	x: Screen.width
	width: photoStripWidth
	height: Screen.height
	backgroundColor: "none"
})

photoStripScroll = new ScrollComponent({
	width: photoStripWidth, 
	height: Screen.height - 1
	backgroundColor: "rgba(0,0,0,0.2)"
	scrollHorizontal: false
	superLayer: photoStripWrapper
})

photoStripLayer = new Layer({
	width: photoStripWidth
	height: Screen.height
	superLayer: photoStripScroll.content
})
	
positionIndicatorLayer = new Layer({
	y: Screen.height / 2
	width: photoStripWidth
	height: photoStripWidth
	superLayer: photoStripWrapper
	borderWidth: 4,
	borderColor: "yellow"
	backgroundColor: "none"
})

photoStripLayer.height = photoStripLayer.width * urlArray.length
photoStripScroll.contentInset = {
	top: Screen.height / 2
	bottom: Screen.height / 2 - photoStripLayer.width
}

photoStripScroll.bringToFront()
positionIndicatorLayer.bringToFront()
photoStripWrapper.bringToFront()
photoPlaceholderLayer.superLayer = backgroundLayer
photoViewerScroll.placeBefore(backgroundLayer)

# States

Framer.Defaults.Animation = {
    curve: "spring(120, 15, 0)"
}

backgroundLayer.states.add({
	enablePhotoViewer: {scale: 0.98, opacity: 0.1}
})

photoArray[1].states.add({
	enablePhotoViewer: {scale: 1, opacity: 1}
})

photoArray[2].states.add({
	enablePhotoViewer: {scale: 1, opacity: 1}
})

photoViewerScroll.content.states.add({
	enablePhotoViewer: {y: 0}
})

photoStripWrapper.states.add({
	enablePhotoStrip: {x: Screen.width - photoStripWrapper.width}
})

# Interaction

photoViewerIsEnabled = false
photoViewerScroll.scrollVertical = false
photoArray[0].on Events.Click, (event, layer) ->
	if photoViewerIsEnabled
		photoArray[1].states.next("default", "enablePhotoViewer")
		photoArray[2].states.next("default", "enablePhotoViewer")
		photoViewerScroll.content.states.next("default", "enablePhotoViewer")
		backgroundLayer.states.next("default", "enablePhotoViewer")
		photoViewerScroll.scrollVertical = false
		photoViewerIsEnabled = false
	else
		backgroundLayer.states.next("default", "enablePhotoViewer")
		photoViewerScroll.content.states.next("default", "enablePhotoViewer")
		Utils.delay 0.15, ->
			photoArray[1].states.next("default", "enablePhotoViewer")
		Utils.delay 0.3, ->
			photoArray[2].states.next("default", "enablePhotoViewer")
		photoViewerScroll.scrollVertical = true
		photoViewerIsEnabled = true

isScrollingQuickly = false
isScrubbingPhotoStrip = false

photoViewerScroll.on Events.Move, ->
	positionPhotoStrip()
	showPhotoStrip()
	
photoViewerScroll.on Events.ScrollAnimationDidEnd, ->
	hidePhotoStrip()

photoStripScroll.on Events.Move, ->
	isScrubbingPhotoStrip = true
	positionPhotoViewer()
	showPhotoStrip()
	
photoStripScroll.on Events.ScrollAnimationDidEnd, ->
	isScrubbingPhotoStrip = false
	
positionPhotoStrip = ->
	progressPercentage = photoViewerScroll.scrollY / photoViewerScroll.content.height
	photoStripScroll.scrollY = progressPercentage * (photoStripScroll.height + (Screen.height / 2))
	
positionPhotoViewer = ->
	progressPercentage = photoStripScroll.scrollY / photoStripScroll.content.height
	photoViewerScroll.scrollY = progressPercentage * photoViewerScroll.content.height
	
# TODO Get time between current and last swipe. If it's less than n seconds, persist photo strip.
	
showPhotoStrip = ->
	if Math.abs(photoViewerScroll.velocity.y) > 5
		photoStripWrapper.states.switch("enablePhotoStrip")
		isScrollingQuickly = true
	else
		isScrollingQuickly = false

hidePhotoStrip = ->
	if isScrollingQuickly or isScrubbingPhotoStrip
		return
	Utils.delay 0.3, ->
		photoStripWrapper.states.switch("default")