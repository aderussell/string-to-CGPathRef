
1.1.0 (31/12/2017)
---------------------

#### Changed
* Added some function annotations to make the function play nicer with projects using Swift.
* Methods passed `nil` as the string input parameter will now return an empty path rather than `nil`.



1.0.0 (11/08/2014)
---------------------

#### Added
* The multiline methods now support justified text alignment. (Note that natural aligment is still not supported; they will be left aligned if used.)

#### Changed
* All the method names have been changed to make them clearer.
* The CoreText internals have been seperated out from the UIBezierPath category, this means that OS X can now use the CoreText methods which return a `CGPathRef`.



0.0.0 (8/8/2014)
------------------
Initial Release
