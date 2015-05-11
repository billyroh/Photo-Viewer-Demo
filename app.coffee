# Background

backgroundColorLayer = new Layer
	x:0, y:0, width:750, height:1334, backgroundColor:"#000"
backgroundLayer = new Layer
	x:0, y:0, width:750, height:1334, image:"images/image1.PNG"
photoPlaceholderLayer = new Layer
		x:0, y:127, width:750, height:562, backgroundColor: "#3C3C3C"

# Photo Viewer

scroll = new ScrollComponent({
	width: Screen.width, 
	height: Screen.height - 1
})

scroll.contentInset = {
	bottom: 600
}

scroll.content.backgroundColor = "rgba(0,0,0,0)"
scroll.scrollHorizontal = false

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
	photoLayer.superLayer = scroll.content
	if index > 0
		previousPhoto = photoArray[index - 1]
		photoLayer.y = previousPhoto.y + previousPhoto.height + 20

photoArray[1].opacity = 0
photoArray[2].opacity = 0
photoArray[1].scale = 0.98
photoArray[2].scale = 0.98

# Photo Strip

photoStripWidth = 50

photoStripScroll = new ScrollComponent({
	x: Screen.width - photoStripWidth
	width: photoStripWidth, 
	height: Screen.height - 1
	backgroundColor: "rgba(0,0,0,0.2)"
	scrollHorizontal: false
})

photoStripLayer = new Layer
	x: 0, y: Screen.height / 2 - (photoStripWidth / 2), width: photoStripWidth, height: Screen.height, superLayer: photoStripScroll.content
	
positionIndicatorLayer = new Layer
	y: (photoStripScroll.height / 2) - (photoStripWidth / 2), width: photoStripWidth, height: photoStripWidth, superLayer: photoStripScroll.content, borderWidth: 4,
	borderColor: "yellow", backgroundColor: "none"

photoStripLayer.height = photoStripLayer.width * urlArray.length
photoStripScroll.contentInset = {
	bottom: Screen.height / 2
}

photoStripScroll.bringToFront()
positionIndicatorLayer.bringToFront()
photoPlaceholderLayer.superLayer = backgroundLayer
scroll.placeBefore(backgroundLayer)

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

scroll.content.states.add({
	enablePhotoViewer: {y: 0}
})

# Interaction

photoViewerIsEnabled = false
scroll.scrollVertical = false
photoArray[0].on Events.Click, (event, layer) ->
	if photoViewerIsEnabled
		photoArray[1].states.next("default", "enablePhotoViewer")
		photoArray[2].states.next("default", "enablePhotoViewer")
		scroll.content.states.next("default", "enablePhotoViewer")
		backgroundLayer.states.next("default", "enablePhotoViewer")
		scroll.scrollVertical = false
		photoViewerIsEnabled = false
	else
		backgroundLayer.states.next("default", "enablePhotoViewer")
		scroll.content.states.next("default", "enablePhotoViewer")
		Utils.delay 0.15, ->
			photoArray[1].states.next("default", "enablePhotoViewer")
		Utils.delay 0.3, ->
			photoArray[2].states.next("default", "enablePhotoViewer")
		scroll.scrollVertical = true
		photoViewerIsEnabled = true

scroll.on Events.Move, ->
	positionPhotoStrip()

photoStripScroll.on Events.Move, ->
	positionPhotoStrip()
	
positionPhotoStrip = ->
	progressPercentage = scroll.scrollY / scroll.content.height
	positionIndicatorLayer.y = photoStripScroll.scrollY + (photoStripScroll.height / 2) - (positionIndicatorLayer.width / 2)
	photoStripLayer.y = (Screen.height / 2 - (photoStripWidth / 2)) - (progressPercentage * photoStripLayer.height)
	
positionPhotoViewer = ->
	progressPercentage = photoStripScroll.scrollY / photoStripScroll.content.height
	
	
	
# 	print scroll.scrollY
#     if Math.abs(scroll.velocity.y) > 5
#     	123