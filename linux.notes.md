

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
