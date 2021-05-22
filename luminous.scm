;;; luminous-logo
;;; Create a luminous text effect
;;; (Based on alien-glow-logo.scm by Spencer Kimball)

(define (apply-luminous-logo-effect img
                                    logo-layer
                                    feather
                                    luminous-color
                                    grow
                                    background-color)
  (let* ((width (car (gimp-drawable-width logo-layer)))
         (height (car (gimp-drawable-height logo-layer)))
         (bg-layer (car (gimp-layer-new img
                                        width height RGB-IMAGE
                                        "Background" 100 NORMAL-MODE)))
         (luminous-layer (car (gimp-layer-new img
                                              width height RGBA-IMAGE
                                              "Luminous" 100 NORMAL-MODE))))
    (gimp-context-push)
    (gimp-context-set-defaults)
    (gimp-selection-none img)
    (script-fu-util-image-resize-from-layer img logo-layer)
    (script-fu-util-image-add-layers img luminous-layer bg-layer)
    (gimp-layer-set-lock-alpha logo-layer TRUE)
    (gimp-context-set-background background-color)
    (gimp-edit-fill bg-layer BACKGROUND-FILL)
    (gimp-edit-clear luminous-layer)
    (gimp-image-select-item img CHANNEL-OP-REPLACE logo-layer)
    (gimp-selection-grow img grow)
    (gimp-selection-feather img feather)
    (gimp-context-set-foreground luminous-color)
    (gimp-edit-fill luminous-layer FOREGROUND-FILL)
    (gimp-selection-none img)
    (gimp-context-pop)))

(define (script-fu-luminous-logo-alpha img
                                       logo-layer
                                       luminous-color
                                       feather
                                       grow
                                       background-color)
  (begin
    (gimp-image-undo-group-start img)
    (apply-luminous-logo-effect img logo-layer feather luminous-color grow background-color)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)))

(script-fu-register "script-fu-luminous-logo-alpha"
                    _"Luminous..."
                    _"Add a luminous effect around the selected region (or alpha)"
                    "Takashi P. KATO(H)"
                    "Takashi P. KATO(H)"
                    "1998"
                    "RGBA"
                    SF-IMAGE       "Image"          0
                    SF-DRAWABLE    "Drawable"       0
                    SF-COLOR      _"Luminous color" '(63 252 0)
                    SF-ADJUSTMENT _"Feather size"   '(50 2 1000 1 10 0 1)
                    SF-ADJUSTMENT _"Grow steps"     '(10 2 1000 1 10 0 1)
                    SF-COLOR      _"Background"     (car (gimp-palette-get-background)))

(script-fu-menu-register "script-fu-luminous-logo-alpha"
                         "<Image>/Filters/Alpha to Logo")

(define (script-fu-luminous-logo text
                                 font
                                 size
                                 foreground-color
                                 background-color
                                 luminous-color
				 feather
                                 grow)
  (gimp-context-push)
  (gimp-context-set-foreground foreground-color)
  (let* ((img (car (gimp-image-new 256 256 RGB)))
         (border (+ feather grow))
         (text-layer (car (gimp-text-fontname img
                                              -1 0 0 text border TRUE
                                              size PIXELS font)))
         (width (car (gimp-drawable-width text-layer)))
         (height (car (gimp-drawable-height text-layer))))
    (gimp-image-undo-disable img)
    (apply-luminous-logo-effect img text-layer feather luminous-color grow background-color)
    (gimp-image-undo-enable img)
    (gimp-display-new img))
  (gimp-context-pop))

(script-fu-register "script-fu-luminous-logo"
                    _"Luminous..."
                    _"Create a logo with a luminous text effect"
                    "Takashi P. KATO(H)"
                    "Takashi P. KATO(H)"
                    "1998"
                    ""
                    SF-STRING     _"Text"               "Luminous"
                    SF-FONT       _"Font"               "Sans Bold"
                    SF-ADJUSTMENT _"Font size (pixels)" '(100 2 1000 1 10 0 1)
                    SF-COLOR      _"Text color"         (car (gimp-palette-get-foreground))
                    SF-COLOR      _"Background"         (car (gimp-palette-get-background))
                    SF-COLOR      _"Luminous color"     '(63 252 0)
                    SF-ADJUSTMENT _"Feather size"       '(50 2 1000 1 10 0 1)
                    SF-ADJUSTMENT _"Grow steps"         '(10 2 1000 1 10 0 1))

(script-fu-menu-register "script-fu-luminous-logo"
                         "<Image>/File/Create/Logos")
