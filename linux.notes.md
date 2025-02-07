# compose key
`echo "keysym Alt_R = Multi_key" >> ~/.Xsessionrc`

# function keys (keychron)
`echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode`

# Font fallback
`/etc/fonts/local.conf`
```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
<alias>
   <family>My Font Family</family>              ## Font with missing characters
   <prefer>
     <family>My Font Family</family>            ## Font with missing characters
     <family>Nerd Fonts Symbols</family>        ## Fallback font of your choice
   </prefer>
 </alias>
</fontconfig>
```

# Firefox window buttons
`~/.mozilla/firefox/<config_dir>/chrome/userChrome.css`
```css
/* Remove close button*/ .titlebar-buttonbox-container{ display:none } 
/* Remove buttons spacer */ .titlebar-spacer[type="post-tabs"]{ display:none }
```

