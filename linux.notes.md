

# font fallback
```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
<alias>
   <family>Hermit</family>              ## Font with missing characters
   <prefer>
     <family>Hermit</family>            ## Font with missing characters
     <family>Droid Sans Mono</family>   ## Fallback font of your choice
   </prefer>
 </alias>
</fontconfig>
```
