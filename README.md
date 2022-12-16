[![Swift](https://github.com/MarcoEidinger/conditional-files/actions/workflows/swift.yml/badge.svg)](https://github.com/MarcoEidinger/conditional-files/actions/workflows/swift.yml) [![codecov](https://codecov.io/github/MarcoEidinger/conditional-files/branch/main/graph/badge.svg?token=OW4DFFVD4R)](https://codecov.io/github/MarcoEidinger/conditional-files)

# ConditionalFiles

A command-line tool intended to insert a conditional compilation statement in multiple Swift files at once.

And generic enough being able to process multiple files and **insert *any* text at the top and the bottom of a file** :)

## Find files with compiler directive (`#if ... #endif`) hugging the file content

```bash
swift run conditional-files find .
```

## Find and remove hugging compilerdirective

```bash
swift run conditional-files find . | xargs swift run conditional-files remove
```

## Add `#if os() ... #endif` to all files in (sub) directory

Set one or more respective flags, e.g. for iOS use `--ios`.

Pass a single dot (`.`) as argument to process all files in the current directory and subdirectories.

Example: `swift run conditional-files --ios .`

<table>
<tr>
<td> File (before) </td> <td> File (after)
</tr>
<tr>
<td>

```swift
import CarKey
// code
```

</td>
<td>
    
```swift
#if os(iOS)
import CarKey
// code
#endif
```

</td>
</tr>
</table>

You can add multiple statements by adding multiple flags.

```bash
swift run conditional-files --ios --watchos .
```

<table>
<tr>
<td> File (before) </td> <td> File (after)
</tr>
<tr>
<td>

```swift
import CarKey
// code
```

</td>
<td>
    
```swift
#if os(iOS) || os(watchOS)
import CarKey
// code
#endif
```

</td>
</tr>
</table>

## Remove `#if os() ... #endif`

You can remove an existing compiler directive with flag `remove`.

```bash
swift run conditional-files --ios --undo test.swift
```

<table>
<tr>
<td> File (before) </td> <td> File (after)
</tr>
<tr>
<td>

```swift
#if os(iOS)
import CarKey
// code
#endif
```

</td>
<td>
    
```swift
import CarKey
// code
```

</td>
</tr>
</table>


## Add `#if os() ... #endif` to specific file(s)

Pass one or more file paths as arguments.

```bash
swift run conditional-files --ios test.swift
```

<table>
<tr>
<td> File (before) </td> <td> File (after) </td>
</tr>
<tr>
<td>

```swift
import CarKey
// code
```

</td>
<td>
    
```swift
#if os(iOS)
import CarKey
// code
#endif
```

</td>
</tr>
</table>

## Add `#if !os() ... #endif`

You can negate the #if(os) directive with command `not-os`.

```bash
swift run conditional-files not-os --ios --watchos test.swift
```

<table>
<tr>
<td> File (before) </td> <td> File (after)
</tr>
<tr>
<td>

```swift
import CarKey
// code
```

</td>
<td>
    
```swift
#if !os(iOS) && !os(watchOS)
import CarKey
// code
#endif
```

</td>
</tr>
</table>

## Add `#if DEBUG ... #endif`

```text
swift run conditional-files generic --first-line '#if DEBUG' --last-line \#endif test.swift
```

<table>
<tr>
<td> File (before) </td> <td> File (after)
</tr>
<tr>
<td>

```swift
import CarKey
// code
```

</td>
<td>
    
```swift
#if DEBUG
import CarKey
// code
#endif
```

</td>
</tr>
</table>

## Add any (generic) top & bottom line

You can also add any top & bottom lines.

```text
swift run conditional-files generic --first-line BEGIN --last-line END test.swift
```

<table>
<tr>
<td> File (before) </td> <td> File (after)
</tr>
<tr>
<td>

```text
// text
```

</td>
<td>
    
```text
BEGIN
// text
END
```

</td>
</tr>
</table>
