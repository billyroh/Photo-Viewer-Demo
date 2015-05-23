# Background

firstPhotoYOffset = 127

backgroundColorLayer = new Layer
	x:0, y:0, width:750, height:1334, backgroundColor:"#000"
backgroundLayer = new Layer
	x:0, y:0, width:750, height:1334, image:"images/image1.PNG"
photoPlaceholderLayer = new Layer
	x:0, y:firstPhotoYOffset, width:750, height:562, backgroundColor: "#3C3C3C"
photoViewerNavigationController = new Layer
	x:0, y:0, width:750, height:208, image:"images/iPhone 6.png", opacity: 0

# Navigation Viewer

closeButton = new Layer({
	x: 0
	y: 30
	width: 100
	height: 100
	opacity: 0
	superLayer: photoViewerNavigationController
})

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
thumbnailArray = []

for url in urlArray
	photoLayer = new Layer
		x:0, y:firstPhotoYOffset, width:750, height:562, image:url
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
	x: Screen.width + 20
	width: photoStripWidth
	height: Screen.height
	backgroundColor: "none"
	shadowBlur: 20
	shadowX: 0
	shadowColor: "rgba(0,0,0,0.5)"
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

for url in urlArray
	thumbnailLayer = new Layer
		x:0, y:0, height:photoStripWidth, image:url
	thumbnailArray.push thumbnailLayer

for thumbnailLayer, index in thumbnailArray
	thumbnailLayer.superLayer = photoStripLayer
	if index > 0
		previousThumbnail = thumbnailArray[index - 1]
		thumbnailLayer.y = previousThumbnail.y + thumbnailLayer.height

photoStripScroll.bringToFront()
positionIndicatorLayer.bringToFront()
photoStripWrapper.bringToFront()
photoPlaceholderLayer.superLayer = backgroundLayer
photoViewerScroll.placeBefore(backgroundLayer)
photoViewerNavigationController.bringToFront()

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

photoViewerNavigationController.states.add({
	enablePhotoViewer: {opacity: 1}
})

# Interaction

photoViewerIsEnabled = false
photoViewerScroll.scrollVertical = false
photoArray[0].on Events.Click, (event, layer) ->
	togglePhotoViewer()
	
photoViewerNavigationController.on Events.Click, (event, layer) ->
	togglePhotoViewer()

togglePhotoViewer = ->
	if photoViewerIsEnabled
		if photoStripWrapper.states.current is "enablePhotoStrip"
			photoStripWrapper.states.switch("default")
			Utils.delay 0.2, ->
				hidePhotoViewer()
		else
			hidePhotoViewer()
	else
		showPhotoViewer()

hidePhotoViewer = ->
	photoArray[1].states.switch("default")
	photoArray[2].states.switch("default")
	photoViewerScroll.content.states.switch("default")
	backgroundLayer.states.switch("default")
	photoViewerNavigationController.states.switch("default")
	photoViewerScroll.scrollVertical = false
	photoViewerIsEnabled = false

showPhotoViewer = ->
	backgroundLayer.states.switch("enablePhotoViewer")
	photoViewerScroll.content.states.switch("enablePhotoViewer")
	Utils.delay 0.15, ->
		photoViewerNavigationController.states.switch("enablePhotoViewer")
		photoArray[1].states.switch("enablePhotoViewer")
	Utils.delay 0.3, ->
		photoArray[2].states.switch("enablePhotoViewer")
	photoViewerScroll.scrollVertical = true
	photoViewerIsEnabled = true

lastScrubTime = null
delayAmount = 1.5
minimumVelocity = 5
numberOfFastSwipes = 0
numberOfFastSwipesThreshold = 1

photoViewerScroll.on Events.ScrollAnimationDidStart, ->
	if Math.abs(photoViewerScroll.velocity.y) > minimumVelocity
		numberOfFastSwipes += 1
	else
		numberOfFastSwipes = 0
	if numberOfFastSwipes > numberOfFastSwipesThreshold
		showPhotoStrip()

photoViewerScroll.on Events.Move, ->
	positionPhotoStrip()

photoStripScroll.on Events.Move, ->
	positionPhotoViewer()
	showPhotoStrip()
	
positionPhotoStrip = ->
	progressPercentage = photoViewerScroll.scrollY / photoViewerScroll.content.height
	photoStripScroll.scrollY = progressPercentage * (photoStripScroll.height + photoStripScroll.contentInset.top - firstPhotoYOffset)
	
positionPhotoViewer = ->
	progressPercentage = photoStripScroll.scrollY / photoStripScroll.content.height
	photoViewerScroll.scrollY = progressPercentage * photoViewerScroll.content.height
	if progressPercentage <= 0
		photoViewerScroll.velocity.y = photoStripScroll.velocity.y
	
showPhotoStrip = ->
	photoStripWrapper.states.switch("enablePhotoStrip")
	currentDate = new Date
	lastScrubTime = currentDate.getTime()
	hidePhotoStrip()

hidePhotoStrip = ->
	Utils.delay delayAmount, ->
		currentDate = new Date
		if ((currentDate.getTime() - lastScrubTime) / 1000 >= delayAmount)
			photoStripWrapper.states.switch("default")
			numberOfFastSwipes = 0

checkTimeSinceLastScrub = ->
	currentDate = new Date
	if currentDate.getTime()
		return