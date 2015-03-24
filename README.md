
# psd-render-slices

> The psd-render-slices command-line utility parses a Photoshop file (.psd) to 
retrieve user-slices and renders the image. ImageMagick command-line tools are 
then used to slice the rendered image into individual assets.

## Dependencies

 - Ruby ([info](http://www.ruby-lang.org/))
 - ImageMagick ([info](http://www.imagemagick.org/) | [binaries](http://www.imagemagick.org/script/binary-releases.php))
```
MacOS: sudo port install ImageMagick
CentOS: yum install ImageMagick
```
 - PSD.rb ([github](https://github.com/layervault/psd.rb))
```
$ gem install psd
```

## Usage

```
$ ./psd-render-slices.rb
usage: ./psd-render-slices <psd file> [<output directory>]
```

### Output format 

The slices are rendered in PNG format in the specified output directory (by 
default `out/`). They will have be saved as `[slice_name].png` where slice name
can be individually set in Photoshop using Slice Selection Tool.

## More information

 - [PSD.rb](https://github.com/layervault/psd.rb) - A general purpose Photoshop
 file parser written in Ruby.
 
## License

The MIT License (MIT)

Copyright (c) 2015 Konrad W.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
