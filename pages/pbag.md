<head>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/gist-embed/2.1/gist-embed.min.js"></script>
</head>
  
# PHP Property Bag

The ubiquitous and the universal data structure in PHP is the array. It is an amalgamation of commonly used data structures – list, map etc. In the recent times, PHP has also adopted object orientation and introduced classes. The syntactic difference in the way a property of an array and object poses an inconvenience in the user code1 specifically when there is a need to interact with code that is not open for change; legacy or not.

JavaScript would allow you to access an object property either obj.propName or obj["propName"]. That does come in handy for sure. Besides, accessing the property by [] tags is the only way if the property name contains characters like hyphen: obj["prop-Name"]. At the user code level, it is fair to see an object as a bag of key-value pairs.

Along the same lines, it is not wrong to expect the same in PHP between an object and an array; although there is a fundamental difference2. The expectation arises when there is a lot of code that generates array (as output), and a lot of code that expects object (as input), or vice versa. Either code would primarily be interested in the getting or setting the properties/keys than the intrinsic. For that matter, the reasoning behind why an array or object was chosen by the author of either code is outside the scope of this post.

When the intent of the user code is to get/set the property or key, the syntax is just an inconvenience that gets in the way. Here is how one would access a property, or key precisely, of an array:

`$arr["key"]` or `$arr[$key]`

Here is how one would access a property of an object:

`$obj->key` or `$obj->$key`

To cope with the impedance mismatch between the code that generates an array and the code that expects an object (or vice versa), one is cast into another:

`$obj = (object) $arr;` or `$arr = (array) $obj;`

Of course, such casting has documented limitations. The restrictions would still apply to any solution trying to address the impedance mismatch problem.

In PHP, arrays are a bit funny to deal with. If one has programmed in other managed environments, it is evident that arrays are reference types. In PHP, arrays are value types; or sort of2. In other words, when you assign an array $a to $b, then $a is copied to $b. It makes perfect sense if one wants to make a copy of the array. If the array needs to be passed over several functions for read only or update purposes, it does not make sense to make copies over and over. We can reference the array:

`$b =& $a;`

An object in PHP – an instance of a class or `stdClass`, on the other hand, is a reference type (Thank God :)). Here the point is to avoid unnecessary copies of arrays and objects (created when casting from an array) that are created for merely accessing the properties.

That’s where `PropertyBag` comes to the rescue. `PropertyBag` is an extremely useful class that can wrap over an object or an array (without creating a copy) or even create one from scratch, and make it possible to access the properties, or keys, either as an array or as an object, depending on the user code. Wherever one would return an array (or an object), an instance of `PropertyBag` could be returned without the need to change the code that consumes this return value. The caveat here is the consumer code does not make explicit type checks or something of the sort. You can grab your copy of `PropertyBag` from github:php-savers or read the excerpt of the class here below.

`PropertyBag` primarily helps to work with array or objects seamlessly, using either the array or the object syntax to access the properties. It also helps avoid creating copies of array when it is passed across functions2.

```php
<?
    abstract class PropertyBag implements ArrayAccess {
        protected $_store = null;
        protected $_readOnly = false;
     
        protected function __construct(&$source, $readOnly = false);
     
        public static function fromArray(array &$source, $readOnly = false);
        public static function fromObject($source, $readOnly = false);
     
        public function isReadOnly();
        public function __get($name);
        public function __set($name, $value);
    }
     
    class ArrayBasedPropertyBag extends PropertyBag {
        public function __construct(array &$source = null, $readOnly = false);
     
        #region ArrayAccess Interface Implementation
        ...
        #endregion
    }
     
    class ObjectBasedPropertyBag extends PropertyBag {
        public function __construct(&$source = null, $readOnly = false);
     
        #region ArrayAccess Interface Implementation
        ...
        #endregion
    }
```

**Appendix**

   1. The code that I am working on is massive and consists of code several years old, a few years in the past and newly written. One can see the characteristics of the code change among the code from different periods. The newly written code, I believe is written with a great level of consciousness and awareness, interacts with old code (give and take) passing in or taking arrays or objects. In no case, the old code could be changed to adapt what the new code is expecting or returning. Besides, the new code attempts its best to avoid copies of entities by leaning on object types whenever there is a chance instead of plain arrays. So there was an inherent need to build/work with something, an intelligent entity, that would bridge the gap among the code from different periods. The friction here was primarily the syntax difference in accessing the data rather than the intrinsic or nature of the data structure. Hence `PropertyBag`.
   
   1. Arrays in PHP are inherently value types but they disguise as reference types until a write is attempted. That means, array variables when passed across functions tend to avoid copies but the moment it is tampered (or written to), a copy of the array is made; copy-on-write. In most cases, a copy is not what is required. Instead the original array is intended to be updated. In cases where a copy is intended, making it explicit via clone mechanism is a good practice. `PropertyBag` will avoid copies of the array, and will also be able to hand out a copy when required through the toArray method.
