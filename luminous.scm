;  luminous-logo
;  Create a luminous text effect
;  (Based on alien-glow-logo.scm by Spencer Kimball)
;  $Id: luminous.scm,v 1.2 1998/08/03 07:32:00 p-katoh Exp $

(define (script-fu-luminous-logo text size font glow-color grow-strength background-color)
  (let ((old-fg (car (gimp-palette-get-foreground)))
	(old-bg (car (gimp-palette-get-background))))
    (gimp-palette-set-foreground '(255 255 255))
    (let* ((img (car (gimp-image-new 256 256 RGB)))
	   (border (/ size 4))
	   (grow (/ size grow-strength))
	   (feather (/ size 4))
	   (text-layer (car (gimp-text img -1 0 0 text border TRUE size PIXELS "*" font "*" "*" "*" "*")))
	   (width (car (gimp-drawable-width text-layer)))
	   (height (car (gimp-drawable-height text-layer)))
	   (bg-layer (car (gimp-layer-new img width height RGB_IMAGE "Background" 100 NORMAL)))
	   (glow-layer (car (gimp-layer-new img width height RGBA_IMAGE "Luminous Glow" 100 NORMAL))))
      (gimp-image-disable-undo img)
      (gimp-image-resize img width height 0 0)
      (gimp-image-add-layer img bg-layer 1)
      (gimp-image-add-layer img glow-layer 1)
      (gimp-layer-set-preserve-trans text-layer TRUE)
      (gimp-palette-set-background background-color)
      (gimp-edit-fill img bg-layer)
      (gimp-edit-clear img glow-layer)
      (gimp-selection-layer-alpha img text-layer)
      (gimp-selection-grow img grow)
      (gimp-selection-feather img feather)
      (gimp-palette-set-background glow-color)
      (gimp-edit-fill img glow-layer)
      (gimp-selection-none img)
      (gimp-layer-set-name text-layer text)
      (gimp-palette-set-background old-bg)
      (gimp-palette-set-foreground old-fg)
      (gimp-image-enable-undo img)
      (gimp-display-new img))))


(script-fu-register "script-fu-luminous-logo"
		    "<Toolbox>/Xtns/Script-Fu/Logos/Luminous"
		    "Create luminescent logo with the specified glow color"
		    "Takashi P.KATOH"
		    "Takashi P.KATOH"
		    "1998"
		    ""
		    SF-VALUE "Text String" "\"Luminous \""
		    SF-VALUE "Font Size (in pixels)" "150"
		    SF-VALUE "Font" "\"utopia\""
		    SF-COLOR "Glow Color" '(63 252 0)
		    SF-VALUE "Grow strength" "10"
		    SF-COLOR "Background" '(0 0 0))
